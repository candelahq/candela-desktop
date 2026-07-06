import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../utils/platform_paths.dart' as platform_paths;
import '../utils/process_runner.dart';

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

/// A locally managed process (Ollama, vLLM, LM Studio, Proxy).
class ManagedProcess {
  final String name;
  final String displayName;
  final String icon;
  ProcessState state;
  int? pid;
  String? port;
  DateTime? startedAt;
  String? errorMessage;

  /// Ring buffer for recent log lines — O(1) add, O(1) removeFirst.
  final Queue<String> recentLogs = Queue<String>();
  static const int maxLogLines = 50;

  ManagedProcess({
    required this.name,
    required this.displayName,
    required this.icon,
    this.state = ProcessState.detecting,
    this.port,
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
}

/// Manages local processes: configured runtime backend + Candela Proxy.
class ProcessManager extends ChangeNotifier {
  final ProcessRunner _runner;
  final Map<String, ManagedProcess> _processes = {};
  final Map<String, Process> _handles = {};
  final Map<String, Timer> _healthTimers = {};
  final _client = http.Client();

  ProcessManager({ProcessRunner? runner})
      : _runner = runner ?? const SystemProcessRunner();
  bool _disposed = false;

  /// Safe notification — prevents crashes if called after [dispose].
  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  /// Configure which processes to manage based on the providers list.
  /// Always includes proxy. Adds any local providers found in the list.
  void configure({
    required List<String> providerNames,
    String? proxyPort,
    Map<String, String>? portOverrides,
  }) {
    // Cancel stale health timers before clearing processes to prevent leaks
    // when providers are added/removed dynamically.
    for (final t in _healthTimers.values) {
      t.cancel();
    }
    _healthTimers.clear();

    // Kill handles for processes being removed to prevent orphaned OS
    // processes that can no longer be stopped via the UI.
    final staleNames =
        _handles.keys.where((n) => !providerNames.contains(n) && n != 'proxy');
    for (final name in staleNames.toList()) {
      final h = _handles[name];
      if (h != null) _killProcess(h);
      _handles.remove(name);
    }

    _processes.clear();

    // Proxy is always managed.
    _processes['proxy'] = ManagedProcess(
      name: 'proxy',
      displayName: 'Candela Proxy',
      icon: '🕯️',
      port: proxyPort ?? '8181',
    );

    // Add any local providers from the config.
    for (final name in providerNames) {
      final info = _runtimeInfo(name);
      if (info != null) {
        // Apply port override from config if available.
        if (portOverrides != null && portOverrides.containsKey(name)) {
          info.port = portOverrides[name];
        }
        _processes[name] = info;
      }
    }
    notifyListeners();
  }

  static ManagedProcess? _runtimeInfo(String name) => switch (name) {
        'ollama' => ManagedProcess(
            name: 'ollama',
            displayName: 'Ollama',
            icon: '🦙',
            port: '11434',
          ),
        'vllm' => ManagedProcess(
            name: 'vllm',
            displayName: 'vLLM',
            icon: 'V',
            port: '8000',
          ),
        'lmstudio' => ManagedProcess(
            name: 'lmstudio',
            displayName: 'LM Studio',
            icon: 'L',
            port: '1234',
          ),
        _ => null,
      };

  List<ManagedProcess> get all => _processes.values.toList();
  ManagedProcess? get(String name) => _processes[name];

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
    final entries = _processes.entries.toList();
    final results = await Future.wait(
      entries.map((e) async {
        final healthy = await _isHealthy(e.key);
        final installed = healthy || await isInstalled(e.key);
        int? pid;
        if (healthy && e.value.port != null) {
          final portNum = int.tryParse(e.value.port!);
          if (portNum != null) pid = await _findPidForPort(portNum);
        }
        return (healthy: healthy, installed: installed, pid: pid);
      }),
    );
    for (var i = 0; i < entries.length; i++) {
      final p = entries[i].value;
      if (results[i].healthy) {
        p.state = ProcessState.running;
        p.pid = results[i].pid;
        // Leave startedAt null — actual start time is unknown.
        _startHealthPolling(entries[i].key);
      } else if (!results[i].installed) {
        p.state = ProcessState.notInstalled;
      } else {
        // Installed but not running — transition from detecting to stopped.
        p.state = ProcessState.stopped;
      }
    }
    notifyListeners();
  }

  /// Start a process.
  Future<void> start(String name) async {
    final p = _processes[name];
    if (p == null) return;

    final binary = _binaryName(name);
    final args = _binaryArgs(name);
    if (binary == null) return;

    if (!await isInstalled(name)) {
      p.state = ProcessState.notInstalled;
      p.errorMessage = '$binary not found in PATH';
      notifyListeners();
      return;
    }

    p.state = ProcessState.starting;
    p.errorMessage = null;
    p.recentLogs.clear();
    notifyListeners();

    try {
      final process = await _runner.start(
        binary,
        args,
        environment: _env(name),
      );
      _handles[name] = process;
      p.pid = process.pid;

      // Capture stdout/stderr with error handlers — prevents unhandled
      // stream errors from invalid UTF-8 (GPU drivers, crash dumps, vLLM).
      process.stdout
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen(
            (line) => _addLog(p, line),
            onError: (Object e) => _addLog(p, '[stdout-err] $e'),
          );
      process.stderr
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen(
            (line) => _addLog(p, '[err] $line'),
            onError: (Object e) => _addLog(p, '[stderr-err] $e'),
          );

      // Wait for health check (poll up to 15 seconds).
      // Check p.state each iteration for early exit if stop() was called.
      var healthy = false;
      for (var i = 0; i < 30; i++) {
        await Future.delayed(const Duration(milliseconds: 500));
        // Bail if stop() was called during startup.
        if (p.state != ProcessState.starting) break;
        if (await _isHealthy(name)) {
          healthy = true;
          break;
        }
      }

      if (healthy) {
        p.state = ProcessState.running;
        p.startedAt = DateTime.now();
        _startHealthPolling(name);
      } else {
        p.state = ProcessState.error;
        p.errorMessage = 'Started but health check failed after 15s';
      }

      // Handle unexpected exit.
      process.exitCode.then((code) {
        if (p.state == ProcessState.running ||
            p.state == ProcessState.starting) {
          p.state = ProcessState.error;
          p.errorMessage = 'Process exited with code $code';
          _handles.remove(name);
          _healthTimers[name]?.cancel();
          notifyListeners();
        }
      });
    } catch (e) {
      p.state = ProcessState.error;
      p.errorMessage = e.toString();
    }
    notifyListeners();
  }

  /// Stop a process.
  Future<void> stop(String name) async {
    final p = _processes[name];
    if (p == null) return;

    p.state = ProcessState.stopping;
    notifyListeners();

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
    } else if (p.pid != null) {
      // Process we detected but didn't start — kill by PID.
      _killPid(p.pid!);
    }

    p.state = ProcessState.stopped;
    p.pid = null;
    p.startedAt = null;
    notifyListeners();
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
    for (final name in _processes.keys.toList()) {
      final state = _processes[name]?.state;
      if (state == ProcessState.running ||
          state == ProcessState.starting ||
          state == ProcessState.error) {
        await stop(name);
      }
    }
  }

  /// Start all configured processes.
  Future<void> startAll() async {
    for (final entry in _processes.entries) {
      if (entry.value.state == ProcessState.stopped &&
          await isInstalled(entry.key)) {
        await start(entry.key);
      }
    }
  }

  // --- Private helpers ---

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
          'OLLAMA_HOST': '0.0.0.0:${_processes['ollama']?.port ?? '11434'}',
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
    final port = _processes[name]?.port;
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
      final p = _processes[name];
      if (p == null) return;
      // Only poll processes that are running or in recoverable error.
      if (p.state != ProcessState.running && p.state != ProcessState.error) {
        return;
      }

      final healthy = await _isHealthy(name);
      if (healthy && p.state == ProcessState.error) {
        // Recovered from transient failure.
        p.state = ProcessState.running;
        p.errorMessage = null;
        notifyListeners();
      } else if (!healthy && p.state == ProcessState.running) {
        p.state = ProcessState.error;
        p.errorMessage = 'Health check failed';
        notifyListeners();
      }
    });
  }

  void _addLog(ManagedProcess p, String line) {
    p.recentLogs.addLast(line);
    while (p.recentLogs.length > ManagedProcess.maxLogLines) {
      p.recentLogs.removeFirst();
    }
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
        runInShell: true,
      );
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

  @override
  void dispose() {
    _disposed = true;
    for (final t in _healthTimers.values) {
      t.cancel();
    }
    // Kill any processes we started to prevent orphans.
    for (final handle in _handles.values) {
      _killProcess(handle);
    }
    _handles.clear();
    _client.close();
    super.dispose();
  }
}
