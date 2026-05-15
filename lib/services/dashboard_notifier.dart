import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';
import '../models/budget_info.dart';
import '../models/span_stats.dart';
import '../services/gcloud_service.dart';
import '../services/telemetry_service.dart';

/// Immutable snapshot of the dashboard state.
class DashboardState {
  final TelemetryResult? result;
  final bool loading;
  final String? errorMessage;
  final TokenTimeRange range;

  const DashboardState({
    this.result,
    this.loading = false,
    this.errorMessage,
    this.range = TokenTimeRange.d7,
  });

  DashboardState copyWith({
    TelemetryResult? result,
    bool? loading,
    String? errorMessage,
    TokenTimeRange? range,
    bool clearError = false,
  }) {
    return DashboardState(
      result: result ?? this.result,
      loading: loading ?? this.loading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      range: range ?? this.range,
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

/// Manages dashboard telemetry state, decoupling business logic from widgets.
///
/// Uses [ChangeNotifier] for compatibility with the existing provider setup.
/// Instantiate with a [TelemetryService] and optional [GCloudService] for
/// team-mode token refresh.
class DashboardNotifier extends SafeChangeNotifier {
  final TelemetryService _telemetry;
  final GCloudService? _gcloud;
  Timer? _refreshTimer;

  DashboardState _state = const DashboardState(loading: true);
  DashboardState get state => _state;

  DashboardNotifier({
    required TelemetryService telemetry,
    GCloudService? gcloud,
  })  : _telemetry = telemetry,
        _gcloud = gcloud;

  /// Start periodic polling. Safe to call multiple times.
  void startPolling({Duration interval = const Duration(seconds: 30)}) {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(interval, (_) => fetch());
  }

  /// Fetch telemetry for the current [range].
  Future<void> fetch() async {
    _state = _state.copyWith(loading: true, clearError: true);
    notifyListeners();

    try {
      final result = await _telemetry.fetch(_state.range);
      _state = _state.copyWith(
        result: result,
        loading: false,
        clearError: true,
      );
    } catch (e) {
      _state = _state.copyWith(
        loading: false,
        errorMessage: e.toString(),
      );
    }
    notifyListeners();
  }

  /// Switch time range and re-fetch.
  Future<void> setRange(TokenTimeRange range) async {
    _state = _state.copyWith(range: range);
    notifyListeners();
    await fetch();
  }

  /// Refresh the auth token (team mode only). Returns the new token or null.
  Future<String?> refreshToken() async {
    if (_gcloud == null) return null;
    final info = await _gcloud.getTokenInfo();
    return info?.accessToken;
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }
}
