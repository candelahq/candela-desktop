import 'dart:io';

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
      // Must be an absolute path.
      expect(home.startsWith('/'), isTrue,
          reason: 'homeDir should return an absolute path, got: $home');
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

    test('extraCliPaths contains google-cloud-sdk path', () {
      final paths = platform_paths.extraCliPaths();
      expect(paths, isNotEmpty);
      expect(
        paths.any((p) => p.contains('google-cloud-sdk')),
        isTrue,
        reason: 'Should contain a google-cloud-sdk path entry',
      );
    });

    test('extraCliPaths contains common binary paths on macOS/Linux', () {
      // These tests only apply on non-Windows.
      if (!Platform.isWindows) {
        final paths = platform_paths.extraCliPaths();
        expect(paths, contains('/opt/homebrew/bin'));
        expect(paths, contains('/usr/local/bin'));
      }
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
      final augmentedPath = env['PATH']!;
      expect(augmentedPath, contains('google-cloud-sdk'));
    });

    test('buildAugmentedEnv includes additional paths when specified', () {
      final env = platform_paths.buildAugmentedEnv(
        additionalPaths: ['/custom/test/path'],
      );
      expect(env['PATH'], contains('/custom/test/path'));
    });

    test('buildAugmentedEnv preserves existing PATH entries', () {
      final systemPath = Platform.environment['PATH'] ?? '';
      final augmentedPath = platform_paths.buildAugmentedEnv()['PATH']!;
      expect(augmentedPath, contains(systemPath),
          reason: 'Augmented PATH should contain original system PATH');
    });

    test('buildAugmentedEnv uses correct separator', () {
      final env = platform_paths.buildAugmentedEnv();
      final augmentedPath = env['PATH']!;
      final sep = platform_paths.pathSeparator;
      expect(augmentedPath.contains(sep), isTrue);
    });

    test('buildAugmentedEnv has exactly one PATH key', () {
      final env = platform_paths.buildAugmentedEnv();
      final pathKeys =
          env.keys.where((k) => k.toUpperCase() == 'PATH').toList();
      expect(pathKeys.length, equals(1),
          reason: 'Should have exactly one PATH key, got: $pathKeys');
    });
  });
}
