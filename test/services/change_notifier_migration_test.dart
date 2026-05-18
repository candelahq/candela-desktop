import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/services/process_manager.dart';
import 'package:candela_desktop/services/update_service.dart';

/// Tests verifying ChangeNotifier behavior after the SafeChangeNotifier removal.
/// These ensure the migration preserved correct dispose/notify semantics.
void main() {
  group('ProcessManager — ChangeNotifier migration', () {
    test('notifyListeners works after configure', () {
      final pm = ProcessManager();
      var notified = false;
      pm.addListener(() => notified = true);
      pm.configure(providerNames: ['ollama']);
      expect(notified, isTrue);
      pm.dispose();
    });

    test('notifyListeners is safe after dispose', () {
      final pm = ProcessManager();
      pm.configure(providerNames: ['ollama']);
      pm.dispose();

      // After dispose, notifyListeners should be a no-op (not throw).
      // Calling configure after dispose exercises the override.
      expect(() => pm.configure(providerNames: ['vllm']), returnsNormally);
    });

    test('disposed ProcessManager does not notify after detectRunning',
        () async {
      final pm = ProcessManager();
      pm.configure(providerNames: ['ollama']);

      var notifiedAfterDispose = false;
      pm.addListener(() => notifiedAfterDispose = true);

      pm.dispose();
      notifiedAfterDispose = false;

      // detectRunning should complete without error even after dispose.
      await pm.detectRunning();
      expect(notifiedAfterDispose, isFalse);
    });

    test('multiple configure calls notify each time', () {
      final pm = ProcessManager();
      var count = 0;
      pm.addListener(() => count++);

      pm.configure(providerNames: ['ollama']);
      pm.configure(providerNames: ['vllm']);
      pm.configure(providerNames: []);

      expect(count, 3);
      pm.dispose();
    });

    test('dispose cleans up handles and timers without error', () {
      final pm = ProcessManager();
      pm.configure(providerNames: ['ollama', 'vllm', 'lmstudio']);
      pm.dispose();
    });

    test('stop after dispose does not crash', () async {
      final pm = ProcessManager();
      pm.configure(providerNames: ['ollama']);
      pm.get('ollama')!.state = ProcessState.running;
      pm.dispose();

      // stop() calls notifyListeners — should be safe after dispose.
      await expectLater(pm.stop('ollama'), completes);
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
