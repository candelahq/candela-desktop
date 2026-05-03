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
  });
}
