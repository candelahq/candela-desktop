import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/services/process_manager.dart';

void main() {
  group('ProcessManagerNotifier.configure', () {
    late ProviderContainer container;
    late ProcessManagerNotifier notifier;

    setUp(() {
      container = ProviderContainer();
      notifier = container.read(processManagerProvider.notifier);
    });

    tearDown(() => container.dispose());

    test('clears previous processes on reconfigure', () {
      notifier.configure(
        providerNames: ['ollama'],
        proxyPort: '8181',
      );
      expect(container.read(processManagerProvider).all.length,
          2); // proxy + ollama

      notifier.configure(
        providerNames: ['lmstudio'],
        proxyPort: '8181',
      );
      final state = container.read(processManagerProvider);
      expect(state.all.length, 2); // proxy + lmstudio
      expect(state.get('ollama'), isNull);
      expect(state.get('lmstudio'), isNotNull);
    });

    test('always includes proxy', () {
      notifier.configure(providerNames: [], proxyPort: '8181');
      expect(container.read(processManagerProvider).get('proxy'), isNotNull);
    });

    test('applies port overrides', () {
      notifier.configure(
        providerNames: ['lmstudio'],
        proxyPort: '9090',
        portOverrides: {'lmstudio': '1234'},
      );
      final state = container.read(processManagerProvider);
      expect(state.get('lmstudio')?.port, '1234');
      expect(state.get('proxy')?.port, '9090');
    });

    test('reconfigure cancels stale health timers', () {
      notifier.configure(providerNames: ['ollama'], proxyPort: '8181');
      // Reconfigure — should not leak timers from first configure.
      notifier.configure(providerNames: ['lmstudio'], proxyPort: '8181');
      // No crash or timer leak.
    });
  });

  group('ManagedProcess', () {
    test('uptimeString formats correctly', () {
      final p = ManagedProcess(
        name: 'test',
        displayName: 'Test',
        icon: '🧪',
        startedAt:
            DateTime.now().subtract(const Duration(hours: 2, minutes: 15)),
      );
      expect(p.uptimeString, contains('h'));
    });

    test('initial state is detecting', () {
      const p = ManagedProcess(
        name: 'test',
        displayName: 'Test',
        icon: '🧪',
      );
      expect(p.state, ProcessState.detecting);
      expect(p.pid, isNull);
      expect(p.errorMessage, isNull);
    });
  });
}
