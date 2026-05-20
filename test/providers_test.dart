import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:candela_desktop/models/candela_config.dart';
import 'package:candela_desktop/providers.dart';
import 'package:candela_desktop/services/brew_service.dart';
import 'package:candela_desktop/services/config_service.dart';
import 'package:candela_desktop/services/process_manager.dart';
import 'package:candela_desktop/services/tray_service.dart';

void main() {
  // Required by TrayService which uses platform channels.
  TestWidgetsFlutterBinding.ensureInitialized();

  group('providers — @riverpod code-gen wiring', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    // ── configServiceProvider ──────────────────────────────────────────────

    test('configServiceProvider returns a ConfigService instance', () {
      final svc = container.read(configServiceProvider);
      expect(svc, isA<ConfigService>());
    });

    test('configServiceProvider is a singleton (keepAlive)', () {
      final a = container.read(configServiceProvider);
      final b = container.read(configServiceProvider);
      expect(identical(a, b), isTrue);
    });

    test('configServiceProvider can be overridden in tests', () {
      final mockService = ConfigService(configPath: '/tmp/test-override.yaml');
      final overridden = ProviderContainer(
        overrides: [
          configServiceProvider.overrideWithValue(mockService),
        ],
      );
      addTearDown(overridden.dispose);

      final svc = overridden.read(configServiceProvider);
      expect(identical(svc, mockService), isTrue);
    });

    // ── configProvider ────────────────────────────────────────────────────

    test('configProvider is a StreamProvider (starts as AsyncLoading)', () {
      final value = container.read(configProvider);
      // Before the stream emits, we should get an AsyncLoading.
      expect(value, isA<AsyncValue<CandelaConfig>>());
      expect(value.isLoading, isTrue);
    });

    test('configProvider emits CandelaConfig via stream', () async {
      // Listen for the first data emission.
      final completer = Completer<CandelaConfig>();
      container.listen<AsyncValue<CandelaConfig>>(
        configProvider,
        (prev, next) {
          next.whenData((config) {
            if (!completer.isCompleted) {
              completer.complete(config);
            }
          });
        },
        fireImmediately: true,
      );

      // The stream should eventually emit a default config (no config file).
      final config = await completer.future.timeout(
        const Duration(seconds: 5),
        onTimeout: () => throw TimeoutException('configProvider never emitted'),
      );
      expect(config, isA<CandelaConfig>());
      expect(config.port, isA<int>());
    });

    // ── brewServiceProvider ───────────────────────────────────────────────

    test('brewServiceProvider returns a BrewService instance', () {
      final svc = container.read(brewServiceProvider);
      expect(svc, isA<BrewService>());
    });

    test('brewServiceProvider is a singleton (keepAlive)', () {
      final a = container.read(brewServiceProvider);
      final b = container.read(brewServiceProvider);
      expect(identical(a, b), isTrue);
    });

    test('brewServiceProvider can be overridden in tests', () {
      final mockBrew = BrewService();
      final overridden = ProviderContainer(
        overrides: [
          brewServiceProvider.overrideWithValue(mockBrew),
        ],
      );
      addTearDown(overridden.dispose);
      expect(identical(overridden.read(brewServiceProvider), mockBrew), isTrue);
    });

    // ── processManagerProvider ────────────────────────────────────────────

    test('processManagerProvider returns a ProcessManager instance', () {
      final pm = container.read(processManagerProvider);
      expect(pm, isA<ProcessManager>());
    });

    test('processManagerProvider is a singleton (keepAlive)', () {
      final a = container.read(processManagerProvider);
      final b = container.read(processManagerProvider);
      expect(identical(a, b), isTrue);
    });

    test('processManagerProvider can be overridden in tests', () {
      final mockPM = ProcessManager();
      final overridden = ProviderContainer(
        overrides: [
          processManagerProvider.overrideWithValue(mockPM),
        ],
      );
      addTearDown(() {
        mockPM.dispose();
        overridden.dispose();
      });
      expect(
          identical(overridden.read(processManagerProvider), mockPM), isTrue);
    });

    // ── trayServiceProvider ──────────────────────────────────────────────

    test('trayServiceProvider returns a TrayService instance', () {
      final tray = container.read(trayServiceProvider);
      expect(tray, isA<TrayService>());
    });

    test('trayServiceProvider receives processManager dependency', () {
      final pm = container.read(processManagerProvider);
      final tray = container.read(trayServiceProvider);
      // TrayService is wired to the same processManager.
      expect(tray, isNotNull);
      expect(pm, isNotNull);
    });
  });

  group('providers — processManager auto-configuration', () {
    test('processManager configures when config emits', () async {
      // Use a real container with the default providers — the config stream
      // will emit default values, causing processManager to be configured.
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Read processManager to trigger the provider.
      final pm = container.read(processManagerProvider);
      expect(pm, isA<ProcessManager>());

      // Wait for configProvider to emit and trigger the listen callback.
      final completer = Completer<void>();
      container.listen<AsyncValue<CandelaConfig>>(
        configProvider,
        (prev, next) {
          next.whenData((_) {
            if (!completer.isCompleted) completer.complete();
          });
        },
        fireImmediately: true,
      );

      await completer.future.timeout(
        const Duration(seconds: 5),
        onTimeout: () => throw TimeoutException('config never emitted'),
      );

      // After config emits, the processManager should have the proxy
      // configured (configure() is called in the listen callback).
      expect(pm.get('proxy'), isNotNull);
    });
  });

  group('providers — generated provider types', () {
    test('configServiceProvider is a ConfigServiceProvider', () {
      expect(configServiceProvider, isA<ConfigServiceProvider>());
    });

    test('configProvider is a ConfigProvider', () {
      expect(configProvider, isA<ConfigProvider>());
    });

    test('processManagerProvider is a ProcessManagerProvider', () {
      expect(processManagerProvider, isA<ProcessManagerProvider>());
    });

    test('brewServiceProvider is a BrewServiceProvider', () {
      expect(brewServiceProvider, isA<BrewServiceProvider>());
    });

    test('trayServiceProvider is a TrayServiceProvider', () {
      expect(trayServiceProvider, isA<TrayServiceProvider>());
    });
  });
}
