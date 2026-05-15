import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';
import 'app.dart';

/// Persistent crash log for release builds — stderr is invisible to users.
///
/// Writes to `~/.config/candela/crash.log` (the same dir as the config file).
/// Each entry is timestamped and capped at 512KB to prevent unbounded growth.
void _logToFile(String message) {
  try {
    final home = Platform.environment['HOME'];
    if (home == null) return;
    final logDir = Directory('$home/.config/candela');
    if (!logDir.existsSync()) logDir.createSync(recursive: true);
    final logFile = File('${logDir.path}/crash.log');

    // Cap at 512KB — truncate from the front if too large.
    if (logFile.existsSync() && logFile.lengthSync() > 512 * 1024) {
      final lines = logFile.readAsLinesSync();
      logFile
          .writeAsStringSync('${lines.skip(lines.length ~/ 2).join('\n')}\n');
    }

    logFile.writeAsStringSync(
      '[${DateTime.now().toIso8601String()}] $message\n',
      mode: FileMode.append,
    );
  } catch (_) {
    // Never let logging itself crash the app.
  }
}

void main() async {
  // Global error boundary — prevents unhandled exceptions from crashing the
  // app and orphaning managed backend processes.
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Catch Flutter framework errors (widget build failures, etc.).
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      final msg = '[Candela] FlutterError: ${details.exceptionAsString()}';
      stderr.writeln(msg);
      _logToFile('$msg\n${details.stack}');
    };

    // Last-resort catch for platform-level errors.
    PlatformDispatcher.instance.onError = (error, stack) {
      final msg = '[Candela] PlatformError: $error';
      stderr.writeln('$msg\n$stack');
      _logToFile('$msg\n$stack');
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
    final msg = '[Candela] Unhandled: $error';
    stderr.writeln('$msg\n$stack');
    _logToFile('$msg\n$stack');
  });
}
