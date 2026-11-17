import 'package:flutter/material.dart';

import '../data/cache_efficiency.dart';
import '../theme/colors.dart';
import '../utils/format.dart';

/// Compact strip showing cache read, cache write, hit rate, cache dollars, and
/// the proxy TTL.
///
/// Renders nothing when no cache tokens were recorded, so surfaces without
/// caching stay uncluttered. [CacheTelemetry.ttl] carries the proxy's cache
/// TTL and is only set when caching is enabled: spans do not record a
/// per-request TTL, so the value is always the current proxy setting.
class CacheSummaryStrip extends StatelessWidget {
  final CacheTelemetry cache;

  const CacheSummaryStrip({super.key, required this.cache});

  static const _denominatorNote =
      'Cache read tokens divided by the true prompt tokens: fresh tokens plus '
      'cache reads and cache writes, or the inclusive prompt count where the '
      'provider reports one number. A dash means the spans behind this figure '
      'did not all report their prompt size.';

  static const _costNote =
      'Dollars charged for cache reads and cache writes. A dash means a span '
      'that used the cache did not report its cost.';

  static const _ttlNote =
      'Current proxy cache setting. Spans do not record a per-request TTL.';

  @override
  Widget build(BuildContext context) {
    if (!cache.hasActivity) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: CandelaColors.bgTertiary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: CandelaColors.border),
      ),
      child: Wrap(
        spacing: 18,
        runSpacing: 6,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.cached, size: 12, color: CandelaColors.textMuted),
              SizedBox(width: 6),
              Text(
                'CACHE',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: CandelaColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          _metric('Read', formatTokenCount(cache.readTokens)),
          _metric('Write', formatTokenCount(cache.creationTokens)),
          Tooltip(
            message: _denominatorNote,
            child: _metric(
              'Hit rate',
              cache.hasRate ? '${cache.percentLabel} ${cache.tierLabel}' : '—',
              color: cache.hasRate ? cacheTierColor(cache.tier) : null,
            ),
          ),
          Tooltip(
            message: _costNote,
            child: _metric('Cache cost', cache.costLabel),
          ),
          if (cache.ttl != null)
            Tooltip(
              message: _ttlNote,
              child: _metric('Proxy cache TTL', cache.ttl!),
            ),
        ],
      ),
    );
  }

  Widget _metric(String label, String value, {Color? color}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: CandelaColors.textMuted),
        ),
        const SizedBox(width: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            fontFamily: 'monospace',
            color: color ?? CandelaColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
