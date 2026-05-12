import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';
import 'app.dart';

void main() async {
  // Global error boundary — prevents unhandled exceptions from crashing the
  // app and orphaning managed backend processes.
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Catch Flutter framework errors (widget build failures, etc.).
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      stderr.writeln('[Candela] FlutterError: ${details.exceptionAsString()}');
    };

    // Last-resort catch for platform-level errors.
    PlatformDispatcher.instance.onError = (error, stack) {
      stderr.writeln('[Candela] PlatformError: $error\n$stack');
      return true; // Handled — don't terminate.
    };

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

    // Riverpod manages all service lifecycle (config, process manager, tray).
    // No more global singletons — everything is scoped via ProviderScope.
    runApp(const ProviderScope(child: CandelaApp()));
  }, (error, stack) {
    // Catch-all for unhandled async exceptions in the zone.
    stderr.writeln('[Candela] Unhandled: $error\n$stack');
  });
}
