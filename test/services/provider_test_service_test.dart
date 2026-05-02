import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/services/provider_test_service.dart';

void main() {
  group('ProviderTestService', () {
    test('modelCategory classifies gemini correctly', () {
      expect(ProviderTestService.modelCategory('gemini-2.0-flash'), 'google');
      expect(ProviderTestService.modelCategory('gemini-1.5-pro'), 'google');
    });

    test('modelCategory classifies claude correctly', () {
      expect(ProviderTestService.modelCategory('claude-sonnet-4'), 'anthropic');
      expect(ProviderTestService.modelCategory('claude-3-haiku'), 'anthropic');
    });

    test('modelCategory classifies local models correctly', () {
      expect(ProviderTestService.modelCategory('llama3'), 'local');
      expect(ProviderTestService.modelCategory('mistral-7b'), 'local');
      expect(ProviderTestService.modelCategory('phi-3'), 'local');
    });

    test('modelCategory classifies openai correctly', () {
      expect(ProviderTestService.modelCategory('gpt-4o'), 'openai');
      expect(ProviderTestService.modelCategory('o1-preview'), 'openai');
      expect(ProviderTestService.modelCategory('o3-mini'), 'openai');
    });

    test('modelCategory classifies unknown model as other', () {
      expect(ProviderTestService.modelCategory('custom-model-v2'), 'other');
      expect(ProviderTestService.modelCategory('my-fine-tune'), 'other');
    });

    // _cleanModelName is private but static — test via proxy if exposed.
    // Since it's private, we test its effects indirectly or make it @visibleForTesting.
  });
}
