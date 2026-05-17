import 'dart:convert';
import 'dart:io';

/// Result of a Homebrew command.
class BrewResult {
  final bool success;
  final String output;
  final String? errorMessage;

  const BrewResult({
    required this.success,
    this.output = '',
    this.errorMessage,
  });
}

/// Thin wrapper around the `brew` CLI for install/upgrade operations.
///
/// All methods spawn `brew` as a subprocess and parse stdout/stderr.
/// The caller is responsible for running these off the main isolate if
/// the UI needs to remain responsive during long-running installs.
class BrewService {
  /// Check if Homebrew is installed.
  Future<bool> isBrewInstalled() async {
    try {
      final result = await Process.run('which', ['brew']);
      return result.exitCode == 0;
    } catch (_) {
      return false;
    }
  }

  /// Check if a formula is installed (e.g. `candelahq/tap/candela`).
  Future<bool> isFormulaInstalled(String formula) async {
    try {
      final result = await Process.run('brew', ['list', '--formula', formula]);
      return result.exitCode == 0;
    } catch (_) {
      return false;
    }
  }

  /// Get the installed version of a formula, or null if not installed.
  Future<String?> installedVersion(String formula) async {
    try {
      final result = await Process.run(
        'brew',
        ['info', '--json=v2', formula],
      );
      if (result.exitCode != 0) return null;

      final json = jsonDecode(result.stdout as String) as Map<String, dynamic>;
      final formulae = json['formulae'] as List<dynamic>?;
      if (formulae != null && formulae.isNotEmpty) {
        final installed = formulae[0]['installed'] as List<dynamic>?;
        if (installed != null && installed.isNotEmpty) {
          return installed.last['version'] as String?;
        }
      }

      // Check casks too.
      final casks = json['casks'] as List<dynamic>?;
      if (casks != null && casks.isNotEmpty) {
        return casks[0]['installed'] as String?;
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  /// Get the latest available version from the tap.
  Future<String?> latestVersion(String formula) async {
    try {
      final result = await Process.run(
        'brew',
        ['info', '--json=v2', formula],
      );
      if (result.exitCode != 0) return null;

      final json = jsonDecode(result.stdout as String) as Map<String, dynamic>;
      final formulae = json['formulae'] as List<dynamic>?;
      if (formulae != null && formulae.isNotEmpty) {
        final versions = formulae[0]['versions'] as Map<String, dynamic>?;
        return versions?['stable'] as String?;
      }

      final casks = json['casks'] as List<dynamic>?;
      if (casks != null && casks.isNotEmpty) {
        return casks[0]['version'] as String?;
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  /// Get both installed and latest version in a single `brew info` call.
  ///
  /// Returns (installedVersion, latestVersion). Either may be null.
  /// This avoids spawning two identical `brew info --json=v2` subprocesses.
  Future<(String?, String?)> formulaVersions(String formula) async {
    try {
      final result = await Process.run(
        'brew',
        ['info', '--json=v2', formula],
      );
      if (result.exitCode != 0) return (null, null);

      final json = jsonDecode(result.stdout as String) as Map<String, dynamic>;
      final formulae = json['formulae'] as List<dynamic>?;
      if (formulae != null && formulae.isNotEmpty) {
        final f = formulae[0];
        // Installed version.
        String? installed;
        final installedList = f['installed'] as List<dynamic>?;
        if (installedList != null && installedList.isNotEmpty) {
          installed = installedList.last['version'] as String?;
        }
        // Latest stable version.
        final versions = f['versions'] as Map<String, dynamic>?;
        final latest = versions?['stable'] as String?;
        return (installed, latest);
      }

      // Cask fallback.
      final casks = json['casks'] as List<dynamic>?;
      if (casks != null && casks.isNotEmpty) {
        final c = casks[0];
        return (c['installed'] as String?, c['version'] as String?);
      }

      return (null, null);
    } catch (_) {
      return (null, null);
    }
  }

  /// Install a formula: `brew install candelahq/tap/candela`.
  Future<BrewResult> install(String formula) async {
    return _runBrew(['install', formula]);
  }

  /// Upgrade a formula: `brew upgrade candelahq/tap/candela`.
  Future<BrewResult> upgrade(String formula) async {
    return _runBrew(['upgrade', formula]);
  }

  /// Upgrade a cask: `brew upgrade --cask candelahq/tap/candela-desktop`.
  Future<BrewResult> upgradeCask(String cask) async {
    return _runBrew(['upgrade', '--cask', cask]);
  }

  /// Update tap metadata so latest versions are visible.
  Future<BrewResult> updateTap() async {
    return _runBrew(['update']);
  }

  Future<BrewResult> _runBrew(List<String> args) async {
    try {
      final result = await Process.run('brew', args);
      final stdout = (result.stdout as String).trim();
      final stderr = (result.stderr as String).trim();

      if (result.exitCode == 0) {
        return BrewResult(success: true, output: stdout);
      } else {
        return BrewResult(
          success: false,
          output: stdout,
          errorMessage:
              stderr.isNotEmpty ? stderr : 'Exit code ${result.exitCode}',
        );
      }
    } catch (e) {
      return BrewResult(
        success: false,
        errorMessage: e.toString(),
      );
    }
  }
}
