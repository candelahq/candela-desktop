import 'dart:async';
import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/candela_config.dart';
import '../models/span_stats.dart';
import '../services/brew_service.dart';
import '../services/config_service.dart';
import '../services/catalog_notifier.dart' as catalog_notifier;
import '../services/catalog_notifier.dart' show CatalogState;
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

// ── Catalog ─────────────────────────────────────────────────────────────────

/// Shared catalog state — the single source of truth for the model catalog.
///
/// Lazily configured from the config stream, auto-fetches on init.
///
/// Usage:
///   final state = ref.watch(catalogProvider);          // CatalogState
///   ref.read(catalogProvider.notifier).fetch();        // methods
///   ref.read(catalogProvider.notifier).toggleEnabled(…);
@Riverpod(keepAlive: true)
class CatalogNotifier extends _$CatalogNotifier {
  late final catalog_notifier.CatalogController _inner;

  @override
  CatalogState build() {
    _inner = catalog_notifier.CatalogController();

    // Bridge: push state changes into the Riverpod graph.
    _inner.onStateChanged = (newState) {
      state = newState;
    };

    void configureAndFetch(CandelaConfig config) async {
      _inner.configure(config);
      await _inner.fetch();
    }

    // Use current value if already loaded.
    ref.read(configProvider).whenData(configureAndFetch);

    // Re-configure when config changes.
    ref.listen<AsyncValue<CandelaConfig>>(configProvider, (prev, next) {
      next.whenData(configureAndFetch);
    });

    ref.onDispose(() => _inner.dispose());

    return _inner.state;
  }

  // ── Delegated public API ──────────────────────────────────────────────────

  Future<void> fetch() => _inner.fetch();
  Future<void> toggleEnabled(String provider, String modelId, bool enabled) =>
      _inner.toggleEnabled(provider, modelId, enabled);
  Future<void> deleteEntry(String provider, String modelId) =>
      _inner.deleteEntry(provider, modelId);
  void clearError() => _inner.clearError();
}

// ── Process Manager ─────────────────────────────────────────────────────────

// ProcessManagerNotifier is defined with @Riverpod in process_manager.dart.
// The generated provider is `processManagerProvider`.
// We configure it reactively here via a setup provider.

/// Auto-configures the ProcessManagerNotifier when config changes.
@Riverpod(keepAlive: true)
void processManagerSetup(Ref ref) {
  void configure(CandelaConfig config) {
    ref.read(processManagerProvider.notifier).configure(
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
}

// ── Brew ─────────────────────────────────────────────────────────────────────

/// Homebrew CLI wrapper for install/upgrade operations.
@Riverpod(keepAlive: true)
BrewService brewService(Ref ref) {
  return BrewService();
}

// ── Tray ────────────────────────────────────────────────────────────────────

/// System tray service, wired to the process manager notifier.
@Riverpod(keepAlive: true)
TrayService trayService(Ref ref) {
  final notifier = ref.watch(processManagerProvider.notifier);
  final tray = TrayService(processManager: notifier);
  ref.onDispose(() => tray.dispose());
  return tray;
}
