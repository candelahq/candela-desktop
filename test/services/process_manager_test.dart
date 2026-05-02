import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/services/process_manager.dart';

void main() {
  group('ProcessManager', () {
    late ProcessManager pm;

    setUp(() {
      pm = ProcessManager();
    });

    tearDown(() {
      pm.dispose();
    });

    test('starts empty with no processes', () {
      expect(pm.all, isEmpty);
    });

    test('configure adds proxy always', () {
      pm.configure(providerNames: []);
      expect(pm.all.length, 1);
      expect(pm.get('proxy'), isNotNull);
      expect(pm.get('proxy')!.displayName, 'Candela Proxy');
      expect(pm.get('proxy')!.port, '8181');
    });

    test('configure respects custom proxy port', () {
      pm.configure(providerNames: [], proxyPort: '9090');
      expect(pm.get('proxy')!.port, '9090');
    });

    test('configure registers ollama when in providers list', () {
      pm.configure(providerNames: ['google', 'ollama']);
      expect(pm.all.length, 2); // proxy + ollama
      expect(pm.get('ollama'), isNotNull);
      expect(pm.get('ollama')!.port, '11434');
      expect(pm.get('google'), isNull); // cloud providers are not processes
    });

    test('configure registers multiple local providers', () {
      pm.configure(providerNames: ['ollama', 'vllm', 'lmstudio']);
      expect(pm.all.length, 4); // proxy + 3 local
      expect(pm.get('ollama'), isNotNull);
      expect(pm.get('vllm'), isNotNull);
      expect(pm.get('lmstudio'), isNotNull);
    });

    test('configure ignores unknown providers', () {
      pm.configure(providerNames: ['google', 'anthropic', 'openai']);
      expect(pm.all.length, 1); // proxy only
    });

    test('configure clears previous state', () {
      pm.configure(providerNames: ['ollama']);
      expect(pm.all.length, 2);
      pm.configure(providerNames: ['vllm']);
      expect(pm.all.length, 2);
      expect(pm.get('ollama'), isNull);
      expect(pm.get('vllm'), isNotNull);
    });

    test('all processes start in stopped state', () {
      pm.configure(providerNames: ['ollama', 'vllm']);
      for (final p in pm.all) {
        expect(p.state, ProcessState.stopped);
        expect(p.pid, isNull);
        expect(p.startedAt, isNull);
      }
    });

    test('notifies listeners on configure', () {
      var notified = false;
      pm.addListener(() => notified = true);
      pm.configure(providerNames: ['ollama']);
      expect(notified, isTrue);
    });
  });

  group('ManagedProcess', () {
    test('uptime is null when not started', () {
      final p = ManagedProcess(name: 'test', displayName: 'Test', icon: 'T');
      expect(p.uptime, isNull);
      expect(p.uptimeString, '');
    });

    test('uptime calculates from startedAt', () {
      final p = ManagedProcess(name: 'test', displayName: 'Test', icon: 'T');
      p.startedAt = DateTime.now().subtract(const Duration(minutes: 5));
      expect(p.uptime!.inMinutes, greaterThanOrEqualTo(4));
      expect(p.uptimeString, contains('m'));
    });

    test('uptime shows hours when > 1h', () {
      final p = ManagedProcess(name: 'test', displayName: 'Test', icon: 'T');
      p.startedAt = DateTime.now().subtract(const Duration(hours: 2, minutes: 30));
      expect(p.uptimeString, contains('h'));
    });
  });

  // --- Fix #2: port overrides ---

  group('ProcessManager port overrides', () {
    late ProcessManager pm;
    setUp(() => pm = ProcessManager());
    tearDown(() => pm.dispose());

    test('configure applies port overrides to local providers', () {
      pm.configure(
        providerNames: ['ollama', 'vllm'],
        portOverrides: {'ollama': '22222', 'vllm': '33333'},
      );
      expect(pm.get('ollama')!.port, '22222');
      expect(pm.get('vllm')!.port, '33333');
    });

    test('configure uses defaults when no override', () {
      pm.configure(
        providerNames: ['ollama'],
        portOverrides: {},
      );
      expect(pm.get('ollama')!.port, '11434');
    });
  });

  // --- Fix #6: stopAll coverage ---

  group('ProcessManager stopAll', () {
    late ProcessManager pm;
    setUp(() => pm = ProcessManager());
    tearDown(() => pm.dispose());

    test('stopAll targets all running processes not just those with handles', () {
      pm.configure(providerNames: ['ollama']);
      // Simulate a detected-running process (no handle, but state=running).
      final ollama = pm.get('ollama')!;
      ollama.state = ProcessState.running;
      ollama.pid = 12345;

      // stopAll should attempt to stop it.
      // We can't verify kill() in unit tests, but we can verify state transition.
      pm.stopAll();
      // After stopAll, process should be stopped.
      expect(ollama.state, ProcessState.stopped);
      expect(ollama.pid, isNull);
    });
  });
}
