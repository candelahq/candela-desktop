import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

/// Writes the Candela proxy endpoint into IDE and tool config files.
///
/// Supports:
/// - Continue (VS Code/JetBrains): `~/.continue/config.json`
/// - Zed: `~/.config/zed/settings.json`
/// - Open Design: `<projectRoot>/.od/media-config.json`
class IdeConfigWriter {
  IdeConfigWriter._();

  // ── Continue ──────────────────────────────────────────────────────────────

  /// Write/update the Candela model entry in Continue's config.json.
  ///
  /// Merges by entry title — if an entry titled "Candela (local proxy)" already
  /// exists it is replaced in-place; otherwise it is prepended to the models list.
  static Future<void> writeContinueConfig(String endpointUrl) async {
    final file = File(_continuePath());
    Map<String, dynamic> config = {};
    if (await file.exists()) {
      try {
        config =
            (jsonDecode(await file.readAsString()) as Map<String, dynamic>?) ??
                {};
      } on FormatException {
        // Corrupt file — start fresh.
        config = {};
      }
    }

    final models = ((config['models'] as List?) ?? [])
        .cast<Map<String, dynamic>>()
        .toList();

    // Remove any prior Candela entry.
    models.removeWhere((m) => m['title'] == 'Candela (local proxy)');

    // Prepend the current entry.
    models.insert(0, {
      'title': 'Candela (local proxy)',
      'provider': 'openai',
      'model': 'candela',
      'apiBase': endpointUrl,
    });

    config['models'] = models;
    await _writeJson(file, config);
  }

  static String _continuePath() {
    final home = Platform.environment['HOME'] ?? '';
    return p.join(home, '.continue', 'config.json');
  }

  // ── Zed ───────────────────────────────────────────────────────────────────

  /// Write/update the Candela endpoint in Zed's settings.json.
  ///
  /// Merges the `language_models.openai` block, preserving all other Zed settings.
  static Future<void> writeZedConfig(String endpointUrl) async {
    final file = File(_zedPath());
    Map<String, dynamic> settings = {};
    if (await file.exists()) {
      try {
        settings =
            (jsonDecode(await file.readAsString()) as Map<String, dynamic>?) ??
                {};
      } on FormatException {
        settings = {};
      }
    }

    // Deep-merge language_models.openai block.
    final lm =
        ((settings['language_models'] as Map?) ?? {}).cast<String, dynamic>();
    final openai = ((lm['openai'] as Map?) ?? {}).cast<String, dynamic>();

    // Merge available_models — upsert by name.
    final models = ((openai['available_models'] as List?) ?? [])
        .cast<Map<String, dynamic>>()
        .toList();
    models.removeWhere((m) => m['name'] == 'candela');
    models.add({'name': 'candela', 'max_tokens': 8192});

    openai['api_url'] = endpointUrl;
    openai['available_models'] = models;
    lm['openai'] = openai;
    settings['language_models'] = lm;

    await _writeJson(file, settings);
  }

  static String _zedPath() {
    final home = Platform.environment['HOME'] ?? '';
    return p.join(home, '.config', 'zed', 'settings.json');
  }

  // ── Open Design ───────────────────────────────────────────────────────────

  /// Write/update Candela as the `openai` BYOK provider in an Open Design project.
  ///
  /// [projectRoot] must be the root directory that contains a `.od/` folder.
  /// Creates `.od/media-config.json` if it does not exist yet.
  /// Uses `"candela"` as the API key (OD requires a non-empty string).
  static Future<void> writeOpenDesignConfig(
    String projectRoot,
    String endpointUrl,
  ) async {
    final odDir = Directory(p.join(projectRoot, '.od'));
    if (!await odDir.exists()) {
      throw StateError(
        'No .od/ directory found in $projectRoot. '
        'Is this an Open Design project root?',
      );
    }

    final file = File(p.join(odDir.path, 'media-config.json'));
    Map<String, dynamic> config = {};
    if (await file.exists()) {
      try {
        config =
            (jsonDecode(await file.readAsString()) as Map<String, dynamic>?) ??
                {};
      } on FormatException {
        config = {};
      }
    }

    final providers =
        ((config['providers'] as Map?) ?? {}).cast<String, dynamic>();

    // Upsert the openai provider slot.
    providers['openai'] = {
      'apiKey': 'candela',
      'baseUrl': endpointUrl,
    };

    config['providers'] = providers;
    await _writeJson(file, config);
  }

  // ── Auto-detect Open Design projects ─────────────────────────────────────

  /// Scan `~` up to [maxDepth] directory levels for Open Design project roots.
  ///
  /// A project root is any directory that contains a `.od/` subdirectory
  /// (but not the `.od/` dir itself, and not directories inside `.od/`).
  static Future<List<String>> findOpenDesignProjects({int maxDepth = 3}) async {
    final home = Platform.environment['HOME'] ?? '';
    if (home.isEmpty) return [];

    final results = <String>[];
    await _scanForOdDirs(Directory(home), 0, maxDepth, results);
    // Sort by path length (shortest = closest to home) for best UX.
    results.sort((a, b) => a.length.compareTo(b.length));
    return results;
  }

  static Future<void> _scanForOdDirs(
    Directory dir,
    int depth,
    int maxDepth,
    List<String> results,
  ) async {
    if (depth > maxDepth) return;

    try {
      await for (final entity in dir.list(followLinks: false)) {
        if (entity is! Directory) continue;
        final name = p.basename(entity.path);

        // Skip hidden dirs (except .od which is what we look for).
        if (name.startsWith('.') && name != '.od') continue;

        if (name == '.od') {
          // Parent is the project root.
          results.add(dir.path);
          // Don't recurse into .od itself.
          continue;
        }

        // Skip large/irrelevant dirs that will never have .od.
        if (_skipDirs.contains(name)) continue;

        await _scanForOdDirs(entity, depth + 1, maxDepth, results);
      }
    } on FileSystemException {
      // Permission denied or gone — skip silently.
    }
  }

  static const _skipDirs = {
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

  // ── Snippet generators (for copy-only IDEs) ───────────────────────────────

  /// Generate the Continue config.json snippet for display.
  static String continueSnippet(String endpointUrl) => jsonEncode({
        'models': [
          {
            'title': 'Candela (local proxy)',
            'provider': 'openai',
            'model': 'candela',
            'apiBase': endpointUrl,
          }
        ],
      });

  /// Generate the Zed settings.json snippet for display.
  static String zedSnippet(String endpointUrl) => jsonEncode({
        'language_models': {
          'openai': {
            'api_url': endpointUrl,
            'available_models': [
              {'name': 'candela', 'max_tokens': 8192},
            ],
          },
        },
      });

  /// Generate the Open Design media-config.json snippet for display.
  static String openDesignSnippet(String endpointUrl) => jsonEncode({
        'providers': {
          'openai': {
            'apiKey': 'candela',
            'baseUrl': endpointUrl,
          },
        },
      });

  // ── Helpers ───────────────────────────────────────────────────────────────

  static Future<void> _writeJson(File file, Map<String, dynamic> data) async {
    await file.parent.create(recursive: true);
    // Pretty-print with 2-space indent for human-readable config files.
    final encoder = const JsonEncoder.withIndent('  ');
    await file.writeAsString('${encoder.convert(data)}\n');
  }
}
