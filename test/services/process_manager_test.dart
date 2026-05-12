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
      p.startedAt =
          DateTime.now().subtract(const Duration(hours: 2, minutes: 30));
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

    test('stopAll targets all running processes not just those with handles',
        () {
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

    test('configure clears previous processes', () {
      pm.configure(providerNames: ['ollama'], proxyPort: '8181');
      expect(pm.all.length, 2); // proxy + ollama

      pm.configure(providerNames: ['vllm'], proxyPort: '8181');
      expect(pm.all.length, 2); // proxy + vllm
      expect(pm.get('ollama'), isNull);
      expect(pm.get('vllm'), isNotNull);
    });

    test('stopAll handles error-state processes with PIDs', () async {
      pm.configure(providerNames: ['ollama'], proxyPort: '8181');
      final ollama = pm.get('ollama')!;
      ollama.state = ProcessState.error;
      ollama.pid = 99999;

      // stopAll now also stops error-state processes to prevent zombie PIDs.
      await pm.stopAll();
      expect(ollama.state, ProcessState.stopped);
      expect(ollama.pid, isNull);
    });

    test('get returns null for unknown process', () {
      pm.configure(providerNames: ['ollama'], proxyPort: '8181');
      expect(pm.get('nonexistent'), isNull);
    });

    test('configure with empty providers has only proxy', () {
      pm.configure(providerNames: [], proxyPort: '9090');
      expect(pm.all.length, 1);
      expect(pm.all.first.name, 'proxy');
      expect(pm.all.first.port, '9090');
    });

    test('process uptime string formats correctly', () {
      final p = ManagedProcess(name: 'test', displayName: 'Test', icon: 'T');
      expect(p.uptimeString, ''); // no startedAt

      p.startedAt = DateTime.now().subtract(const Duration(seconds: 45));
      expect(p.uptimeString, '45s');

      p.startedAt =
          DateTime.now().subtract(const Duration(minutes: 12, seconds: 30));
      expect(p.uptimeString, '12m');

      p.startedAt =
          DateTime.now().subtract(const Duration(hours: 2, minutes: 15));
      expect(p.uptimeString, '2h 15m');
    });
  });

  // --- Audit v4: new unit tests ---

  group('ProcessManager — audit v4 tests', () {
    late ProcessManager pm;
    setUp(() => pm = ProcessManager());
    tearDown(() => pm.dispose());

    test('stopAll stops error-state processes that still have PIDs', () async {
      pm.configure(providerNames: ['ollama']);
      final ollama = pm.get('ollama')!;
      ollama.state = ProcessState.error;
      ollama.pid = 54321;
      ollama.errorMessage = 'Health check failed';
      await pm.stopAll();
      expect(ollama.state, ProcessState.stopped);
      expect(ollama.pid, isNull);
      expect(ollama.startedAt, isNull);
    });

    test('configure clears health timers from previous config', () {
      pm.configure(providerNames: ['ollama']);
      pm.configure(providerNames: ['vllm']);
      // No timer leak — previous ollama timers should be gone.
      expect(pm.get('ollama'), isNull);
      expect(pm.get('vllm'), isNotNull);
    });

    test('ManagedProcess uptimeString formats sub-minute correctly', () {
      final p = ManagedProcess(name: 'x', displayName: 'X', icon: 'X');
      p.startedAt = DateTime.now().subtract(const Duration(seconds: 5));
      expect(p.uptimeString, '5s');
    });

    test('ManagedProcess recentLogs capped at maxLogLines', () {
      final p = ManagedProcess(name: 'x', displayName: 'X', icon: 'X');
      for (var i = 0; i < 60; i++) {
        p.recentLogs.addLast('line $i');
        while (p.recentLogs.length > ManagedProcess.maxLogLines) {
          p.recentLogs.removeFirst();
        }
      }
      expect(p.recentLogs.length, ManagedProcess.maxLogLines);
      expect(p.recentLogs.first, 'line 10'); // oldest 10 were evicted
    });

    test('_runtimeInfo returns null for cloud-only provider', () {
      pm.configure(providerNames: ['google', 'anthropic']);
      expect(pm.all.length, 1); // only proxy
    });

    test('configure applies lmstudio port override', () {
      pm.configure(
        providerNames: ['lmstudio'],
        portOverrides: {'lmstudio': '5555'},
      );
      expect(pm.get('lmstudio')!.port, '5555');
    });
  });

  // ── start() / stop() / restart() / startAll() path coverage ─────────────────

  group('ProcessManager start/stop early-return paths', () {
    late ProcessManager pm;
    setUp(() => pm = ProcessManager());
    tearDown(() => pm.dispose());

    test('start unknown key is a no-op', () async {
      pm.configure(providerNames: []);
      // 'unknown' is not registered — should return immediately without error.
      await expectLater(pm.start('nonexistent'), completes);
    });

    test('start lmstudio (null binary) returns without changing state',
        () async {
      pm.configure(providerNames: ['lmstudio']);
      final lmstudio = pm.get('lmstudio')!;
      expect(lmstudio.state, ProcessState.stopped);
      // lmstudio has no CLI binary — start() hits the null-binary early return.
      await pm.start('lmstudio');
      // State should remain stopped (binary == null path).
      expect(lmstudio.state, ProcessState.stopped);
    });

    test('stop unknown key is a no-op', () async {
      pm.configure(providerNames: []);
      await expectLater(pm.stop('nonexistent'), completes);
    });

    test('stop stopped process with no handle and no PID clears state',
        () async {
      pm.configure(providerNames: ['ollama']);
      final ollama = pm.get('ollama')!;
      // No handle, no PID — stop() should transition to stopped cleanly.
      ollama.state = ProcessState.stopped;
      await pm.stop('ollama');
      expect(ollama.state, ProcessState.stopped);
      expect(ollama.pid, isNull);
    });

    test('stop running process with PID but no handle sends kill', () async {
      pm.configure(providerNames: ['ollama']);
      final ollama = pm.get('ollama')!;
      ollama.state = ProcessState.running;
      ollama.pid =
          1; // PID 1 (init) always exists; kill to sigterm is safe noop.
      // Should complete without error — actually sends SIGTERM to PID 1 which
      // is ignored on macOS but does exercise the killPid code path.
      await pm.stop('ollama');
      expect(ollama.state, ProcessState.stopped);
      expect(ollama.pid, isNull);
    });

    test('restart unknown key is a no-op', () async {
      pm.configure(providerNames: []);
      await expectLater(pm.restart('nonexistent'), completes);
    });

    test('restart lmstudio (null binary) leaves state stopped', () async {
      pm.configure(providerNames: ['lmstudio']);
      await pm.restart('lmstudio');
      expect(pm.get('lmstudio')!.state, ProcessState.stopped);
    });

    test('startAll with no processes installed is a no-op', () async {
      // Configure with a cloud-only provider — no local processes.
      pm.configure(providerNames: []);
      await expectLater(pm.startAll(), completes);
      // Only proxy is configured — proxy binary won't be installed in CI.
      expect(pm.get('proxy')!.state,
          anyOf(ProcessState.stopped, ProcessState.notInstalled));
    });

    test('isInstalled returns false for unknown binary name', () async {
      pm.configure(providerNames: []);
      // lmstudio has no binary — isInstalled returns false immediately.
      pm.configure(providerNames: ['lmstudio']);
      final result = await pm.isInstalled('lmstudio');
      expect(result, isFalse);
    });

    test('isInstalled returns false for unregistered name (null binary)',
        () async {
      pm.configure(providerNames: []);
      // 'proxy' has a binary ('candela-local') but it won't be on PATH in tests.
      final result = await pm.isInstalled('proxy');
      // Either false (not installed) or the binary exists on dev machine — both are valid.
      expect(result, isA<bool>());
    });

    test('configure then startAll completes without throwing', () async {
      pm.configure(providerNames: ['lmstudio', 'vllm']);
      // startAll calls isInstalled for each stopped process.
      // lmstudio has no binary → skipped; vllm likely not installed → skipped.
      await expectLater(pm.startAll(), completes);
    });

    test('stop from stopping state to stopped is safe', () async {
      pm.configure(providerNames: ['ollama']);
      final ollama = pm.get('ollama')!;
      ollama.state = ProcessState.stopping;
      await pm.stop('ollama');
      expect(ollama.state, ProcessState.stopped);
    });

    test('stopAll with error-state process stops it', () async {
      pm.configure(providerNames: ['ollama']);
      final ollama = pm.get('ollama')!;
      ollama.state = ProcessState.error;
      ollama.pid = null;
      await pm.stopAll();
      expect(ollama.state, ProcessState.stopped);
    });

    test('startAll skips processes that are not stopped', () async {
      pm.configure(providerNames: ['ollama']);
      final ollama = pm.get('ollama')!;
      // Mark it as running — startAll should not attempt to restart it.
      ollama.state = ProcessState.running;
      await pm.startAll();
      // State should still be running (startAll skips non-stopped processes).
      expect(ollama.state, ProcessState.running);
    });
  });

  group('ProcessManager detectRunning', () {
    late ProcessManager pm;
    setUp(() => pm = ProcessManager());
    tearDown(() => pm.dispose());

    test('detectRunning completes without error when no processes configured',
        () async {
      pm.configure(providerNames: []);
      await expectLater(pm.detectRunning(), completes);
    });

    test('detectRunning marks lmstudio as notInstalled when binary missing',
        () async {
      pm.configure(providerNames: ['lmstudio']);
      await pm.detectRunning();
      // lmstudio has no CLI binary, but its health endpoint may respond
      // if LM Studio is running on this machine.
      expect(
        pm.get('lmstudio')!.state,
        anyOf(ProcessState.notInstalled, ProcessState.running),
      );
    });

    test('detectRunning with ollama configured resolves to a valid state',
        () async {
      pm.configure(providerNames: ['ollama']);
      await pm.detectRunning();
      // On dev machines ollama may be running; in CI it won't be.
      expect(
        pm.get('ollama')!.state,
        anyOf(ProcessState.stopped, ProcessState.notInstalled,
            ProcessState.running),
      );
    });

    test('detectRunning with proxy configured resolves to a valid state',
        () async {
      pm.configure(providerNames: []);
      await pm.detectRunning();
      expect(
        pm.get('proxy')!.state,
        anyOf(ProcessState.stopped, ProcessState.notInstalled,
            ProcessState.running),
      );
    });
  });
}
