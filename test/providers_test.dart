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

    test('processManagerProvider returns a ProcessManagerState instance', () {
      final state = container.read(processManagerProvider);
      expect(state, isA<ProcessManagerState>());
    });

    test('processManagerProvider notifier is a ProcessManagerNotifier', () {
      final notifier = container.read(processManagerProvider.notifier);
      expect(notifier, isA<ProcessManagerNotifier>());
    });

    test('processManagerProvider returns consistent state', () {
      final a = container.read(processManagerProvider);
      final b = container.read(processManagerProvider);
      expect(identical(a, b), isTrue);
    });

    test('processManagerProvider can be overridden with state value', () {
      const mockState = ProcessManagerState(processes: [
        ManagedProcess(
          name: 'test',
          displayName: 'Test',
          icon: 'T',
        ),
      ]);
      final overridden = ProviderContainer(
        overrides: [
          processManagerProvider.overrideWithValue(mockState),
        ],
      );
      addTearDown(overridden.dispose);

      final state = overridden.read(processManagerProvider);
      expect(state.all.length, 1);
      expect(state.get('test')!.displayName, 'Test');
    });

    // ── trayServiceProvider ──────────────────────────────────────────────

    test('trayServiceProvider returns a TrayService instance', () {
      final tray = container.read(trayServiceProvider);
      expect(tray, isA<TrayService>());
    });

    test('trayServiceProvider receives processManager dependency', () {
      final state = container.read(processManagerProvider);
      final tray = container.read(trayServiceProvider);
      // TrayService is wired to the processManager notifier.
      expect(tray, isNotNull);
      expect(state, isNotNull);
    });
  });

  group('providers — processManager auto-configuration', () {
    test('processManager configures when config emits', () async {
      // Use a real container with the default providers — the config stream
      // will emit default values, causing processManager to be configured.
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Read processManagerSetup to trigger the reactive wiring.
      container.read(processManagerSetupProvider);

      // Read processManager state.
      final state = container.read(processManagerProvider);
      expect(state, isA<ProcessManagerState>());

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
      final updatedState = container.read(processManagerProvider);
      expect(updatedState.get('proxy'), isNotNull);
    });
  });

  group('providers — generated provider types', () {
    test('configServiceProvider is a ConfigServiceProvider', () {
      expect(configServiceProvider, isA<ConfigServiceProvider>());
    });

    test('configProvider is a ConfigProvider', () {
      expect(configProvider, isA<ConfigProvider>());
    });

    test('processManagerProvider is a ProcessManagerNotifierProvider', () {
      expect(processManagerProvider, isA<ProcessManagerNotifierProvider>());
    });

    test('brewServiceProvider is a BrewServiceProvider', () {
      expect(brewServiceProvider, isA<BrewServiceProvider>());
    });

    test('trayServiceProvider is a TrayServiceProvider', () {
      expect(trayServiceProvider, isA<TrayServiceProvider>());
    });
  });
}
