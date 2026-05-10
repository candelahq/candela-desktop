import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/services/provider_test_service.dart';

void main() {
  group('ProviderTestService.sanitizeError', () {
    test('redacts Bearer tokens', () {
      const input = 'Authorization: Bearer ya29.abc123XYZ-test_token+foo/bar==';
      final result = ProviderTestService.sanitizeError(input);
      expect(result, contains('Bearer [REDACTED]'));
      expect(result, isNot(contains('ya29')));
    });

    test('redacts multiple Bearer tokens', () {
      const input = 'Token: Bearer abc123 and also Bearer xyz456';
      final result = ProviderTestService.sanitizeError(input);
      expect(result, isNot(contains('abc123')));
      expect(result, isNot(contains('xyz456')));
    });

    test('redacts API key headers with replaceAllMapped', () {
      const input = 'authorization: sk-abcdefghijklmnopqrstuvwxyz';
      final result = ProviderTestService.sanitizeError(input);
      expect(result, contains('authorization: [REDACTED]'));
      expect(result, isNot(contains('sk-abc')));
    });

    test('redacts api-key header', () {
      const input = 'api-key: abcdefghijklmnopqrstuvwxyz1234';
      final result = ProviderTestService.sanitizeError(input);
      expect(result, contains('api-key: [REDACTED]'));
    });

    test('redacts api_key header', () {
      const input = 'api_key: abcdefghijklmnopqrstuvwxyz1234';
      final result = ProviderTestService.sanitizeError(input);
      expect(result, contains('api_key: [REDACTED]'));
    });

    test('preserves non-sensitive content', () {
      const input = 'Connection refused to localhost:8181';
      final result = ProviderTestService.sanitizeError(input);
      expect(result, input);
    });

    test('handles empty string', () {
      expect(ProviderTestService.sanitizeError(''), '');
    });
  });

  group('ProviderTestService.modelCategory', () {
    test('categorizes gemini models', () {
      expect(ProviderTestService.modelCategory('gemini-2.0-flash'), 'google');
    });

    test('categorizes claude models', () {
      expect(ProviderTestService.modelCategory('claude-sonnet-4-20250514'),
          'anthropic');
    });

    test('categorizes gpt models', () {
      expect(ProviderTestService.modelCategory('gpt-4o-2024-08-06'), 'openai');
    });

    test('returns other for unknown models', () {
      expect(ProviderTestService.modelCategory('custom-model'), 'other');
    });

    test('categorizes local models', () {
      expect(ProviderTestService.modelCategory('llama-3.2'), 'local');
      expect(ProviderTestService.modelCategory('mistral-7b'), 'local');
      expect(ProviderTestService.modelCategory('phi-3'), 'local');
    });
  });

  group('ProviderTestService lifecycle', () {
    test('dispose marks service as disposed', () {
      final service = ProviderTestService();
      // Should not throw.
      service.dispose();
    });

    test('double dispose does not throw', () {
      final service = ProviderTestService();
      service.dispose();
      // Second dispose should be safe.
      service.dispose();
    });
  });
}
