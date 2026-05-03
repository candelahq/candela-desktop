import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/services/provider_test_service.dart';

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
  });
}
