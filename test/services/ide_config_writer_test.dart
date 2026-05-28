import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/services/ide_config_writer.dart';

void main() {
  group('IdeConfigWriter', () {
    // ── Snippet generators ──────────────────────────────────────────────────

    group('continueSnippet', () {
      test('returns valid JSON with models array', () {
        final snippet =
            IdeConfigWriter.continueSnippet('http://localhost:8181');
        final json = jsonDecode(snippet) as Map<String, dynamic>;
        expect(json.containsKey('models'), isTrue);
        expect(json['models'], isList);
        expect((json['models'] as List).length, 1);
      });

      test('model entry has correct structure', () {
        final snippet =
            IdeConfigWriter.continueSnippet('http://localhost:9090');
        final json = jsonDecode(snippet) as Map<String, dynamic>;
        final model = (json['models'] as List)[0] as Map<String, dynamic>;

        expect(model['title'], 'Candela (local proxy)');
        expect(model['provider'], 'openai');
        expect(model['model'], 'candela');
        expect(model['apiBase'], 'http://localhost:9090');
      });

      test('embeds the provided endpoint URL', () {
        const url = 'http://10.0.0.5:4444/v1';
        final snippet = IdeConfigWriter.continueSnippet(url);
        final json = jsonDecode(snippet) as Map<String, dynamic>;
        final model = (json['models'] as List)[0] as Map<String, dynamic>;
        expect(model['apiBase'], url);
      });
    });

    group('zedSnippet', () {
      test('returns valid JSON with language_models.openai block', () {
        final snippet = IdeConfigWriter.zedSnippet('http://localhost:8181');
        final json = jsonDecode(snippet) as Map<String, dynamic>;
        expect(json.containsKey('language_models'), isTrue);

        final lm = json['language_models'] as Map<String, dynamic>;
        expect(lm.containsKey('openai'), isTrue);
      });

      test('openai block contains api_url and available_models', () {
        const url = 'http://localhost:8181/v1';
        final snippet = IdeConfigWriter.zedSnippet(url);
        final json = jsonDecode(snippet) as Map<String, dynamic>;
        final openai = (json['language_models']
            as Map<String, dynamic>)['openai'] as Map<String, dynamic>;

        expect(openai['api_url'], url);
        expect(openai['available_models'], isList);

        final models = openai['available_models'] as List;
        expect(models.length, 1);
        final model = models[0] as Map<String, dynamic>;
        expect(model['name'], 'candela');
        expect(model['max_tokens'], 8192);
      });
    });

    group('openDesignSnippet', () {
      test('returns valid JSON with openai provider', () {
        final snippet =
            IdeConfigWriter.openDesignSnippet('http://localhost:8181');
        final json = jsonDecode(snippet) as Map<String, dynamic>;
        expect(json.containsKey('providers'), isTrue);

        final providers = json['providers'] as Map<String, dynamic>;
        expect(providers.containsKey('openai'), isTrue);
      });

      test('openai provider has apiKey and baseUrl', () {
        const url = 'http://localhost:8181/v1';
        final snippet = IdeConfigWriter.openDesignSnippet(url);
        final json = jsonDecode(snippet) as Map<String, dynamic>;
        final openai = (json['providers'] as Map<String, dynamic>)['openai']
            as Map<String, dynamic>;

        expect(openai['apiKey'], 'candela');
        expect(openai['baseUrl'], url);
      });
    });

    // ── writeOpenDesignConfig ────────────────────────────────────────────────

    group('writeOpenDesignConfig', () {
      late Directory tempDir;

      setUp(() {
        tempDir =
            Directory.systemTemp.createTempSync('candela_ide_writer_test_');
      });

      tearDown(() {
        if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
      });

      test('creates media-config.json with correct content', () async {
        // Create .od/ subdirectory to simulate a project root.
        Directory('${tempDir.path}/.od').createSync();

        await IdeConfigWriter.writeOpenDesignConfig(
          tempDir.path,
          'http://localhost:8181',
        );

        final configFile = File('${tempDir.path}/.od/media-config.json');
        expect(configFile.existsSync(), isTrue);

        final json =
            jsonDecode(configFile.readAsStringSync()) as Map<String, dynamic>;
        final openai = (json['providers'] as Map<String, dynamic>)['openai']
            as Map<String, dynamic>;
        expect(openai['apiKey'], 'candela');
        expect(openai['baseUrl'], 'http://localhost:8181');
      });

      test('upserts existing openai provider preserving other providers',
          () async {
        final odDir = Directory('${tempDir.path}/.od')..createSync();
        final configFile = File('${odDir.path}/media-config.json');

        // Write an existing config with another provider.
        final existing = jsonEncode({
          'providers': {
            'anthropic': {
              'apiKey': 'sk-ant-xxx',
              'baseUrl': 'https://api.anthropic.com',
            },
            'openai': {
              'apiKey': 'old-key',
              'baseUrl': 'http://old-url',
            },
          },
        });
        configFile.writeAsStringSync(existing);

        await IdeConfigWriter.writeOpenDesignConfig(
          tempDir.path,
          'http://localhost:9090',
        );

        final json =
            jsonDecode(configFile.readAsStringSync()) as Map<String, dynamic>;
        final providers = json['providers'] as Map<String, dynamic>;

        // Anthropic should be preserved.
        expect(providers.containsKey('anthropic'), isTrue);
        expect(
          (providers['anthropic'] as Map<String, dynamic>)['apiKey'],
          'sk-ant-xxx',
        );

        // OpenAI should be updated.
        final openai = providers['openai'] as Map<String, dynamic>;
        expect(openai['apiKey'], 'candela');
        expect(openai['baseUrl'], 'http://localhost:9090');
      });

      test('throws StateError if no .od/ directory exists', () {
        // tempDir exists but has no .od/ subdirectory.
        expect(
          () => IdeConfigWriter.writeOpenDesignConfig(
            tempDir.path,
            'http://localhost:8181',
          ),
          throwsA(isA<StateError>()),
        );
      });

      test('handles corrupt JSON gracefully', () async {
        final odDir = Directory('${tempDir.path}/.od')..createSync();
        final configFile = File('${odDir.path}/media-config.json');
        configFile.writeAsStringSync('{{not valid json!!!');

        // Should not throw — source starts with empty config on parse failure.
        await IdeConfigWriter.writeOpenDesignConfig(
          tempDir.path,
          'http://localhost:8181',
        );

        final json =
            jsonDecode(configFile.readAsStringSync()) as Map<String, dynamic>;
        final openai = (json['providers'] as Map<String, dynamic>)['openai']
            as Map<String, dynamic>;
        expect(openai['apiKey'], 'candela');
        expect(openai['baseUrl'], 'http://localhost:8181');
      });

      test('creates media-config.json when file does not exist yet', () async {
        Directory('${tempDir.path}/.od').createSync();

        final configFile = File('${tempDir.path}/.od/media-config.json');
        expect(configFile.existsSync(), isFalse);

        await IdeConfigWriter.writeOpenDesignConfig(
          tempDir.path,
          'http://localhost:8181',
        );

        expect(configFile.existsSync(), isTrue);
      });

      test('output is pretty-printed JSON', () async {
        Directory('${tempDir.path}/.od').createSync();

        await IdeConfigWriter.writeOpenDesignConfig(
          tempDir.path,
          'http://localhost:8181',
        );

        final content =
            File('${tempDir.path}/.od/media-config.json').readAsStringSync();
        // Pretty-printed JSON uses newlines and indentation.
        expect(content, contains('\n'));
        expect(content, contains('  '));
      });
    });

    // ── findOpenDesignProjects ───────────────────────────────────────────────
    //
    // findOpenDesignProjects() scans from Platform.environment['HOME'],
    // so we create a temp structure and call the internal scanner logic
    // via the public API. Since the public method uses HOME, these tests
    // construct a realistic directory tree within a temp dir and use a
    // helper that mirrors the scanning logic to validate behavior.

    group('findOpenDesignProjects (directory scanning logic)', () {
      late Directory scanRoot;

      setUp(() {
        scanRoot = Directory.systemTemp.createTempSync('candela_od_scan_test_');
      });

      tearDown(() {
        if (scanRoot.existsSync()) scanRoot.deleteSync(recursive: true);
      });

      test('finds directories containing .od/ subdirectory', () async {
        // Create two project dirs with .od/.
        Directory('${scanRoot.path}/projectA/.od').createSync(recursive: true);
        Directory('${scanRoot.path}/projectB/.od').createSync(recursive: true);
        // Create a non-project dir.
        Directory('${scanRoot.path}/notAProject').createSync();

        // Use the same scanning pattern as the source.
        final results = <String>[];
        await _scanForOdDirs(scanRoot, 0, 3, results);

        expect(results, contains('${scanRoot.path}/projectA'));
        expect(results, contains('${scanRoot.path}/projectB'));
        expect(results, isNot(contains('${scanRoot.path}/notAProject')));
      });

      test('respects maxDepth limit', () async {
        // depth 0 = scanRoot, depth 1 = level1, depth 2 = level2
        Directory('${scanRoot.path}/level1/level2/deep/.od')
            .createSync(recursive: true);
        Directory('${scanRoot.path}/shallow/.od').createSync(recursive: true);

        // maxDepth=1: should find shallow (at depth 1) but not deep (at depth 3).
        final results = <String>[];
        await _scanForOdDirs(scanRoot, 0, 1, results);

        expect(results, contains('${scanRoot.path}/shallow'));
        expect(
          results,
          isNot(contains('${scanRoot.path}/level1/level2/deep')),
        );
      });

      test('skips hidden directories (except .od)', () async {
        // Hidden dir with .od inside — should NOT be found because the
        // scanner skips dirs starting with '.' (other than .od itself).
        Directory('${scanRoot.path}/.hidden/project/.od')
            .createSync(recursive: true);
        // Regular dir with .od — should be found.
        Directory('${scanRoot.path}/visible/.od').createSync(recursive: true);

        final results = <String>[];
        await _scanForOdDirs(scanRoot, 0, 3, results);

        expect(results, contains('${scanRoot.path}/visible'));
        expect(
          results,
          isNot(contains('${scanRoot.path}/.hidden/project')),
        );
      });

      test('skips node_modules, .git, and other excluded dirs', () async {
        Directory('${scanRoot.path}/node_modules/pkg/.od')
            .createSync(recursive: true);
        Directory('${scanRoot.path}/.git/objects/.od')
            .createSync(recursive: true);
        Directory('${scanRoot.path}/vendor/dep/.od')
            .createSync(recursive: true);
        Directory('${scanRoot.path}/realProject/.od')
            .createSync(recursive: true);

        final results = <String>[];
        await _scanForOdDirs(scanRoot, 0, 3, results);

        expect(results, contains('${scanRoot.path}/realProject'));
        // All excluded dirs should be skipped.
        expect(results.length, 1);
      });

      test('returns empty when no .od dirs exist', () async {
        Directory('${scanRoot.path}/foo/bar').createSync(recursive: true);
        Directory('${scanRoot.path}/baz').createSync();

        final results = <String>[];
        await _scanForOdDirs(scanRoot, 0, 3, results);

        expect(results, isEmpty);
      });

      test('handles .od at root scan level', () async {
        // If scanRoot itself has .od, it should be detected.
        Directory('${scanRoot.path}/.od').createSync();

        final results = <String>[];
        await _scanForOdDirs(scanRoot, 0, 3, results);

        expect(results, contains(scanRoot.path));
      });
    });
  });
}

// ── Test helper: mirrors IdeConfigWriter._scanForOdDirs ─────────────────────
//
// Since _scanForOdDirs is private, we replicate its logic here to unit-test
// the scanning behavior in isolation with controlled temp directories.
// This is the same algorithm used in the source (see ide_config_writer.dart).

const _skipDirs = {
  'node_modules',
  '.git',
  'vendor',
  'target',
  'build',
  'dist',
  '.gradle',
  '__pycache__',
  'venv',
  '.venv',
  'Library',
  'Applications',
  'Music',
  'Pictures',
  'Movies',
};

Future<void> _scanForOdDirs(
  Directory dir,
  int depth,
  int maxDepth,
  List<String> results,
) async {
  if (depth > maxDepth) return;

  try {
    await for (final entity in dir.list(followLinks: false)) {
      if (entity is! Directory) continue;
      final name = entity.path.split('/').last;

      // Skip hidden dirs (except .od which is what we look for).
      if (name.startsWith('.') && name != '.od') continue;

      if (name == '.od') {
        // Parent is the project root.
        results.add(dir.path);
        // Don't recurse into .od itself.
        continue;
      }

      // Skip large/irrelevant dirs.
      if (_skipDirs.contains(name)) continue;

      await _scanForOdDirs(entity, depth + 1, maxDepth, results);
    }
  } on FileSystemException {
    // Permission denied — skip silently.
  }
}
