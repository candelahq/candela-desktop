import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// State of a managed process.
enum ProcessState { stopped, starting, running, stopping, error, notInstalled }

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
  final List<String> recentLogs = [];

  ManagedProcess({
    required this.name,
    required this.displayName,
    required this.icon,
    this.state = ProcessState.stopped,
    this.port,
  });

  Duration? get uptime => startedAt != null ? DateTime.now().difference(startedAt!) : null;

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
  final Map<String, ManagedProcess> _processes = {};
  final Map<String, Process> _handles = {};
  final Map<String, Timer> _healthTimers = {};
  final _client = http.Client();

  /// Configure which processes to manage based on the providers list.
  /// Always includes proxy. Adds any local providers found in the list.
  void configure({required List<String> providerNames, String? proxyPort}) {
    _processes.clear();

    // Proxy is always managed.
    _processes['proxy'] = ManagedProcess(
      name: 'proxy', displayName: 'Candela Proxy', icon: '🕯️',
      port: proxyPort ?? '8181',
    );

    // Add any local providers from the config.
    for (final name in providerNames) {
      final info = _runtimeInfo(name);
      if (info != null) {
        _processes[name] = info;
      }
    }
    notifyListeners();
  }

  static ManagedProcess? _runtimeInfo(String name) => switch (name) {
    'ollama' => ManagedProcess(name: 'ollama', displayName: 'Ollama', icon: '🦙', port: '11434'),
    'vllm' => ManagedProcess(name: 'vllm', displayName: 'vLLM', icon: 'V', port: '8000'),
    'lmstudio' => ManagedProcess(name: 'lmstudio', displayName: 'LM Studio', icon: 'L', port: '1234'),
    _ => null,
  };

  List<ManagedProcess> get all => _processes.values.toList();
  ManagedProcess? get(String name) => _processes[name];

  /// Check if a binary is installed.
  Future<bool> isInstalled(String name) async {
    final binary = _binaryName(name);
    if (binary == null) return false;
    try {
      final result = await Process.run('which', [binary]);
      return result.exitCode == 0;
    } catch (_) {
      return false;
    }
  }

  /// Detect already-running processes on startup.
  Future<void> detectRunning() async {
    for (final entry in _processes.entries) {
      final p = entry.value;
      if (await _isHealthy(entry.key)) {
        p.state = ProcessState.running;
        p.startedAt = DateTime.now(); // approximate
        _startHealthPolling(entry.key);
      } else if (!await isInstalled(entry.key)) {
        p.state = ProcessState.notInstalled;
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
      final process = await Process.start(binary, args, environment: _env(name));
      _handles[name] = process;
      p.pid = process.pid;

      // Capture stdout/stderr.
      process.stdout.transform(utf8.decoder).transform(const LineSplitter()).listen((line) {
        _addLog(p, line);
      });
      process.stderr.transform(utf8.decoder).transform(const LineSplitter()).listen((line) {
        _addLog(p, '[err] $line');
      });

      // Wait for health check (poll up to 15 seconds).
      var healthy = false;
      for (var i = 0; i < 30; i++) {
        await Future.delayed(const Duration(milliseconds: 500));
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
        if (p.state == ProcessState.running || p.state == ProcessState.starting) {
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
      handle.kill(ProcessSignal.sigterm);
      try {
        await handle.exitCode.timeout(const Duration(seconds: 5));
      } catch (_) {
        // Force kill.
        handle.kill(ProcessSignal.sigkill);
      }
      _handles.remove(name);
    } else if (p.pid != null) {
      // Process we detected but didn't start — kill by PID.
      Process.killPid(p.pid!, ProcessSignal.sigterm);
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

  /// Stop all managed processes.
  Future<void> stopAll() async {
    for (final name in _handles.keys.toList()) {
      await stop(name);
    }
  }

  /// Start all configured processes.
  Future<void> startAll() async {
    for (final entry in _processes.entries) {
      if (entry.value.state == ProcessState.stopped && await isInstalled(entry.key)) {
        await start(entry.key);
      }
    }
  }

  // --- Private helpers ---

  String? _binaryName(String name) => switch (name) {
    'ollama' => 'ollama',
    'proxy' => 'candela-local',
    'vllm' => 'vllm',
    'lmstudio' => null, // LM Studio is a GUI app, can't start from CLI
    _ => null,
  };

  List<String> _binaryArgs(String name) => switch (name) {
    'ollama' => ['serve'],
    'proxy' => [],
    'vllm' => ['serve'],
    _ => [],
  };

  Map<String, String>? _env(String name) => switch (name) {
    'ollama' => {'OLLAMA_HOST': '0.0.0.0:11434'},
    _ => null,
  };

  Future<bool> _isHealthy(String name) async {
    final url = _healthUrl(name);
    if (url == null) return false;
    try {
      final resp = await _client.get(Uri.parse(url)).timeout(const Duration(seconds: 2));
      return resp.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  String? _healthUrl(String name) => switch (name) {
    'ollama' => 'http://localhost:11434/api/tags',
    'proxy' => 'http://localhost:${_processes["proxy"]?.port ?? "8181"}/v1/models',
    'vllm' => 'http://localhost:8000/health',
    'lmstudio' => 'http://localhost:1234/v1/models',
    _ => null,
  };

  void _startHealthPolling(String name) {
    _healthTimers[name]?.cancel();
    _healthTimers[name] = Timer.periodic(const Duration(seconds: 10), (_) async {
      final p = _processes[name];
      if (p == null || p.state != ProcessState.running) return;
      if (!await _isHealthy(name)) {
        p.state = ProcessState.error;
        p.errorMessage = 'Health check failed';
        notifyListeners();
      }
    });
  }

  void _addLog(ManagedProcess p, String line) {
    p.recentLogs.add(line);
    if (p.recentLogs.length > 50) p.recentLogs.removeAt(0);
  }

  @override
  void dispose() {
    for (final t in _healthTimers.values) { t.cancel(); }
    _client.close();
    super.dispose();
  }
}
