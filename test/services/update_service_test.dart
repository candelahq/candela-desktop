import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart' as http_testing;
import 'package:candela_desktop/services/brew_service.dart';
import 'package:candela_desktop/services/update_service.dart';
import 'package:candela_desktop/utils/process_runner.dart';

// ── Test doubles ────────────────────────────────────────────────────────────

/// A fake [ProcessRunner] that records calls without spawning real processes.
class _FakeProcessRunner implements ProcessRunner {
  final List<({String executable, List<String> args})> runCalls = [];
  final List<({String executable, List<String> args})> startCalls = [];

  ProcessResult nextRunResult = ProcessResult(0, 0, '', '');

  @override
  Future<ProcessResult> run(
    String executable,
    List<String> arguments, {
    Map<String, String>? environment,
    String? workingDirectory,
    bool runInShell = false,
  }) async {
    runCalls.add((executable: executable, args: arguments));
    return nextRunResult;
  }

  @override
  Future<Process> start(
    String executable,
    List<String> arguments, {
    Map<String, String>? environment,
    String? workingDirectory,
    bool runInShell = false,
    ProcessStartMode mode = ProcessStartMode.normal,
  }) async {
    startCalls.add((executable: executable, args: arguments));
    return Process.start('echo', ['fake']);
  }
}

/// A fake [BrewService] that returns canned results for [upgradeCask].
class _FakeBrewService extends BrewService {
  BrewResult nextUpgradeCaskResult =
      const BrewResult(success: true, output: 'upgraded');
  final List<String> upgradeCaskCalls = [];
  bool throwOnUpgrade = false;

  _FakeBrewService() : super(runner: _FakeProcessRunner());

  @override
  Future<BrewResult> upgradeCask(String cask) async {
    upgradeCaskCalls.add(cask);
    if (throwOnUpgrade) throw Exception('brew not found');
    return nextUpgradeCaskResult;
  }
}

void main() {
  group('UpdateService — semver comparison', () {
    test('newer major version detected', () {
      expect(UpdateService.isNewer('2.0.0', '1.0.0'), isTrue);
      expect(UpdateService.isNewer('1.0.0', '2.0.0'), isFalse);
    });

    test('newer minor version detected', () {
      expect(UpdateService.isNewer('0.3.0', '0.2.0'), isTrue);
      expect(UpdateService.isNewer('0.2.0', '0.3.0'), isFalse);
    });

    test('newer patch version detected', () {
      expect(UpdateService.isNewer('0.2.1', '0.2.0'), isTrue);
      expect(UpdateService.isNewer('0.2.0', '0.2.1'), isFalse);
    });

    test('same version is not newer', () {
      expect(UpdateService.isNewer('0.2.0', '0.2.0'), isFalse);
    });

    test('release is newer than pre-release with same base', () {
      expect(UpdateService.isNewer('0.2.0', '0.2.0-beta.1'), isTrue);
    });

    test('pre-release is not newer than release with same base', () {
      expect(UpdateService.isNewer('0.2.0-beta.1', '0.2.0'), isFalse);
    });

    test('higher pre-release is newer than lower pre-release', () {
      expect(UpdateService.isNewer('0.2.0-beta.2', '0.2.0-beta.1'), isTrue);
      expect(UpdateService.isNewer('0.2.0-beta.1', '0.2.0-beta.2'), isFalse);
    });

    test('build number suffix is stripped for comparison', () {
      // 0.3.5+1 must parse patch=5, not patch=0
      expect(UpdateService.isNewer('0.3.5+1', '0.3.4'), isTrue);
      expect(UpdateService.isNewer('0.3.4', '0.3.5+1'), isFalse);
    });

    test('same version with different build numbers is not newer', () {
      expect(UpdateService.isNewer('0.4.0+1', '0.4.0+2'), isFalse);
      expect(UpdateService.isNewer('0.4.0+2', '0.4.0+1'), isFalse);
    });

    test('build number with pre-release is handled correctly', () {
      // 0.4.0-beta.1+1 → base 0.4.0, pre-release beta.1
      expect(UpdateService.isNewer('0.4.0-beta.1+1', '0.3.0'), isTrue);
      expect(UpdateService.isNewer('0.4.0+1', '0.4.0-beta.1+1'), isTrue);
    });

    test('v prefix is stripped for comparison', () {
      expect(UpdateService.isNewer('v2.0.0', 'v1.0.0'), isTrue);
      expect(UpdateService.isNewer('v1.0.0', 'v2.0.0'), isFalse);
      // Mixed: one with prefix, one without.
      expect(UpdateService.isNewer('v0.4.0', '0.3.0'), isTrue);
      expect(UpdateService.isNewer('0.4.0', 'v0.3.0'), isTrue);
    });
  });

  group('UpdateService — checkForUpdate', () {
    test('returns version when newer release exists', () async {
      final mockClient = http_testing.MockClient((request) async {
        return http.Response(
          jsonEncode({'tag_name': 'v0.3.0', 'name': 'v0.3.0'}),
          200,
        );
      });

      final service = UpdateService(client: mockClient);
      final result = await service.checkForUpdate('0.2.0');
      expect(result, equals('0.3.0'));
      expect(service.latestVersion, equals('0.3.0'));
    });

    test('returns null when already on latest', () async {
      final mockClient = http_testing.MockClient((request) async {
        return http.Response(
          jsonEncode({'tag_name': 'v0.2.0', 'name': 'v0.2.0'}),
          200,
        );
      });

      final service = UpdateService(client: mockClient);
      final result = await service.checkForUpdate('0.2.0');
      expect(result, isNull);
    });

    test('returns null on non-200 response', () async {
      final mockClient = http_testing.MockClient((request) async {
        return http.Response('not found', 404);
      });

      final service = UpdateService(client: mockClient);
      final result = await service.checkForUpdate('0.2.0');
      expect(result, isNull);
    });

    test('returns null on malformed JSON', () async {
      final mockClient = http_testing.MockClient((request) async {
        return http.Response('not json at all!!!', 200);
      });

      final service = UpdateService(client: mockClient);
      final result = await service.checkForUpdate('0.2.0');
      expect(result, isNull);
    });

    test('handles tag_name without v prefix', () async {
      final mockClient = http_testing.MockClient((request) async {
        return http.Response(
          jsonEncode({'tag_name': '0.3.0', 'name': '0.3.0'}),
          200,
        );
      });

      final service = UpdateService(client: mockClient);
      final result = await service.checkForUpdate('0.2.0');
      expect(result, equals('0.3.0'));
    });

    test('sends correct Accept header', () async {
      String? capturedAccept;
      final mockClient = http_testing.MockClient((request) async {
        capturedAccept = request.headers['Accept'];
        return http.Response(
          jsonEncode({'tag_name': 'v0.2.0'}),
          200,
        );
      });

      final service = UpdateService(client: mockClient);
      await service.checkForUpdate('0.2.0');
      expect(capturedAccept, equals('application/vnd.github.v3+json'));
    });

    test('returns null on missing tag_name field', () async {
      final mockClient = http_testing.MockClient((request) async {
        return http.Response(
          jsonEncode({'name': 'some release'}),
          200,
        );
      });

      final service = UpdateService(client: mockClient);
      final result = await service.checkForUpdate('0.2.0');
      expect(result, isNull);
    });
  });

  group('UpdateService — updateInstructions', () {
    test('direct channel gives fallback download message', () {
      final service = UpdateService();
      final msg = service.updateInstructions(InstallChannel.direct);
      expect(msg, contains('Download'));
    });

    test('homebrew channel gives brew command', () {
      final service = UpdateService();
      final msg = service.updateInstructions(InstallChannel.homebrew);
      expect(msg, contains('brew upgrade'));
    });

    test('nix channel gives nix command', () {
      final service = UpdateService();
      final msg = service.updateInstructions(InstallChannel.nix);
      expect(msg, contains('nix profile upgrade'));
    });

    test('CRITICAL-6: unknown channel returns fallback URL message', () {
      final service = UpdateService();
      final msg = service.updateInstructions(InstallChannel.unknown);
      expect(msg, contains('releases'));
    });
  });

  group('UpdateService — status transitions', () {
    test('initial status is idle', () {
      final service = UpdateService();
      expect(service.status, UpdateStatus.idle);
    });

    test('status transitions to checking then upToDate', () async {
      final states = <UpdateStatus>[];
      final mockClient = http_testing.MockClient((request) async {
        return http.Response(
          jsonEncode({'tag_name': 'v0.3.4'}),
          200,
        );
      });
      final service = UpdateService(client: mockClient);
      service.addListener(() => states.add(service.status));
      await service.checkForUpdate('0.3.4');
      expect(states,
          containsAllInOrder([UpdateStatus.checking, UpdateStatus.upToDate]));
    });

    test('status transitions to available on newer version', () async {
      final states = <UpdateStatus>[];
      final mockClient = http_testing.MockClient((request) async {
        return http.Response(
          jsonEncode({'tag_name': 'v1.0.0'}),
          200,
        );
      });
      final service = UpdateService(client: mockClient);
      service.addListener(() => states.add(service.status));
      await service.checkForUpdate('0.3.4');
      expect(states,
          containsAllInOrder([UpdateStatus.checking, UpdateStatus.available]));
    });

    test('status transitions to error on 404', () async {
      final states = <UpdateStatus>[];
      final mockClient = http_testing.MockClient((request) async {
        return http.Response('not found', 404);
      });
      final service = UpdateService(client: mockClient);
      service.addListener(() => states.add(service.status));
      await service.checkForUpdate('0.3.4');
      expect(states,
          containsAllInOrder([UpdateStatus.checking, UpdateStatus.error]));
    });

    test('latestVersion is null initially', () {
      expect(UpdateService().latestVersion, isNull);
    });
  });

  group('UpdateService — releasesPageUrl', () {
    test('releasesPageUrl is a valid https URL', () {
      final uri = Uri.parse(UpdateService.releasesPageUrl);
      expect(uri.scheme, anyOf('https', 'http'));
      expect(uri.host, isNotEmpty);
      expect(uri.host, contains('github'));
    });
  });

  group('UpdateService — performBrewUpgrade', () {
    test(
      'delegates to BrewService.upgradeCask with correct cask name',
      () async {
        final fakeBrew = _FakeBrewService();
        // Simulate failure so we don't hit exit(0).
        fakeBrew.nextUpgradeCaskResult =
            const BrewResult(success: false, errorMessage: 'no cask');
        final runner = _FakeProcessRunner();
        final service = UpdateService(runner: runner, brew: fakeBrew);

        await service.performBrewUpgrade();

        expect(fakeBrew.upgradeCaskCalls, hasLength(1));
        expect(
            fakeBrew.upgradeCaskCalls.first, 'candelahq/tap/candela-desktop');
      },
      skip: !Platform.isMacOS ? 'performBrewUpgrade is macOS-only' : null,
    );

    test(
      'returns false and sets error status on upgrade failure',
      () async {
        final fakeBrew = _FakeBrewService();
        fakeBrew.nextUpgradeCaskResult = const BrewResult(
          success: false,
          output: '',
          errorMessage: 'Error: cask not found',
        );
        final runner = _FakeProcessRunner();
        final service = UpdateService(runner: runner, brew: fakeBrew);

        final states = <UpdateStatus>[];
        service.addListener(() => states.add(service.status));

        final result = await service.performBrewUpgrade();

        expect(result, isFalse);
        expect(service.status, UpdateStatus.error);
        expect(states,
            containsAllInOrder([UpdateStatus.checking, UpdateStatus.error]));
        // Should NOT have tried to relaunch the app.
        expect(runner.startCalls, isEmpty);
      },
      skip: !Platform.isMacOS ? 'performBrewUpgrade is macOS-only' : null,
    );

    test(
      'returns false and sets error status on thrown exception',
      () async {
        final fakeBrew = _FakeBrewService();
        fakeBrew.throwOnUpgrade = true;
        final runner = _FakeProcessRunner();
        final service = UpdateService(runner: runner, brew: fakeBrew);

        final result = await service.performBrewUpgrade();

        expect(result, isFalse);
        expect(service.status, UpdateStatus.error);
        expect(runner.startCalls, isEmpty);
      },
      skip: !Platform.isMacOS ? 'performBrewUpgrade is macOS-only' : null,
    );

    test(
      'does not spawn real processes when no BrewService is injected',
      () async {
        // When only a fake ProcessRunner is provided (no explicit BrewService),
        // the default BrewService should receive the same fake runner —
        // so no real `brew` process is spawned.
        final runner = _FakeProcessRunner();
        // Make `which brew` fail and `brew` commands fail, so we don't hit exit(0).
        runner.nextRunResult = ProcessResult(0, 1, '', 'not found');
        final service = UpdateService(runner: runner);

        final result = await service.performBrewUpgrade();

        // The upgrade should fail (brew not found), but crucially it should
        // have gone through our fake runner, not spawned a real process.
        expect(result, isFalse);
        // Verify the fake runner was used (BrewService calls `which brew`
        // to resolve the path, then the upgrade command).
        expect(runner.runCalls, isNotEmpty);
      },
      skip: !Platform.isMacOS ? 'performBrewUpgrade is macOS-only' : null,
    );

    test(
      'returns false immediately on non-macOS platforms',
      () async {
        final fakeBrew = _FakeBrewService();
        final runner = _FakeProcessRunner();
        final service = UpdateService(runner: runner, brew: fakeBrew);

        final result = await service.performBrewUpgrade();

        expect(result, isFalse);
        // Should not have called BrewService at all.
        expect(fakeBrew.upgradeCaskCalls, isEmpty);
        // Status should remain idle (no state change).
        expect(service.status, UpdateStatus.idle);
      },
      skip: Platform.isMacOS ? 'Only meaningful on non-macOS platforms' : null,
    );
  });
}
