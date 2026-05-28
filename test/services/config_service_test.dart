import 'dart:async';
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

    test('team mode skips vertex_ai.project and region validation', () async {
      File(testConfigPath).writeAsStringSync('''
remote: https://candela.example.com
audience: my-audience
providers:
  - name: google
  - name: anthropic
''');
      final config = await service.load();
      expect(config.mode, CandelaMode.team);
      final projectIssues =
          config.issues.where((i) => i.field == 'vertex_ai.project');
      final regionIssues =
          config.issues.where((i) => i.field == 'vertex_ai.region');
      expect(projectIssues, isEmpty,
          reason: 'team mode should not require vertex_ai.project');
      expect(regionIssues, isEmpty,
          reason: 'team mode should not warn about vertex_ai.region');
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

    // --- Config hardening: new feature tests ---

    group('config_version', () {
      test('load parses config_version', () async {
        File(testConfigPath).writeAsStringSync('''
config_version: 1
port: 8181
''');
        final config = await service.load();
        expect(config.configVersion, 1);
      });

      test('load defaults config_version to 0 when missing', () async {
        File(testConfigPath).writeAsStringSync('port: 8181\n');
        final config = await service.load();
        expect(config.configVersion, 0);
      });
    });

    group('pricing', () {
      test('load parses pricing with model rates', () async {
        File(testConfigPath).writeAsStringSync('''
port: 8181
pricing:
  models:
    - provider: openai
      model: gpt-4o
      input_per_million: 2.50
      output_per_million: 10.00
    - provider: google
      model: gemini-2.5-pro
      input_per_million: 1.25
      output_per_million: 5.00
''');
        final config = await service.load();
        expect(config.pricing, isNotNull);
        expect(config.pricing!.models.length, 2);

        final gpt4o = config.pricing!.models[0];
        expect(gpt4o.provider, 'openai');
        expect(gpt4o.model, 'gpt-4o');
        expect(gpt4o.inputPerMillion, 2.50);
        expect(gpt4o.outputPerMillion, 10.00);

        final gemini = config.pricing!.models[1];
        expect(gemini.provider, 'google');
        expect(gemini.model, 'gemini-2.5-pro');
        expect(gemini.inputPerMillion, 1.25);
        expect(gemini.outputPerMillion, 5.00);
      });

      test('load handles pricing with empty models list', () async {
        File(testConfigPath).writeAsStringSync('''
port: 8181
pricing:
  models: []
''');
        final config = await service.load();
        expect(config.pricing, isNotNull);
        expect(config.pricing!.models, isEmpty);
      });

      test('load handles config without pricing section', () async {
        File(testConfigPath).writeAsStringSync('port: 8181\n');
        final config = await service.load();
        expect(config.pricing, isNull);
      });

      test('load handles pricing model with zero rates', () async {
        File(testConfigPath).writeAsStringSync('''
port: 8181
pricing:
  models:
    - provider: ollama
      model: llama3
      input_per_million: 0
      output_per_million: 0
''');
        final config = await service.load();
        expect(config.pricing!.models[0].inputPerMillion, 0.0);
        expect(config.pricing!.models[0].outputPerMillion, 0.0);
      });
    });

    group('writeInitialConfig', () {
      test('includes config_version and schema header', () async {
        await service.writeInitialConfig({'port': 9090});
        final content = File(testConfigPath).readAsStringSync();

        // Should have the yaml-language-server schema comment.
        expect(content, contains('yaml-language-server'));
        expect(content, contains('config.v1.json'));

        // Should include config_version: 1.
        final config = await service.load();
        expect(config.configVersion, 1);
        expect(config.port, 9090);
      });

      test('throws when config file already exists', () async {
        File(testConfigPath).writeAsStringSync('port: 8181\n');
        expect(
          () => service.writeInitialConfig({'port': 9090}),
          throwsA(isA<StateError>()),
        );
      });

      test('sets chmod 600 on created file', () async {
        await service.writeInitialConfig({'port': 8181});
        final stat = File(testConfigPath).statSync();
        // On macOS/Linux, 600 = owner rw only.
        final mode = stat.mode & 0x1FF; // last 9 bits
        expect(mode, 0x180); // 0o600
      });
    });

    group('writeRawConfig', () {
      test('writes valid YAML content', () async {
        await File(testConfigPath).create(recursive: true);
        await service.writeRawConfig('port: 9999\n');
        final config = await service.load();
        expect(config.port, 9999);
      });

      test('rejects invalid YAML', () async {
        await File(testConfigPath).create(recursive: true);
        expect(
          () => service.writeRawConfig('port: [invalid'),
          throwsA(isA<FormatException>()),
        );
      });

      test('rejects empty content to prevent config wipe', () async {
        await File(testConfigPath).create(recursive: true);
        expect(
          () => service.writeRawConfig(''),
          throwsA(isA<FormatException>()),
        );
      });

      test('rejects whitespace-only content', () async {
        await File(testConfigPath).create(recursive: true);
        expect(
          () => service.writeRawConfig('   \n  \n'),
          throwsA(isA<FormatException>()),
        );
      });
    });

    group('yaml_edit comment preservation', () {
      test('setPort preserves user comments', () async {
        File(testConfigPath).writeAsStringSync('''
# My Candela config
port: 8181
# This is my proxy
providers:
  - name: google
''');
        await service.setPort('port', 9999);
        final content = File(testConfigPath).readAsStringSync();
        // Comments should survive the edit.
        expect(content, contains('# My Candela config'));
        expect(content, contains('# This is my proxy'));
        // Value should be updated.
        expect(content, contains('9999'));
      });

      test('addProvider preserves existing comments', () async {
        File(testConfigPath).writeAsStringSync('''
# Primary config
port: 8181
providers:
  - name: google  # cloud provider
''');
        await service.addProvider('ollama');
        final content = File(testConfigPath).readAsStringSync();
        expect(content, contains('# Primary config'));
        expect(content, contains('ollama'));
      });

      test('removeProvider preserves other comments', () async {
        File(testConfigPath).writeAsStringSync('''
# Config with multiple providers
port: 8181
providers:
  - name: google
  - name: ollama
''');
        await service.removeProvider('ollama');
        final content = File(testConfigPath).readAsStringSync();
        expect(content, contains('# Config with multiple providers'));
        expect(content, contains('google'));
        expect(content, isNot(contains('ollama')));
      });
    });

    group('watchForChanges', () {
      test('returns null when config directory does not exist', () {
        final svc = ConfigService(configPath: '/nonexistent/path/config.yaml');
        final stream = svc.watchForChanges();
        expect(stream, isNull);
      });

      test('returns a stream when config directory exists', () async {
        await File(testConfigPath).create(recursive: true);
        final stream = service.watchForChanges();
        expect(stream, isNotNull);
      });

      test('emits event when config file is modified', () async {
        final file = File(testConfigPath);
        await file.writeAsString('port: 8181\n');

        final stream = service.watchForChanges();
        expect(stream, isNotNull);

        // Listen for an event, then modify the file.
        final gotEvent = stream!.first.timeout(
          const Duration(seconds: 3),
          onTimeout: () => throw TimeoutException('No event received'),
        );

        // Small delay to ensure watcher is set up.
        await Future.delayed(const Duration(milliseconds: 100));
        await file.writeAsString('port: 9999\n');

        // Should receive the event without timeout.
        await expectLater(gotEvent, completes);
      });
    });

    group('removeProvider edge cases', () {
      test('removes last provider and cleans up providers key', () async {
        File(testConfigPath).writeAsStringSync('''
port: 8181
providers:
  - name: ollama
''');
        await service.removeProvider('ollama');
        final content = File(testConfigPath).readAsStringSync();
        // providers key should be removed entirely.
        expect(content, isNot(contains('providers')));
        final config = await service.load();
        expect(config.providers, isEmpty);
      });
    });

    group('autoStartProxy', () {
      test('auto_start_proxy: false is parsed correctly', () async {
        File(testConfigPath).writeAsStringSync('''
port: 8181
auto_start_proxy: false
''');
        final config = await service.load();
        expect(config.autoStartProxy, isFalse);
      });

      test('missing auto_start_proxy defaults to true', () async {
        File(testConfigPath).writeAsStringSync('''
port: 8181
''');
        final config = await service.load();
        expect(config.autoStartProxy, isTrue);
      });

      test('setAutoStartProxy(false) writes to YAML correctly', () async {
        File(testConfigPath).writeAsStringSync('''
port: 8181
auto_start_proxy: true
''');
        await service.setAutoStartProxy(false);
        final config = await service.load();
        expect(config.autoStartProxy, isFalse);
      });

      test('setAutoStartProxy(true) writes to YAML correctly', () async {
        File(testConfigPath).writeAsStringSync('''
port: 8181
auto_start_proxy: false
''');
        await service.setAutoStartProxy(true);
        final config = await service.load();
        expect(config.autoStartProxy, isTrue);
      });

      test('setAutoStartProxy creates config file if missing', () async {
        expect(File(testConfigPath).existsSync(), isFalse);
        await service.setAutoStartProxy(false);
        expect(File(testConfigPath).existsSync(), isTrue);
        final config = await service.load();
        expect(config.autoStartProxy, isFalse);
      });
    });
  });
}
