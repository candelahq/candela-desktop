import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/utils/process_runner.dart';

/// A fake [ProcessRunner] that records calls and returns canned results.
///
/// Tests inject this to verify services call the right commands without
/// spawning real subprocesses.
class FakeProcessRunner implements ProcessRunner {
  final List<({String executable, List<String> args})> runCalls = [];
  final List<({String executable, List<String> args})> startCalls = [];

  ProcessResult nextRunResult = ProcessResult(0, 0, '', '');
  ProcessResult Function(String, List<String>)? onRun;

  @override
  Future<ProcessResult> run(
    String executable,
    List<String> arguments, {
    Map<String, String>? environment,
    String? workingDirectory,
    bool runInShell = false,
  }) async {
    runCalls.add((executable: executable, args: arguments));
    if (onRun != null) return onRun!(executable, arguments);
    return nextRunResult;
  }

  @override
  Future<Process> start(
    String executable,
    List<String> arguments, {
    Map<String, String>? environment,
    String? workingDirectory,
    bool runInShell = false,
    ProcessStartMode mode = ProcessStartMode.normal,
  }) async {
    startCalls.add((executable: executable, args: arguments));
    // Return a real process for start() — tests needing full control
    // should mock at a higher level.
    return Process.start('echo', ['fake']);
  }
}

void main() {
  group('ProcessRunner', () {
    test('SystemProcessRunner is const-constructible', () {
      const runner = SystemProcessRunner();
      expect(runner, isA<ProcessRunner>());
    });

    test('SystemProcessRunner.run delegates to Process.run', () async {
      const runner = SystemProcessRunner();
      final result = await runner.run('echo', ['hello']);
      expect(result.exitCode, 0);
      expect((result.stdout as String).trim(), 'hello');
    });

    test('SystemProcessRunner.start delegates to Process.start', () async {
      const runner = SystemProcessRunner();
      final process = await runner.start('echo', ['hello']);
      final exitCode = await process.exitCode;
      expect(exitCode, 0);
    });
  });

  group('FakeProcessRunner', () {
    test('records run calls', () async {
      final fake = FakeProcessRunner();
      fake.nextRunResult = ProcessResult(0, 0, 'output', '');

      await fake.run('gcloud', ['--version']);
      await fake.run('brew', ['list']);

      expect(fake.runCalls, hasLength(2));
      expect(fake.runCalls[0].executable, 'gcloud');
      expect(fake.runCalls[0].args, ['--version']);
      expect(fake.runCalls[1].executable, 'brew');
    });

    test('onRun callback overrides default', () async {
      final fake = FakeProcessRunner();
      fake.onRun = (exe, args) {
        if (exe == 'which') return ProcessResult(0, 0, '/usr/bin/brew', '');
        return ProcessResult(0, 1, '', 'not found');
      };

      final r1 = await fake.run('which', ['brew']);
      expect(r1.exitCode, 0);
      expect(r1.stdout, '/usr/bin/brew');

      final r2 = await fake.run('gcloud', ['--version']);
      expect(r2.exitCode, 1);
    });

    test('records start calls', () async {
      final fake = FakeProcessRunner();
      await fake.start('ollama', ['serve']);
      expect(fake.startCalls, hasLength(1));
      expect(fake.startCalls[0].executable, 'ollama');
    });
  });
}
