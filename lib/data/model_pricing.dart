/// Static per-model pricing registry.
///
/// **DEPRECATED** — This entire library is deprecated. Pricing should come
/// from the catalog RPC ([ModelCatalogService] / `catalogProvider`), which
/// returns [ModelCatalogEntry.inputPerMillion] / [outputPerMillion] directly.
///
/// Migration:
///   1. Replace `lookupPricing(modelId)` with a lookup into the catalog
///      state: `ref.read(catalogProvider).models` keyed by model ID.
///   2. Import cache-efficiency helpers from `cache_efficiency.dart` instead
///      of this file.
///   3. Once all call-sites are migrated, this file can be deleted.
///
/// SOURCE OF TRUTH: pkg/costcalc/pricing.yaml (in candelahq/candela)
/// Keep this file in sync whenever model pricing is added or changed.
///
/// Prices are list prices in USD per 1 million tokens.
@Deprecated('Use catalog RPC pricing (catalogProvider / ModelCatalogEntry) '
    'instead. See migration notes in the library doc comment.')
library;

// Re-export cache-efficiency types so existing imports keep working.
export 'cache_efficiency.dart';

/// Pricing for a single model (input + output per million tokens).
class ModelPricing {
  final double inputPerMillion;
  final double outputPerMillion;
  const ModelPricing(
      {required this.inputPerMillion, required this.outputPerMillion});
}

// ── Registry ──────────────────────────────────────────────────────
// Keys are lowercase model names (provider-agnostic).
// Last synced with pricing.yaml: 2026-06-15

const Map<String, ModelPricing> _pricingMap = {
  // ── Google Gemini ───────────────────────────────────────────────
  'gemini-3.5-flash':
      ModelPricing(inputPerMillion: 1.50, outputPerMillion: 9.00),
  'gemini-3.1-pro':
      ModelPricing(inputPerMillion: 2.00, outputPerMillion: 12.00),
  'gemini-3.1-flash':
      ModelPricing(inputPerMillion: 0.50, outputPerMillion: 3.00),
  'gemini-3.1-flash-lite':
      ModelPricing(inputPerMillion: 0.25, outputPerMillion: 1.50),
  'gemini-3.0-pro':
      ModelPricing(inputPerMillion: 2.00, outputPerMillion: 12.00),
  'gemini-3.0-flash':
      ModelPricing(inputPerMillion: 0.50, outputPerMillion: 3.00),
  'gemini-3-flash': ModelPricing(inputPerMillion: 0.50, outputPerMillion: 3.00),
  'gemini-3-flash-lite':
      ModelPricing(inputPerMillion: 0.02, outputPerMillion: 0.10),
  'gemini-2.5-pro':
      ModelPricing(inputPerMillion: 1.25, outputPerMillion: 10.00),
  'gemini-2.5-flash':
      ModelPricing(inputPerMillion: 0.30, outputPerMillion: 2.50),
  'gemini-2.5-flash-lite':
      ModelPricing(inputPerMillion: 0.10, outputPerMillion: 0.40),
  'gemini-2.0-flash':
      ModelPricing(inputPerMillion: 0.10, outputPerMillion: 0.40),
  'gemini-2.0-pro':
      ModelPricing(inputPerMillion: 1.25, outputPerMillion: 10.00),
  'gemini-1.5-flash':
      ModelPricing(inputPerMillion: 0.075, outputPerMillion: 0.30),
  'gemini-1.5-pro': ModelPricing(inputPerMillion: 1.25, outputPerMillion: 5.00),

  // ── OpenAI ──────────────────────────────────────────────────────
  // GPT-4.1 family (current flagship)
  'gpt-4.1': ModelPricing(inputPerMillion: 2.00, outputPerMillion: 8.00),
  'gpt-4.1-mini': ModelPricing(inputPerMillion: 0.40, outputPerMillion: 1.60),
  'gpt-4.1-nano': ModelPricing(inputPerMillion: 0.10, outputPerMillion: 0.40),
  // GPT-5.4 family
  'gpt-5.4-pro': ModelPricing(inputPerMillion: 30.00, outputPerMillion: 180.00),
  'gpt-5.4': ModelPricing(inputPerMillion: 2.50, outputPerMillion: 15.00),
  'gpt-5.4-mini': ModelPricing(inputPerMillion: 0.75, outputPerMillion: 4.50),
  'gpt-5.4-nano': ModelPricing(inputPerMillion: 0.20, outputPerMillion: 1.25),
  // o-series reasoning models
  'o3': ModelPricing(inputPerMillion: 2.00, outputPerMillion: 8.00),
  'o4-mini': ModelPricing(inputPerMillion: 1.10, outputPerMillion: 4.40),
  // Legacy
  'gpt-4o': ModelPricing(inputPerMillion: 2.50, outputPerMillion: 10.00),
  'gpt-4o-mini': ModelPricing(inputPerMillion: 0.15, outputPerMillion: 0.60),
  'gpt-4-turbo': ModelPricing(inputPerMillion: 10.00, outputPerMillion: 30.00),
  'gpt-3.5-turbo': ModelPricing(inputPerMillion: 0.50, outputPerMillion: 1.50),
  'o3-mini': ModelPricing(inputPerMillion: 1.10, outputPerMillion: 4.40),
  'o1': ModelPricing(inputPerMillion: 15.00, outputPerMillion: 60.00),
  'o1-mini': ModelPricing(inputPerMillion: 3.00, outputPerMillion: 12.00),

  // ── Anthropic ───────────────────────────────────────────────────
  // All Opus 4.x are $5/$25. Claude 3 Opus was $15/$75.
  'claude-opus-4.8':
      ModelPricing(inputPerMillion: 5.00, outputPerMillion: 25.00),
  'claude-opus-4.7':
      ModelPricing(inputPerMillion: 5.00, outputPerMillion: 25.00),
  'claude-opus-4.6':
      ModelPricing(inputPerMillion: 5.00, outputPerMillion: 25.00),
  'claude-sonnet-4.6':
      ModelPricing(inputPerMillion: 3.00, outputPerMillion: 15.00),
  'claude-haiku-4.5':
      ModelPricing(inputPerMillion: 1.00, outputPerMillion: 5.00),
  'claude-sonnet-4':
      ModelPricing(inputPerMillion: 3.00, outputPerMillion: 15.00),
  'claude-opus-4': ModelPricing(inputPerMillion: 5.00, outputPerMillion: 25.00),
  'claude-sonnet-4-20250514':
      ModelPricing(inputPerMillion: 3.00, outputPerMillion: 15.00),
  'claude-opus-4-20250514':
      ModelPricing(inputPerMillion: 5.00, outputPerMillion: 25.00),
  // Legacy
  'claude-3-5-sonnet-20241022':
      ModelPricing(inputPerMillion: 3.00, outputPerMillion: 15.00),
  'claude-haiku-3-5-20241022':
      ModelPricing(inputPerMillion: 0.80, outputPerMillion: 4.00),
  'claude-3-opus-20240229':
      ModelPricing(inputPerMillion: 15.00, outputPerMillion: 75.00),

  // ── Mistral (via Vertex AI) ─────────────────────────────────────
  'mistral-small-2503':
      ModelPricing(inputPerMillion: 0.10, outputPerMillion: 0.30),
  'mistral-medium-3':
      ModelPricing(inputPerMillion: 0.40, outputPerMillion: 2.00),
  'codestral-2501': ModelPricing(inputPerMillion: 0.30, outputPerMillion: 0.90),
  'codestral-2': ModelPricing(inputPerMillion: 0.30, outputPerMillion: 0.90),

  // ── DeepSeek (via Vertex AI) ────────────────────────────────────
  'deepseek-r1-0528-maas':
      ModelPricing(inputPerMillion: 0.14, outputPerMillion: 0.28),
  'deepseek-r1': ModelPricing(inputPerMillion: 0.14, outputPerMillion: 0.28),
  'deepseek-v3.2-maas':
      ModelPricing(inputPerMillion: 0.14, outputPerMillion: 0.28),
  'deepseek-v3-maas':
      ModelPricing(inputPerMillion: 0.14, outputPerMillion: 0.28),
  'deepseek-chat': ModelPricing(inputPerMillion: 0.14, outputPerMillion: 0.28),

  // ── Qwen (via Vertex AI) ───────────────────────────────────────
  'qwen3-235b-a22b-instruct-2507-maas':
      ModelPricing(inputPerMillion: 0.30, outputPerMillion: 1.20),
  'qwen3-coder-480b-a35b-instruct-maas':
      ModelPricing(inputPerMillion: 0.22, outputPerMillion: 1.80),
  'qwen-2.5-coder-32b-instruct-maas':
      ModelPricing(inputPerMillion: 0.30, outputPerMillion: 1.20),
};

/// Look up static list pricing for a model.
/// Returns null for models without a known price (e.g. local/custom).
@Deprecated('Pricing should come from the catalog RPC (ModelCatalogService). '
    'This hardcoded map will be removed once the Usage tab also sources '
    'pricing from the catalog.')
ModelPricing? lookupPricing(String model) {
  return _pricingMap[model.toLowerCase()];
}
