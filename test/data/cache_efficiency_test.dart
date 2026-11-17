import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/data/cache_efficiency.dart';

void main() {
  group('CacheTelemetry', () {
    test('no counts at all reports no activity and no rate', () {
      const cache = CacheTelemetry();
      expect(cache.hasActivity, isFalse);
      expect(cache.hasRate, isFalse);
      expect(cache.effectiveHitRate, isNull);
      expect(cache.tier, isNull);
      expect(cache.tierLabel, isNull);
      expect(cache.percentLabel, '—');
    });

    test('zero input tokens leaves the rate undefined', () {
      const cache = CacheTelemetry(readTokens: 500, creationTokens: 100);
      expect(cache.hasActivity, isTrue);
      expect(cache.hasRate, isFalse);
      expect(cache.effectiveHitRate, isNull);
      expect(cache.percentLabel, '—');
    });

    test('reads without creations report the hit rate', () {
      const cache = CacheTelemetry(readTokens: 400, inputTokens: 1000);
      expect(cache.hasActivity, isTrue);
      expect(cache.hasRate, isTrue);
      expect(cache.effectiveHitRate, closeTo(0.4, 1e-9));
      expect(cache.tier, CacheEfficiencyTier.good);
      expect(cache.tierLabel, 'Good');
      expect(cache.percentLabel, '40.0%');
    });

    test('creations without reads report no rate', () {
      const cache = CacheTelemetry(creationTokens: 1200, inputTokens: 1000);
      expect(cache.hasActivity, isTrue);
      expect(cache.hasRate, isFalse);
      expect(cache.effectiveHitRate, isNull);
      expect(cache.tier, isNull);
      expect(cache.percentLabel, '—');
    });

    test('a rate above one clamps to one', () {
      const cache = CacheTelemetry(readTokens: 2000, inputTokens: 1000);
      expect(cache.effectiveHitRate, 1.0);
      expect(cache.tier, CacheEfficiencyTier.excellent);
      expect(cache.percentLabel, '100.0%');
    });

    test('negative counts never produce a rate', () {
      const cache = CacheTelemetry(readTokens: -5, inputTokens: 1000);
      expect(cache.hasActivity, isFalse);
      expect(cache.effectiveHitRate, isNull);
    });

    test('tier thresholds match the web dashboard', () {
      expect(
        const CacheTelemetry(readTokens: 500, inputTokens: 1000).tier,
        CacheEfficiencyTier.excellent,
      );
      expect(
        const CacheTelemetry(readTokens: 499, inputTokens: 1000).tier,
        CacheEfficiencyTier.good,
      );
      expect(
        const CacheTelemetry(readTokens: 200, inputTokens: 1000).tier,
        CacheEfficiencyTier.good,
      );
      expect(
        const CacheTelemetry(readTokens: 199, inputTokens: 1000).tier,
        CacheEfficiencyTier.low,
      );
    });

    test('withTtl keeps the counts and attaches the proxy TTL', () {
      const cache = CacheTelemetry(
        readTokens: 400,
        creationTokens: 100,
        inputTokens: 1000,
      );
      final withTtl = cache.withTtl('1h');
      expect(withTtl.ttl, '1h');
      expect(withTtl.readTokens, 400);
      expect(withTtl.creationTokens, 100);
      expect(withTtl.inputTokens, 1000);
      expect(withTtl.effectiveHitRate, cache.effectiveHitRate);
      expect(cache.ttl, isNull);
    });
  });
}
