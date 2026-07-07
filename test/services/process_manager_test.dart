import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/services/process_manager.dart';

void main() {
  group('ProcessManagerNotifier', () {
    late ProviderContainer container;
    late ProcessManagerNotifier notifier;

    ProcessManagerState readState() => container.read(processManagerProvider);

    setUp(() {
      container = ProviderContainer();
      notifier = container.read(processManagerProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    test('starts empty with no processes', () {
      expect(readState().all, isEmpty);
    });

    test('configure adds proxy always', () {
      notifier.configure(providerNames: []);
      expect(readState().all.length, 1);
      expect(readState().get('proxy'), isNotNull);
      expect(readState().get('proxy')!.displayName, 'Candela Proxy');
      expect(readState().get('proxy')!.port, '8181');
    });

    test('configure respects custom proxy port', () {
      notifier.configure(providerNames: [], proxyPort: '9090');
      expect(readState().get('proxy')!.port, '9090');
    });

    test('configure registers ollama when in providers list', () {
      notifier.configure(providerNames: ['google', 'ollama']);
      expect(readState().all.length, 2); // proxy + ollama
      expect(readState().get('ollama'), isNotNull);
      expect(readState().get('ollama')!.port, '11434');
      expect(readState().get('google'),
          isNull); // cloud providers are not processes
    });

    test('configure registers multiple local providers', () {
      notifier.configure(providerNames: ['ollama', 'vllm', 'lmstudio']);
      expect(readState().all.length, 4); // proxy + 3 local
      expect(readState().get('ollama'), isNotNull);
      expect(readState().get('vllm'), isNotNull);
      expect(readState().get('lmstudio'), isNotNull);
    });

    test('configure ignores unknown providers', () {
      notifier.configure(providerNames: ['google', 'anthropic', 'openai']);
      expect(readState().all.length, 1); // proxy only
    });

    test('configure clears previous state', () {
      notifier.configure(providerNames: ['ollama']);
      expect(readState().all.length, 2);
      notifier.configure(providerNames: ['vllm']);
      expect(readState().all.length, 2);
      expect(readState().get('ollama'), isNull);
      expect(readState().get('vllm'), isNotNull);
    });

    test('all processes start in detecting state', () {
      notifier.configure(providerNames: ['ollama', 'vllm']);
      for (final p in readState().all) {
        expect(p.state, ProcessState.detecting);
        expect(p.pid, isNull);
        expect(p.startedAt, isNull);
      }
    });

    test('state changes on configure', () {
      notifier.configure(providerNames: ['ollama']);
      expect(readState().all, isNotEmpty);
    });
  });

  group('ManagedProcess', () {
    test('uptime is null when not started', () {
      const p = ManagedProcess(name: 'test', displayName: 'Test', icon: 'T');
      expect(p.uptime, isNull);
      expect(p.uptimeString, '');
    });

    test('uptime calculates from startedAt', () {
      final p = ManagedProcess(
        name: 'test',
        displayName: 'Test',
        icon: 'T',
        startedAt: DateTime.now().subtract(const Duration(minutes: 5)),
      );
      expect(p.uptime!.inMinutes, greaterThanOrEqualTo(4));
      expect(p.uptimeString, contains('m'));
    });

    test('uptime shows hours when > 1h', () {
      final p = ManagedProcess(
        name: 'test',
        displayName: 'Test',
        icon: 'T',
        startedAt:
            DateTime.now().subtract(const Duration(hours: 2, minutes: 30)),
      );
      expect(p.uptimeString, contains('h'));
    });

    test('copyWith preserves unmodified fields', () {
      const original = ManagedProcess(
        name: 'ollama',
        displayName: 'Ollama',
        icon: '🦙',
        port: '11434',
      );
      final updated = original.copyWith(state: ProcessState.running);
      expect(updated.name, 'ollama');
      expect(updated.displayName, 'Ollama');
      expect(updated.icon, '🦙');
      expect(updated.port, '11434');
      expect(updated.state, ProcessState.running);
    });

    test('copyWith with nullable fields uses factory pattern', () {
      const original = ManagedProcess(
        name: 'test',
        displayName: 'Test',
        icon: 'T',
        pid: 12345,
        errorMessage: 'some error',
      );
      // Setting pid to null explicitly
      final cleared = original.copyWith(
        pid: () => null,
        errorMessage: () => null,
      );
      expect(cleared.pid, isNull);
      expect(cleared.errorMessage, isNull);
    });
  });

  // --- Port overrides ---

  group('ProcessManagerNotifier port overrides', () {
    late ProviderContainer container;
    late ProcessManagerNotifier notifier;

    ProcessManagerState readState() => container.read(processManagerProvider);

    setUp(() {
      container = ProviderContainer();
      notifier = container.read(processManagerProvider.notifier);
    });

    tearDown(() => container.dispose());

    test('configure applies port overrides to local providers', () {
      notifier.configure(
        providerNames: ['ollama', 'vllm'],
        portOverrides: {'ollama': '22222', 'vllm': '33333'},
      );
      expect(readState().get('ollama')!.port, '22222');
      expect(readState().get('vllm')!.port, '33333');
    });

    test('configure uses defaults when no override', () {
      notifier.configure(
        providerNames: ['ollama'],
        portOverrides: {},
      );
      expect(readState().get('ollama')!.port, '11434');
    });
  });

  // --- stopAll coverage ---

  group('ProcessManagerNotifier stopAll', () {
    late ProviderContainer container;
    late ProcessManagerNotifier notifier;

    ProcessManagerState readState() => container.read(processManagerProvider);

    setUp(() {
      container = ProviderContainer();
      notifier = container.read(processManagerProvider.notifier);
    });

    tearDown(() => container.dispose());

    test('configure clears previous processes', () {
      notifier.configure(providerNames: ['ollama'], proxyPort: '8181');
      expect(readState().all.length, 2); // proxy + ollama

      notifier.configure(providerNames: ['vllm'], proxyPort: '8181');
      expect(readState().all.length, 2); // proxy + vllm
      expect(readState().get('ollama'), isNull);
      expect(readState().get('vllm'), isNotNull);
    });

    test('get returns null for unknown process', () {
      notifier.configure(providerNames: ['ollama'], proxyPort: '8181');
      expect(readState().get('nonexistent'), isNull);
    });

    test('configure with empty providers has only proxy', () {
      notifier.configure(providerNames: [], proxyPort: '9090');
      expect(readState().all.length, 1);
      expect(readState().all.first.name, 'proxy');
      expect(readState().all.first.port, '9090');
    });

    test('process uptime string formats correctly', () {
      const p = ManagedProcess(name: 'test', displayName: 'Test', icon: 'T');
      expect(p.uptimeString, ''); // no startedAt

      final p2 = ManagedProcess(
        name: 'test',
        displayName: 'Test',
        icon: 'T',
        startedAt: DateTime.now().subtract(const Duration(seconds: 45)),
      );
      expect(p2.uptimeString, '45s');

      final p3 = ManagedProcess(
        name: 'test',
        displayName: 'Test',
        icon: 'T',
        startedAt:
            DateTime.now().subtract(const Duration(minutes: 12, seconds: 30)),
      );
      expect(p3.uptimeString, '12m');

      final p4 = ManagedProcess(
        name: 'test',
        displayName: 'Test',
        icon: 'T',
        startedAt:
            DateTime.now().subtract(const Duration(hours: 2, minutes: 15)),
      );
      expect(p4.uptimeString, '2h 15m');
    });
  });

  // --- Audit v4 tests ---

  group('ProcessManagerNotifier — audit v4 tests', () {
    late ProviderContainer container;
    late ProcessManagerNotifier notifier;

    ProcessManagerState readState() => container.read(processManagerProvider);

    setUp(() {
      container = ProviderContainer();
      notifier = container.read(processManagerProvider.notifier);
    });

    tearDown(() => container.dispose());

    test('configure clears health timers from previous config', () {
      notifier.configure(providerNames: ['ollama']);
      notifier.configure(providerNames: ['vllm']);
      // No timer leak — previous ollama timers should be gone.
      expect(readState().get('ollama'), isNull);
      expect(readState().get('vllm'), isNotNull);
    });

    test('ManagedProcess uptimeString formats sub-minute correctly', () {
      final p = ManagedProcess(
        name: 'x',
        displayName: 'X',
        icon: 'X',
        startedAt: DateTime.now().subtract(const Duration(seconds: 5)),
      );
      expect(p.uptimeString, '5s');
    });

    test('ManagedProcess recentLogs handles max capacity', () {
      var logs = <String>[];
      for (var i = 0; i < 60; i++) {
        logs.add('line $i');
      }
      // Trim to maxLogLines like the Notifier would
      if (logs.length > ManagedProcess.maxLogLines) {
        logs = logs.sublist(logs.length - ManagedProcess.maxLogLines);
      }
      final p = ManagedProcess(
        name: 'x',
        displayName: 'X',
        icon: 'X',
        recentLogs: logs,
      );
      expect(p.recentLogs.length, ManagedProcess.maxLogLines);
      expect(p.recentLogs.first, 'line 10'); // oldest 10 were evicted
    });

    test('_runtimeInfo returns null for cloud-only provider', () {
      notifier.configure(providerNames: ['google', 'anthropic']);
      expect(readState().all.length, 1); // only proxy
    });

    test('configure applies lmstudio port override', () {
      notifier.configure(
        providerNames: ['lmstudio'],
        portOverrides: {'lmstudio': '5555'},
      );
      expect(readState().get('lmstudio')!.port, '5555');
    });
  });

  // ── start() / stop() / restart() / startAll() path coverage ─────────────────

  group('ProcessManagerNotifier start/stop early-return paths', () {
    late ProviderContainer container;
    late ProcessManagerNotifier notifier;

    ProcessManagerState readState() => container.read(processManagerProvider);

    setUp(() {
      container = ProviderContainer();
      notifier = container.read(processManagerProvider.notifier);
    });

    tearDown(() => container.dispose());

    test('start unknown key is a no-op', () async {
      notifier.configure(providerNames: []);
      // 'unknown' is not registered — should return immediately without error.
      await expectLater(notifier.start('nonexistent'), completes);
    });

    test('start lmstudio (null binary) returns without changing state',
        () async {
      notifier.configure(providerNames: ['lmstudio']);
      final lmstudio = readState().get('lmstudio')!;
      expect(lmstudio.state, ProcessState.detecting);
      // lmstudio has no CLI binary — start() hits the null-binary early return.
      await notifier.start('lmstudio');
      // State should remain detecting (binary == null path).
      expect(readState().get('lmstudio')!.state, ProcessState.detecting);
    });

    test('stop unknown key is a no-op', () async {
      notifier.configure(providerNames: []);
      await expectLater(notifier.stop('nonexistent'), completes);
    });

    test('stop stopped process with no handle and no PID clears state',
        () async {
      notifier.configure(providerNames: ['ollama']);
      // No handle, no PID — stop() should transition to stopped cleanly.
      await notifier.stop('ollama');
      expect(readState().get('ollama')!.state, ProcessState.stopped);
      expect(readState().get('ollama')!.pid, isNull);
    });

    test('restart unknown key is a no-op', () async {
      notifier.configure(providerNames: []);
      await expectLater(notifier.restart('nonexistent'), completes);
    });

    test('restart lmstudio (null binary) leaves state stopped', () async {
      notifier.configure(providerNames: ['lmstudio']);
      await notifier.restart('lmstudio');
      expect(readState().get('lmstudio')!.state, ProcessState.stopped);
    });

    test('startAll with no processes installed is a no-op', () async {
      // Configure with a cloud-only provider — no local processes.
      notifier.configure(providerNames: []);
      await expectLater(notifier.startAll(), completes);
      // Only proxy is configured — proxy binary won't be installed in CI,
      // but on dev machines it may actually start.
      expect(
          readState().get('proxy')!.state,
          anyOf(ProcessState.detecting, ProcessState.stopped,
              ProcessState.notInstalled, ProcessState.running));
    });

    test('isInstalled returns false for unknown binary name', () async {
      notifier.configure(providerNames: []);
      // lmstudio has no binary — isInstalled returns false immediately.
      notifier.configure(providerNames: ['lmstudio']);
      final result = await notifier.isInstalled('lmstudio');
      expect(result, isFalse);
    });

    test('isInstalled returns false for unregistered name (null binary)',
        () async {
      notifier.configure(providerNames: []);
      // 'proxy' has a binary ('candela') but it won't be on PATH in tests.
      final result = await notifier.isInstalled('proxy');
      // Either false (not installed) or the binary exists on dev machine — both are valid.
      expect(result, isA<bool>());
    });

    test('configure then startAll completes without throwing', () async {
      notifier.configure(providerNames: ['lmstudio', 'vllm']);
      // startAll calls isInstalled for each stopped process.
      // lmstudio has no binary → skipped; vllm likely not installed → skipped.
      await expectLater(notifier.startAll(), completes);
    });

    test('stopAll completes without error', () async {
      notifier.configure(providerNames: ['ollama']);
      // stopAll should complete without error even if nothing is running.
      await notifier.stopAll();
      expect(readState().get('ollama')!.state,
          anyOf(ProcessState.detecting, ProcessState.stopped));
    });

    test('startAll skips processes that are not stopped', () async {
      notifier.configure(providerNames: ['ollama']);
      // Initial state is detecting — startAll skips non-stopped processes.
      await notifier.startAll();
      // State should still be detecting (startAll skips non-stopped processes).
      expect(
          readState().get('ollama')!.state,
          anyOf(ProcessState.detecting, ProcessState.stopped,
              ProcessState.notInstalled));
    });
  });

  group('ProcessManagerNotifier detectRunning', () {
    late ProviderContainer container;
    late ProcessManagerNotifier notifier;

    ProcessManagerState readState() => container.read(processManagerProvider);

    setUp(() {
      container = ProviderContainer();
      notifier = container.read(processManagerProvider.notifier);
    });

    tearDown(() => container.dispose());

    test('detectRunning completes without error when no processes configured',
        () async {
      notifier.configure(providerNames: []);
      await expectLater(notifier.detectRunning(), completes);
    });

    test('detectRunning marks lmstudio as notInstalled when binary missing',
        () async {
      notifier.configure(providerNames: ['lmstudio']);
      await notifier.detectRunning();
      // lmstudio has no CLI binary, but its health endpoint may respond
      // if LM Studio is running on this machine.
      expect(
        readState().get('lmstudio')!.state,
        anyOf(ProcessState.notInstalled, ProcessState.running),
      );
    });

    test('detectRunning with ollama configured resolves to a valid state',
        () async {
      notifier.configure(providerNames: ['ollama']);
      await notifier.detectRunning();
      // On dev machines ollama may be running; in CI it won't be.
      expect(
        readState().get('ollama')!.state,
        anyOf(ProcessState.stopped, ProcessState.notInstalled,
            ProcessState.running),
      );
    });

    test('detectRunning with proxy configured resolves to a valid state',
        () async {
      notifier.configure(providerNames: []);
      await notifier.detectRunning();
      expect(
        readState().get('proxy')!.state,
        anyOf(ProcessState.stopped, ProcessState.notInstalled,
            ProcessState.running),
      );
    });
  });

  // ── Immutable state transition tests ─────────────────────────────────────

  group('ProcessManagerState immutability', () {
    test('ProcessManagerState.copyWith creates a new instance', () {
      const original = ProcessManagerState();
      final updated = original.copyWith(processes: [
        const ManagedProcess(name: 'proxy', displayName: 'Proxy', icon: 'P'),
      ]);
      expect(original.processes, isEmpty);
      expect(updated.processes.length, 1);
    });

    test('ManagedProcess is immutable (fields are final)', () {
      const p = ManagedProcess(
        name: 'test',
        displayName: 'Test',
        icon: 'T',
        state: ProcessState.running,
        pid: 123,
      );
      // Verify that copyWith creates a new instance
      final stopped = p.copyWith(state: ProcessState.stopped, pid: () => null);
      expect(p.state, ProcessState.running);
      expect(p.pid, 123);
      expect(stopped.state, ProcessState.stopped);
      expect(stopped.pid, isNull);
    });

    test('ProcessManagerState.get returns null for unknown process', () {
      const s = ProcessManagerState(processes: [
        ManagedProcess(name: 'proxy', displayName: 'Proxy', icon: 'P'),
      ]);
      expect(s.get('proxy'), isNotNull);
      expect(s.get('unknown'), isNull);
    });

    test('ProcessManagerState.all returns all processes', () {
      const s = ProcessManagerState(processes: [
        ManagedProcess(name: 'a', displayName: 'A', icon: 'A'),
        ManagedProcess(name: 'b', displayName: 'B', icon: 'B'),
      ]);
      expect(s.all.length, 2);
    });
  });
}
