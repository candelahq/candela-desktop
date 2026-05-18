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

    test('augmentedEnv preserves HOME variable', () {
      final env = service.augmentedEnv;
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
      expect(token!.isValid, isTrue);
    });

    test('decodeJwt future-dated expiry returns valid', () {
      final header =
          base64Url.encode(utf8.encode('{"alg":"RS256","typ":"JWT"}'));
      final payload = base64Url
          .encode(utf8.encode('{"exp":4070908800,"email":"future@test.com"}'));
      final fakeToken = '$header.$payload.signature';

      final token = service.getTokenInfoForTest(fakeToken);
      expect(token, isNotNull);
      expect(token!.isValid, isTrue);
      expect(token.email, 'future@test.com');
      expect(token.timeRemaining.inDays, greaterThan(365));
    });

    // ── CRITICAL-3: email validation added after security hardening ─────────

    test('CRITICAL-3: rejects non-string email field (int in JSON)', () {
      final header =
          base64Url.encode(utf8.encode('{"alg":"RS256","typ":"JWT"}'));
      final payload =
          base64Url.encode(utf8.encode('{"exp":4102444800,"email":12345}'));
      final fakeToken = '$header.$payload.signature';
      final token = service.getTokenInfoForTest(fakeToken);
      expect(token!.email, isNull);
    });

    test('CRITICAL-3: rejects email longer than 254 chars', () {
      final longEmail = '${'a' * 250}@x.com'; // 256 chars
      final header =
          base64Url.encode(utf8.encode('{"alg":"RS256","typ":"JWT"}'));
      final payload = base64Url
          .encode(utf8.encode('{"exp":4102444800,"email":"$longEmail"}'));
      final fakeToken = '$header.$payload.signature';
      final token = service.getTokenInfoForTest(fakeToken);
      expect(token!.email, isNull);
    });

    test('CRITICAL-3: accepts email at exactly 254 chars', () {
      // 249 a's + @x.co = exactly 254
      final okEmail = '${'a' * 249}@x.co';
      expect(okEmail.length, 254);
      final header =
          base64Url.encode(utf8.encode('{"alg":"RS256","typ":"JWT"}'));
      final payload = base64Url
          .encode(utf8.encode('{"exp":4102444800,"email":"$okEmail"}'));
      final fakeToken = '$header.$payload.signature';
      final token = service.getTokenInfoForTest(fakeToken);
      expect(token!.email, equals(okEmail));
    });

    test('CRITICAL-3: rejects boolean email field', () {
      final header =
          base64Url.encode(utf8.encode('{"alg":"RS256","typ":"JWT"}'));
      final payload =
          base64Url.encode(utf8.encode('{"exp":4102444800,"email":false}'));
      final fakeToken = '$header.$payload.signature';
      final token = service.getTokenInfoForTest(fakeToken);
      expect(token!.email, isNull);
    });

    // ── ADC lifetime fix: opaque token fallback now uses 60-min estimate ──

    test('opaque token fallback uses ~60-minute TTL (not 15 min)', () {
      final token = service.getTokenInfoForTest('ya29.opaque-access-token');
      expect(token, isNotNull);
      expect(token!.isValid, isTrue);
      // Should be close to 60 minutes, not 15.
      expect(token.timeRemaining.inMinutes, greaterThanOrEqualTo(58));
      expect(token.timeRemaining.inMinutes, lessThanOrEqualTo(60));
    });
  });
}
