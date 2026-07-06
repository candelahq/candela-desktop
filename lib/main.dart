import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:window_manager/window_manager.dart';
import 'app.dart';
import 'utils/platform_paths.dart' as platform_paths;

/// Persistent crash log for release builds — stderr is invisible to users.
///
/// Writes to `~/.config/candela/crash.log` (the same dir as the config file).
/// Each entry is timestamped and capped at 512KB to prevent unbounded growth.
void _logToFile(String message) {
  try {
    final logDir = Directory(platform_paths.candelaConfigDir());
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

    // Configure launch-at-startup with the app name and executable path.
    // On Windows this writes to HKCU\...\Run; on macOS it uses SMLoginItem.
    // Must be called before any LaunchAtStartup.instance.enable/isEnabled.
    // Guarded so a failure here doesn't prevent the app from launching.
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final appName =
          packageInfo.appName.isNotEmpty ? packageInfo.appName : 'Candela';
      LaunchAtStartup.instance.setup(
        appName: appName,
        appPath: Platform.resolvedExecutable,
      );
    } catch (e) {
      debugPrint('LaunchAtStartup.setup() failed: $e');
    }

    const windowOptions = WindowOptions(
      size: Size(1280, 820),
      minimumSize: Size(900, 600),
      center: true,
      backgroundColor: Color(0xFF0A0A0F),
      titleBarStyle: TitleBarStyle.hidden,
      title: 'Candela',
    );

    // Track whether the window has been shown — the safety fallback below
    // must not race with the normal path.
    var windowShown = false;

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      if (!windowShown) {
        windowShown = true;
        await windowManager.show();
        await windowManager.focus();
      }
    });

    // Safety fallback: if waitUntilReadyToShow never fires its callback
    // (observed in some adhoc-signed release builds on macOS), force the
    // window visible after 3 seconds so the user doesn't stare at a
    // spinner forever.
    Future.delayed(const Duration(seconds: 3), () async {
      if (!windowShown) {
        windowShown = true;
        debugPrint('[Candela] waitUntilReadyToShow timed out — forcing show');
        await windowManager.show();
        await windowManager.focus();
      }
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
