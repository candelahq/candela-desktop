import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:candela_desktop/app.dart';
import 'package:candela_desktop/providers.dart';
import 'package:candela_desktop/services/config_service.dart';

// ── Isolated config helper ──────────────────────────────────────────────────

/// Creates a temporary config directory for test isolation.
///
/// Each test gets its own config file so tests don't interfere with each other
/// or with the user's real ~/.config/candela/config.yaml.
class TestConfigHelper {
  late final Directory _tempDir;
  late final String configPath;

  Future<void> setUp() async {
    _tempDir = await Directory.systemTemp.createTemp('candela_itest_');
    configPath = '${_tempDir.path}/config.yaml';
  }

  Future<void> tearDown() async {
    if (_tempDir.existsSync()) {
      await _tempDir.delete(recursive: true);
    }
  }

  /// Write a minimal solo config so the app skips onboarding.
  Future<void> writeSoloConfig({int port = 8181}) async {
    final file = File(configPath);
    await file.writeAsString('''
config_version: 1
port: $port
''');
  }

  /// Write a config with providers so the app launches in solo+cloud mode.
  Future<void> writeSoloCloudConfig({
    int port = 8181,
    String project = 'test-project',
    String region = 'us-central1',
    List<String> providers = const ['ollama'],
  }) async {
    final file = File(configPath);
    final providerLines = providers.map((p) => '  - name: $p').join('\n');
    await file.writeAsString('''
config_version: 1
port: $port
vertex_ai:
  project: $project
  region: $region
providers:
$providerLines
''');
  }

  /// Returns Riverpod overrides that use the isolated config path.
  List<Override> get overrides => [
        configServiceProvider.overrideWithValue(
          ConfigService(configPath: configPath),
        ),
      ];
}

// ── Package info mock ───────────────────────────────────────────────────────

/// Sets mock PackageInfo for tests (avoids platform plugin failures).
void mockPackageInfo({
  String version = '0.0.0-test',
  String buildNumber = '1',
}) {
  PackageInfo.setMockInitialValues(
    appName: 'Candela',
    packageName: 'com.candela.desktop.test',
    version: version,
    buildNumber: buildNumber,
    buildSignature: '',
    installerStore: null,
  );
}

/// Pumps the full CandelaApp with the given Riverpod overrides.
///
/// Uses bounded frame pumping instead of `pumpAndSettle` because the app has
/// continuous frame schedulers (window_manager listeners, Timer.periodic
/// auto-refresh in TodayScreen) that prevent `pumpAndSettle` from ever
/// returning.
Future<void> pumpApp(
  WidgetTester tester, {
  List<Override> overrides = const [],
  int pumpFrames = 50,
}) async {
  // Configure test view to match app's expected window dimensions.
  tester.view.physicalSize = const Size(1400, 900);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  // Suppress headless renderer overflow errors — these don't occur on
  // a real macOS display because the font metrics are available.
  final oldOnError = FlutterError.onError;
  FlutterError.onError = (details) {
    if (details.exceptionAsString().contains('RenderFlex overflowed')) return;
    oldOnError?.call(details);
  };
  addTearDown(() => FlutterError.onError = oldOnError);

  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      child: const CandelaApp(),
    ),
  );

  // Pump N frames to let async initialization complete (config load,
  // detectRunning, etc.) without waiting for full quiescence — which
  // never happens due to window_manager and periodic timers.
  for (var i = 0; i < pumpFrames; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

/// Settles the widget tree with a bounded timeout.
///
/// Unlike `tester.pumpAndSettle`, this pumps individual frames for at most
/// [duration] before returning. Use this instead of `pumpAndSettle` in any
/// test that renders the full app.
Future<void> settleWithTimeout(
  WidgetTester tester, {
  Duration duration = const Duration(seconds: 2),
}) async {
  final end = DateTime.now().add(duration);
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}
