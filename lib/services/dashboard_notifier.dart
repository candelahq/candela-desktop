import 'dart:async';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import '../models/budget_info.dart';
import '../models/candela_config.dart';
import '../models/span_stats.dart';
import '../models/user_scope.dart';
import '../services/candela_auth_service.dart';
import '../services/telemetry_service.dart';

// ── Immutable state snapshot ─────────────────────────────────────────────────

/// Immutable snapshot of the dashboard state.
class DashboardState {
  final TelemetryResult? result;
  final bool loading;
  final String? errorMessage;
  final TokenTimeRange range;
  final UserScope userScope;

  const DashboardState({
    this.result,
    this.loading = false,
    this.errorMessage,
    this.range = TokenTimeRange.d7,
    this.userScope = UserScope.personal,
  });

  DashboardState copyWith({
    TelemetryResult? result,
    bool? loading,
    String? errorMessage,
    TokenTimeRange? range,
    UserScope? userScope,
    bool clearError = false,
  }) {
    return DashboardState(
      result: result ?? this.result,
      loading: loading ?? this.loading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      range: range ?? this.range,
      userScope: userScope ?? this.userScope,
    );
  }

  // ── Convenience accessors ──────────────────────────────────────────────────

  bool get hasData => result?.hasData ?? false;
  UsageSummary? get summary => result?.summary;
  List<ModelBreakdown> get models => result?.models ?? const [];
  List<SpanRecord> get spans => result?.spans ?? const [];
  bool get isTeamMode => result?.isTeamMode ?? false;
  TelemetryErrorKind? get error => result?.error;
  BudgetInfo? get budget => result?.budget;
  List<GrantInfo> get activeGrants => result?.activeGrants ?? const [];
  double? get totalRemainingUsd => result?.totalRemainingUsd;
}

// ── Notifier ─────────────────────────────────────────────────────────────────

/// Centralized telemetry data manager shared by all dashboard screens.
///
/// Combines three optimizations:
/// 1. **Shared data**: Single [TelemetryService] instance and timer — all
///    screens consume the same state instead of each polling independently.
/// 2. **Response caching**: Skips re-fetch when the last successful response
///    is newer than [cacheTtl] (default: 25 seconds). The 30-second timer
///    ticks at the same interval, but the actual BigQuery round-trip only
///    happens when the cache has expired.
/// 3. **Visibility-aware polling**: Pauses the timer when the app lifecycle
///    reports [AppLifecycleState.paused] or [hidden], and resumes with an
///    immediate fetch when the app returns to the foreground.
///
/// This class is designed to be used as a Riverpod Notifier. State transitions
/// are driven by assigning to [state] (immutable snapshots) — no
/// [ChangeNotifier] or manual listener management required.
class DashboardController {
  TelemetryService? _telemetry;
  final CandelaAuthService _candelaAuth;
  Timer? _refreshTimer;

  /// Callback invoked whenever [state] changes. Set by the provider to
  /// bridge state updates into the Riverpod graph.
  void Function(DashboardState)? onStateChanged;

  /// Minimum interval between actual network fetches.
  /// Set to slightly less than the polling interval so the fetch triggered
  /// by the timer tick doesn't skip (60s tick – 50s TTL = 10s margin).
  final Duration cacheTtl;

  /// Timestamp of the last successful fetch (UTC).
  DateTime? _lastFetchAt;

  /// Whether the app is currently in the foreground.
  bool _appVisible = true;

  /// Whether this controller has been disposed.
  bool _disposed = false;

  /// Whether the notifier has been configured with a [TelemetryService].
  bool get isConfigured => _telemetry != null;

  DashboardState _state = const DashboardState(loading: true);
  DashboardState get state => _state;
  set state(DashboardState newState) {
    if (_disposed) return;
    _state = newState;
    onStateChanged?.call(newState);
  }

  DashboardController({
    TelemetryService? telemetry,
    CandelaAuthService? candelaAuth,
    this.cacheTtl = const Duration(seconds: 50),
  })  : _telemetry = telemetry,
        _candelaAuth = candelaAuth ?? CandelaAuthService();

  // ── Configuration ─────────────────────────────────────────────────────────

  /// Initialize the notifier with a config-derived [TelemetryService].
  ///
  /// Called once from the provider setup. After this, [startPolling] can be
  /// called to begin the refresh loop.
  ///
  /// In team mode, dashboard data is fetched through the local candela proxy
  /// (`localhost:{port}`) which handles all IAP auth via its reverse proxy
  /// catch-all route. The desktop app does NOT need to manage IAP tokens
  /// for dashboard requests — it simply points ConnectRPC at the proxy.
  Future<void> configure(CandelaConfig config) async {
    final isTeam = config.mode == CandelaMode.team &&
        config.remote != null &&
        config.remote!.isNotEmpty;

    if (isTeam) {
      // Route through the local proxy — no auth needed.
      // The proxy's catch-all (`/` → remoteProxy) forwards ConnectRPC
      // requests to the remote backend with IAP + X-Candela-Auth headers
      // automatically injected.
      _telemetry?.dispose();
      _telemetry = TelemetryService(
        port: config.port,
        remoteUrl: 'http://localhost:${config.port}',
      );
    } else {
      _telemetry?.dispose();
      _telemetry = TelemetryService(port: config.port);
    }
  }

  // ── Polling lifecycle ─────────────────────────────────────────────────────

  /// Start periodic polling. Safe to call multiple times — cancels any
  /// existing timer before creating a new one.
  void startPolling({Duration interval = const Duration(seconds: 60)}) {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(interval, (_) => _tickFetch());
  }

  /// Timer callback — respects the cache TTL to avoid redundant queries.
  void _tickFetch() {
    if (!_appVisible) return; // Don't fetch while backgrounded.
    if (_isCacheFresh) {
      debugPrint('[DashboardController] cache still fresh, skipping fetch');
      return;
    }
    fetch();
  }

  bool get _isCacheFresh {
    if (_lastFetchAt == null) return false;
    return DateTime.now().toUtc().difference(_lastFetchAt!) < cacheTtl;
  }

  // ── App lifecycle (Fix #4) ────────────────────────────────────────────────

  /// Call from a [WidgetsBindingObserver] when the app lifecycle changes.
  void onAppLifecycleChanged(AppLifecycleState lifecycleState) {
    final wasVisible = _appVisible;
    _appVisible = lifecycleState == AppLifecycleState.resumed;

    if (_appVisible && !wasVisible) {
      debugPrint('[DashboardController] app resumed → immediate fetch');
      // Invalidate cache so we always get fresh data on resume.
      _lastFetchAt = null;
      fetch();
    } else if (!_appVisible && wasVisible) {
      debugPrint('[DashboardController] app backgrounded → pausing polls');
    }
  }

  // ── Fetch ─────────────────────────────────────────────────────────────────

  /// Fetch telemetry for the current [range]. Updates [state] on change.
  ///
  /// This is the single entry point for all data loading — no screen should
  /// call [TelemetryService.fetch] directly.
  Future<void> fetch() async {
    if (_telemetry == null) return;

    state = state.copyWith(loading: true, clearError: true);

    try {
      final result =
          await _telemetry!.fetch(state.range, userScope: state.userScope);
      _lastFetchAt = DateTime.now().toUtc();
      state = state.copyWith(
        result: result,
        loading: false,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        loading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Switch time range, invalidate cache, and re-fetch.
  Future<void> setRange(TokenTimeRange range) async {
    state = state.copyWith(range: range);
    _lastFetchAt = null; // Invalidate cache — new range needs fresh data.
    await fetch();
  }

  /// Switch user scope (Personal / Global), invalidate cache, and re-fetch.
  Future<void> setUserScope(UserScope scope) async {
    state = state.copyWith(userScope: scope);
    _lastFetchAt = null;
    await fetch();
  }

  /// Refresh the auth token. Returns the new token or null.
  ///
  /// In the proxy-routed architecture, the desktop doesn't manage tokens
  /// for dashboard requests. This is kept for other callers (e.g. diagnostics)
  /// that may need a direct token.
  Future<String?> refreshToken() async {
    final info = await _candelaAuth.getTokenInfo();
    return info?.accessToken;
  }

  // ── Expose TelemetryService for model filtering ───────────────────────────

  /// Build a filtered [UsageSummary] for a specific model selection.
  /// Used by screens that offer a per-model filter dropdown.
  UsageSummary? buildFilteredSummary(String? selectedModel) {
    if (_telemetry == null || state.result == null) return null;
    if (selectedModel == null) return state.summary;
    final filtered =
        state.spans.where((s) => s.model == selectedModel).toList();
    if (filtered.isEmpty) return null;
    return _telemetry!.buildSummary(filtered, state.range, DateTime.now());
  }

  /// Release resources. Called by the provider's [onDispose] callback.
  void dispose() {
    _disposed = true;
    _refreshTimer?.cancel();
    _telemetry?.dispose();
  }
}
