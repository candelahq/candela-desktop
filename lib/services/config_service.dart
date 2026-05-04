import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';

import '../models/candela_config.dart';

/// Reads, parses, and validates ~/.config/candela/config.yaml.
class ConfigService {
  final String? configPath;
  Future<void>? _writeLock;

  ConfigService({this.configPath});

  /// Load and validate the candela config file.
  ///
  /// Search order: configPath → $CANDELA_CONFIG → ~/.config/candela/config.yaml
  Future<CandelaConfig> load() async {
    final resolvedPath = _resolveConfigPath();
    final file = File(resolvedPath);

    if (!await file.exists()) {
      return CandelaConfig(
        path: resolvedPath,
        issues: const [
          ConfigIssue(
            severity: IssueSeverity.info,
            message: 'No config file found — using defaults',
            field: 'file',
          ),
        ],
      );
    }

    final stat = await file.stat();
    String content;
    try {
      content = await file.readAsString();
    } catch (e) {
      return CandelaConfig(
        path: resolvedPath,
        lastModified: stat.modified,
        issues: [
          ConfigIssue(
            severity: IssueSeverity.error,
            message: 'Config file is not valid text: $e',
            field: 'file',
          ),
        ],
      );
    }

    try {
      final yaml = loadYaml(content) as YamlMap?;
      if (yaml == null) {
        return CandelaConfig(
          path: resolvedPath,
          lastModified: stat.modified,
          issues: const [
            ConfigIssue(
              severity: IssueSeverity.warning,
              message: 'Config file is empty',
              field: 'file',
            ),
          ],
        );
      }
      return _parse(resolvedPath, stat.modified, yaml);
    } on YamlException catch (e) {
      return CandelaConfig(
        path: resolvedPath,
        lastModified: stat.modified,
        issues: [
          ConfigIssue(
            severity: IssueSeverity.error,
            message: 'YAML syntax error: ${e.message}',
            field: 'file',
          ),
        ],
      );
    }
  }

  /// Watch the config file for changes.
  Stream<FileSystemEvent>? watchForChanges() {
    final configPath = _resolveConfigPath();
    final file = File(configPath);
    if (!file.existsSync()) return null;
    return file.watch(events: FileSystemEvent.modify | FileSystemEvent.delete);
  }

  /// The default config path using XDG convention.
  static String defaultConfigPath() {
    final home = Platform.environment['HOME'] ?? '';
    return path.join(home, '.config', 'candela', 'config.yaml');
  }

  /// The legacy config path (~/.candela.yaml).
  static String legacyConfigPath() {
    final home = Platform.environment['HOME'] ?? '';
    return path.join(home, '.candela.yaml');
  }

  String _resolveConfigPath() {
    if (configPath != null) return configPath!;
    final envPath = Platform.environment['CANDELA_CONFIG'];
    if (envPath != null && envPath.isNotEmpty) return envPath;
    return defaultConfigPath();
  }

  /// Whether a config file exists at the resolved path.
  Future<bool> configExists() async {
    final configPath = _resolveConfigPath();
    return File(configPath).exists();
  }

  /// Find an available port, starting with [preferred].
  ///
  /// Tries the preferred port first, then scans up to [preferred + maxScan].
  /// Returns the preferred port if all attempts fail (let the proxy report the
  /// actual error).
  static Future<int> findAvailablePort({
    int preferred = 8181,
    int maxScan = 18,
  }) async {
    for (var port = preferred; port <= preferred + maxScan; port++) {
      try {
        final socket = await ServerSocket.bind(
          InternetAddress.loopbackIPv4,
          port,
          shared: false,
        );
        await socket.close();
        return port;
      } on SocketException {
        // Port in use — try next.
        continue;
      }
    }
    return preferred; // fallback
  }

  CandelaConfig _parse(String configPath, DateTime lastModified, YamlMap yaml) {
    final issues = <ConfigIssue>[];

    // Parse fields.
    final remote = yaml['remote']?.toString();
    final audience = yaml['audience']?.toString();
    final port = yaml['port'] as int? ?? 8181;
    final lmStudioPort = yaml['lmstudio_port'] as int? ?? 1234;

    // Parse providers.
    final providers = <ProviderConfig>[];
    final providersYaml = yaml['providers'] as YamlList?;
    if (providersYaml != null) {
      for (final p in providersYaml) {
        if (p is YamlMap) {
          final name = p['name'] as String? ?? '';
          final models =
              (p['models'] as YamlList?)?.map((m) => m.toString()).toList() ??
                  [];
          providers.add(ProviderConfig(name: name, models: models));
        }
      }
    }

    // Parse vertex_ai.
    VertexAIConfig? vertexAI;
    final vtx = yaml['vertex_ai'] as YamlMap?;
    if (vtx != null) {
      vertexAI = VertexAIConfig(
        project: vtx['project'] as String?,
        region: vtx['region'] as String?,
      );
    }

    // Detect mode.
    CandelaMode mode;
    if (remote != null && remote.isNotEmpty) {
      mode = CandelaMode.team;
    } else if (providers.isNotEmpty) {
      mode = CandelaMode.soloCloud;
    } else {
      mode = CandelaMode.solo;
    }

    // ── Validation ──

    // Team mode requires audience.
    if (mode == CandelaMode.team && (audience == null || audience.isEmpty)) {
      issues.add(const ConfigIssue(
        severity: IssueSeverity.error,
        message: '`audience` is required when `remote` is set',
        field: 'audience',
      ));
    }

    // Cloud providers require vertex_ai.project.
    final hasGcpProvider = providers.any(
      (p) => p.name == 'google' || p.name == 'anthropic' || p.name == 'gemini',
    );
    if (hasGcpProvider &&
        (vertexAI?.project == null || vertexAI!.project!.isEmpty)) {
      issues.add(const ConfigIssue(
        severity: IssueSeverity.error,
        message: '`vertex_ai.project` is required for cloud providers',
        field: 'vertex_ai.project',
      ));
    }

    // Region warning.
    if (hasGcpProvider && vertexAI?.region == null) {
      issues.add(const ConfigIssue(
        severity: IssueSeverity.warning,
        message: '`vertex_ai.region` not set — defaulting to us-central1',
        field: 'vertex_ai.region',
      ));
    }

    return CandelaConfig(
      path: configPath,
      lastModified: lastModified,
      remote: remote,
      audience: audience,
      port: port,
      lmStudioPort: lmStudioPort,
      providers: providers,
      vertexAI: vertexAI,
      mode: mode,
      issues: issues,
    );
  }

  /// Migrate legacy config location and fields.
  ///
  /// 1. If ~/.candela.yaml exists but ~/.config/candela/config.yaml does not,
  ///    move the legacy file to the new XDG-compliant location.
  /// 2. Remove deprecated fields (runtime_backend, runtime_config, runtime_manage).
  Future<void> migrateLegacyFields() async {
    // Skip migration if using explicit path override.
    if (configPath != null || Platform.environment['CANDELA_CONFIG'] != null) {
      return _migrateLegacyFieldsInPlace();
    }

    // Step 1: Migrate file location.
    final legacy = File(legacyConfigPath());
    final modern = File(defaultConfigPath());
    if (await legacy.exists() && !await modern.exists()) {
      // Ensure target directory exists.
      await modern.parent.create(recursive: true);
      // Copy to new location — check again after directory creation
      // to avoid a race if another process migrated concurrently.
      if (!await modern.exists()) {
        await legacy.copy(modern.path);
      }
      // Leave a breadcrumb in the old file.
      await legacy.writeAsString(
        '# Candela config has moved to ~/.config/candela/config.yaml\n'
        '# This file is no longer used and can be safely deleted.\n',
      );
    }

    // Step 2: Remove deprecated fields from the active config.
    await _migrateLegacyFieldsInPlace();
  }

  /// Write an initial config map in a single atomic operation.
  ///
  /// Used by onboarding to avoid N sequential read-modify-write cycles.
  /// Only writes if the config file does not already exist.
  Future<void> writeInitialConfig(Map<String, dynamic> config) async {
    final resolvedPath = _resolveConfigPath();
    final file = File(resolvedPath);
    if (await file.exists()) {
      throw StateError(
        'Config file already exists at $resolvedPath. '
        'Use setPort/setMode/addProvider to modify.',
      );
    }
    await _writeYaml(file, config);
  }

  Future<void> _migrateLegacyFieldsInPlace() async {
    final configPath = _resolveConfigPath();
    final file = File(configPath);
    if (!await file.exists()) return;

    final content = await file.readAsString();
    final parsed = loadYaml(content);
    if (parsed is! YamlMap) return;

    final yamlMap = _yamlMapToMap(parsed);
    var changed = false;
    for (final field in [
      'runtime_backend',
      'runtime_config',
      'runtime_manage'
    ]) {
      if (yamlMap.containsKey(field)) {
        yamlMap.remove(field);
        changed = true;
      }
    }
    if (changed) await _writeYaml(file, yamlMap);
  }

  /// Set a port field (port or lmstudio_port) in the config.
  Future<void> setPort(String field, int port) async {
    const allowed = {'port', 'lmstudio_port'};
    if (!allowed.contains(field)) {
      throw ArgumentError('Invalid port field: $field. Allowed: $allowed');
    }
    if (port <= 0 || port > 65535) {
      throw ArgumentError('Port must be 1-65535, got $port');
    }

    final configPath = _resolveConfigPath();
    final file = File(configPath);

    Map<String, dynamic> yamlMap = {};
    if (await file.exists()) {
      final content = await file.readAsString();
      final parsed = loadYaml(content);
      if (parsed is YamlMap) yamlMap = _yamlMapToMap(parsed);
    }

    yamlMap[field] = port;
    await _writeYaml(file, yamlMap);
  }

  /// Set mode: team (with remote URL) or solo (remove remote).
  Future<void> setMode({String? remote, String? audience}) async {
    final configPath = _resolveConfigPath();
    final file = File(configPath);

    Map<String, dynamic> yamlMap = {};
    if (await file.exists()) {
      final content = await file.readAsString();
      final parsed = loadYaml(content);
      if (parsed is YamlMap) yamlMap = _yamlMapToMap(parsed);
    }

    if (remote != null && remote.isNotEmpty) {
      yamlMap['remote'] = remote;
      yamlMap['audience'] = audience ?? remote;
    } else {
      yamlMap.remove('remote');
      yamlMap.remove('audience');
    }

    await _writeYaml(file, yamlMap);
  }

  /// Add a provider to the config file.
  Future<void> addProvider(String providerName,
      {List<String> models = const []}) async {
    final configPath = _resolveConfigPath();
    final file = File(configPath);

    Map<String, dynamic> yamlMap = {};
    if (await file.exists()) {
      final content = await file.readAsString();
      final parsed = loadYaml(content);
      if (parsed is YamlMap) {
        yamlMap = _yamlMapToMap(parsed);
      }
    }

    // Get or create providers list.
    final providers =
        (yamlMap['providers'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    // Don't add duplicate.
    if (providers.any((p) => p['name'] == providerName)) return;

    providers
        .add({'name': providerName, if (models.isNotEmpty) 'models': models});
    yamlMap['providers'] = providers;

    await _writeYaml(file, yamlMap);
  }

  /// Remove a provider from the config file.
  Future<void> removeProvider(String providerName) async {
    final configPath = _resolveConfigPath();
    final file = File(configPath);
    if (!await file.exists()) return;

    final content = await file.readAsString();
    final parsed = loadYaml(content);
    if (parsed is! YamlMap) return;

    final yamlMap = _yamlMapToMap(parsed);
    final providers =
        (yamlMap['providers'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    providers.removeWhere((p) => p['name'] == providerName);

    if (providers.isEmpty) {
      yamlMap.remove('providers');
    } else {
      yamlMap['providers'] = providers;
    }

    await _writeYaml(file, yamlMap);
  }

  /// Convert YamlMap to a plain Dart Map (deep).
  Map<String, dynamic> _yamlMapToMap(YamlMap yaml) {
    final map = <String, dynamic>{};
    for (final key in yaml.keys) {
      final value = yaml[key];
      if (value is YamlMap) {
        map[key.toString()] = _yamlMapToMap(value);
      } else if (value is YamlList) {
        map[key.toString()] =
            value.map((e) => e is YamlMap ? _yamlMapToMap(e) : e).toList();
      } else {
        map[key.toString()] = value;
      }
    }
    return map;
  }

  /// Write a map back as YAML (serialized via async mutex).
  Future<void> _writeYaml(File file, Map<String, dynamic> data) async {
    // Chain writes: each waits for the previous to finish.
    final previous = _writeLock;
    final completer = Completer<void>();
    _writeLock = completer.future;
    try {
      if (previous != null) await previous;
      // Ensure parent directory exists (for first-time config creation).
      await file.parent.create(recursive: true);
      final sb = StringBuffer();
      _writeYamlMap(sb, data, 0);
      await file.writeAsString(sb.toString());
      // Restrict permissions to owner-only (0600) since config may contain
      // sensitive project/audience data.
      if (!Platform.isWindows) {
        try {
          await Process.run('chmod', ['600', file.path]);
        } catch (_) {
          // chmod not available — best-effort.
        }
      }
    } finally {
      completer.complete();
      // Only clear if we're still the latest writer.
      if (_writeLock == completer.future) _writeLock = null;
    }
  }

  void _writeYamlMap(StringBuffer sb, Map<String, dynamic> map, int indent) {
    final prefix = '  ' * indent;
    for (final entry in map.entries) {
      final key = entry.key;
      final value = entry.value;
      if (value is Map<String, dynamic>) {
        sb.writeln('$prefix$key:');
        _writeYamlMap(sb, value, indent + 1);
      } else if (value is List) {
        sb.writeln('$prefix$key:');
        for (final item in value) {
          if (item is Map<String, dynamic>) {
            sb.write('$prefix  - ');
            var first = true;
            for (final e in item.entries) {
              if (first) {
                sb.writeln('${e.key}: ${_yamlValue(e.value)}');
                first = false;
              } else {
                sb.writeln('$prefix    ${e.key}: ${_yamlValue(e.value)}');
              }
            }
          } else {
            sb.writeln('$prefix  - ${_yamlValue(item)}');
          }
        }
      } else {
        sb.writeln('$prefix$key: ${_yamlValue(value)}');
      }
    }
  }

  static final _yamlUnsafe = RegExp(r'[:#{}\[\]&*!|>%@`]');
  static final _yamlNumeric =
      RegExp(r'^[+-]?(\d+\.?\d*|\.\d+)([eE][+-]?\d+)?$');
  static final _yamlOctal = RegExp(r'^0[0-7]+$');
  static final _yamlHex = RegExp(r'^0x[0-9a-fA-F]+$');
  static const _yamlKeywords = {
    'true',
    'false',
    'null',
    'yes',
    'no',
    'on',
    'off'
  };

  String _yamlValue(dynamic value) {
    if (value is String) {
      if (value.isEmpty ||
          _yamlUnsafe.hasMatch(value) ||
          _yamlKeywords.contains(value.toLowerCase()) ||
          _yamlNumeric.hasMatch(value) ||
          _yamlOctal.hasMatch(value) ||
          _yamlHex.hasMatch(value)) {
        return "'${value.replaceAll("'", "''")}'";
      }
      return value;
    }
    if (value is bool) return value.toString();
    if (value is num) return value.toString();
    if (value is List) return '[${value.map(_yamlValue).join(', ')}]';
    return value.toString();
  }
}
