import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/utils/platform_paths.dart' as platform_paths;

void main() {
  group('platform_paths', () {
    // ── homeDir ────────────────────────────────────────────────────────────

    test('homeDir returns non-empty string on current platform', () {
      // This test runs on the CI platform (macOS/Linux).
      // $HOME is always set in CI and dev environments.
      final home = platform_paths.homeDir();
      expect(home, isNotEmpty);
      expect(home, isNot(contains('/tmp')));
    });

    // ── candelaConfigDir ─────────────────────────────────────────────────

    test('candelaConfigDir returns path containing "candela"', () {
      final dir = platform_paths.candelaConfigDir();
      expect(dir, contains('candela'));
      expect(dir, isNotEmpty);
    });

    test('candelaConfigDir returns absolute path', () {
      final dir = platform_paths.candelaConfigDir();
      // On Unix, absolute paths start with /
      // On Windows, they start with a drive letter (e.g., C:\)
      expect(dir.startsWith('/') || RegExp(r'^[A-Z]:\\').hasMatch(dir), isTrue,
          reason: 'Config dir should be an absolute path, got: $dir');
    });

    // ── candelaConfigPath ────────────────────────────────────────────────

    test('candelaConfigPath ends with config.yaml', () {
      final path = platform_paths.candelaConfigPath();
      expect(path, endsWith('config.yaml'));
      expect(path, contains('candela'));
    });

    // ── candelaLegacyConfigPath ──────────────────────────────────────────

    test('candelaLegacyConfigPath ends with .candela.yaml', () {
      final path = platform_paths.candelaLegacyConfigPath();
      expect(path, endsWith('.candela.yaml'));
    });

    // ── adcCredentialPath ────────────────────────────────────────────────

    test('adcCredentialPath returns path containing gcloud and ADC file', () {
      final path = platform_paths.adcCredentialPath();
      expect(path, contains('gcloud'));
      expect(path, contains('application_default_credentials.json'));
    });

    test('adcCredentialPath returns absolute path', () {
      final path = platform_paths.adcCredentialPath();
      expect(
          path.startsWith('/') || RegExp(r'^[A-Z]:\\').hasMatch(path), isTrue,
          reason: 'ADC path should be an absolute path, got: $path');
    });

    // ── extraCliPaths ────────────────────────────────────────────────────

    test('extraCliPaths returns non-empty list', () {
      final paths = platform_paths.extraCliPaths();
      expect(paths, isNotEmpty);
      expect(paths.length, greaterThanOrEqualTo(3));
    });

    test('extraCliPaths contains google-cloud-sdk/bin', () {
      final paths = platform_paths.extraCliPaths();
      expect(paths.any((p) => p.contains('google-cloud-sdk')), isTrue);
    });

    // ── pathSeparator ────────────────────────────────────────────────────

    test('pathSeparator is : on Unix or ; on Windows', () {
      final sep = platform_paths.pathSeparator;
      expect(sep == ':' || sep == ';', isTrue);
    });

    // ── buildAugmentedEnv ────────────────────────────────────────────────

    test('buildAugmentedEnv returns map with PATH key', () {
      final env = platform_paths.buildAugmentedEnv();
      expect(env, contains('PATH'));
      expect(env['PATH'], isNotEmpty);
    });

    test('buildAugmentedEnv prepends extra CLI paths', () {
      final env = platform_paths.buildAugmentedEnv();
      final path = env['PATH']!;
      expect(path, contains('google-cloud-sdk'));
    });

    test('buildAugmentedEnv includes additional paths when specified', () {
      final env = platform_paths.buildAugmentedEnv(
        additionalPaths: ['/custom/test/path'],
      );
      expect(env['PATH'], contains('/custom/test/path'));
    });

    test('buildAugmentedEnv preserves existing PATH entries', () {
      final originalPath = platform_paths.buildAugmentedEnv()['PATH']!;
      // The original PATH from the environment should be present as a suffix.
      expect(originalPath.length, greaterThan(50),
          reason: 'Augmented PATH should contain original PATH entries');
    });

    test('buildAugmentedEnv uses correct separator', () {
      final env = platform_paths.buildAugmentedEnv();
      final path = env['PATH']!;
      final sep = platform_paths.pathSeparator;
      expect(path.contains(sep), isTrue);
    });

    test('buildAugmentedEnv does not duplicate PATH keys', () {
      final env = platform_paths.buildAugmentedEnv();
      // Should have exactly one PATH key (case-insensitive check).
      final pathKeys =
          env.keys.where((k) => k.toUpperCase() == 'PATH').toList();
      expect(pathKeys.length, equals(1),
          reason: 'Should have exactly one PATH key, got: $pathKeys');
    });
  });
}
