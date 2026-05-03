import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/services/config_service.dart';
import 'package:candela_desktop/models/candela_config.dart';

/// Integration test: full config round-trip through all field types.
void main() {
  group('ConfigService — integration round-trip', () {
    late ConfigService service;
    late String testConfigPath;

    setUp(() {
      testConfigPath =
          '${Directory.systemTemp.path}/candela_integ_${DateTime.now().millisecondsSinceEpoch}.yaml';
      service = ConfigService(configPath: testConfigPath);
    });

    tearDown(() {
      final f = File(testConfigPath);
      if (f.existsSync()) f.deleteSync();
    });

    test('full round-trip: write all fields → read → validate', () async {
      // 1. Start with team mode + providers + vertex_ai.
      await service.setMode(
          remote: 'https://candela.example.com', audience: 'my-audience');
      await service.setPort('port', 9090);
      await service.setPort('lmstudio_port', 5678);
      await service.addProvider('google',
          models: ['gemini-2.0-flash', 'gemini-1.5-pro']);
      await service.addProvider('anthropic', models: ['claude-sonnet-4']);
      await service.addProvider('ollama');

      // 2. Read back and validate all fields.
      var config = await service.load();
      expect(config.mode, CandelaMode.team);
      expect(config.remote, 'https://candela.example.com');
      expect(config.audience, 'my-audience');
      expect(config.port, 9090);
      expect(config.lmStudioPort, 5678);
      expect(config.providers.length, 3);
      expect(config.providers[0].name, 'google');
      expect(
          config.providers[0].models, ['gemini-2.0-flash', 'gemini-1.5-pro']);
      expect(config.providers[1].name, 'anthropic');
      expect(config.providers[2].name, 'ollama');

      // 3. Switch to solo mode (removes remote/audience).
      await service.setMode();
      config = await service.load();
      expect(config.mode, CandelaMode.soloCloud); // has providers → soloCloud
      expect(config.remote, isNull);

      // 4. Remove all providers → pure solo.
      await service.removeProvider('google');
      await service.removeProvider('anthropic');
      await service.removeProvider('ollama');
      config = await service.load();
      expect(config.mode, CandelaMode.solo);
      expect(config.providers, isEmpty);

      // 5. Verify ports survived the round-trip.
      expect(config.port, 9090);
      expect(config.lmStudioPort, 5678);
    });

    test('concurrent writes all complete without corruption', () async {
      File(testConfigPath).writeAsStringSync('port: 8181\n');

      // Fire 5 concurrent writes — all should be serialized by the async mutex.
      await Future.wait([
        service.setPort('port', 1111),
        service.addProvider('google'),
        service.setPort('lmstudio_port', 2222),
        service.addProvider('ollama'),
        service.setPort('port', 3333),
      ]);

      // Config should be valid YAML and parseable — no corruption.
      final config = await service.load();
      expect(config.issues.where((i) => i.severity == IssueSeverity.error),
          isEmpty);
      // File should exist and be valid.
      expect(File(testConfigPath).existsSync(), isTrue);
      final content = File(testConfigPath).readAsStringSync();
      expect(content, isNotEmpty);
    });
  });
}
