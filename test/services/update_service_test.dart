import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart' as http_testing;
import 'package:candela_desktop/services/update_service.dart';

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
    test('direct channel gives auto-update message', () {
      final service = UpdateService();
      final msg = service.updateInstructions(InstallChannel.direct);
      expect(msg, contains('automatically'));
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
  });
}
