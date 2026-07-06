import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/utils/platform_paths.dart';
import 'package:candela_desktop/utils/platform_paths.dart' as platform_paths;

void main() {
  // ═══════════════════════════════════════════════════════════════════════════
  // Top-level shim tests (existing — verify backward compatibility)
  // ═══════════════════════════════════════════════════════════════════════════

  group('platform_paths top-level shim', () {
    test('homeDir returns non-empty string on current platform', () {
      final home = platform_paths.homeDir();
      expect(home, isNotEmpty);
      // Platform-aware: Windows uses drive letters, Unix uses /.
      if (Platform.isWindows) {
        expect(RegExp(r'^[A-Z]:\\').hasMatch(home), isTrue,
            reason:
                'homeDir should return an absolute path on Windows, got: $home');
      } else {
        expect(home.startsWith('/'), isTrue,
            reason:
                'homeDir should return an absolute path on Unix, got: $home');
      }
    });

    test('candelaConfigDir returns path containing "candela"', () {
      final dir = platform_paths.candelaConfigDir();
      expect(dir, contains('candela'));
      expect(dir, isNotEmpty);
    });

    test('candelaConfigDir returns absolute path', () {
      final dir = platform_paths.candelaConfigDir();
      expect(dir.startsWith('/') || RegExp(r'^[A-Z]:\\').hasMatch(dir), isTrue,
          reason: 'Config dir should be an absolute path, got: $dir');
    });

    test('candelaConfigPath ends with config.yaml', () {
      final path = platform_paths.candelaConfigPath();
      expect(path, endsWith('config.yaml'));
      expect(path, contains('candela'));
    });

    test('candelaLegacyConfigPath ends with .candela.yaml', () {
      final path = platform_paths.candelaLegacyConfigPath();
      expect(path, endsWith('.candela.yaml'));
    });

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
      if (!Platform.isWindows) {
        final paths = platform_paths.extraCliPaths();
        expect(paths, contains('/opt/homebrew/bin'));
        expect(paths, contains('/usr/local/bin'));
      }
    });

    test('pathSeparator is : on Unix or ; on Windows', () {
      final sep = platform_paths.pathSeparator;
      expect(sep == ':' || sep == ';', isTrue);
    });

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
      // Use /tmp because the top-level shim filters non-existent dirs.
      final env = platform_paths.buildAugmentedEnv(
        additionalPaths: ['/tmp'],
      );
      expect(env['PATH'], contains('/tmp'));
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

  // ═══════════════════════════════════════════════════════════════════════════
  // PlatformPaths class tests — Windows paths tested on macOS CI!
  // ═══════════════════════════════════════════════════════════════════════════

  group('PlatformPaths — Windows', () {
    // ── homeDir ──────────────────────────────────────────────────────────

    test('homeDir returns USERPROFILE when set', () {
      final paths = const PlatformPaths(
        env: {'USERPROFILE': r'C:\Users\testuser'},
        isWindows: true,
      );
      expect(paths.homeDir(), r'C:\Users\testuser');
    });

    test('homeDir falls back to HOMEDRIVE + HOMEPATH', () {
      final paths = const PlatformPaths(
        env: {'HOMEDRIVE': 'D:', 'HOMEPATH': r'\Users\admin'},
        isWindows: true,
      );
      expect(paths.homeDir(), r'D:\Users\admin');
    });

    test('homeDir prefers USERPROFILE over HOMEDRIVE+HOMEPATH', () {
      final paths = const PlatformPaths(
        env: {
          'USERPROFILE': r'C:\Users\primary',
          'HOMEDRIVE': 'D:',
          'HOMEPATH': r'\Users\fallback',
        },
        isWindows: true,
      );
      expect(paths.homeDir(), r'C:\Users\primary');
    });

    test('homeDir throws StateError when all env vars missing', () {
      final paths = const PlatformPaths(env: {}, isWindows: true);
      expect(
        () => paths.homeDir(),
        throwsA(isA<StateError>().having(
          (e) => e.message,
          'message',
          contains('USERPROFILE'),
        )),
      );
    });

    test('homeDir throws StateError when USERPROFILE is empty', () {
      final paths = const PlatformPaths(
        env: {'USERPROFILE': ''},
        isWindows: true,
      );
      expect(() => paths.homeDir(), throwsA(isA<StateError>()));
    });

    // ── candelaConfigDir ─────────────────────────────────────────────────

    test('candelaConfigDir returns APPDATA/candela', () {
      final paths = const PlatformPaths(
        env: {'APPDATA': r'C:\Users\test\AppData\Roaming'},
        isWindows: true,
      );
      expect(paths.candelaConfigDir(), contains('candela'));
      expect(paths.candelaConfigDir(), contains('AppData'));
    });

    test('candelaConfigDir throws when APPDATA missing', () {
      final paths = const PlatformPaths(env: {}, isWindows: true);
      expect(
        () => paths.candelaConfigDir(),
        throwsA(isA<StateError>().having(
          (e) => e.message,
          'message',
          contains('APPDATA'),
        )),
      );
    });

    // ── candelaConfigPath ────────────────────────────────────────────────

    test('candelaConfigPath ends with config.yaml', () {
      final paths = const PlatformPaths(
        env: {'APPDATA': r'C:\Users\test\AppData\Roaming'},
        isWindows: true,
      );
      expect(paths.candelaConfigPath(), endsWith('config.yaml'));
      expect(paths.candelaConfigPath(), contains('candela'));
    });

    // ── candelaLegacyConfigPath ──────────────────────────────────────────

    test('candelaLegacyConfigPath uses USERPROFILE', () {
      final paths = const PlatformPaths(
        env: {'USERPROFILE': r'C:\Users\test'},
        isWindows: true,
      );
      expect(paths.candelaLegacyConfigPath(), endsWith('.candela.yaml'));
      expect(paths.candelaLegacyConfigPath(), contains('Users'));
    });

    // ── adcCredentialPath ────────────────────────────────────────────────

    test('adcCredentialPath uses APPDATA/gcloud', () {
      final paths = const PlatformPaths(
        env: {'APPDATA': r'C:\Users\test\AppData\Roaming'},
        isWindows: true,
      );
      final adc = paths.adcCredentialPath();
      expect(adc, contains('gcloud'));
      expect(adc, contains('application_default_credentials.json'));
      expect(adc, contains('AppData'));
    });

    test('adcCredentialPath prefers CLOUDSDK_CONFIG', () {
      final paths = const PlatformPaths(
        env: {
          'CLOUDSDK_CONFIG': r'D:\custom\gcloud',
          'APPDATA': r'C:\Users\test\AppData\Roaming',
        },
        isWindows: true,
      );
      final adc = paths.adcCredentialPath();
      expect(adc, contains('custom'));
      expect(adc, contains('application_default_credentials.json'));
    });

    test('adcCredentialPath throws when APPDATA missing (no CLOUDSDK_CONFIG)',
        () {
      final paths = const PlatformPaths(env: {}, isWindows: true);
      expect(
        () => paths.adcCredentialPath(),
        throwsA(isA<StateError>().having(
          (e) => e.message,
          'message',
          contains('APPDATA'),
        )),
      );
    });

    // ── extraCliPaths ────────────────────────────────────────────────────

    test('extraCliPaths includes Windows SDK paths', () {
      final paths = const PlatformPaths(
        env: {
          'USERPROFILE': r'C:\Users\test',
          'LOCALAPPDATA': r'C:\Users\test\AppData\Local',
          'ProgramFiles': r'C:\Program Files',
        },
        isWindows: true,
      );
      final cliPaths = paths.extraCliPaths();
      expect(cliPaths.length, greaterThanOrEqualTo(2));
      expect(cliPaths.any((p) => p.contains('google-cloud-sdk')), isTrue);
      expect(cliPaths.any((p) => p.contains('Local')), isTrue);
      expect(cliPaths.any((p) => p.contains('Program Files')), isTrue);
    });

    test('extraCliPaths uses fallback when ProgramFiles missing', () {
      final paths = const PlatformPaths(
        env: {'USERPROFILE': r'C:\Users\test'},
        isWindows: true,
      );
      final cliPaths = paths.extraCliPaths();
      expect(cliPaths.any((p) => p.contains('Program Files')), isTrue);
    });

    test('extraCliPaths skips LOCALAPPDATA when not set', () {
      final paths = const PlatformPaths(
        env: {'USERPROFILE': r'C:\Users\test'},
        isWindows: true,
      );
      final cliPaths = paths.extraCliPaths();
      // Without LOCALAPPDATA, no relative paths should be generated.
      for (final p in cliPaths) {
        expect(p.startsWith('Google'), isFalse,
            reason: 'Should not generate relative path, got: $p');
      }
    });

    // ── pathSeparator ────────────────────────────────────────────────────

    test('pathSeparator is ; on Windows', () {
      final paths = const PlatformPaths(env: {}, isWindows: true);
      expect(paths.pathSeparator, ';');
    });

    // ── buildAugmentedEnv ────────────────────────────────────────────────

    test('buildAugmentedEnv uses ; separator on Windows', () {
      final paths = const PlatformPaths(
        env: {
          'USERPROFILE': r'C:\Users\test',
          'LOCALAPPDATA': r'C:\Users\test\AppData\Local',
          'PATH': r'C:\Windows\system32',
        },
        isWindows: true,
      );
      final env = paths.buildAugmentedEnv();
      expect(env['PATH'], contains(';'));
      expect(env['PATH'], contains('system32'));
      expect(env['PATH'], contains('google-cloud-sdk'));
    });

    test('buildAugmentedEnv includes additional paths on Windows', () {
      final paths = const PlatformPaths(
        env: {
          'USERPROFILE': r'C:\Users\test',
          'PATH': r'C:\Windows',
        },
        isWindows: true,
      );
      final env = paths.buildAugmentedEnv(
        additionalPaths: [r'C:\custom\bin'],
      );
      expect(env['PATH'], contains(r'C:\custom\bin'));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // PlatformPaths class tests — Unix
  // ═══════════════════════════════════════════════════════════════════════════

  group('PlatformPaths — Unix', () {
    test('homeDir returns HOME', () {
      final paths = const PlatformPaths(
        env: {'HOME': '/home/testuser'},
        isWindows: false,
      );
      expect(paths.homeDir(), '/home/testuser');
    });

    test('homeDir throws StateError when HOME missing', () {
      final paths = const PlatformPaths(env: {}, isWindows: false);
      expect(
        () => paths.homeDir(),
        throwsA(isA<StateError>().having(
          (e) => e.message,
          'message',
          contains('HOME'),
        )),
      );
    });

    test('homeDir throws StateError when HOME is empty', () {
      final paths = const PlatformPaths(
        env: {'HOME': ''},
        isWindows: false,
      );
      expect(() => paths.homeDir(), throwsA(isA<StateError>()));
    });

    test('candelaConfigDir returns ~/.config/candela', () {
      final paths = const PlatformPaths(
        env: {'HOME': '/home/testuser'},
        isWindows: false,
      );
      expect(paths.candelaConfigDir(), '/home/testuser/.config/candela');
    });

    test('adcCredentialPath returns ~/.config/gcloud/...', () {
      final paths = const PlatformPaths(
        env: {'HOME': '/home/testuser'},
        isWindows: false,
      );
      final adc = paths.adcCredentialPath();
      expect(
          adc,
          '/home/testuser/.config/gcloud/'
          'application_default_credentials.json');
    });

    test('adcCredentialPath prefers CLOUDSDK_CONFIG on Unix', () {
      final paths = const PlatformPaths(
        env: {
          'CLOUDSDK_CONFIG': '/custom/gcloud',
          'HOME': '/home/testuser',
        },
        isWindows: false,
      );
      expect(
          paths.adcCredentialPath(),
          '/custom/gcloud/'
          'application_default_credentials.json');
    });

    test('extraCliPaths includes homebrew and local bin', () {
      final paths = const PlatformPaths(
        env: {'HOME': '/home/testuser'},
        isWindows: false,
      );
      final cliPaths = paths.extraCliPaths();
      expect(cliPaths, contains('/opt/homebrew/bin'));
      expect(cliPaths, contains('/usr/local/bin'));
      expect(cliPaths.any((p) => p.contains('.local/bin')), isTrue);
    });

    test('pathSeparator is : on Unix', () {
      final paths = const PlatformPaths(env: {}, isWindows: false);
      expect(paths.pathSeparator, ':');
    });

    test('buildAugmentedEnv uses : separator on Unix', () {
      final paths = const PlatformPaths(
        env: {
          'HOME': '/home/testuser',
          'PATH': '/usr/bin',
        },
        isWindows: false,
      );
      final env = paths.buildAugmentedEnv();
      expect(env['PATH'], contains(':'));
      expect(env['PATH'], contains('/usr/bin'));
      expect(env['PATH'], contains('google-cloud-sdk'));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // PlatformPaths class tests — Cross-platform edge cases
  // ═══════════════════════════════════════════════════════════════════════════

  group('PlatformPaths — edge cases', () {
    test('constructor stores platform flags correctly', () {
      final paths = const PlatformPaths(
        env: {},
        isWindows: true,
        isMacOS: false,
        isLinux: false,
        resolvedExecutable: r'C:\Program Files\Candela\candela.exe',
      );
      expect(paths.isWindows, isTrue);
      expect(paths.isMacOS, isFalse);
      expect(paths.isLinux, isFalse);
      expect(paths.resolvedExecutable, contains('candela.exe'));
    });

    test('buildAugmentedEnv does not mutate input env', () {
      final original = {'HOME': '/home/test', 'PATH': '/usr/bin'};
      final paths = PlatformPaths(env: original, isWindows: false);
      paths.buildAugmentedEnv(additionalPaths: ['/extra']);
      // Original should be unchanged.
      expect(original['PATH'], '/usr/bin');
    });

    test('buildAugmentedEnv handles empty PATH gracefully', () {
      final paths = const PlatformPaths(
        env: {'HOME': '/home/test'},
        isWindows: false,
      );
      final env = paths.buildAugmentedEnv();
      expect(env['PATH'], isNotNull);
      expect(env['PATH'], contains('google-cloud-sdk'));
      // CWE-426: trailing separator would be interpreted as CWD on Unix.
      expect(env['PATH']!.endsWith(':'), isFalse,
          reason: 'Should not append a trailing separator when PATH is empty');
    });
  });
}
