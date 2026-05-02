import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'app.dart';
import 'services/process_manager.dart';
import 'services/tray_service.dart';
import 'services/config_service.dart';

/// Global singletons for process management and tray.
final processManager = ProcessManager();
late final TrayService trayService;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  const windowOptions = WindowOptions(
    size: Size(1280, 820),
    minimumSize: Size(900, 600),
    center: true,
    backgroundColor: Color(0xFF0A0A0F),
    titleBarStyle: TitleBarStyle.hidden,
    title: 'Candela',
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  // Load config and configure process manager.
  final config = await ConfigService().load();
  processManager.configure(
    providerNames: config.providers.map((p) => p.name).toList(),
    proxyPort: config.port?.toString(),
  );

  // Detect already-running processes.
  await processManager.detectRunning();

  // Initialize system tray.
  trayService = TrayService(processManager: processManager);
  await trayService.init();

  runApp(const CandelaApp());
}
