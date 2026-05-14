import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';
import 'package:yaml_edit/yaml_edit.dart';

import '../models/candela_config.dart';

/// Reads, parses, validates, and modifies ~/.config/candela/config.yaml.
///
/// Uses [yaml_edit] for all modifications to preserve comments and formatting.
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
  ///
  /// Returns a debounced stream that emits after file modifications settle.
  /// Editors often write to temp files then rename, causing multiple events —
  /// the 500ms debounce collapses these into a single reload.
  Stream<void>? watchForChanges() {
    final configPath = _resolveConfigPath();
    final dir = File(configPath).parent;
    if (!dir.existsSync()) return null;

    // Watch the directory (not the file) to catch atomic rename writes.
    final raw = dir.watch(
      events: FileSystemEvent.modify | FileSystemEvent.create,
    );

    // Filter to only our config file and debounce.
    // ignore: close_sinks — closed via onCancel below.
    final controller = StreamController<void>.broadcast();
    Timer? debounce;
    final basename = path.basename(configPath);

    final sub = raw.listen((event) {
      if (path.basename(event.path) != basename) return;
      debounce?.cancel();
      debounce = Timer(const Duration(milliseconds: 500), () {
        controller.add(null);
      });
    });

    controller.onCancel = () {
      debounce?.cancel();
      sub.cancel();
    };

    return controller.stream;
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
    final configVersion =
        yaml['config_version'] is int ? yaml['config_version'] as int : 0;
    final remote = yaml['remote']?.toString();
    final audience = yaml['audience']?.toString();
    final port = yaml['port'] is int ? yaml['port'] as int : 8181;
    final lmStudioPort =
        yaml['lmstudio_port'] is int ? yaml['lmstudio_port'] as int : 1234;

    // Parse providers.
    final providers = <ProviderConfig>[];
    final providersYaml =
        yaml['providers'] is YamlList ? yaml['providers'] as YamlList : null;
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
    final vtx =
        yaml['vertex_ai'] is YamlMap ? yaml['vertex_ai'] as YamlMap : null;
    if (vtx != null) {
      vertexAI = VertexAIConfig(
        project: vtx['project'] as String?,
        region: vtx['region'] as String?,
        promptCaching: vtx['prompt_caching'] == true,
      );
    }

    // Parse pricing.
    PricingConfig? pricing;
    final pricingYaml =
        yaml['pricing'] is YamlMap ? yaml['pricing'] as YamlMap : null;
    if (pricingYaml != null) {
      final modelsYaml = pricingYaml['models'] is YamlList
          ? pricingYaml['models'] as YamlList
          : null;
      if (modelsYaml != null) {
        final modelPricing = <ModelPricing>[];
        for (final m in modelsYaml) {
          if (m is YamlMap) {
            modelPricing.add(ModelPricing(
              provider: m['provider'] as String? ?? '',
              model: m['model'] as String? ?? '',
              inputPerMillion:
                  (m['input_per_million'] as num?)?.toDouble() ?? 0.0,
              outputPerMillion:
                  (m['output_per_million'] as num?)?.toDouble() ?? 0.0,
            ));
          }
        }
        pricing = PricingConfig(models: modelPricing);
      }
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
      configVersion: configVersion,
      remote: remote,
      audience: audience,
      port: port,
      lmStudioPort: lmStudioPort,
      providers: providers,
      vertexAI: vertexAI,
      pricing: pricing,
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

    // Step 1: Migrate file location using atomic rename to prevent data
    // loss if two Candela instances launch simultaneously.
    final legacy = File(legacyConfigPath());
    final modern = File(defaultConfigPath());
    if (await legacy.exists() && !await modern.exists()) {
      // Ensure target directory exists.
      await modern.parent.create(recursive: true);
      // Atomic migration: copy to temp, then rename (POSIX atomic).
      final tempFile = File('${modern.path}.migrating');
      try {
        await legacy.copy(tempFile.path);
        await tempFile.rename(modern.path);
      } on FileSystemException {
        // Another process already migrated — clean up temp if it exists.
        if (await tempFile.exists()) await tempFile.delete();
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
    // Prepend config_version and schema comment for initial configs.
    final fullConfig = <String, dynamic>{
      'config_version': 1,
      ...config,
    };
    await _writeYaml(file, fullConfig);
  }

  /// Write raw YAML content to the config file, routed through the write
  /// mutex to prevent data loss from concurrent modifications.
  ///
  /// Validates YAML syntax before writing. Throws [FormatException] on
  /// invalid YAML.
  Future<void> writeRawConfig(String yamlContent) async {
    // Validate YAML before acquiring the lock.
    if (yamlContent.trim().isNotEmpty) {
      try {
        loadYaml(yamlContent);
      } on YamlException catch (e) {
        throw FormatException('Invalid YAML: ${e.message}');
      }
    }
    final resolvedPath = _resolveConfigPath();
    final file = File(resolvedPath);

    // Chain through the write mutex.
    final previous = _writeLock;
    final completer = Completer<void>();
    _writeLock = completer.future;
    try {
      if (previous != null) await previous;
      await file.parent.create(recursive: true);
      await file.writeAsString(yamlContent);
      if (!Platform.isWindows) {
        try {
          await Process.run('chmod', ['600', file.path]);
        } catch (_) {}
      }
    } finally {
      completer.complete();
      if (_writeLock == completer.future) _writeLock = null;
    }
  }

  Future<void> _migrateLegacyFieldsInPlace() async {
    final resolvedPath = _resolveConfigPath();
    final file = File(resolvedPath);
    if (!await file.exists()) return;

    final content = await file.readAsString();
    final parsed = loadYaml(content);
    if (parsed is! YamlMap) return;

    // Use yaml_edit for surgical removal — preserves comments.
    final editor = YamlEditor(content);
    var changed = false;
    for (final field in [
      'runtime_backend',
      'runtime_config',
      'runtime_manage'
    ]) {
      if (parsed.containsKey(field)) {
        editor.remove([field]);
        changed = true;
      }
    }
    if (changed) {
      await _writeRaw(file, editor.toString());
    }
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

    final resolvedPath = _resolveConfigPath();
    final file = File(resolvedPath);

    if (await file.exists()) {
      final content = await file.readAsString();
      final editor = YamlEditor(content);
      editor.update([field], port);
      await _writeRaw(file, editor.toString());
    } else {
      await _writeYaml(file, {'config_version': 1, field: port});
    }
  }

  /// Set mode: team (with remote URL) or solo (remove remote).
  Future<void> setMode({String? remote, String? audience}) async {
    final resolvedPath = _resolveConfigPath();
    final file = File(resolvedPath);

    if (await file.exists()) {
      final content = await file.readAsString();
      final editor = YamlEditor(content);
      if (remote != null && remote.isNotEmpty) {
        editor.update(['remote'], remote);
        editor.update(['audience'], audience ?? remote);
      } else {
        final parsed = loadYaml(content);
        if (parsed is YamlMap) {
          if (parsed.containsKey('remote')) editor.remove(['remote']);
          if (parsed.containsKey('audience')) editor.remove(['audience']);
        }
      }
      await _writeRaw(file, editor.toString());
    } else {
      final config = <String, dynamic>{'config_version': 1};
      if (remote != null && remote.isNotEmpty) {
        config['remote'] = remote;
        config['audience'] = audience ?? remote;
      }
      await _writeYaml(file, config);
    }
  }

  /// Add a provider to the config file.
  Future<void> addProvider(String providerName,
      {List<String> models = const []}) async {
    final resolvedPath = _resolveConfigPath();
    final file = File(resolvedPath);

    if (await file.exists()) {
      final content = await file.readAsString();
      final parsed = loadYaml(content);
      if (parsed is YamlMap) {
        // Check for duplicates.
        final existing = parsed['providers'] as YamlList?;
        if (existing != null) {
          for (final p in existing) {
            if (p is YamlMap && p['name'] == providerName) return;
          }
        }
      }
      final editor = YamlEditor(content);
      final entry = <String, dynamic>{
        'name': providerName,
        if (models.isNotEmpty) 'models': models,
      };
      // If providers list exists, append; otherwise create it.
      if (parsed is YamlMap && parsed.containsKey('providers')) {
        final list = parsed['providers'] as YamlList?;
        editor.insertIntoList(['providers'], list?.length ?? 0, entry);
      } else {
        editor.update(['providers'], [entry]);
      }
      await _writeRaw(file, editor.toString());
    } else {
      await _writeYaml(file, {
        'config_version': 1,
        'providers': [
          {'name': providerName, if (models.isNotEmpty) 'models': models}
        ],
      });
    }
  }

  /// Remove a provider from the config file.
  Future<void> removeProvider(String providerName) async {
    final resolvedPath = _resolveConfigPath();
    final file = File(resolvedPath);
    if (!await file.exists()) return;

    final content = await file.readAsString();
    final parsed = loadYaml(content);
    if (parsed is! YamlMap) return;

    final providers = parsed['providers'] as YamlList?;
    if (providers == null) return;

    // Find the index of the provider to remove.
    int? removeIdx;
    for (var i = 0; i < providers.length; i++) {
      final p = providers[i];
      if (p is YamlMap && p['name'] == providerName) {
        removeIdx = i;
        break;
      }
    }
    if (removeIdx == null) return;

    final editor = YamlEditor(content);
    if (providers.length == 1) {
      // Remove the entire providers key when it would become empty.
      editor.remove(['providers']);
    } else {
      editor.remove(['providers', removeIdx]);
    }
    await _writeRaw(file, editor.toString());
  }

  /// Toggle prompt caching under `vertex_ai.prompt_caching`.
  ///
  /// When enabled, the proxy injects `cache_control` breakpoints into
  /// Anthropic requests, reducing costs ~10x for multi-turn conversations.
  Future<void> setPromptCaching(bool enabled) async {
    final resolvedPath = _resolveConfigPath();
    final file = File(resolvedPath);

    if (await file.exists()) {
      final content = await file.readAsString();
      final parsed = loadYaml(content);
      final editor = YamlEditor(content);
      if (parsed is YamlMap && parsed.containsKey('vertex_ai')) {
        editor.update(['vertex_ai', 'prompt_caching'], enabled);
      } else {
        editor.update(['vertex_ai'], {'prompt_caching': enabled});
      }
      await _writeRaw(file, editor.toString());
    } else {
      await _writeYaml(file, {
        'config_version': 1,
        'vertex_ai': {'prompt_caching': enabled},
      });
    }
  }

  // ── Write helpers ────────────────────────────────────────────────────────

  /// Write raw content through the async mutex with chmod 600.
  Future<void> _writeRaw(File file, String content) async {
    final previous = _writeLock;
    final completer = Completer<void>();
    _writeLock = completer.future;
    try {
      if (previous != null) await previous;
      await file.parent.create(recursive: true);
      await file.writeAsString(content);
      if (!Platform.isWindows) {
        try {
          await Process.run('chmod', ['600', file.path]);
        } catch (_) {}
      }
    } finally {
      completer.complete();
      if (_writeLock == completer.future) _writeLock = null;
    }
  }

  /// Write a map as YAML through the async mutex (for initial config creation).
  Future<void> _writeYaml(File file, Map<String, dynamic> data) async {
    final sb = StringBuffer();
    sb.writeln(
        '# yaml-language-server: \$schema=https://candelahq.com/schemas/config.v1.json');
    _writeYamlMap(sb, data, 0);
    await _writeRaw(file, sb.toString());
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

  static final _yamlUnsafe = RegExp(r'[:#{}\\[\]&*!|>%@`]');
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
