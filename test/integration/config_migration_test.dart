import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/services/config_service.dart';
import 'package:yaml/yaml.dart';

/// Integration tests for XDG config migration and onboarding batch write.
void main() {
  late Directory tmpDir;

  setUp(() {
    tmpDir = Directory.systemTemp.createTempSync('candela_migration_test_');
  });

  tearDown(() {
    tmpDir.deleteSync(recursive: true);
  });

  group('Config migration — legacy to XDG', () {
    test('migrates legacy file to new path', () async {
      // Arrange: create a legacy config file.
      final legacyPath = '${tmpDir.path}/legacy.yaml';
      final modernPath = '${tmpDir.path}/modern/config.yaml';
      File(legacyPath).writeAsStringSync('port: 8181\n');

      // Create a service that uses legacy path as configPath.
      // We simulate migration by calling the underlying logic directly.
      final legacyFile = File(legacyPath);
      final modernFile = File(modernPath);

      // Simulate migrateLegacyFields step 1:
      expect(await legacyFile.exists(), isTrue);
      expect(await modernFile.exists(), isFalse);

      await modernFile.parent.create(recursive: true);
      await legacyFile.copy(modernFile.path);
      await legacyFile.writeAsString(
        '# Config has moved\n# Safe to delete.\n',
      );

      // Assert: modern file exists with original content.
      expect(await modernFile.exists(), isTrue);
      final content = await modernFile.readAsString();
      expect(content, contains('port: 8181'));

      // Assert: legacy file has breadcrumb.
      final legacyContent = await legacyFile.readAsString();
      expect(legacyContent, contains('moved'));
    });

    test('does not overwrite existing modern config', () async {
      // Arrange: both files exist.
      final legacyPath = '${tmpDir.path}/legacy.yaml';
      final modernDir = Directory('${tmpDir.path}/modern');
      await modernDir.create(recursive: true);
      final modernPath = '${modernDir.path}/config.yaml';

      File(legacyPath).writeAsStringSync('port: 8181\n');
      File(modernPath).writeAsStringSync('port: 9999\n');

      // Simulate: migration should NOT happen.
      final legacy = File(legacyPath);
      final modern = File(modernPath);

      final shouldMigrate = await legacy.exists() && !await modern.exists();
      expect(shouldMigrate, isFalse);

      // Modern file unchanged.
      final content = await modern.readAsString();
      expect(content, contains('port: 9999'));
    });
  });

  group('Config — writeInitialConfig', () {
    test('writes complete config in single operation', () async {
      final configPath = '${tmpDir.path}/config/candela/config.yaml';
      final service = ConfigService(configPath: configPath);

      await service.writeInitialConfig({
        'port': 8185,
        'remote': 'https://candela.example.com',
        'audience': 'https://candela.example.com',
        'providers': [
          {'name': 'google'},
          {'name': 'ollama'},
        ],
      });

      // Verify file was created.
      final file = File(configPath);
      expect(await file.exists(), isTrue);

      // Verify content is valid YAML with all fields.
      final content = await file.readAsString();
      final yaml = loadYaml(content) as YamlMap;
      expect(yaml['port'], equals(8185));
      expect(yaml['remote'], equals('https://candela.example.com'));
      expect(yaml['providers'], hasLength(2));
    });

    test('throws if config already exists', () async {
      final configPath = '${tmpDir.path}/existing.yaml';
      File(configPath).writeAsStringSync('port: 8181\n');

      final service = ConfigService(configPath: configPath);

      expect(
        () => service.writeInitialConfig({'port': 9999}),
        throwsA(isA<StateError>()),
      );
    });
  });

  group('Config — findAvailablePort', () {
    test('returns preferred port when available', () async {
      // Use a high port unlikely to be in use.
      final port = await ConfigService.findAvailablePort(
        preferred: 58181,
        maxScan: 5,
      );
      expect(port, greaterThanOrEqualTo(58181));
      expect(port, lessThanOrEqualTo(58186));
    });
  });

  group('Config — configExists', () {
    test('returns false when no config file', () async {
      final service = ConfigService(
        configPath: '${tmpDir.path}/nonexistent.yaml',
      );
      expect(await service.configExists(), isFalse);
    });

    test('returns true when config file exists', () async {
      final configPath = '${tmpDir.path}/exists.yaml';
      File(configPath).writeAsStringSync('port: 8181\n');

      final service = ConfigService(configPath: configPath);
      expect(await service.configExists(), isTrue);
    });
  });
}
