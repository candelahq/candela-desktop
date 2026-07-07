import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../utils/platform_paths.dart' as platform_paths;
import '../utils/process_runner.dart';

part 'process_manager.g.dart';

/// State of a managed process.
enum ProcessState {
  detecting,
  stopped,
  starting,
  running,
  stopping,
  error,
  notInstalled
}

/// An immutable snapshot of a locally managed process (Ollama, vLLM, LM Studio, Proxy).
class ManagedProcess {
  final String name;
  final String displayName;
  final String icon;
  final ProcessState state;
  final int? pid;
  final String? port;
  final DateTime? startedAt;
  final String? errorMessage;

  /// Recent log lines — stored as an immutable list snapshot.
  final List<String> recentLogs;

  static const int maxLogLines = 50;

  const ManagedProcess({
    required this.name,
    required this.displayName,
    required this.icon,
    this.state = ProcessState.detecting,
    this.pid,
    this.port,
    this.startedAt,
    this.errorMessage,
    this.recentLogs = const [],
  });

  Duration? get uptime =>
      startedAt != null ? DateTime.now().difference(startedAt!) : null;

  String get uptimeString {
    final d = uptime;
    if (d == null) return '';
    if (d.inHours > 0) return '${d.inHours}h ${d.inMinutes.remainder(60)}m';
    if (d.inMinutes > 0) return '${d.inMinutes}m';
    return '${d.inSeconds}s';
  }

  ManagedProcess copyWith({
    String? name,
    String? displayName,
    String? icon,
    ProcessState? state,
    int? Function()? pid,
    String? Function()? port,
    DateTime? Function()? startedAt,
    String? Function()? errorMessage,
    List<String>? recentLogs,
  }) {
    return ManagedProcess(
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      icon: icon ?? this.icon,
      state: state ?? this.state,
      pid: pid != null ? pid() : this.pid,
      port: port != null ? port() : this.port,
      startedAt: startedAt != null ? startedAt() : this.startedAt,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      recentLogs: recentLogs ?? this.recentLogs,
    );
  }
}

/// Immutable state exposed by [ProcessManagerNotifier].
class ProcessManagerState {
  final List<ManagedProcess> processes;

  const ProcessManagerState({this.processes = const []});

  /// All managed processes.
  List<ManagedProcess> get all => processes;

  /// Lookup a process by name, returns null if not found.
  ManagedProcess? get(String name) {
    for (final p in processes) {
      if (p.name == name) return p;
    }
    return null;
  }

  ProcessManagerState copyWith({List<ManagedProcess>? processes}) {
    return ProcessManagerState(processes: processes ?? this.processes);
  }
}

/// Manages local processes: configured runtime backend + Candela Proxy.
///
/// Exposed state is immutable [ProcessManagerState]. OS process handles,
/// health timers, and the HTTP client are internal implementation details.
@Riverpod(keepAlive: true)
class ProcessManagerNotifier extends _$ProcessManagerNotifier {
  ProcessRunner _runner = const SystemProcessRunner();
  final Map<String, Process> _handles = {};
  final Map<String, Timer> _healthTimers = {};
  final http.Client _client = http.Client();

  /// Internal mutable ring buffers for log accumulation.
  /// Snapshot into immutable lists when emitting state.
  final Map<String, List<String>> _logBuffers = {};

  @override
  ProcessManagerState build() {
    ref.onDispose(_cleanup);
    return const ProcessManagerState();
  }

  /// Public accessor for the current state.
  /// Use this in non-widget code (e.g. TrayService) instead of the
  /// protected [state] getter.
  ProcessManagerState get currentState => state;

  /// Override the process runner for testing.
  // ignore: use_setters_to_change_properties
  void setRunner(ProcessRunner runner) {
    _runner = runner;
  }

  /// Configure which processes to manage based on the providers list.
  /// Always includes proxy. Adds any local providers found in the list.
  ///
  /// Preserves existing runtime state (pid, logs, health timers) for
  /// processes that remain configured, to avoid resetting running services.
  void configure({
    required List<String> providerNames,
    String? proxyPort,
    Map<String, String>? portOverrides,
  }) {
    // Build the set of names that should remain after reconfiguration.
    final desiredNames = {'proxy', ...providerNames};
    final existingByName = {
      for (final p in state.processes) p.name: p,
    };

    // Kill handles and cancel timers for processes being removed.
    for (final name in existingByName.keys) {
      if (!desiredNames.contains(name)) {
        final h = _handles.remove(name);
        if (h != null) _killProcess(h);
        _healthTimers[name]?.cancel();
        _healthTimers.remove(name);
        _logBuffers.remove(name);
      }
    }

    final newProcesses = <ManagedProcess>[];

    // Proxy is always managed — preserve existing state if present.
    final existingProxy = existingByName['proxy'];
    if (existingProxy != null) {
      newProcesses.add(existingProxy.copyWith(
        port: () => proxyPort ?? '8181',
      ));
    } else {
      newProcesses.add(ManagedProcess(
        name: 'proxy',
        displayName: 'Candela Proxy',
        icon: '🕯️',
        port: proxyPort ?? '8181',
      ));
    }

    // Add local providers — preserve existing state when available.
    for (final name in providerNames) {
      final existing = existingByName[name];
      if (existing != null) {
        // Apply port override if changed.
        if (portOverrides != null && portOverrides.containsKey(name)) {
          newProcesses.add(existing.copyWith(port: () => portOverrides[name]));
        } else {
          newProcesses.add(existing);
        }
      } else {
        var info = _runtimeInfo(name);
        if (info != null) {
          if (portOverrides != null && portOverrides.containsKey(name)) {
            info = info.copyWith(port: () => portOverrides[name]);
          }
          newProcesses.add(info);
        }
      }
    }

    state = ProcessManagerState(processes: newProcesses);
  }

  static ManagedProcess? _runtimeInfo(String name) => switch (name) {
        'ollama' => const ManagedProcess(
            name: 'ollama',
            displayName: 'Ollama',
            icon: '🦙',
            port: '11434',
          ),
        'vllm' => const ManagedProcess(
            name: 'vllm',
            displayName: 'vLLM',
            icon: 'V',
            port: '8000',
          ),
        'lmstudio' => const ManagedProcess(
            name: 'lmstudio',
            displayName: 'LM Studio',
            icon: 'L',
            port: '1234',
          ),
        _ => null,
      };

  /// Check if a binary is installed.
  Future<bool> isInstalled(String name) async {
    final binary = _binaryName(name);
    if (binary == null) return false;
    try {
      final cmd = Platform.isWindows ? 'where.exe' : 'which';
      final result = await _runner.run(cmd, [binary]);
      return result.exitCode == 0;
    } catch (_) {
      return false;
    }
  }

  /// Detect already-running processes on startup.
  /// Checks all processes in parallel to avoid sequential 2s timeouts.
  Future<void> detectRunning() async {
    final processes = state.processes;
    final results = await Future.wait(
      processes.map((p) async {
        final healthy = await _isHealthy(p.name);
        final installed = healthy || await isInstalled(p.name);
        int? pid;
        if (healthy && p.port != null) {
          final portNum = int.tryParse(p.port!);
          if (portNum != null) pid = await _findPidForPort(portNum);
        }
        return (healthy: healthy, installed: installed, pid: pid);
      }),
    );

    final updated = <ManagedProcess>[];
    for (var i = 0; i < processes.length; i++) {
      final p = processes[i];
      if (results[i].healthy) {
        updated.add(p.copyWith(
          state: ProcessState.running,
          pid: () => results[i].pid,
        ));
        _startHealthPolling(p.name);
      } else if (!results[i].installed) {
        updated.add(p.copyWith(state: ProcessState.notInstalled));
      } else {
        // Installed but not running — transition from detecting to stopped.
        updated.add(p.copyWith(state: ProcessState.stopped));
      }
    }
    state = state.copyWith(processes: updated);
  }

  /// Start a process.
  Future<void> start(String name) async {
    if (state.get(name) == null) return;

    final binary = _binaryName(name);
    final args = _binaryArgs(name);
    if (binary == null) return;

    if (!await isInstalled(name)) {
      _updateProcess(
          name,
          (p) => p.copyWith(
                state: ProcessState.notInstalled,
                errorMessage: () => '$binary not found in PATH',
              ));
      return;
    }

    _updateProcess(
        name,
        (p) => p.copyWith(
              state: ProcessState.starting,
              errorMessage: () => null,
            ));
    _logBuffers[name] = [];

    try {
      final process = await _runner.start(
        binary,
        args,
        environment: _env(name),
      );
      // Guard: if configure() ran while we were starting, the process
      // is no longer in our managed set — kill it to prevent orphans.
      if (state.get(name) == null) {
        _killProcess(process, force: true);
        return;
      }
      _handles[name] = process;
      _updateProcess(name, (p) => p.copyWith(pid: () => process.pid));

      // Capture stdout/stderr with error handlers — prevents unhandled
      // stream errors from invalid UTF-8 (GPU drivers, crash dumps, vLLM).
      process.stdout
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen(
            (line) => _addLog(name, line),
            onError: (Object e) => _addLog(name, '[stdout-err] $e'),
          );
      process.stderr
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen(
            (line) => _addLog(name, '[err] $line'),
            onError: (Object e) => _addLog(name, '[stderr-err] $e'),
          );

      // Wait for health check (poll up to 15 seconds).
      // Check state each iteration for early exit if stop() was called.
      var healthy = false;
      for (var i = 0; i < 30; i++) {
        await Future.delayed(const Duration(milliseconds: 500));
        // Bail if stop() was called during startup.
        if (state.get(name)?.state != ProcessState.starting) break;
        if (await _isHealthy(name)) {
          healthy = true;
          break;
        }
      }

      // Re-check: process may have been removed or stopped during the loop.
      final postLoopState = state.get(name);
      if (postLoopState == null) return;
      if (postLoopState.state != ProcessState.starting) return;

      if (healthy) {
        _updateProcess(
            name,
            (p) => p.copyWith(
                  state: ProcessState.running,
                  startedAt: () => DateTime.now(),
                ));
        _startHealthPolling(name);
      } else {
        _updateProcess(
            name,
            (p) => p.copyWith(
                  state: ProcessState.error,
                  errorMessage: () =>
                      'Started but health check failed after 15s',
                ));
      }

      // Handle unexpected exit.
      process.exitCode.then((code) {
        final currentState = state.get(name)?.state;
        if (currentState == ProcessState.running ||
            currentState == ProcessState.starting) {
          _updateProcess(
              name,
              (p) => p.copyWith(
                    state: ProcessState.error,
                    errorMessage: () => 'Process exited with code $code',
                  ));
          _handles.remove(name);
          _healthTimers[name]?.cancel();
        }
      });
    } catch (e) {
      _updateProcess(
          name,
          (p) => p.copyWith(
                state: ProcessState.error,
                errorMessage: () => e.toString(),
              ));
    }
  }

  /// Stop a process.
  Future<void> stop(String name) async {
    if (state.get(name) == null) return;

    _updateProcess(name, (p) => p.copyWith(state: ProcessState.stopping));

    _healthTimers[name]?.cancel();

    final handle = _handles[name];
    if (handle != null) {
      // Graceful shutdown.
      _killProcess(handle);
      try {
        await handle.exitCode.timeout(const Duration(seconds: 5));
      } catch (_) {
        // Force kill.
        _killProcess(handle, force: true);
      }
      _handles.remove(name);
    } else {
      final currentPid = state.get(name)?.pid;
      if (currentPid != null) {
        // Process we detected but didn't start — kill by PID.
        _killPid(currentPid);
      }
    }

    _updateProcess(
        name,
        (p) => p.copyWith(
              state: ProcessState.stopped,
              pid: () => null,
              startedAt: () => null,
            ));
  }

  /// Restart a process.
  Future<void> restart(String name) async {
    await stop(name);
    await Future.delayed(const Duration(milliseconds: 500));
    await start(name);
  }

  /// Stop all managed processes (including detected ones without handles).
  /// Also stops error-state processes that may still have live OS handles/PIDs.
  Future<void> stopAll() async {
    for (final p in state.processes.toList()) {
      if (p.state == ProcessState.running ||
          p.state == ProcessState.starting ||
          p.state == ProcessState.error) {
        await stop(p.name);
      }
    }
  }

  /// Start all configured processes.
  Future<void> startAll() async {
    for (final p in state.processes) {
      if (p.state == ProcessState.stopped && await isInstalled(p.name)) {
        await start(p.name);
      }
    }
  }

  // --- Private helpers ---

  /// Update a single process in state by name.
  void _updateProcess(
      String name, ManagedProcess Function(ManagedProcess) updater) {
    state = state.copyWith(
      processes: [
        for (final p in state.processes)
          if (p.name == name) updater(p) else p,
      ],
    );
  }

  /// Kill a process. On Windows, always uses TerminateProcess (no POSIX signals).
  void _killProcess(Process handle, {bool force = false}) {
    if (Platform.isWindows) {
      handle.kill(); // TerminateProcess
    } else {
      handle.kill(force ? ProcessSignal.sigkill : ProcessSignal.sigterm);
    }
  }

  /// Kill a process by PID. On Windows, uses TerminateProcess.
  void _killPid(int pid) {
    if (Platform.isWindows) {
      Process.killPid(pid);
    } else {
      Process.killPid(pid, ProcessSignal.sigterm);
    }
  }

  String? _binaryName(String name) => switch (name) {
        'ollama' => 'ollama',
        'proxy' => 'candela',
        'vllm' => 'vllm',
        'lmstudio' => null, // LM Studio is a GUI app, can't start from CLI
        _ => null,
      };

  List<String> _binaryArgs(String name) => switch (name) {
        'ollama' => ['serve'],
        'proxy' => ['run'], // `candela run` = foreground mode
        'vllm' => ['serve'],
        _ => [],
      };

  /// Build the environment map for a process. Starts with the augmented
  /// PATH (so gcloud, candela, etc. are discoverable) and merges any
  /// per-process overrides on top.
  Map<String, String> _env(String name) {
    Map<String, String> base;
    try {
      base = platform_paths.buildAugmentedEnv();
    } catch (_) {
      // If path resolution fails (e.g. missing env vars), fall back to
      // the unaugmented system environment.
      base = Map<String, String>.from(Platform.environment);
    }
    final overrides = switch (name) {
      'ollama' => {
          'OLLAMA_HOST': '0.0.0.0:${state.get('ollama')?.port ?? '11434'}',
        },
      _ => <String, String>{},
    };
    return {...base, ...overrides};
  }

  Future<bool> _isHealthy(String name) async {
    final url = _healthUrl(name);
    if (url == null) return false;
    try {
      final resp =
          await _client.get(Uri.parse(url)).timeout(const Duration(seconds: 2));
      return resp.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  String? _healthUrl(String name) {
    final port = state.get(name)?.port;
    return switch (name) {
      'ollama' => 'http://localhost:${port ?? "11434"}/api/tags',
      'proxy' => 'http://localhost:${port ?? "8181"}/v1/models',
      'vllm' => 'http://localhost:${port ?? "8000"}/health',
      'lmstudio' => 'http://localhost:${port ?? "1234"}/v1/models',
      _ => null,
    };
  }

  void _startHealthPolling(String name) {
    _healthTimers[name]?.cancel();
    _healthTimers[name] = Timer.periodic(const Duration(seconds: 10), (
      _,
    ) async {
      final p = state.get(name);
      if (p == null) return;
      // Only poll processes that are running or in recoverable error.
      if (p.state != ProcessState.running && p.state != ProcessState.error) {
        return;
      }

      final healthy = await _isHealthy(name);

      // Re-fetch state after the async gap — the snapshot `p` is stale.
      final current = state.get(name);
      if (current == null) return;

      if (healthy && current.state == ProcessState.error) {
        // Recovered from transient failure.
        _updateProcess(
            name,
            (p) => p.copyWith(
                  state: ProcessState.running,
                  errorMessage: () => null,
                ));
      } else if (!healthy && current.state == ProcessState.running) {
        _updateProcess(
            name,
            (p) => p.copyWith(
                  state: ProcessState.error,
                  errorMessage: () => 'Health check failed',
                ));
      }
    });
  }

  /// Retrieve a snapshot of the log buffer for a process.
  ///
  /// Logs are kept as private mutable buffers to avoid triggering
  /// Riverpod state rebuilds on every line. The UI (ProcessLogsDialog)
  /// polls this method periodically.
  List<String> getLogs(String name) =>
      List.unmodifiable(_logBuffers[name] ?? const <String>[]);

  void _addLog(String name, String line) {
    final buffer = _logBuffers.putIfAbsent(name, () => []);
    buffer.add(line);
    while (buffer.length > ManagedProcess.maxLogLines) {
      buffer.removeAt(0);
    }
    // Logs are intentionally NOT emitted as state to avoid flooding
    // Riverpod listeners on every line from chatty processes.
  }

  /// Resolve the PID of a process listening on [port].
  ///
  /// Uses `netstat -ano` on Windows, `lsof -ti` on macOS/Linux.
  /// Returns null if not found or the command fails (best-effort).
  Future<int?> _findPidForPort(int port) async {
    // CRITICAL-5: validate port is a safe positive integer before shell use.
    if (port <= 0 || port > 65535) return null;

    if (Platform.isWindows) {
      return _findPidForPortWindows(port);
    }

    try {
      final result = await _runner.run('lsof', ['-ti', ':$port']);
      if (result.exitCode == 0) {
        final pid = int.tryParse(
          (result.stdout as String).trim().split('\n').first,
        );
        return pid;
      }
    } catch (_) {
      // lsof not available — PID resolution is best-effort.
    }
    return null;
  }

  /// Windows implementation: parse `netstat -ano` for LISTENING on [port].
  ///
  /// Example netstat output line:
  ///   TCP    0.0.0.0:8080           0.0.0.0:0              LISTENING       1234
  Future<int?> _findPidForPortWindows(int port) async {
    try {
      final result = await _runner.run(
        'netstat',
        ['-ano'],
      ).timeout(const Duration(seconds: 3));
      if (result.exitCode != 0) return null;

      final portSuffix = ':$port';
      for (final line in (result.stdout as String).split('\n')) {
        final trimmed = line.trim();
        if (!trimmed.contains('LISTENING')) continue;

        // Split by whitespace: [protocol, local, foreign, state, pid]
        final parts = trimmed.split(RegExp(r'\s+'));
        if (parts.length < 5) continue;

        final localAddr = parts[1]; // e.g. "0.0.0.0:8080" or "[::]:8080"
        if (!localAddr.endsWith(portSuffix)) continue;

        final pid = int.tryParse(parts[4]);
        if (pid != null && pid > 0) return pid;
      }
    } catch (_) {
      // netstat not available — PID resolution is best-effort.
    }
    return null;
  }

  void _cleanup() {
    for (final t in _healthTimers.values) {
      t.cancel();
    }
    // Kill any processes we started to prevent orphans.
    for (final handle in _handles.values) {
      _killProcess(handle);
    }
    _handles.clear();
    _client.close();
  }
}
