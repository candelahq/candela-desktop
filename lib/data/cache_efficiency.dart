/// Cache efficiency utilities for usage analytics badges.
///
/// Extracted from `model_pricing.dart` so that the Usage tab can import
/// cache-efficiency helpers without pulling in the deprecated pricing map.
library;

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
