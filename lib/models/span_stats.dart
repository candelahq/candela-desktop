/// Data models for the local token / cost observability dashboard.
///
/// These mirror the JSON shapes emitted by the candela
/// `/_local/api/traces` endpoint (see traces_handler.go).
library;

import '../data/cache_efficiency.dart';

// ── Raw span from the server ────────────────────────────────────────────────

class SpanRecord {
  final String spanId;
  final String traceId;
  final String model;
  final String provider;
  final int inputTokens;
  final int outputTokens;
  final int totalTokens;
  final double costUsd;
  final double durationMs;
  final String status; // "ok" | "error" | "unset"
  final DateTime timestamp;
  final String name;
  final int cacheReadTokens;
  final int cacheCreationTokens;

  /// True prompt size reported by the proxy, 0 when the span predates it.
  final int promptTokens;

  /// Dollars charged for this call's cache reads and writes, null when the span
  /// predates the field.
  final double? cacheCostUsd;

  const SpanRecord({
    required this.spanId,
    required this.traceId,
    required this.model,
    required this.provider,
    required this.inputTokens,
    required this.outputTokens,
    required this.totalTokens,
    required this.costUsd,
    required this.durationMs,
    required this.status,
    required this.timestamp,
    required this.name,
    this.cacheReadTokens = 0,
    this.cacheCreationTokens = 0,
    this.promptTokens = 0,
    this.cacheCostUsd,
  });

  factory SpanRecord.fromJson(Map<String, dynamic> j) => SpanRecord(
    spanId: j['span_id'] as String? ?? '',
    traceId: j['trace_id'] as String? ?? '',
    model: j['model'] as String? ?? 'unknown',
    provider: j['provider'] as String? ?? 'local',
    inputTokens: (j['input_tokens'] as num?)?.toInt() ?? 0,
    outputTokens: (j['output_tokens'] as num?)?.toInt() ?? 0,
    totalTokens: (j['total_tokens'] as num?)?.toInt() ?? 0,
    costUsd: (j['cost_usd'] as num?)?.toDouble() ?? 0.0,
    durationMs: (j['duration_ms'] as num?)?.toDouble() ?? 0.0,
    status: j['status'] as String? ?? 'unset',
    timestamp:
        DateTime.tryParse(j['timestamp'] as String? ?? '') ?? DateTime.now(),
    name: j['name'] as String? ?? '',
    cacheReadTokens: (j['cache_read_tokens'] as num?)?.toInt() ?? 0,
    cacheCreationTokens: (j['cache_creation_tokens'] as num?)?.toInt() ?? 0,
    promptTokens: (j['prompt_tokens'] as num?)?.toInt() ?? 0,
    cacheCostUsd: (j['cache_cost_usd'] as num?)?.toDouble(),
  );

  /// Cache telemetry for this call. Attach the proxy TTL with
  /// [CacheTelemetry.withTtl] where the config is in reach.
  CacheTelemetry get cache => CacheTelemetry(
    readTokens: cacheReadTokens,
    creationTokens: cacheCreationTokens,
    promptTokens: promptTokens,
    costUsd: cacheCostUsd,
  );
}

// ── Aggregated summaries ─────────────────────────────────────────────────────

/// A single (label, value) point for a time-series chart.
class TimeSeriesPoint {
  final String label;
  final double value;
  const TimeSeriesPoint({required this.label, required this.value});
}

/// Top-level summary numbers shown in the stat cards.
class UsageSummary {
  final int totalCalls;
  final int totalInputTokens;
  final int totalOutputTokens;
  final double totalCostUsd;
  final double avgLatencyMs;
  final List<TimeSeriesPoint> costOverTime;
  final List<TimeSeriesPoint> tokensOverTime;
  final List<TimeSeriesPoint> callsOverTime;
  final int totalCacheReadTokens;
  final int totalCacheCreationTokens;

  /// True prompt tokens across the window, 0 when any span did not report them.
  final int totalPromptTokens;

  /// Cache dollars across the window, null when any span did not report them.
  final double? totalCacheCostUsd;

  const UsageSummary({
    required this.totalCalls,
    required this.totalInputTokens,
    required this.totalOutputTokens,
    required this.totalCostUsd,
    required this.avgLatencyMs,
    required this.costOverTime,
    required this.tokensOverTime,
    required this.callsOverTime,
    this.totalCacheReadTokens = 0,
    this.totalCacheCreationTokens = 0,
    this.totalPromptTokens = 0,
    this.totalCacheCostUsd,
  });

  int get totalTokens => totalInputTokens + totalOutputTokens;

  /// Cache telemetry for the whole window. Attach the proxy TTL with
  /// [CacheTelemetry.withTtl] where the config is in reach.
  CacheTelemetry get cache => CacheTelemetry(
    readTokens: totalCacheReadTokens,
    creationTokens: totalCacheCreationTokens,
    promptTokens: totalPromptTokens,
    costUsd: totalCacheCostUsd,
  );
}

/// Per-model cost & token breakdown row.
class ModelBreakdown {
  final String model;
  final String provider;
  final int callCount;
  final int inputTokens;
  final int outputTokens;
  final double costUsd;
  final double avgLatencyMs;

  /// Static list price — populated from the pricing registry (may be null for
  /// local/custom models).
  final double? inputPricePerMillion;
  final double? outputPricePerMillion;

  /// Cache token counts — used for cache efficiency badges.
  final int cacheReadTokens;
  final int cacheCreationTokens;

  /// True prompt tokens for this model, 0 when any of its spans did not report
  /// them.
  final int promptTokens;

  /// Cache dollars for this model, null when any of its spans did not report
  /// them.
  final double? cacheCostUsd;

  const ModelBreakdown({
    required this.model,
    required this.provider,
    required this.callCount,
    required this.inputTokens,
    required this.outputTokens,
    required this.costUsd,
    required this.avgLatencyMs,
    this.inputPricePerMillion,
    this.outputPricePerMillion,
    this.cacheReadTokens = 0,
    this.cacheCreationTokens = 0,
    this.promptTokens = 0,
    this.cacheCostUsd,
  });

  int get totalTokens => inputTokens + outputTokens;

  /// Cache telemetry for this model. Attach the proxy TTL with
  /// [CacheTelemetry.withTtl] where the config is in reach.
  CacheTelemetry get cache => CacheTelemetry(
    readTokens: cacheReadTokens,
    creationTokens: cacheCreationTokens,
    promptTokens: promptTokens,
    costUsd: cacheCostUsd,
  );

  /// Returns a copy with pricing data enriched from the static registry.
  ModelBreakdown withPricing({
    double? inputPerMillion,
    double? outputPerMillion,
  }) {
    return ModelBreakdown(
      model: model,
      provider: provider,
      callCount: callCount,
      inputTokens: inputTokens,
      outputTokens: outputTokens,
      costUsd: costUsd,
      avgLatencyMs: avgLatencyMs,
      inputPricePerMillion: inputPerMillion ?? inputPricePerMillion,
      outputPricePerMillion: outputPerMillion ?? outputPricePerMillion,
      cacheReadTokens: cacheReadTokens,
      cacheCreationTokens: cacheCreationTokens,
      promptTokens: promptTokens,
      cacheCostUsd: cacheCostUsd,
    );
  }
}

// ── Time range ───────────────────────────────────────────────────────────────

enum TokenTimeRange {
  /// Today from UTC midnight — matches the web dashboard and budget reset period.
  todayUtc('Today', Duration(hours: 24)),
  h24('24h', Duration(hours: 24)),
  d7('7d', Duration(days: 7)),
  d30('30d', Duration(days: 30));

  final String label;
  final Duration duration;
  const TokenTimeRange(this.label, this.duration);

  /// Returns the window start for a given [now] timestamp.
  /// [todayUtc] snaps to UTC midnight (converted to local for chart labels);
  /// rolling ranges subtract [duration].
  DateTime startFrom(DateTime now) {
    if (this == todayUtc) {
      final utcMidnight = DateTime.utc(
        now.toUtc().year,
        now.toUtc().month,
        now.toUtc().day,
      );
      return utcMidnight.toLocal();
    }
    return now.subtract(duration);
  }
}

// ── Span aggregation helpers ────────────────────────────────────────────────

/// Prompt size and cache dollars for a group of spans.
///
/// Both totals are all or nothing. One span that did not report a value would
/// understate the group, so the total is unknown instead. An unknown prompt
/// count is 0 and an unknown cost is null, which every surface renders as an em
/// dash.
({int promptTokens, double? costUsd}) spanCacheTotals(
  Iterable<SpanRecord> spans,
) {
  var promptTokens = 0;
  var promptKnown = true;
  var costUsd = 0.0;
  var costKnown = true;
  for (final s in spans) {
    if (s.promptTokens > 0) {
      promptTokens += s.promptTokens;
    } else {
      promptKnown = false;
    }
    final cost = s.cacheCostUsd;
    if (cost != null) {
      costUsd += cost;
    } else if (s.cacheReadTokens > 0 || s.cacheCreationTokens > 0) {
      // No cache tokens means no cache charge, so only a span that used the
      // cache can leave the cost unknown.
      costKnown = false;
    }
  }
  return (
    promptTokens: promptKnown ? promptTokens : 0,
    costUsd: costKnown ? costUsd : null,
  );
}

/// Aggregate a list of spans into a [UsageSummary].
///
/// The Today screen aggregates its UTC-day window through this helper, so
/// the stat cards and the cache strip share one implementation.
UsageSummary buildSummaryFromSpans(List<SpanRecord> spans) {
  int totalIn = 0, totalOut = 0, totalCacheRead = 0, totalCacheCreation = 0;
  double totalCost = 0, totalMs = 0;
  for (final s in spans) {
    totalIn += s.inputTokens;
    totalOut += s.outputTokens;
    totalCost += s.costUsd;
    totalMs += s.durationMs;
    totalCacheRead += s.cacheReadTokens;
    totalCacheCreation += s.cacheCreationTokens;
  }
  final cacheTotals = spanCacheTotals(spans);
  return UsageSummary(
    totalCalls: spans.length,
    totalInputTokens: totalIn,
    totalOutputTokens: totalOut,
    totalCostUsd: totalCost,
    avgLatencyMs: spans.isEmpty ? 0.0 : totalMs / spans.length,
    costOverTime: const [],
    tokensOverTime: const [],
    callsOverTime: const [],
    totalCacheReadTokens: totalCacheRead,
    totalCacheCreationTokens: totalCacheCreation,
    totalPromptTokens: cacheTotals.promptTokens,
    totalCacheCostUsd: cacheTotals.costUsd,
  );
}

/// Aggregate a list of spans into per-model [ModelBreakdown] entries,
/// sorted by cost descending.
///
/// The Today screen builds "Top Models Today" through this helper.
List<ModelBreakdown> buildModelBreakdownFromSpans(List<SpanRecord> spans) {
  if (spans.isEmpty) return [];

  final byModel = <String, List<SpanRecord>>{};
  for (final s in spans) {
    byModel.putIfAbsent(s.model, () => []).add(s);
  }

  final models = byModel.entries.map((e) {
    final group = e.value;
    int inTok = 0, outTok = 0, cacheRead = 0, cacheCreation = 0;
    double cost = 0, ms = 0;
    for (final s in group) {
      inTok += s.inputTokens;
      outTok += s.outputTokens;
      cost += s.costUsd;
      ms += s.durationMs;
      cacheRead += s.cacheReadTokens;
      cacheCreation += s.cacheCreationTokens;
    }
    final cacheTotals = spanCacheTotals(group);
    return ModelBreakdown(
      model: e.key,
      provider: group.first.provider,
      callCount: group.length,
      inputTokens: inTok,
      outputTokens: outTok,
      costUsd: cost,
      avgLatencyMs: group.isEmpty ? 0.0 : ms / group.length,
      cacheReadTokens: cacheRead,
      cacheCreationTokens: cacheCreation,
      promptTokens: cacheTotals.promptTokens,
      cacheCostUsd: cacheTotals.costUsd,
    );
  }).toList();

  models.sort((a, b) => b.costUsd.compareTo(a.costUsd));
  return models;
}
