import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/services/process_manager.dart';

/// Integration test: ProcessManagerNotifier configure → reconfigure with no state leak.
void main() {
  group('ProcessManagerNotifier — integration reconfigure', () {
    late ProviderContainer container;
    late ProcessManagerNotifier notifier;

    setUp(() {
      container = ProviderContainer();
      notifier = container.read(processManagerProvider.notifier);
    });

    tearDown(() => container.dispose());

    test('configure → reconfigure preserves no stale state', () {
      // Initial config with ollama + vllm.
      notifier.configure(
        providerNames: ['ollama', 'vllm'],
        proxyPort: '8181',
      );
      final state1 = container.read(processManagerProvider);
      expect(state1.all.length, 3); // proxy + ollama + vllm
      expect(state1.get('ollama'), isNotNull);

      // Reconfigure with only lmstudio.
      notifier.configure(
        providerNames: ['lmstudio'],
        proxyPort: '9090',
        portOverrides: {'lmstudio': '5555'},
      );

      final state2 = container.read(processManagerProvider);

      // Old processes should be fully gone.
      expect(state2.get('ollama'), isNull);
      expect(state2.get('vllm'), isNull);
      expect(state2.all.length, 2); // proxy + lmstudio

      // New proxy should have updated port; state preserved from initial config.
      expect(state2.get('proxy')!.port, '9090');
      expect(state2.get('lmstudio')!.port, '5555');

      // lmstudio is newly added — starts fresh.
      expect(state2.get('lmstudio')!.state, ProcessState.detecting);
      expect(state2.get('lmstudio')!.pid, isNull);

      // proxy was preserved from previous config — still detecting (its
      // initial state), since we never changed it.
      expect(state2.get('proxy')!.state, ProcessState.detecting);
      expect(state2.get('proxy')!.pid, isNull);
    });

    test('stopAll then reconfigure leaves clean state', () async {
      notifier.configure(providerNames: ['ollama']);

      await notifier.stopAll();

      notifier.configure(providerNames: ['vllm']);
      final state = container.read(processManagerProvider);
      expect(state.get('ollama'), isNull);
      expect(state.get('vllm')!.state, ProcessState.detecting);
    });
  });
}
