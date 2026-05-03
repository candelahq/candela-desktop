import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/services/process_manager.dart';

/// Integration test: ProcessManager configure → reconfigure with no state leak.
void main() {
  group('ProcessManager — integration reconfigure', () {
    late ProcessManager pm;

    setUp(() => pm = ProcessManager());
    tearDown(() => pm.dispose());

    test('configure → reconfigure preserves no stale state', () {
      // Initial config with ollama + vllm.
      pm.configure(
        providerNames: ['ollama', 'vllm'],
        proxyPort: '8181',
      );
      expect(pm.all.length, 3); // proxy + ollama + vllm

      // Simulate ollama running.
      final ollama = pm.get('ollama')!;
      ollama.state = ProcessState.running;
      ollama.pid = 12345;
      ollama.startedAt = DateTime.now();
      ollama.recentLogs.addLast('started serving');

      // Reconfigure with only lmstudio.
      pm.configure(
        providerNames: ['lmstudio'],
        proxyPort: '9090',
        portOverrides: {'lmstudio': '5555'},
      );

      // Old processes should be fully gone.
      expect(pm.get('ollama'), isNull);
      expect(pm.get('vllm'), isNull);
      expect(pm.all.length, 2); // proxy + lmstudio

      // New proxy should have updated port.
      expect(pm.get('proxy')!.port, '9090');
      expect(pm.get('lmstudio')!.port, '5555');

      // All new processes start fresh.
      for (final p in pm.all) {
        expect(p.state, ProcessState.stopped);
        expect(p.pid, isNull);
        expect(p.recentLogs, isEmpty);
      }
    });

    test('stopAll then reconfigure leaves clean state', () async {
      pm.configure(providerNames: ['ollama']);
      final ollama = pm.get('ollama')!;
      ollama.state = ProcessState.error;
      ollama.pid = 99999;
      ollama.errorMessage = 'crashed';

      await pm.stopAll();
      expect(ollama.state, ProcessState.stopped);

      pm.configure(providerNames: ['vllm']);
      expect(pm.get('ollama'), isNull);
      expect(pm.get('vllm')!.state, ProcessState.stopped);
    });
  });
}
