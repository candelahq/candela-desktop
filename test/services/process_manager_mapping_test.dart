import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/services/process_manager.dart';

void main() {
  group('ProcessManager — static process mapping', () {
    test('ollama process has correct defaults', () {
      final pm = ProcessManager();
      pm.configure(providerNames: ['ollama'], proxyPort: '8181');
      final ollama = pm.get('ollama');
      expect(ollama, isNotNull);
      expect(ollama!.displayName, 'Ollama');
      expect(ollama.icon, '🦙');
      expect(ollama.port, '11434');
      pm.dispose();
    });

    test('vllm process has correct defaults', () {
      final pm = ProcessManager();
      pm.configure(providerNames: ['vllm'], proxyPort: '8181');
      final vllm = pm.get('vllm');
      expect(vllm, isNotNull);
      expect(vllm!.displayName, 'vLLM');
      expect(vllm.port, '8000');
      pm.dispose();
    });

    test('lmstudio process has correct defaults', () {
      final pm = ProcessManager();
      pm.configure(providerNames: ['lmstudio'], proxyPort: '8181');
      final lm = pm.get('lmstudio');
      expect(lm, isNotNull);
      expect(lm!.displayName, 'LM Studio');
      expect(lm.port, '1234');
      pm.dispose();
    });

    test('unknown provider is silently skipped', () {
      final pm = ProcessManager();
      pm.configure(providerNames: ['unknown_runtime'], proxyPort: '8181');
      // Only proxy should exist
      expect(pm.all.length, 1);
      expect(pm.get('proxy'), isNotNull);
      pm.dispose();
    });

    test('proxy is configured with correct port', () {
      final pm = ProcessManager();
      pm.configure(providerNames: [], proxyPort: '9999');
      final proxy = pm.get('proxy');
      expect(proxy, isNotNull);
      expect(proxy!.displayName, 'Candela Proxy');
      expect(proxy.port, '9999');
      pm.dispose();
    });

    test('multiple providers configured simultaneously', () {
      final pm = ProcessManager();
      pm.configure(
        providerNames: ['ollama', 'vllm', 'lmstudio'],
        proxyPort: '8181',
      );
      expect(pm.all.length, 4); // proxy + 3
      expect(pm.get('ollama'), isNotNull);
      expect(pm.get('vllm'), isNotNull);
      expect(pm.get('lmstudio'), isNotNull);
      expect(pm.get('proxy'), isNotNull);
      pm.dispose();
    });
  });

  group('ManagedProcess — state transitions', () {
    test('state starts as stopped', () {
      final p = ManagedProcess(
        name: 'test',
        displayName: 'Test',
        icon: 'T',
      );
      expect(p.state, ProcessState.stopped);
    });

    test('can transition to starting', () {
      final p = ManagedProcess(
        name: 'test',
        displayName: 'Test',
        icon: 'T',
      );
      p.state = ProcessState.starting;
      expect(p.state, ProcessState.starting);
    });

    test('can transition to running', () {
      final p = ManagedProcess(
        name: 'test',
        displayName: 'Test',
        icon: 'T',
      );
      p.state = ProcessState.running;
      p.startedAt = DateTime.now();
      expect(p.state, ProcessState.running);
      expect(p.startedAt, isNotNull);
    });

    test('can set error with message', () {
      final p = ManagedProcess(
        name: 'test',
        displayName: 'Test',
        icon: 'T',
      );
      p.state = ProcessState.error;
      p.errorMessage = 'Process crashed';
      expect(p.state, ProcessState.error);
      expect(p.errorMessage, 'Process crashed');
    });

    test('uptimeString returns empty when not started', () {
      final p = ManagedProcess(
        name: 'test',
        displayName: 'Test',
        icon: 'T',
      );
      expect(p.uptimeString, anyOf(isNull, isEmpty));
    });

    test('uptimeString shows minutes for short uptime', () {
      final p = ManagedProcess(
        name: 'test',
        displayName: 'Test',
        icon: 'T',
      );
      p.startedAt = DateTime.now().subtract(const Duration(minutes: 5));
      final uptime = p.uptimeString;
      expect(uptime, isNotNull);
      expect(uptime, contains('m'));
    });

    test('uptimeString shows hours for long uptime', () {
      final p = ManagedProcess(
        name: 'test',
        displayName: 'Test',
        icon: 'T',
      );
      p.startedAt = DateTime.now().subtract(const Duration(hours: 3));
      final uptime = p.uptimeString;
      expect(uptime, isNotNull);
      expect(uptime, contains('h'));
    });

    test('recentLogs captures entries', () {
      final p = ManagedProcess(
        name: 'test',
        displayName: 'Test',
        icon: 'T',
      );
      p.recentLogs.addLast('line 1');
      p.recentLogs.addLast('line 2');
      expect(p.recentLogs.length, 2);
      expect(p.recentLogs.first, 'line 1');
    });
  });
}
