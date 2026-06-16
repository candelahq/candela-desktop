import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/models/span_stats.dart';

/// Unit tests for the span aggregation helpers used by the Today screen.
///
/// These test [buildSummaryFromSpans] and [buildModelBreakdownFromSpans] —
/// the core logic behind the "Today's Spend" hero card and
/// "Top Models Today" card.

SpanRecord _span({
  required String model,
  String provider = 'google',
  int inputTokens = 100,
  int outputTokens = 50,
  double costUsd = 0.01,
  double durationMs = 500.0,
  DateTime? timestamp,
}) =>
    SpanRecord(
      spanId:
          'span-${model.hashCode}-${timestamp?.millisecondsSinceEpoch ?? 0}',
      traceId: 'trace-1',
      model: model,
      provider: provider,
      inputTokens: inputTokens,
      outputTokens: outputTokens,
      totalTokens: inputTokens + outputTokens,
      costUsd: costUsd,
      durationMs: durationMs,
      status: 'ok',
      timestamp: timestamp ?? DateTime.now(),
      name: 'chat',
    );

void main() {
  group('buildSummaryFromSpans', () {
    test('empty list returns zero-value summary', () {
      final summary = buildSummaryFromSpans([]);
      expect(summary.totalCalls, 0);
      expect(summary.totalInputTokens, 0);
      expect(summary.totalOutputTokens, 0);
      expect(summary.totalCostUsd, 0.0);
      expect(summary.avgLatencyMs, 0.0);
    });

    test('single span aggregates correctly', () {
      final summary = buildSummaryFromSpans([
        _span(
            model: 'gpt-4o',
            inputTokens: 200,
            outputTokens: 100,
            costUsd: 0.05,
            durationMs: 800.0),
      ]);
      expect(summary.totalCalls, 1);
      expect(summary.totalInputTokens, 200);
      expect(summary.totalOutputTokens, 100);
      expect(summary.totalCostUsd, closeTo(0.05, 1e-10));
      expect(summary.avgLatencyMs, 800.0);
    });

    test('multiple spans aggregate totals and average latency', () {
      final summary = buildSummaryFromSpans([
        _span(
            model: 'gpt-4o',
            inputTokens: 100,
            outputTokens: 50,
            costUsd: 0.01,
            durationMs: 400.0),
        _span(
            model: 'claude-sonnet-4',
            inputTokens: 200,
            outputTokens: 100,
            costUsd: 0.03,
            durationMs: 600.0),
        _span(
            model: 'gpt-4o',
            inputTokens: 300,
            outputTokens: 150,
            costUsd: 0.05,
            durationMs: 800.0),
      ]);
      expect(summary.totalCalls, 3);
      expect(summary.totalInputTokens, 600);
      expect(summary.totalOutputTokens, 300);
      expect(summary.totalCostUsd, closeTo(0.09, 1e-10));
      expect(summary.avgLatencyMs, 600.0); // (400+600+800)/3
    });

    test('totalTokens getter returns sum of input + output', () {
      final summary = buildSummaryFromSpans([
        _span(model: 'x', inputTokens: 100, outputTokens: 50),
      ]);
      expect(summary.totalTokens, 150);
    });
  });

  group('buildModelBreakdownFromSpans', () {
    test('empty list returns empty', () {
      expect(buildModelBreakdownFromSpans([]), isEmpty);
    });

    test('single model single span', () {
      final models = buildModelBreakdownFromSpans([
        _span(
            model: 'gpt-4o',
            provider: 'openai',
            inputTokens: 100,
            outputTokens: 50,
            costUsd: 0.01),
      ]);
      expect(models.length, 1);
      expect(models[0].model, 'gpt-4o');
      expect(models[0].provider, 'openai');
      expect(models[0].callCount, 1);
      expect(models[0].inputTokens, 100);
      expect(models[0].outputTokens, 50);
      expect(models[0].costUsd, closeTo(0.01, 1e-10));
    });

    test('groups spans by model and aggregates', () {
      final models = buildModelBreakdownFromSpans([
        _span(
            model: 'gpt-4o',
            provider: 'openai',
            costUsd: 0.02,
            inputTokens: 100,
            outputTokens: 50),
        _span(
            model: 'gpt-4o',
            provider: 'openai',
            costUsd: 0.03,
            inputTokens: 200,
            outputTokens: 100),
        _span(
            model: 'claude-sonnet-4',
            provider: 'anthropic',
            costUsd: 0.10,
            inputTokens: 500,
            outputTokens: 250),
      ]);
      expect(models.length, 2);

      // Sorted by cost descending — claude should be first.
      expect(models[0].model, 'claude-sonnet-4');
      expect(models[0].callCount, 1);
      expect(models[0].costUsd, closeTo(0.10, 1e-10));

      expect(models[1].model, 'gpt-4o');
      expect(models[1].callCount, 2);
      expect(models[1].inputTokens, 300);
      expect(models[1].outputTokens, 150);
      expect(models[1].costUsd, closeTo(0.05, 1e-10));
    });

    test('sorted by cost descending', () {
      final models = buildModelBreakdownFromSpans([
        _span(model: 'cheap', costUsd: 0.001),
        _span(model: 'expensive', costUsd: 1.50),
        _span(model: 'medium', costUsd: 0.10),
      ]);
      expect(models.map((m) => m.model).toList(),
          ['expensive', 'medium', 'cheap']);
    });

    test('preserves provider from first span in group', () {
      final models = buildModelBreakdownFromSpans([
        _span(model: 'gemini-2.5-pro', provider: 'google'),
        _span(model: 'gemini-2.5-pro', provider: 'google'),
      ]);
      expect(models[0].provider, 'google');
    });

    test('average latency is per-model', () {
      final models = buildModelBreakdownFromSpans([
        _span(model: 'fast', durationMs: 100.0, costUsd: 0.01),
        _span(model: 'fast', durationMs: 300.0, costUsd: 0.01),
        _span(model: 'slow', durationMs: 2000.0, costUsd: 0.05),
      ]);
      final fast = models.firstWhere((m) => m.model == 'fast');
      final slow = models.firstWhere((m) => m.model == 'slow');
      expect(fast.avgLatencyMs, 200.0); // (100+300)/2
      expect(slow.avgLatencyMs, 2000.0);
    });
  });

  group('TokenTimeRange.todayUtc', () {
    test('cutoff is at UTC midnight today', () {
      final now = DateTime.now();
      final cutoff = TokenTimeRange.todayUtc.startFrom(now);
      final utcMidnight =
          DateTime.utc(now.toUtc().year, now.toUtc().month, now.toUtc().day);
      expect(cutoff.toUtc(), utcMidnight);
    });

    test('spans before UTC midnight are excluded', () {
      final now = DateTime.now();
      final cutoff = TokenTimeRange.todayUtc.startFrom(now);
      final yesterday = cutoff.subtract(const Duration(hours: 1));
      final todaySpan = _span(model: 'x', timestamp: now);
      final yesterdaySpan = _span(model: 'x', timestamp: yesterday);

      final todayOnly = [todaySpan, yesterdaySpan]
          .where((s) => s.timestamp.isAfter(cutoff))
          .toList();
      expect(todayOnly.length, 1);
      expect(todayOnly[0].timestamp, now);
    });
  });
}
