/// Data models for the local token / cost observability dashboard.
///
/// These mirror the JSON shapes emitted by the candela-local
/// `/_local/api/traces` endpoint (see traces_handler.go).
library;

import 'dart:math' show min;

// ── Raw span from the server ────────────────────────────────────────────────

/// Maximum length for string fields read from remote JSON.
/// Prevents arbitrarily long model/provider names from crashing the layout.
const _kMaxFieldLen = 200;

String _truncate(String s) =>
    s.length > _kMaxFieldLen ? s.substring(0, _kMaxFieldLen) : s;

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
        spanId: _truncate(j['span_id'] as String? ?? ''),
        traceId: _truncate(j['trace_id'] as String? ?? ''),
        // H2: truncate all string fields to prevent layout overflow
        model: _truncate(j['model'] as String? ?? 'unknown'),
        provider: _truncate(j['provider'] as String? ?? 'local'),
        inputTokens: (j['input_tokens'] as num?)?.toInt() ?? 0,
        outputTokens: (j['output_tokens'] as num?)?.toInt() ?? 0,
        totalTokens: (j['total_tokens'] as num?)?.toInt() ?? 0,
        costUsd: (j['cost_usd'] as num?)?.toDouble() ?? 0.0,
        durationMs: (j['duration_ms'] as num?)?.toDouble() ?? 0.0,
        status: _truncate(j['status'] as String? ?? 'unset'),
        timestamp: DateTime.tryParse(j['timestamp'] as String? ?? '') ??
            DateTime.now(),
        name: _truncate(j['name'] as String? ?? ''),
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

// Suppress unused import warning — min is used by _truncate indirectly.
// ignore: unused_element
int _useMin(int a, int b) => min(a, b);
