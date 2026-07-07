import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/services/process_manager.dart';
import 'package:candela_desktop/services/update_service.dart';

/// Tests verifying Riverpod Notifier behavior after the ChangeNotifier → Riverpod migration.
/// These ensure the migration preserved correct state-update semantics.
void main() {
  group('ProcessManagerNotifier — Riverpod migration', () {
    late ProviderContainer container;
    late ProcessManagerNotifier notifier;

    setUp(() {
      container = ProviderContainer();
      notifier = container.read(processManagerProvider.notifier);
    });

    tearDown(() => container.dispose());

    test('state updates after configure', () {
      var stateChanged = false;
      container.listen<ProcessManagerState>(
        processManagerProvider,
        (prev, next) => stateChanged = true,
      );

      notifier.configure(providerNames: ['ollama']);
      expect(stateChanged, isTrue);
    });

    test('multiple configure calls each produce new state', () {
      final states = <ProcessManagerState>[];
      container.listen<ProcessManagerState>(
        processManagerProvider,
        (prev, next) => states.add(next),
      );

      notifier.configure(providerNames: ['ollama']);
      notifier.configure(providerNames: ['vllm']);
      notifier.configure(providerNames: []);

      expect(states.length, 3);
    });

    test('container.dispose cleans up without error', () {
      notifier.configure(providerNames: ['ollama', 'vllm', 'lmstudio']);
      container.dispose();
      // Re-create so tearDown doesn't double-dispose.
      container = ProviderContainer();
    });

    test('state reflects configured processes', () {
      notifier.configure(providerNames: ['ollama']);
      final state = container.read(processManagerProvider);
      expect(state.get('ollama'), isNotNull);
      expect(state.get('ollama')!.state, ProcessState.detecting);
    });
  });

  group('UpdateService — ChangeNotifier migration', () {
    test('status changes trigger notifyListeners', () {
      final svc = UpdateService();
      var count = 0;
      svc.addListener(() => count++);

      svc.checkForUpdate('0.1.0');

      expect(count, greaterThanOrEqualTo(1));
      expect(svc.status, UpdateStatus.checking);
      svc.dispose();
    });

    test('notifyListeners is safe after dispose', () {
      final svc = UpdateService();
      svc.dispose();

      // checkForUpdate calls _setStatus which calls notifyListeners.
      // After dispose, this should not throw.
      expect(() => svc.checkForUpdate('0.1.0'), returnsNormally);
    });

    test('dispose does not throw', () {
      final svc = UpdateService();
      svc.dispose();
    });

    test('detectChannel returns consistent results', () {
      final svc = UpdateService();
      final channel = svc.detectChannel();
      expect(channel, svc.detectChannel()); // cached
      expect(
        channel,
        anyOf(InstallChannel.direct, InstallChannel.homebrew,
            InstallChannel.nix, InstallChannel.unknown),
      );
      svc.dispose();
    });

    test('updateInstructions returns non-empty for all channels', () {
      final svc = UpdateService();
      for (final channel in InstallChannel.values) {
        expect(svc.updateInstructions(channel), isNotEmpty);
      }
      svc.dispose();
    });

    test('concurrent checkForUpdate calls do not crash after dispose',
        () async {
      final svc = UpdateService();
      // Start an async operation, then immediately dispose.
      final future = svc.checkForUpdate('0.1.0');
      svc.dispose();

      // The future should complete without throwing.
      await expectLater(future, completes);
    });
  });
}
