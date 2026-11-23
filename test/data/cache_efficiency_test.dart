import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/data/cache_efficiency.dart';

void main() {
  group('CacheTelemetry', () {
    test('no counts at all reports no activity, no rate and no cost', () {
      const cache = CacheTelemetry();
      expect(cache.hasActivity, isFalse);
      expect(cache.hasRate, isFalse);
      expect(cache.effectiveHitRate, isNull);
      expect(cache.tier, isNull);
      expect(cache.tierLabel, isNull);
      expect(cache.percentLabel, '—');
      expect(cache.costLabel, '—');
    });

    test('cache reads without a prompt count leave the rate undefined', () {
      const cache = CacheTelemetry(readTokens: 500, creationTokens: 100);
      expect(cache.hasActivity, isTrue);
      expect(cache.hasRate, isFalse);
      expect(cache.effectiveHitRate, isNull);
      expect(cache.percentLabel, '—');
    });

    test('the rate divides reads by the prompt tokens', () {
      const cache = CacheTelemetry(readTokens: 400, promptTokens: 1000);
      expect(cache.hasActivity, isTrue);
      expect(cache.hasRate, isTrue);
      expect(cache.effectiveHitRate, closeTo(0.4, 1e-9));
      expect(cache.tier, CacheEfficiencyTier.good);
      expect(cache.tierLabel, 'Good');
      expect(cache.percentLabel, '40.0%');
    });

    test('a cached prompt reports the share of the whole prompt', () {
      const cache = CacheTelemetry(readTokens: 12000, promptTokens: 20000);
      expect(cache.effectiveHitRate, closeTo(0.6, 1e-9));
      expect(cache.tier, CacheEfficiencyTier.excellent);
      expect(cache.percentLabel, '60.0%');
    });

    test('creations without reads report no rate', () {
      const cache = CacheTelemetry(creationTokens: 1200, promptTokens: 1000);
      expect(cache.hasActivity, isTrue);
      expect(cache.hasRate, isFalse);
      expect(cache.effectiveHitRate, isNull);
      expect(cache.tier, isNull);
      expect(cache.percentLabel, '—');
    });

    test('a rate above one clamps to one', () {
      const cache = CacheTelemetry(readTokens: 2000, promptTokens: 1000);
      expect(cache.effectiveHitRate, 1.0);
      expect(cache.tier, CacheEfficiencyTier.excellent);
      expect(cache.percentLabel, '100.0%');
    });

    test('negative counts never produce a rate', () {
      const cache = CacheTelemetry(readTokens: -5, promptTokens: 1000);
      expect(cache.hasActivity, isFalse);
      expect(cache.effectiveHitRate, isNull);
    });

    test('tier thresholds match the web dashboard', () {
      expect(
        const CacheTelemetry(readTokens: 500, promptTokens: 1000).tier,
        CacheEfficiencyTier.excellent,
      );
      expect(
        const CacheTelemetry(readTokens: 499, promptTokens: 1000).tier,
        CacheEfficiencyTier.good,
      );
      expect(
        const CacheTelemetry(readTokens: 200, promptTokens: 1000).tier,
        CacheEfficiencyTier.good,
      );
      expect(
        const CacheTelemetry(readTokens: 199, promptTokens: 1000).tier,
        CacheEfficiencyTier.low,
      );
    });

    test('costLabel renders dollars at two decimals', () {
      expect(const CacheTelemetry(costUsd: 0).costLabel, '\$0.00');
      expect(const CacheTelemetry(costUsd: 1.234).costLabel, '\$1.23');
      expect(const CacheTelemetry(costUsd: 12).costLabel, '\$12.00');
    });

    test('costLabel reports a floor for a charge below one cent', () {
      expect(const CacheTelemetry(costUsd: 0.004).costLabel, '<\$0.01');
      expect(const CacheTelemetry(costUsd: 0.005).costLabel, '\$0.01');
    });

    test('withTtl keeps the counts and attaches the proxy TTL', () {
      const cache = CacheTelemetry(
        readTokens: 400,
        creationTokens: 100,
        promptTokens: 1000,
        costUsd: 0.25,
      );
      final withTtl = cache.withTtl('1h');
      expect(withTtl.ttl, '1h');
      expect(withTtl.readTokens, 400);
      expect(withTtl.creationTokens, 100);
      expect(withTtl.promptTokens, 1000);
      expect(withTtl.costUsd, 0.25);
      expect(withTtl.effectiveHitRate, cache.effectiveHitRate);
      expect(cache.ttl, isNull);
    });
  });
}
