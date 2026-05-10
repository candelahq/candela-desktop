import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/services/provider_test_service.dart';
import 'package:candela_desktop/models/provider_status.dart';

void main() {
  group('ProviderTestService', () {
    group('modelCategory', () {
      test('classifies gemini models correctly', () {
        expect(ProviderTestService.modelCategory('gemini-2.0-flash'), 'google');
        expect(ProviderTestService.modelCategory('gemini-1.5-pro'), 'google');
        expect(ProviderTestService.modelCategory('gemini-1.5-flash-001'),
            'google');
      });

      test('classifies claude models correctly', () {
        expect(
            ProviderTestService.modelCategory('claude-sonnet-4'), 'anthropic');
        expect(
            ProviderTestService.modelCategory('claude-3-haiku'), 'anthropic');
        expect(ProviderTestService.modelCategory('claude-3.5-sonnet-20240620'),
            'anthropic');
      });

      test('classifies local models correctly', () {
        expect(ProviderTestService.modelCategory('llama3'), 'local');
        expect(ProviderTestService.modelCategory('llama3.1:70b'), 'local');
        expect(ProviderTestService.modelCategory('mistral-7b'), 'local');
        expect(ProviderTestService.modelCategory('phi-3'), 'local');
        expect(ProviderTestService.modelCategory('phi-3.5-mini'), 'local');
      });

      test('classifies openai gpt models correctly', () {
        expect(ProviderTestService.modelCategory('gpt-4o'), 'openai');
        expect(ProviderTestService.modelCategory('gpt-4-turbo'), 'openai');
        expect(ProviderTestService.modelCategory('gpt-3.5-turbo'), 'openai');
      });

      test('classifies openai o-series models correctly', () {
        expect(ProviderTestService.modelCategory('o1-preview'), 'openai');
        expect(ProviderTestService.modelCategory('o1-mini'), 'openai');
        expect(ProviderTestService.modelCategory('o3-mini'), 'openai');
        expect(ProviderTestService.modelCategory('o3'), 'openai');
        expect(ProviderTestService.modelCategory('o1'), 'openai');
      });

      test('does NOT misclassify models with o1/o3 substrings', () {
        // These should NOT be classified as openai.
        expect(ProviderTestService.modelCategory('proto1-alpha'), 'other');
        expect(ProviderTestService.modelCategory('mongo3-db'), 'other');
        expect(ProviderTestService.modelCategory('no1-model'), 'other');
        expect(ProviderTestService.modelCategory('foo3bar'), 'other');
      });

      test('classifies unknown models as other', () {
        expect(ProviderTestService.modelCategory('custom-model-v2'), 'other');
        expect(ProviderTestService.modelCategory('my-fine-tune'), 'other');
        expect(ProviderTestService.modelCategory('deepseek-coder'), 'other');
        expect(ProviderTestService.modelCategory('qwen-72b'), 'other');
      });
    });

    group('cleanModelName (via verifyProxyCategories behavior)', () {
      // _cleanModelName is private — test indirectly via modelCategory on cleaned names.
      // The tests below verify the patterns that cleanModelName strips.
      test('date suffix regex matches 8-digit dates', () {
        // Verify the pattern by checking our understanding.
        final dateSuffix = RegExp(r'-\d{8}$');
        expect(dateSuffix.hasMatch('claude-sonnet-4-20250514'), isTrue);
        expect(dateSuffix.hasMatch('gemini-2.0-flash-001'), isFalse);
        expect(dateSuffix.hasMatch('model-123'), isFalse);
      });

      test('version suffix regex matches 1-3 digit versions', () {
        final versionSuffix = RegExp(r'-0{1,2}\d$');
        expect(versionSuffix.hasMatch('gemini-2.0-flash-001'), isTrue);
        expect(versionSuffix.hasMatch('gemini-2.0-flash-01'), isTrue);
        expect(
            versionSuffix.hasMatch('model-100'), isFalse); // not zero-prefixed
        expect(versionSuffix.hasMatch('model-200'), isFalse);
      });

      test('@latest regex only matches @latest not @v2', () {
        final latestSuffix = RegExp(r'@latest$');
        expect(latestSuffix.hasMatch('model@latest'), isTrue);
        expect(latestSuffix.hasMatch('model@v2'), isFalse);
        expect(latestSuffix.hasMatch('model@stable'), isFalse);
      });
    });

    // --- Audit v4: new unit tests ---

    group('sanitizeError', () {
      test('redacts Bearer tokens from error strings', () {
        const error =
            'Connection failed: header Authorization: Bearer ya29.c.b0AXv0zTM_long_token_here';
        final sanitized = ProviderTestService.sanitizeError(error);
        expect(sanitized, contains('Bearer [REDACTED]'));
        expect(sanitized, isNot(contains('ya29.c.b0AXv0zTM')));
      });

      test('preserves non-sensitive error details', () {
        const error = 'Connection timed out after 10 seconds';
        expect(ProviderTestService.sanitizeError(error), error);
      });

      test('redacts multiple Bearer tokens in same string', () {
        const error = 'Try 1: Bearer abc123, Try 2: Bearer def456_longer_token';
        final sanitized = ProviderTestService.sanitizeError(error);
        expect('Bearer [REDACTED]'.allMatches(sanitized).length, 2);
      });
    });

    group('_cleanModelName (tested via regex patterns)', () {
      test('strips 8-digit date suffix', () {
        final regex = RegExp(r'-\d{8}$');
        final cleaned = 'claude-sonnet-4-20250514'.replaceAll(regex, '');
        expect(cleaned, 'claude-sonnet-4');
      });

      test('strips version suffix like -001', () {
        final regex = RegExp(r'-0{1,2}\d$');
        final cleaned = 'gemini-2.0-flash-001'.replaceAll(regex, '');
        expect(cleaned, 'gemini-2.0-flash');
      });

      test('strips @latest but preserves @v2', () {
        final regex = RegExp(r'@latest$');
        expect('model@latest'.replaceAll(regex, ''), 'model');
        expect('model@v2'.replaceAll(regex, ''), 'model@v2');
      });
    });
    group('testGoogle — null-guard paths', () {
      test('returns error status when project is null', () async {
        final svc = ProviderTestService();
        final result = await svc.testGoogle();
        expect(result.name, 'google');
        expect(result.state, ProviderState.error);
        expect(result.statusMessage, contains('project'));
        svc.dispose();
      });

      test('returns error status when accessToken is null', () async {
        final svc = ProviderTestService();
        final result = await svc.testGoogle(project: 'my-proj');
        expect(result.name, 'google');
        expect(result.state, ProviderState.error);
        expect(result.project, 'my-proj');
        svc.dispose();
      });
    });

    group('testAnthropic — null-guard paths', () {
      test('returns error when project is null', () async {
        final svc = ProviderTestService();
        final result = await svc.testAnthropic(accessToken: 'tok');
        expect(result.name, 'anthropic');
        expect(result.state, ProviderState.error);
        expect(result.statusMessage, contains('project'));
        svc.dispose();
      });

      test('returns error when accessToken is null', () async {
        final svc = ProviderTestService();
        final result = await svc.testAnthropic(project: 'my-proj');
        expect(result.name, 'anthropic');
        expect(result.state, ProviderState.error);
        expect(result.project, 'my-proj');
        svc.dispose();
      });

      test('returns error when both project and token are null', () async {
        final svc = ProviderTestService();
        final result = await svc.testAnthropic();
        expect(result.name, 'anthropic');
        expect(result.state, ProviderState.error);
        svc.dispose();
      });
    });

    group('modelCategory — edge cases', () {
      test('o2 is not classified as openai (no o2 model exists)', () {
        // o1/o3 are valid, o2 is not — should fall through to other
        expect(ProviderTestService.modelCategory('o2'), 'other');
      });

      test('empty string is classified as other', () {
        expect(ProviderTestService.modelCategory(''), 'other');
      });
    });

    group('dispose', () {
      test('can be called without crash', () {
        final svc = ProviderTestService();
        expect(() => svc.dispose(), returnsNormally);
      });

      test('double dispose does not throw', () {
        final svc = ProviderTestService();
        svc.dispose();
        expect(() => svc.dispose(), returnsNormally);
      });
    });
  });
}
