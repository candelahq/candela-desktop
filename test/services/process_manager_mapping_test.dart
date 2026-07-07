import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/services/process_manager.dart';

void main() {
  group('ProcessManagerNotifier — static process mapping', () {
    late ProviderContainer container;
    late ProcessManagerNotifier notifier;

    setUp(() {
      container = ProviderContainer();
      notifier = container.read(processManagerProvider.notifier);
    });

    tearDown(() => container.dispose());

    test('ollama process has correct defaults', () {
      notifier.configure(providerNames: ['ollama'], proxyPort: '8181');
      final ollama = container.read(processManagerProvider).get('ollama');
      expect(ollama, isNotNull);
      expect(ollama!.displayName, 'Ollama');
      expect(ollama.icon, '🦙');
      expect(ollama.port, '11434');
    });

    test('vllm process has correct defaults', () {
      notifier.configure(providerNames: ['vllm'], proxyPort: '8181');
      final vllm = container.read(processManagerProvider).get('vllm');
      expect(vllm, isNotNull);
      expect(vllm!.displayName, 'vLLM');
      expect(vllm.port, '8000');
    });

    test('lmstudio process has correct defaults', () {
      notifier.configure(providerNames: ['lmstudio'], proxyPort: '8181');
      final lm = container.read(processManagerProvider).get('lmstudio');
      expect(lm, isNotNull);
      expect(lm!.displayName, 'LM Studio');
      expect(lm.port, '1234');
    });

    test('unknown provider is silently skipped', () {
      notifier.configure(providerNames: ['unknown_runtime'], proxyPort: '8181');
      final state = container.read(processManagerProvider);
      // Only proxy should exist
      expect(state.all.length, 1);
      expect(state.get('proxy'), isNotNull);
    });

    test('proxy is configured with correct port', () {
      notifier.configure(providerNames: [], proxyPort: '9999');
      final proxy = container.read(processManagerProvider).get('proxy');
      expect(proxy, isNotNull);
      expect(proxy!.displayName, 'Candela Proxy');
      expect(proxy.port, '9999');
    });

    test('multiple providers configured simultaneously', () {
      notifier.configure(
        providerNames: ['ollama', 'vllm', 'lmstudio'],
        proxyPort: '8181',
      );
      final state = container.read(processManagerProvider);
      expect(state.all.length, 4); // proxy + 3
      expect(state.get('ollama'), isNotNull);
      expect(state.get('vllm'), isNotNull);
      expect(state.get('lmstudio'), isNotNull);
      expect(state.get('proxy'), isNotNull);
    });
  });

  group('ManagedProcess — state transitions (immutable)', () {
    test('state starts as detecting', () {
      const p = ManagedProcess(
        name: 'test',
        displayName: 'Test',
        icon: 'T',
      );
      expect(p.state, ProcessState.detecting);
    });

    test('copyWith can transition to starting', () {
      const p = ManagedProcess(
        name: 'test',
        displayName: 'Test',
        icon: 'T',
      );
      final updated = p.copyWith(state: ProcessState.starting);
      expect(updated.state, ProcessState.starting);
    });

    test('copyWith can transition to running', () {
      const p = ManagedProcess(
        name: 'test',
        displayName: 'Test',
        icon: 'T',
      );
      final updated = p.copyWith(
        state: ProcessState.running,
        startedAt: () => DateTime.now(),
      );
      expect(updated.state, ProcessState.running);
      expect(updated.startedAt, isNotNull);
    });

    test('copyWith can set error with message', () {
      const p = ManagedProcess(
        name: 'test',
        displayName: 'Test',
        icon: 'T',
      );
      final updated = p.copyWith(
        state: ProcessState.error,
        errorMessage: () => 'Process crashed',
      );
      expect(updated.state, ProcessState.error);
      expect(updated.errorMessage, 'Process crashed');
    });

    test('uptimeString returns empty when not started', () {
      const p = ManagedProcess(
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
        startedAt: DateTime.now().subtract(const Duration(minutes: 5)),
      );
      final uptime = p.uptimeString;
      expect(uptime, isNotNull);
      expect(uptime, contains('m'));
    });

    test('uptimeString shows hours for long uptime', () {
      final p = ManagedProcess(
        name: 'test',
        displayName: 'Test',
        icon: 'T',
        startedAt: DateTime.now().subtract(const Duration(hours: 3)),
      );
      final uptime = p.uptimeString;
      expect(uptime, isNotNull);
      expect(uptime, contains('h'));
    });

    test('recentLogs set via constructor', () {
      const p = ManagedProcess(
        name: 'test',
        displayName: 'Test',
        icon: 'T',
        recentLogs: ['line 1', 'line 2'],
      );
      expect(p.recentLogs.length, 2);
      expect(p.recentLogs.first, 'line 1');
    });
  });
}
