/// Data models for the local token / cost observability dashboard.
///
/// These mirror the JSON shapes emitted by the candela
/// `/_local/api/traces` endpoint (see traces_handler.go).
library;

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
        timestamp: DateTime.tryParse(j['timestamp'] as String? ?? '') ??
            DateTime.now(),
        name: j['name'] as String? ?? '',
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

  const UsageSummary({
    required this.totalCalls,
    required this.totalInputTokens,
    required this.totalOutputTokens,
    required this.totalCostUsd,
    required this.avgLatencyMs,
    required this.costOverTime,
    required this.tokensOverTime,
    required this.callsOverTime,
  });

  int get totalTokens => totalInputTokens + totalOutputTokens;
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
  });

  int get totalTokens => inputTokens + outputTokens;

  /// Returns a copy with pricing data enriched from the static registry.
  ModelBreakdown withPricing(
      {double? inputPerMillion, double? outputPerMillion}) {
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
      final utcMidnight =
          DateTime.utc(now.toUtc().year, now.toUtc().month, now.toUtc().day);
      return utcMidnight.toLocal();
    }
    return now.subtract(duration);
  }
}

// ── Span aggregation helpers ────────────────────────────────────────────────

/// Aggregate a list of spans into a [UsageSummary].
///
/// This is the pure-logic equivalent of TodayScreen._buildSummaryFromSpans,
/// extracted here so it can be unit tested.
UsageSummary buildSummaryFromSpans(List<SpanRecord> spans) {
  int totalIn = 0, totalOut = 0;
  double totalCost = 0, totalMs = 0;
  for (final s in spans) {
    totalIn += s.inputTokens;
    totalOut += s.outputTokens;
    totalCost += s.costUsd;
    totalMs += s.durationMs;
  }
  return UsageSummary(
    totalCalls: spans.length,
    totalInputTokens: totalIn,
    totalOutputTokens: totalOut,
    totalCostUsd: totalCost,
    avgLatencyMs: spans.isEmpty ? 0.0 : totalMs / spans.length,
    costOverTime: const [],
    tokensOverTime: const [],
    callsOverTime: const [],
  );
}

/// Aggregate a list of spans into per-model [ModelBreakdown] entries,
/// sorted by cost descending.
///
/// This is the pure-logic equivalent of TodayScreen._buildTodayModels,
/// extracted here so it can be unit tested.
List<ModelBreakdown> buildModelBreakdownFromSpans(List<SpanRecord> spans) {
  if (spans.isEmpty) return [];

  final byModel = <String, List<SpanRecord>>{};
  for (final s in spans) {
    byModel.putIfAbsent(s.model, () => []).add(s);
  }

  final models = byModel.entries.map((e) {
    final group = e.value;
    int inTok = 0, outTok = 0;
    double cost = 0, ms = 0;
    for (final s in group) {
      inTok += s.inputTokens;
      outTok += s.outputTokens;
      cost += s.costUsd;
      ms += s.durationMs;
    }
    return ModelBreakdown(
      model: e.key,
      provider: group.first.provider,
      callCount: group.length,
      inputTokens: inTok,
      outputTokens: outTok,
      costUsd: cost,
      avgLatencyMs: group.isEmpty ? 0.0 : ms / group.length,
    );
  }).toList();

  models.sort((a, b) => b.costUsd.compareTo(a.costUsd));
  return models;
}
