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

    test('disposed ProcessManager does not notify after detectRunning',
        () async {
      final pm = ProcessManager();
      pm.configure(providerNames: ['ollama']);

      var notifiedAfterDispose = false;
      pm.addListener(() => notifiedAfterDispose = true);

      // Dispose before detectRunning completes — the _disposed guard
      // should prevent notifyListeners() from being called.
      pm.dispose();
      notifiedAfterDispose = false;

      // detectRunning should complete without error even after dispose.
      // The internal _disposed check prevents the post-detection notify.
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
      // Should not throw.
      pm.dispose();
    });
  });

  group('UpdateService — ChangeNotifier migration', () {
    test('status changes trigger notifyListeners', () {
      final svc = UpdateService();
      var count = 0;
      svc.addListener(() => count++);

      // checkForUpdate will fail fast (no network in tests) but
      // should still trigger a status change to 'checking'.
      svc.checkForUpdate('0.1.0');

      // The status should have changed at least once (to checking).
      expect(count, greaterThanOrEqualTo(1));
      expect(svc.status, UpdateStatus.checking);
      svc.dispose();
    });

    test('dispose does not throw', () {
      final svc = UpdateService();
      // Should not throw.
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
  });
}
