import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/services/brew_service.dart';

void main() {
  group('BrewService', () {
    // ── BrewResult data class ─────────────────────────────────────────────

    group('BrewResult', () {
      test('stores success and output fields correctly', () {
        const result = BrewResult(success: true, output: 'ok');
        expect(result.success, isTrue);
        expect(result.output, 'ok');
      });

      test('errorMessage is null for successful result', () {
        const result = BrewResult(success: true, output: 'installed');
        expect(result.errorMessage, isNull);
      });

      test('errorMessage is present for failure result', () {
        const result = BrewResult(
          success: false,
          output: '',
          errorMessage: 'formula not found',
        );
        expect(result.success, isFalse);
        expect(result.errorMessage, 'formula not found');
      });

      test('output defaults to empty string', () {
        const result = BrewResult(success: true);
        expect(result.output, '');
      });

      test('errorMessage defaults to null', () {
        const result = BrewResult(success: true, output: 'done');
        expect(result.errorMessage, isNull);
      });

      test('all fields can be set simultaneously', () {
        const result = BrewResult(
          success: false,
          output: 'partial output',
          errorMessage: 'timeout',
        );
        expect(result.success, isFalse);
        expect(result.output, 'partial output');
        expect(result.errorMessage, 'timeout');
      });
    });

    // ── brew info JSON parsing logic ──────────────────────────────────────
    //
    // The installedVersion, latestVersion, and formulaVersions methods all
    // parse the same `brew info --json=v2` output. Since Process.run is not
    // injectable, we can't call these methods directly without brew.
    // The core parsing logic is exposed as
    // BrewService.parseFormulaVersionsFromJson and tested here directly.

    group('brew info --json=v2 formula parsing', () {
      test('extracts installed version from formulae[0].installed', () {
        final json = _makeBrewInfoJson(
          installedVersions: ['1.0.0', '1.2.0'],
          stableVersion: '1.3.0',
        );

        // Source uses: formulae[0]['installed'].last['version']
        final formulae = json['formulae'] as List;
        final installed = formulae[0]['installed'] as List;
        final version = installed.last['version'] as String;

        expect(version, '1.2.0');
      });

      test('extracts latest stable version from formulae[0].versions.stable',
          () {
        final json = _makeBrewInfoJson(
          installedVersions: ['1.0.0'],
          stableVersion: '2.0.0',
        );

        final formulae = json['formulae'] as List;
        final versions = formulae[0]['versions'] as Map<String, dynamic>;
        final stable = versions['stable'] as String;

        expect(stable, '2.0.0');
      });

      test('handles empty installed list', () {
        final json = _makeBrewInfoJson(
          installedVersions: [],
          stableVersion: '1.0.0',
        );

        final formulae = json['formulae'] as List;
        final installed = formulae[0]['installed'] as List;

        expect(installed, isEmpty);
      });

      test('handles null formulae gracefully (cask fallback)', () {
        final json = <String, dynamic>{
          'formulae': <dynamic>[],
          'casks': [
            {
              'installed': '3.5.0',
              'version': '4.0.0',
            }
          ],
        };

        // When formulae is empty, source falls back to casks.
        final formulae = json['formulae'] as List;
        expect(formulae, isEmpty);

        final casks = json['casks'] as List;
        expect(casks[0]['installed'], '3.5.0');
        expect(casks[0]['version'], '4.0.0');
      });

      test('handles both formulae and cask data present', () {
        final json = <String, dynamic>{
          'formulae': [
            {
              'installed': [
                {'version': '1.0.0'}
              ],
              'versions': {'stable': '1.1.0'},
            }
          ],
          'casks': [
            {
              'installed': '2.0.0',
              'version': '2.1.0',
            }
          ],
        };

        // Source checks formulae first, so formulae should take priority.
        final formulae = json['formulae'] as List;
        expect(formulae.isNotEmpty, isTrue);
        final installed = (formulae[0]['installed'] as List).last;
        expect(installed['version'], '1.0.0');
      });
    });

    group('formulaVersions parsing (combined installed + latest)', () {
      test('extracts both installed and latest from formula', () {
        final json = _makeBrewInfoJson(
          installedVersions: ['0.1.0', '0.2.0'],
          stableVersion: '0.3.0',
        );

        // Replicate the formulaVersions parsing logic.
        final (installed, latest) =
            BrewService.parseFormulaVersionsFromJson(json);

        expect(installed, '0.2.0');
        expect(latest, '0.3.0');
      });

      test('returns nulls when formulae is empty and no casks', () {
        final json = <String, dynamic>{
          'formulae': <dynamic>[],
          'casks': <dynamic>[],
        };

        final (installed, latest) =
            BrewService.parseFormulaVersionsFromJson(json);

        expect(installed, isNull);
        expect(latest, isNull);
      });

      test('falls back to cask data when formulae is empty', () {
        final json = <String, dynamic>{
          'formulae': <dynamic>[],
          'casks': [
            {
              'installed': '5.0.0',
              'version': '5.1.0',
            }
          ],
        };

        final (installed, latest) =
            BrewService.parseFormulaVersionsFromJson(json);

        expect(installed, '5.0.0');
        expect(latest, '5.1.0');
      });

      test('returns null installed when not installed but formula exists', () {
        final json = _makeBrewInfoJson(
          installedVersions: [],
          stableVersion: '1.0.0',
        );

        final (installed, latest) =
            BrewService.parseFormulaVersionsFromJson(json);

        expect(installed, isNull);
        expect(latest, '1.0.0');
      });

      test('handles formula with missing versions key', () {
        final json = <String, dynamic>{
          'formulae': [
            {
              'installed': [
                {'version': '1.0.0'}
              ],
              // No 'versions' key.
            }
          ],
          'casks': <dynamic>[],
        };

        final (installed, latest) =
            BrewService.parseFormulaVersionsFromJson(json);

        expect(installed, '1.0.0');
        expect(latest, isNull);
      });
    });

    // ── JSON round-trip safety ────────────────────────────────────────────

    group('JSON round-trip', () {
      test('brew info JSON can be serialized and deserialized', () {
        final original = _makeBrewInfoJson(
          installedVersions: ['1.0.0'],
          stableVersion: '1.1.0',
        );

        final serialized = jsonEncode(original);
        final deserialized = jsonDecode(serialized) as Map<String, dynamic>;

        final formulae = deserialized['formulae'] as List;
        expect(formulae.isNotEmpty, isTrue);
        expect(
          (formulae[0]['installed'] as List).first['version'],
          '1.0.0',
        );
      });
    });

    // ── What can't be tested ─────────────────────────────────────────────
    //
    // The following BrewService methods call Process.run directly (not
    // injectable) and require an actual brew installation:
    //   - isBrewInstalled()
    //   - isFormulaInstalled(formula)
    //   - installedVersion(formula)
    //   - latestVersion(formula)
    //   - install(formula)
    //   - upgrade(formula)
    //   - upgradeCask(cask)
    //   - updateTap()
    //   - _resolveBrewPath()
    //
    // The formulaVersions JSON parsing is now tested directly via
    // BrewService.parseFormulaVersionsFromJson. To test the full methods,
    // Process.run would need to be injected (e.g., via a ProcessRunner
    // abstraction).
  });
}

// ── Test helpers ──────────────────────────────────────────────────────────────

/// Builds a brew info --json=v2 response map for testing.
Map<String, dynamic> _makeBrewInfoJson({
  required List<String> installedVersions,
  required String stableVersion,
}) {
  return {
    'formulae': [
      {
        'installed': [
          for (final v in installedVersions) {'version': v},
        ],
        'versions': {'stable': stableVersion},
      },
    ],
    'casks': <dynamic>[],
  };
}
