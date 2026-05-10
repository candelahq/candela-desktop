import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/services/url_validator.dart';

void main() {
  group('UrlValidator.validate', () {
    test('rejects null/empty URLs', () {
      expect(UrlValidator.validate(''), isNotNull);
      expect(UrlValidator.validate('not a url %%%'), isNotNull);
    });

    test('rejects non-https scheme', () {
      expect(
          UrlValidator.validate('http://example.com'), 'URL must use https://');
      expect(
          UrlValidator.validate('ftp://example.com'), 'URL must use https://');
    });

    test('rejects URLs without host', () {
      expect(UrlValidator.validate('https://'), isNotNull);
    });

    test('accepts valid https URLs', () {
      expect(UrlValidator.validate('https://candela.example.com'), isNull);
      expect(UrlValidator.validate('https://api.candelahq.com/v1'), isNull);
    });

    test('rejects loopback IPv4', () {
      final result = UrlValidator.validate('https://127.0.0.1');
      expect(result, contains('Loopback'));
    });

    test('rejects private 10.x.x.x', () {
      final result = UrlValidator.validate('https://10.0.0.1');
      expect(result, contains('Private'));
    });

    test('rejects private 172.16-31.x.x', () {
      expect(UrlValidator.validate('https://172.16.0.1'), contains('Private'));
      expect(
          UrlValidator.validate('https://172.31.255.1'), contains('Private'));
      // 172.32 is NOT private
      expect(UrlValidator.validate('https://172.32.0.1'), isNull);
    });

    test('rejects private 192.168.x.x', () {
      final result = UrlValidator.validate('https://192.168.1.1');
      expect(result, contains('Private'));
    });

    test('rejects link-local 169.254.x.x', () {
      final result = UrlValidator.validate('https://169.254.1.1');
      expect(result, contains('Link-local'));
    });

    test('rejects IPv6 loopback ::1', () {
      final result = UrlValidator.validate('https://[::1]');
      expect(result, contains('Loopback'));
    });

    test('allows valid public IPs', () {
      expect(UrlValidator.validate('https://8.8.8.8'), isNull);
      expect(UrlValidator.validate('https://1.1.1.1'), isNull);
    });

    test('allows hostnames (DNS check is separate)', () {
      expect(UrlValidator.validate('https://candela.example.com'), isNull);
      expect(UrlValidator.validate('https://internal.corp.net'), isNull);
    });
  });

  group('UrlValidator.validateWithDnsCheck', () {
    test('rejects unresolvable hostname', () async {
      final result = await UrlValidator.validateWithDnsCheck(
          'https://this-definitely-does-not-exist-xyz123.invalid');
      expect(result, contains('Could not resolve'));
    });

    test('passes basic sync validation first', () async {
      final result =
          await UrlValidator.validateWithDnsCheck('http://example.com');
      expect(result, 'URL must use https://');
    });

    test('resolves and validates real hostname', () async {
      // google.com should resolve to a public IP
      final result =
          await UrlValidator.validateWithDnsCheck('https://google.com');
      expect(result, isNull);
    });
  });
}
