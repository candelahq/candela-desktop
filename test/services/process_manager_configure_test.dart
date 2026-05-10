import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/services/process_manager.dart';

void main() {
  group('ProcessManager.configure', () {
    test('clears previous processes on reconfigure', () {
      final pm = ProcessManager();
      pm.configure(
        providerNames: ['ollama'],
        proxyPort: '8181',
      );
      expect(pm.all.length, 2); // proxy + ollama

      pm.configure(
        providerNames: ['lmstudio'],
        proxyPort: '8181',
      );
      expect(pm.all.length, 2); // proxy + lmstudio
      expect(pm.get('ollama'), isNull);
      expect(pm.get('lmstudio'), isNotNull);
      pm.dispose();
    });

    test('always includes proxy', () {
      final pm = ProcessManager();
      pm.configure(providerNames: [], proxyPort: '8181');
      expect(pm.get('proxy'), isNotNull);
      pm.dispose();
    });

    test('applies port overrides', () {
      final pm = ProcessManager();
      pm.configure(
        providerNames: ['lmstudio'],
        proxyPort: '9090',
        portOverrides: {'lmstudio': '1234'},
      );
      expect(pm.get('lmstudio')?.port, '1234');
      expect(pm.get('proxy')?.port, '9090');
      pm.dispose();
    });

    test('reconfigure cancels stale health timers', () {
      final pm = ProcessManager();
      pm.configure(providerNames: ['ollama'], proxyPort: '8181');
      // Reconfigure — should not leak timers from first configure.
      pm.configure(providerNames: ['lmstudio'], proxyPort: '8181');
      // No crash or timer leak.
      pm.dispose();
    });
  });

  group('ManagedProcess', () {
    test('uptimeString formats correctly', () {
      final p = ManagedProcess(
        name: 'test',
        displayName: 'Test',
        icon: '🧪',
      );
      p.startedAt =
          DateTime.now().subtract(const Duration(hours: 2, minutes: 15));
      expect(p.uptimeString, contains('h'));
    });

    test('initial state is stopped', () {
      final p = ManagedProcess(
        name: 'test',
        displayName: 'Test',
        icon: '🧪',
      );
      expect(p.state, ProcessState.stopped);
      expect(p.pid, isNull);
      expect(p.errorMessage, isNull);
    });
  });
}
