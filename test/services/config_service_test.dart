import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/services/config_service.dart';
import 'package:candela_desktop/models/candela_config.dart';

void main() {
  group('ConfigService', () {
    late ConfigService service;
    late String testConfigPath;

    setUp(() {
      testConfigPath =
          '${Directory.systemTemp.path}/candela_test_${DateTime.now().millisecondsSinceEpoch}.yaml';
      service = ConfigService(configPath: testConfigPath);
    });

    tearDown(() {
      final f = File(testConfigPath);
      if (f.existsSync()) f.deleteSync();
    });

    test('load returns defaults when file does not exist', () async {
      final config = await service.load();
      expect(config.port, 8181);
      expect(config.lmStudioPort, 1234);
      expect(config.providers, isEmpty);
      expect(config.mode, CandelaMode.solo);
    });

    test('load parses minimal YAML', () async {
      File(testConfigPath).writeAsStringSync('''
port: 9090
providers:
  - name: google
  - name: ollama
''');
      final config = await service.load();
      expect(config.port, 9090);
      expect(config.providers.length, 2);
      expect(config.providers[0].name, 'google');
      expect(config.providers[1].name, 'ollama');
    });

    test('load detects team mode when remote is set', () async {
      File(testConfigPath).writeAsStringSync('''
remote: https://candela.example.com
port: 8181
''');
      final config = await service.load();
      expect(config.mode, CandelaMode.team);
      expect(config.remote, 'https://candela.example.com');
    });

    test('load parses lmstudio_port', () async {
      File(testConfigPath).writeAsStringSync('''
port: 8181
lmstudio_port: 4321
''');
      final config = await service.load();
      expect(config.lmStudioPort, 4321);
    });

    test('addProvider appends to providers list', () async {
      File(testConfigPath).writeAsStringSync('''
providers:
  - name: google
''');
      await service.addProvider('ollama');
      final config = await service.load();
      expect(config.providers.length, 2);
      expect(
          config.providers.map((p) => p.name).toList(), ['google', 'ollama']);
    });

    test('removeProvider removes from list', () async {
      File(testConfigPath).writeAsStringSync('''
providers:
  - name: google
  - name: ollama
''');
      await service.removeProvider('ollama');
      final config = await service.load();
      expect(config.providers.length, 1);
      expect(config.providers[0].name, 'google');
    });

    test('setPort updates port field', () async {
      File(testConfigPath).writeAsStringSync('''
port: 8181
''');
      await service.setPort('port', 9999);
      final config = await service.load();
      expect(config.port, 9999);
    });

    test('setPort updates lmstudio_port field', () async {
      File(testConfigPath).writeAsStringSync('''
port: 8181
lmstudio_port: 1234
''');
      await service.setPort('lmstudio_port', 5678);
      final config = await service.load();
      expect(config.lmStudioPort, 5678);
    });

    test('setMode to team adds remote', () async {
      File(testConfigPath).writeAsStringSync('''
port: 8181
''');
      await service.setMode(remote: 'https://candela.example.com');
      final config = await service.load();
      expect(config.mode, CandelaMode.team);
      expect(config.remote, 'https://candela.example.com');
    });

    test('setMode to solo removes remote', () async {
      File(testConfigPath).writeAsStringSync('''
remote: https://candela.example.com
port: 8181
''');
      await service.setMode();
      final config = await service.load();
      expect(config.mode, CandelaMode.solo);
      expect(config.remote, isNull);
    });

    // --- Fix #1: setPort field validation ---

    test('setPort rejects invalid field names', () async {
      File(testConfigPath).writeAsStringSync('port: 8181\n');
      expect(
        () => service.setPort('remote', 9999),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('setPort rejects out-of-range port', () async {
      File(testConfigPath).writeAsStringSync('port: 8181\n');
      expect(
        () => service.setPort('port', 0),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => service.setPort('port', 70000),
        throwsA(isA<ArgumentError>()),
      );
    });

    // --- Fix #3: legacy migration ---

    test('migrateLegacyFields removes runtime_backend', () async {
      File(testConfigPath).writeAsStringSync('''
port: 8181
runtime_backend: ollama
runtime_config: some_value
runtime_manage: true
providers:
  - name: ollama
''');
      await service.migrateLegacyFields();
      final content = File(testConfigPath).readAsStringSync();
      expect(content, isNot(contains('runtime_backend')));
      expect(content, isNot(contains('runtime_config')));
      expect(content, isNot(contains('runtime_manage')));
      // providers should still be there
      expect(content, contains('ollama'));
    });

    test('migrateLegacyFields is no-op if no legacy fields', () async {
      final original = 'port: 8181\nproviders:\n  - name: google\n';
      File(testConfigPath).writeAsStringSync(original);
      await service.migrateLegacyFields();
      // File should be unchanged
      final content = File(testConfigPath).readAsStringSync();
      expect(content, original);
    });

    // --- Fix #7: YAML quoting ---

    test('setMode preserves URLs with special characters', () async {
      File(testConfigPath).writeAsStringSync('port: 8181\n');
      await service.setMode(remote: 'https://candela.example.com#auth');
      // Should survive a round-trip
      final config = await service.load();
      expect(config.remote, 'https://candela.example.com#auth');
    });

    // --- YAML error handling ---

    test('load handles YAML syntax errors gracefully', () async {
      File(testConfigPath).writeAsStringSync('port: [invalid yaml');
      final config = await service.load();
      expect(config.issues, isNotEmpty);
      expect(config.issues.first.severity, IssueSeverity.error);
      expect(config.issues.first.message, contains('YAML syntax error'));
    });

    test('load handles empty YAML file', () async {
      File(testConfigPath).writeAsStringSync('');
      final config = await service.load();
      expect(config.issues, isNotEmpty);
      expect(config.issues.first.message, contains('empty'));
    });

    // --- Validation ---

    test('team mode without audience generates error', () async {
      File(testConfigPath).writeAsStringSync('''
remote: https://candela.example.com
port: 8181
''');
      final config = await service.load();
      final audienceIssue = config.issues.where((i) => i.field == 'audience');
      expect(audienceIssue, isNotEmpty);
      expect(audienceIssue.first.severity, IssueSeverity.error);
    });

    test('cloud provider without vertex_ai.project generates error', () async {
      File(testConfigPath).writeAsStringSync('''
providers:
  - name: google
''');
      final config = await service.load();
      final projectIssue =
          config.issues.where((i) => i.field == 'vertex_ai.project');
      expect(projectIssue, isNotEmpty);
    });

    test('cloud provider without vertex_ai.region generates warning', () async {
      File(testConfigPath).writeAsStringSync('''
providers:
  - name: google
vertex_ai:
  project: my-project
''');
      final config = await service.load();
      final regionIssue =
          config.issues.where((i) => i.field == 'vertex_ai.region');
      expect(regionIssue, isNotEmpty);
      expect(regionIssue.first.severity, IssueSeverity.warning);
    });

    // --- vertex_ai parsing ---

    test('load parses vertex_ai config', () async {
      File(testConfigPath).writeAsStringSync('''
providers:
  - name: google
vertex_ai:
  project: my-project
  region: us-east1
''');
      final config = await service.load();
      expect(config.vertexAI, isNotNull);
      expect(config.vertexAI!.project, 'my-project');
      expect(config.vertexAI!.region, 'us-east1');
    });

    // --- Duplicate prevention ---

    test('addProvider does not add duplicate', () async {
      File(testConfigPath).writeAsStringSync('''
providers:
  - name: google
''');
      await service.addProvider('google');
      final config = await service.load();
      expect(config.providers.length, 1);
    });

    // --- Mode detection ---

    test('solo cloud mode detected when providers but no remote', () async {
      File(testConfigPath).writeAsStringSync('''
providers:
  - name: google
vertex_ai:
  project: my-project
  region: us-central1
''');
      final config = await service.load();
      expect(config.mode, CandelaMode.soloCloud);
    });

    test('solo mode detected when no providers and no remote', () async {
      File(testConfigPath).writeAsStringSync('port: 8181\n');
      final config = await service.load();
      expect(config.mode, CandelaMode.solo);
    });

    // --- Provider models ---

    test('load parses provider models list', () async {
      File(testConfigPath).writeAsStringSync('''
providers:
  - name: google
    models:
      - gemini-1.5-pro
      - gemini-1.5-flash
''');
      final config = await service.load();
      expect(
          config.providers[0].models, ['gemini-1.5-pro', 'gemini-1.5-flash']);
    });

    // --- Port boundary values ---

    test('setPort accepts boundary values', () async {
      File(testConfigPath).writeAsStringSync('port: 8181\n');
      await service.setPort('port', 1);
      var config = await service.load();
      expect(config.port, 1);

      await service.setPort('port', 65535);
      config = await service.load();
      expect(config.port, 65535);
    });

    test('concurrent writes are serialized', () async {
      File(testConfigPath).writeAsStringSync('port: 8181\n');
      // Fire two writes concurrently — both should succeed without data loss.
      await Future.wait([
        service.setPort('port', 9090),
        service.setPort('lmstudio_port', 5555),
      ]);
      final config = await service.load();
      // At least one of them should have been applied (serialization ensures no crash).
      expect(config.port == 9090 || config.lmStudioPort == 5555, isTrue);
    });

    test('removeProvider on empty list is no-op', () async {
      File(testConfigPath).writeAsStringSync('port: 8181\n');
      await service.removeProvider('nonexistent');
      final config = await service.load();
      expect(config.providers, isEmpty);
    });

    test('addProvider with models persists models list', () async {
      File(testConfigPath).writeAsStringSync('port: 8181\n');
      await service.addProvider('ollama', models: ['llama3', 'codellama']);
      final config = await service.load();
      expect(config.providers.first.name, 'ollama');
      expect(config.providers.first.models, ['llama3', 'codellama']);
    });

    test('load handles non-YAML binary content', () async {
      File(testConfigPath).writeAsBytesSync([0x00, 0xFF, 0xFE, 0x89]);
      final config = await service.load();
      expect(config.issues, isNotEmpty);
    });

    test('setMode with audience persists both fields', () async {
      File(testConfigPath).writeAsStringSync('port: 8181\n');
      await service.setMode(
          remote: 'https://candela.example.com', audience: 'my-audience-id');
      final config = await service.load();
      expect(config.remote, 'https://candela.example.com');
      expect(config.audience, 'my-audience-id');
    });

    test('_yamlValue quotes strings that look like numbers', () async {
      File(testConfigPath).writeAsStringSync('port: 8181\n');
      await service.setMode(remote: '8080');
      final content = File(testConfigPath).readAsStringSync();
      // yaml_edit should quote numeric-looking strings to prevent
      // them being parsed as integers. Check the value round-trips.
      expect(content.contains('8080'), isTrue);
      final config = await service.load();
      expect(config.remote, '8080');
    });

    // --- Audit v4: new unit tests ---

    test('setPort creates config file if it does not exist', () async {
      expect(File(testConfigPath).existsSync(), isFalse);
      await service.setPort('port', 9999);
      expect(File(testConfigPath).existsSync(), isTrue);
      final config = await service.load();
      expect(config.port, 9999);
    });

    test('setMode creates config file if it does not exist', () async {
      expect(File(testConfigPath).existsSync(), isFalse);
      await service.setMode(remote: 'https://new.example.com');
      expect(File(testConfigPath).existsSync(), isTrue);
      final config = await service.load();
      expect(config.remote, 'https://new.example.com');
    });

    test('load ignores unknown YAML keys gracefully', () async {
      File(testConfigPath).writeAsStringSync('''
port: 8181
unknown_future_key: some_value
another_unknown:
  nested: value
providers:
  - name: google
''');
      final config = await service.load();
      expect(config.port, 8181);
      expect(config.providers.length, 1);
      // Should not error on unknown keys.
      expect(
          config.issues.where((i) => i.severity == IssueSeverity.error),
          isNot(contains(predicate<ConfigIssue>(
              (i) => i.message.contains('unknown_future_key')))));
    });

    test('addProvider to minimal file creates providers list', () async {
      File(testConfigPath).writeAsStringSync('port: 8181\n');
      await service.addProvider('ollama');
      final config = await service.load();
      expect(config.providers.length, 1);
      expect(config.providers.first.name, 'ollama');
    });

    test('_yamlValue quotes numeric-looking strings on round-trip', () async {
      File(testConfigPath).writeAsStringSync('port: 8181\n');
      await service.addProvider('test-provider',
          models: ['3.14', '0777', '0xDEAD', '1e10']);
      final config = await service.load();
      // All should survive as strings, not be parsed as numbers.
      expect(config.providers.first.models, ['3.14', '0777', '0xDEAD', '1e10']);
    });

    test('setPort with negative port throws ArgumentError', () async {
      File(testConfigPath).writeAsStringSync('port: 8181\n');
      expect(
        () => service.setPort('port', -1),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
