/// Static per-model pricing registry.
///
/// SOURCE OF TRUTH: pkg/costcalc/calculator.go → loadDefaults()
/// Keep this file in sync whenever model pricing is added or changed.
///
/// Prices are list prices in USD per 1 million tokens.
library;

/// Pricing for a single model (input + output per million tokens).
class ModelPricing {
  final double inputPerMillion;
  final double outputPerMillion;
  const ModelPricing(
      {required this.inputPerMillion, required this.outputPerMillion});
}

/// Cache efficiency tier label for UI badges.
class CacheEfficiencyResult {
  /// Hit rate 0.0–1.0
  final double rate;

  /// Human label: "Excellent", "Good", "Low"
  final String label;

  /// Tier key for styling
  final CacheEfficiencyTier tier;

  const CacheEfficiencyResult({
    required this.rate,
    required this.label,
    required this.tier,
  });
}

enum CacheEfficiencyTier { excellent, good, low }

// ── Registry ──────────────────────────────────────────────────────
// Keys are lowercase model names (provider-agnostic).

const Map<String, ModelPricing> _pricingMap = {
  // Google Gemini
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

  // OpenAI
  'gpt-5.4-pro': ModelPricing(inputPerMillion: 30.00, outputPerMillion: 180.00),
  'gpt-5.4': ModelPricing(inputPerMillion: 2.50, outputPerMillion: 15.00),
  'gpt-5.4-mini': ModelPricing(inputPerMillion: 0.75, outputPerMillion: 4.50),
  'gpt-5.4-nano': ModelPricing(inputPerMillion: 0.20, outputPerMillion: 1.25),
  'gpt-4o': ModelPricing(inputPerMillion: 2.50, outputPerMillion: 10.00),
  'gpt-4o-mini': ModelPricing(inputPerMillion: 0.15, outputPerMillion: 0.60),
  'gpt-4-turbo': ModelPricing(inputPerMillion: 10.00, outputPerMillion: 30.00),
  'gpt-3.5-turbo': ModelPricing(inputPerMillion: 0.50, outputPerMillion: 1.50),
  'o3': ModelPricing(inputPerMillion: 10.00, outputPerMillion: 40.00),
  'o3-mini': ModelPricing(inputPerMillion: 1.10, outputPerMillion: 4.40),
  'o1': ModelPricing(inputPerMillion: 15.00, outputPerMillion: 60.00),
  'o1-mini': ModelPricing(inputPerMillion: 3.00, outputPerMillion: 12.00),

  // Anthropic
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
  'claude-3-5-sonnet-20241022':
      ModelPricing(inputPerMillion: 3.00, outputPerMillion: 15.00),
  'claude-haiku-3-5-20241022':
      ModelPricing(inputPerMillion: 0.80, outputPerMillion: 4.00),
  'claude-3-opus-20240229':
      ModelPricing(inputPerMillion: 15.00, outputPerMillion: 75.00),
};

/// Look up static list pricing for a model.
/// Returns null for models without a known price (e.g. local/custom).
ModelPricing? lookupPricing(String model) {
  return _pricingMap[model.toLowerCase()];
}

/// Compute cache efficiency from per-model token counts.
/// Returns null when there are no cache read tokens.
CacheEfficiencyResult? cacheEfficiencyLabel(
    int cacheReadTokens, int inputTokens) {
  if (inputTokens <= 0 || cacheReadTokens <= 0) return null;

  final rate = (cacheReadTokens / inputTokens).clamp(0.0, 1.0);

  if (rate >= 0.5) {
    return CacheEfficiencyResult(
        rate: rate, label: 'Excellent', tier: CacheEfficiencyTier.excellent);
  }
  if (rate >= 0.2) {
    return CacheEfficiencyResult(
        rate: rate, label: 'Good', tier: CacheEfficiencyTier.good);
  }
  return CacheEfficiencyResult(
      rate: rate, label: 'Low', tier: CacheEfficiencyTier.low);
}
