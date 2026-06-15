import 'dart:async';
import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/candela_config.dart';
import '../models/span_stats.dart';
import '../services/brew_service.dart';
import '../services/config_service.dart';
import '../services/dashboard_notifier.dart' as dashboard_notifier;
import '../services/dashboard_notifier.dart' show DashboardState;
import '../services/process_manager.dart';
import '../services/tray_service.dart';
import '../models/user_scope.dart';

part 'providers.g.dart';

// ── Config ──────────────────────────────────────────────────────────────────

/// The singleton ConfigService instance.
@Riverpod(keepAlive: true)
ConfigService configService(Ref ref) {
  return ConfigService();
}

/// Reactive config that auto-reloads when the config file changes on disk.
///
/// Emits the initial config, then re-emits whenever the file is modified.
/// Debouncing is handled inside [ConfigService.watchForChanges].
@Riverpod(keepAlive: true)
Stream<CandelaConfig> config(Ref ref) {
  final service = ref.watch(configServiceProvider);

  return _configStream(service);
}

Stream<CandelaConfig> _configStream(ConfigService service) async* {
  // Run legacy migration before first load.
  await service.migrateLegacyFields();

  // Initial load.
  yield await service.load();

  // Watch for changes and reload.
  final watcher = service.watchForChanges();
  if (watcher == null) return;

  await for (final _ in watcher) {
    yield await service.load();
  }
}

// ── Dashboard ───────────────────────────────────────────────────────────────

/// Shared dashboard state — the single source of truth for telemetry data.
///
/// Both DashboardScreen and TodayScreen consume this provider instead of each
/// maintaining their own [TelemetryService] and 30-second timer. This cuts
/// BigQuery queries by 50% and enables TTL-based caching + visibility-aware
/// polling.
///
/// The notifier is lazily configured on first read using the current config,
/// then re-configured automatically when the config file changes.
///
/// Usage:
///   final state = ref.watch(dashboardProvider);  // DashboardState
///   ref.read(dashboardProvider.notifier).fetch(); // methods
@Riverpod(keepAlive: true)
class DashboardNotifier extends _$DashboardNotifier {
  late final dashboard_notifier.DashboardController _inner;

  @override
  DashboardState build() {
    _inner = dashboard_notifier.DashboardController();

    // Bridge: when the inner notifier updates its state, push the new
    // snapshot into the Riverpod graph so all ref.watch() consumers rebuild.
    _inner.onStateChanged = (newState) {
      state = newState;
    };

    // Configure and start polling when config becomes available.
    void configureAndPoll(CandelaConfig config) async {
      await _inner.configure(config);
      await _inner.fetch();
      _inner.startPolling();
    }

    // Use current value if already loaded.
    ref.read(configProvider).whenData(configureAndPoll);

    // Re-configure when config changes (e.g. user edits config.yaml).
    ref.listen<AsyncValue<CandelaConfig>>(configProvider, (prev, next) {
      next.whenData(configureAndPoll);
    });

    ref.onDispose(() => _inner.dispose());

    return _inner.state;
  }

  // ── Delegated public API ────────────────────────────────────────────────

  bool get isConfigured => _inner.isConfigured;
  Duration get cacheTtl => _inner.cacheTtl;

  Future<void> configure(CandelaConfig config) => _inner.configure(config);
  Future<void> fetch() => _inner.fetch();
  Future<void> setRange(TokenTimeRange range) => _inner.setRange(range);
  Future<void> setUserScope(UserScope scope) => _inner.setUserScope(scope);
  void startPolling({Duration interval = const Duration(seconds: 60)}) =>
      _inner.startPolling(interval: interval);
  void onAppLifecycleChanged(AppLifecycleState lifecycleState) =>
      _inner.onAppLifecycleChanged(lifecycleState);
  Future<String?> refreshToken() => _inner.refreshToken();
  UsageSummary? buildFilteredSummary(String? selectedModel) =>
      _inner.buildFilteredSummary(selectedModel);
}

// ── Process Manager ─────────────────────────────────────────────────────────

/// The singleton ProcessManager, auto-configured when config changes.
@Riverpod(keepAlive: true)
ProcessManager processManager(Ref ref) {
  final pm = ProcessManager();

  void configure(CandelaConfig config) {
    pm.configure(
      providerNames: config.providers.map((p) => p.name).toList(),
      proxyPort: config.port.toString(),
      portOverrides: {
        'lmstudio': config.lmStudioPort.toString(),
      },
    );
  }

  // Configure with current value if already available (prevents missed
  // initial state when configProvider was read earlier during app startup).
  ref.read(configProvider).whenData(configure);

  // Reconfigure whenever config changes.
  ref.listen<AsyncValue<CandelaConfig>>(configProvider, (prev, next) {
    next.whenData(configure);
  });

  ref.onDispose(() => pm.dispose());
  return pm;
}

// ── Brew ─────────────────────────────────────────────────────────────────────

/// Homebrew CLI wrapper for install/upgrade operations.
@Riverpod(keepAlive: true)
BrewService brewService(Ref ref) {
  return BrewService();
}

// ── Tray ────────────────────────────────────────────────────────────────────

/// System tray service, wired to the process manager.
@Riverpod(keepAlive: true)
TrayService trayService(Ref ref) {
  final pm = ref.watch(processManagerProvider);
  final tray = TrayService(processManager: pm);
  ref.onDispose(() => tray.dispose());
  return tray;
}
