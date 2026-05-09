/// Data models for the local token / cost observability dashboard.
///
/// These mirror the JSON shapes emitted by the candela-local
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

  const ModelBreakdown({
    required this.model,
    required this.provider,
    required this.callCount,
    required this.inputTokens,
    required this.outputTokens,
    required this.costUsd,
    required this.avgLatencyMs,
  });

  int get totalTokens => inputTokens + outputTokens;
}

// ── Time range ───────────────────────────────────────────────────────────────

enum TokenTimeRange {
  h24('24h', Duration(hours: 24)),
  d7('7d', Duration(days: 7)),
  d30('30d', Duration(days: 30));

  final String label;
  final Duration duration;
  const TokenTimeRange(this.label, this.duration);
}
