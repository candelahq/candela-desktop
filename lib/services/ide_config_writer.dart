import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

import '../utils/platform_paths.dart' as platform_paths;

/// Writes the Candela proxy endpoint into IDE and tool config files.
///
/// Supports:
/// - Continue (VS Code/JetBrains): `~/.continue/config.json`
/// - Zed: `~/.config/zed/settings.json`
/// - Open Design: `<projectRoot>/.od/media-config.json`
class IdeConfigWriter {
  /// Const constructor for DI. Default instance uses real filesystem.
  const IdeConfigWriter();

  // ── Continue ──────────────────────────────────────────────────────────────

  /// Write/update the Candela model entry in Continue's config.json.
  ///
  /// Merges by entry title — if an entry titled "Candela (local proxy)" already
  /// exists it is replaced in-place; otherwise it is prepended to the models list.
  Future<void> writeContinueConfig(String endpointUrl) async {
    final String configPath;
    try {
      configPath = _continuePath();
    } on StateError {
      return; // Can't determine home directory — skip Continue config.
    }
    final file = File(configPath);
    Map<String, dynamic> config = {};
    if (await file.exists()) {
      try {
        final decoded = jsonDecode(await file.readAsString());
        config = decoded is Map<String, dynamic> ? decoded : {};
      } on FormatException {
        // Corrupt file — start fresh.
        config = {};
      }
    }

    final models = ((config['models'] as List?) ?? [])
        .whereType<Map<String, dynamic>>()
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

  String _continuePath() {
    final home = platform_paths.homeDir();
    return p.join(home, '.continue', 'config.json');
  }

  // ── Zed ───────────────────────────────────────────────────────────────────

  /// Write/update the Candela endpoint in Zed's settings.json.
  ///
  /// Merges the `language_models.openai` block, preserving all other Zed settings.
  Future<void> writeZedConfig(String endpointUrl) async {
    final String zedPath;
    try {
      zedPath = _zedPath();
    } on StateError {
      return; // Can't determine Zed config path — skip.
    }
    final file = File(zedPath);
    Map<String, dynamic> settings = {};
    if (await file.exists()) {
      try {
        final decoded = jsonDecode(await file.readAsString());
        settings = decoded is Map<String, dynamic> ? decoded : {};
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
        .whereType<Map<String, dynamic>>()
        .toList();
    models.removeWhere((m) => m['name'] == 'candela');
    models.add({'name': 'candela', 'max_tokens': 8192});

    openai['api_url'] = endpointUrl;
    openai['available_models'] = models;
    lm['openai'] = openai;
    settings['language_models'] = lm;

    await _writeJson(file, settings);
  }

  String _zedPath() {
    // Zed on Windows: %APPDATA%\Zed\settings.json
    // Zed on macOS/Linux: ~/.config/zed/settings.json
    if (Platform.isWindows) {
      final appData = Platform.environment['APPDATA'];
      if (appData == null || appData.isEmpty) {
        throw StateError(
            'Unable to determine Zed config path: %APPDATA% is not set');
      }
      return p.join(appData, 'Zed', 'settings.json');
    }
    final home = platform_paths.homeDir();
    return p.join(home, '.config', 'zed', 'settings.json');
  }

  // ── Open Design ───────────────────────────────────────────────────────────

  /// Write/update Candela as the `openai` BYOK provider in an Open Design project.
  ///
  /// [projectRoot] must be the root directory that contains a `.od/` folder.
  /// Creates `.od/media-config.json` if it does not exist yet.
  /// Uses `"candela"` as the API key (OD requires a non-empty string).
  Future<void> writeOpenDesignConfig(
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
        final decoded = jsonDecode(await file.readAsString());
        config = decoded is Map<String, dynamic> ? decoded : {};
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

  /// Scan [startDir] (defaults to `~`) up to [maxDepth] directory levels
  /// for Open Design project roots.
  ///
  /// A project root is any directory that contains a `.od/` subdirectory
  /// (but not the `.od/` dir itself, and not directories inside `.od/`).
  Future<List<String>> findOpenDesignProjects({
    int maxDepth = 3,
    @visibleForTesting Directory? startDir,
  }) async {
    final Directory root;
    if (startDir != null) {
      root = startDir;
    } else {
      try {
        root = Directory(platform_paths.homeDir());
      } on StateError {
        return [];
      }
    }
    if (!root.existsSync()) return [];

    final results = <String>[];
    await _scanForOdDirs(root, 0, maxDepth, results);
    // Sort by path length (shortest = closest to home) for best UX.
    results.sort((a, b) => a.length.compareTo(b.length));
    return results;
  }

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

  static final Set<String> _skipDirs = {
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
    // macOS-specific directories.
    'Library',
    'Applications',
    'Music',
    'Pictures',
    'Movies',
    // Windows-specific directories.
    if (Platform.isWindows) ...[
      'AppData',
      'Program Files',
      'Program Files (x86)',
      'Windows',
      'ProgramData',
    ],
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

  Future<void> _writeJson(File file, Map<String, dynamic> data) async {
    await file.parent.create(recursive: true);
    // Pretty-print with 2-space indent for human-readable config files.
    final encoder = const JsonEncoder.withIndent('  ');
    await file.writeAsString('${encoder.convert(data)}\n');
  }
}
