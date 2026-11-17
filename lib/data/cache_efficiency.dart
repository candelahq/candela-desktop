/// Cache telemetry shared by every usage surface.
///
/// Extracted from `model_pricing.dart` so that the Usage tab can import
/// cache-efficiency helpers without pulling in the deprecated pricing map.
library;

/// Tier key for badge styling. Thresholds match the web dashboard's
/// `getCacheEfficiency` in `ui/src/lib/cacheUtils.ts`.
enum CacheEfficiencyTier { excellent, good, low }

/// Cache telemetry for one call, one model, or one summary window.
///
/// [effectiveHitRate] divides cache reads by the true prompt size. The proxy's
/// `input_tokens` is cost-normalized (base tokens plus cache reads at 0.1x plus
/// cache writes at 1.25x) and leaves cached prompt tokens out, so it never
/// serves as the denominator here.
class CacheTelemetry {
  /// Tokens served from the provider's prompt cache.
  final int readTokens;

  /// Tokens written into the cache, billed at a premium.
  final int creationTokens;

  /// True prompt size: fresh tokens plus cache reads and cache writes where the
  /// provider reports them apart, the inclusive prompt count where it does not.
  /// 0 when the source did not report it, which leaves the rate unknown.
  final int promptTokens;

  /// Dollars charged for cache reads and cache writes, null when the source did
  /// not report it.
  final double? costUsd;

  /// Proxy cache TTL ('5m' or '1h'), null when the surface has no config in
  /// reach or caching is off. Always a proxy setting: spans do not record a
  /// per-request TTL.
  final String? ttl;

  const CacheTelemetry({
    this.readTokens = 0,
    this.creationTokens = 0,
    this.promptTokens = 0,
    this.costUsd,
    this.ttl,
  });

  /// Rate at or above this counts as excellent. Matches the web dashboard.
  static const excellentThreshold = 0.5;

  /// Rate at or above this counts as good. Matches the web dashboard.
  static const goodThreshold = 0.2;

  /// True when any cache tokens were recorded, in either direction.
  bool get hasActivity => readTokens > 0 || creationTokens > 0;

  /// True when the prompt size is known and at least one cached read happened.
  bool get hasRate => promptTokens > 0 && readTokens > 0;

  /// Cache hit rate in 0.0 to 1.0, null when [hasRate] is false.
  double? get effectiveHitRate {
    if (!hasRate) return null;
    return (readTokens / promptTokens).clamp(0.0, 1.0);
  }

  /// Tier for [effectiveHitRate], null when there is no rate to tier.
  CacheEfficiencyTier? get tier {
    final rate = effectiveHitRate;
    if (rate == null) return null;
    if (rate >= excellentThreshold) return CacheEfficiencyTier.excellent;
    if (rate >= goodThreshold) return CacheEfficiencyTier.good;
    return CacheEfficiencyTier.low;
  }

  /// Human label for [tier]: "Excellent", "Good", "Low", or null.
  String? get tierLabel => switch (tier) {
    null => null,
    CacheEfficiencyTier.excellent => 'Excellent',
    CacheEfficiencyTier.good => 'Good',
    CacheEfficiencyTier.low => 'Low',
  };

  /// Rate formatted for display, one decimal, or an em dash when unknown.
  String get percentLabel {
    final rate = effectiveHitRate;
    return rate == null ? '—' : '${(rate * 100).toStringAsFixed(1)}%';
  }

  /// Cache dollars at two decimals, or an em dash when the source has none. A
  /// charge too small to round reports its floor rather than reading as zero.
  String get costLabel {
    final cost = costUsd;
    if (cost == null) return '—';
    if (cost > 0 && cost < 0.005) return '<\$0.01';
    return '\$${cost.toStringAsFixed(2)}';
  }

  /// Same counts with a different [ttl], for attaching the proxy setting.
  CacheTelemetry withTtl(String? ttl) => CacheTelemetry(
    readTokens: readTokens,
    creationTokens: creationTokens,
    promptTokens: promptTokens,
    costUsd: costUsd,
    ttl: ttl,
  );
}
