import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/candela_config.dart';
import '../services/brew_service.dart';
import '../services/config_service.dart';
import '../services/dashboard_notifier.dart';
import '../services/process_manager.dart';
import '../services/tray_service.dart';

// ── Config ──────────────────────────────────────────────────────────────────

/// The singleton ConfigService instance.
final configServiceProvider = Provider<ConfigService>((ref) {
  return ConfigService();
});

/// Reactive config that auto-reloads when the config file changes on disk.
///
/// Emits the initial config, then re-emits whenever the file is modified.
/// Debouncing is handled inside [ConfigService.watchForChanges].
final configProvider = StreamProvider<CandelaConfig>((ref) {
  final service = ref.watch(configServiceProvider);

  return _configStream(service);
});

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

/// Shared [DashboardNotifier] — the single source of truth for telemetry data.
///
/// Both DashboardScreen and TodayScreen consume this provider instead of each
/// maintaining their own [TelemetryService] and 30-second timer. This cuts
/// BigQuery queries by 50% and enables TTL-based caching + visibility-aware
/// polling.
///
/// The notifier is lazily configured on first read using the current config,
/// then re-configured automatically when the config file changes.
final dashboardNotifierProvider =
    ChangeNotifierProvider<DashboardNotifier>((ref) {
  final notifier = DashboardNotifier();

  // Configure and start polling when config becomes available.
  void configureAndPoll(CandelaConfig config) async {
    await notifier.configure(config);
    await notifier.fetch();
    notifier.startPolling();
  }

  // Use current value if already loaded.
  ref.read(configProvider).whenData(configureAndPoll);

  // Re-configure when config changes (e.g. user edits config.yaml).
  ref.listen<AsyncValue<CandelaConfig>>(configProvider, (prev, next) {
    next.whenData(configureAndPoll);
  });

  return notifier;
});

// ── Process Manager ─────────────────────────────────────────────────────────

/// The singleton ProcessManager, auto-configured when config changes.
final processManagerProvider = Provider<ProcessManager>((ref) {
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
});

// ── Brew ─────────────────────────────────────────────────────────────────────

/// Homebrew CLI wrapper for install/upgrade operations.
final brewServiceProvider = Provider<BrewService>((ref) {
  return BrewService();
});

// ── Tray ────────────────────────────────────────────────────────────────────

/// System tray service, wired to the process manager.
final trayServiceProvider = Provider<TrayService>((ref) {
  final pm = ref.watch(processManagerProvider);
  final tray = TrayService(processManager: pm);
  ref.onDispose(() => tray.dispose());
  return tray;
});
