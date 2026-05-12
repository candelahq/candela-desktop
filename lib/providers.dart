import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/candela_config.dart';
import '../services/config_service.dart';
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

// ── Process Manager ─────────────────────────────────────────────────────────

/// The singleton ProcessManager, auto-configured when config changes.
final processManagerProvider = Provider<ProcessManager>((ref) {
  final pm = ProcessManager();

  // Reconfigure whenever config changes.
  ref.listen(configProvider, (prev, next) {
    next.whenData((config) {
      pm.configure(
        providerNames: config.providers.map((p) => p.name).toList(),
        proxyPort: config.port.toString(),
        portOverrides: {
          'lmstudio': config.lmStudioPort.toString(),
        },
      );
    });
  });

  ref.onDispose(() => pm.dispose());
  return pm;
});

// ── Tray ────────────────────────────────────────────────────────────────────

/// System tray service, wired to the process manager.
final trayServiceProvider = Provider<TrayService>((ref) {
  final pm = ref.watch(processManagerProvider);
  final tray = TrayService(processManager: pm);
  ref.onDispose(() => tray.dispose());
  return tray;
});
