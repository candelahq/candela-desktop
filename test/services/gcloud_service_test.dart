import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/services/gcloud_service.dart';

void main() {
  group('GCloudService', () {
    late GCloudService service;

    setUp(() {
      service = GCloudService();
    });

    test('augmentedEnv includes homebrew paths', () {
      final env = service.augmentedEnv;
      expect(env['PATH'], contains('/opt/homebrew/bin'));
      expect(env['PATH'], contains('/usr/local/bin'));
      expect(env['PATH'], contains('google-cloud-sdk/bin'));
    });

    test('augmentedEnv preserves existing PATH', () {
      final env = service.augmentedEnv;
      expect(env['PATH'], isNotEmpty);
      expect(env['PATH']!.split(':').length, greaterThan(5));
    });

    test('decodeJwt handles opaque token (not a JWT)', () {
      final token = service.getTokenInfoForTest('not-a-jwt-token');
      expect(token, isNotNull);
      expect(token!.isValid, isTrue);
    });

    test('decodeJwt handles expired JWT', () {
      final header =
          base64Url.encode(utf8.encode('{"alg":"RS256","typ":"JWT"}'));
      final payload = base64Url
          .encode(utf8.encode('{"exp":1000000000,"email":"test@test.com"}'));
      final fakeToken = '$header.$payload.signature';

      final token = service.getTokenInfoForTest(fakeToken);
      expect(token, isNotNull);
      expect(token!.isValid, isFalse);
      expect(token.email, 'test@test.com');
    });

    test('decodeJwt handles valid JWT', () {
      final header =
          base64Url.encode(utf8.encode('{"alg":"RS256","typ":"JWT"}'));
      final payload = base64Url
          .encode(utf8.encode('{"exp":4102444800,"email":"user@example.com"}'));
      final fakeToken = '$header.$payload.signature';

      final token = service.getTokenInfoForTest(fakeToken);
      expect(token, isNotNull);
      expect(token!.isValid, isTrue);
      expect(token.email, 'user@example.com');
    });

    // --- Audit v4: new unit tests ---

    test('augmentedEnv preserves HOME variable', () {
      final env = service.augmentedEnv;
      // HOME should be preserved from the host environment.
      expect(env.containsKey('HOME'), isTrue);
    });

    test('decodeJwt handles token with no email claim', () {
      final header =
          base64Url.encode(utf8.encode('{"alg":"RS256","typ":"JWT"}'));
      final payload =
          base64Url.encode(utf8.encode('{"exp":4102444800}')); // no email
      final fakeToken = '$header.$payload.signature';

      final token = service.getTokenInfoForTest(fakeToken);
      expect(token, isNotNull);
      expect(token!.isValid, isTrue);
      expect(token.email, isNull);
    });

    test('decodeJwt handles malformed base64 gracefully', () {
      final header =
          base64Url.encode(utf8.encode('{"alg":"RS256","typ":"JWT"}'));
      const brokenPayload = '!!!not-valid-base64!!!';
      final fakeToken = '$header.$brokenPayload.signature';

      final token = service.getTokenInfoForTest(fakeToken);
      expect(token, isNotNull);
      // Should fall back to non-JWT "assume valid" path.
      expect(token!.isValid, isTrue);
    });

    test('decodeJwt future-dated expiry returns valid', () {
      final header =
          base64Url.encode(utf8.encode('{"alg":"RS256","typ":"JWT"}'));
      // Year 2099 timestamp.
      final payload = base64Url
          .encode(utf8.encode('{"exp":4070908800,"email":"future@test.com"}'));
      final fakeToken = '$header.$payload.signature';

      final token = service.getTokenInfoForTest(fakeToken);
      expect(token, isNotNull);
      expect(token!.isValid, isTrue);
      expect(token.email, 'future@test.com');
      expect(token.timeRemaining.inDays, greaterThan(365));
    });
  });
}
