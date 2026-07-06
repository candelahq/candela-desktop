import 'dart:io';

/// Injectable abstraction over Dart's [Process.run] and [Process.start].
///
/// Production code uses [SystemProcessRunner] (the default).  Tests can
/// substitute a mock or fake that records calls and returns canned results
/// without spawning real subprocesses.
///
/// ## Usage
///
/// ```dart
/// class MyService {
///   final ProcessRunner _runner;
///   MyService({ProcessRunner? runner}) : _runner = runner ?? const SystemProcessRunner();
///
///   Future<bool> isInstalled() async {
///     final result = await _runner.run('which', ['my-tool']);
///     return result.exitCode == 0;
///   }
/// }
/// ```
abstract class ProcessRunner {
  /// Runs [executable] with [arguments] and returns the completed result.
  ///
  /// Mirrors [Process.run] — collects stdout/stderr and returns a
  /// [ProcessResult] once the process exits.
  Future<ProcessResult> run(
    String executable,
    List<String> arguments, {
    Map<String, String>? environment,
    String? workingDirectory,
    bool runInShell = false,
  });

  /// Starts [executable] with [arguments] and returns the live [Process].
  ///
  /// Mirrors [Process.start] — the caller is responsible for reading
  /// stdout/stderr streams and waiting for exit.
  Future<Process> start(
    String executable,
    List<String> arguments, {
    Map<String, String>? environment,
    String? workingDirectory,
    bool runInShell = false,
    ProcessStartMode mode = ProcessStartMode.normal,
  });
}

/// Default implementation that delegates to [Process.run] / [Process.start].
class SystemProcessRunner implements ProcessRunner {
  /// Creates a [SystemProcessRunner].
  const SystemProcessRunner();

  @override
  Future<ProcessResult> run(
    String executable,
    List<String> arguments, {
    Map<String, String>? environment,
    String? workingDirectory,
    bool runInShell = false,
  }) =>
      Process.run(
        executable,
        arguments,
        environment: environment,
        workingDirectory: workingDirectory,
        runInShell: runInShell,
      );

  @override
  Future<Process> start(
    String executable,
    List<String> arguments, {
    Map<String, String>? environment,
    String? workingDirectory,
    bool runInShell = false,
    ProcessStartMode mode = ProcessStartMode.normal,
  }) =>
      Process.start(
        executable,
        arguments,
        environment: environment,
        workingDirectory: workingDirectory,
        runInShell: runInShell,
        mode: mode,
      );
}
