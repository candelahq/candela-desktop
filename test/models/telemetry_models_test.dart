import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/models/span_stats.dart';
import 'package:candela_desktop/services/telemetry_service.dart';
import 'package:candela_desktop/services/dashboard_notifier.dart';

void main() {
  // ── TelemetryResult tests ───────────────────────────────────────────────────

  group('TelemetryResult', () {
    test('empty result has no data', () {
      const r = TelemetryResult.empty(isTeamMode: false);
      expect(r.hasData, isFalse);
      expect(r.models, isEmpty);
      expect(r.spans, isEmpty);
      expect(r.isTeamMode, isFalse);
    });

    test('result with summary has data', () {
      const r = TelemetryResult(
        summary: UsageSummary(
          totalCalls: 1,
          totalInputTokens: 10,
          totalOutputTokens: 5,
          totalCostUsd: 0.01,
          avgLatencyMs: 500,
          costOverTime: [],
          tokensOverTime: [],
          callsOverTime: [],
        ),
        models: [],
        spans: [],
        isTeamMode: false,
      );
      expect(r.hasData, isTrue);
    });

    test('withError result carries error kind', () {
      const r = TelemetryResult.withError(
        isTeamMode: true,
        error: TelemetryErrorKind.authExpired,
      );
      expect(r.error, TelemetryErrorKind.authExpired);
      expect(r.isTeamMode, isTrue);
    });
  });

  // ── UsageSummary tests ──────────────────────────────────────────────────────

  group('UsageSummary', () {
    test('totalTokens is sum of input and output', () {
      const s = UsageSummary(
        totalCalls: 10,
        totalInputTokens: 1000,
        totalOutputTokens: 500,
        totalCostUsd: 5.0,
        avgLatencyMs: 200,
        costOverTime: [],
        tokensOverTime: [],
        callsOverTime: [],
      );
      expect(s.totalTokens, 1500);
    });

    test('zero values are valid', () {
      const s = UsageSummary(
        totalCalls: 0,
        totalInputTokens: 0,
        totalOutputTokens: 0,
        totalCostUsd: 0,
        avgLatencyMs: 0,
        costOverTime: [],
        tokensOverTime: [],
        callsOverTime: [],
      );
      expect(s.totalTokens, 0);
      expect(s.totalCalls, 0);
    });
  });

  // ── SpanRecord tests ────────────────────────────────────────────────────────

  group('SpanRecord', () {
    test('constructs with all required fields', () {
      final s = SpanRecord(
        traceId: 't1',
        spanId: 's1',
        name: 'chat',
        model: 'gpt-4',
        provider: 'openai',
        status: 'ok',
        inputTokens: 100,
        outputTokens: 50,
        totalTokens: 150,
        costUsd: 0.01,
        durationMs: 500,
        timestamp: DateTime(2025, 1, 1),
      );
      expect(s.model, 'gpt-4');
      expect(s.totalTokens, 150);
      expect(s.status, 'ok');
    });

    test('fromJson handles missing fields gracefully', () {
      final s = SpanRecord.fromJson({});
      expect(s.model, 'unknown');
      expect(s.provider, 'local');
      expect(s.inputTokens, 0);
      expect(s.outputTokens, 0);
      expect(s.totalTokens, 0);
      expect(s.costUsd, 0.0);
    });

    test('fromJson parses complete JSON', () {
      final s = SpanRecord.fromJson({
        'span_id': 'abc',
        'trace_id': 'xyz',
        'model': 'claude-3',
        'provider': 'anthropic',
        'input_tokens': 200,
        'output_tokens': 100,
        'total_tokens': 300,
        'cost_usd': 0.05,
        'duration_ms': 1200.5,
        'status': 'error',
        'timestamp': '2025-06-01T12:00:00Z',
        'name': 'completion',
      });
      expect(s.spanId, 'abc');
      expect(s.model, 'claude-3');
      expect(s.totalTokens, 300);
      expect(s.costUsd, 0.05);
      expect(s.status, 'error');
    });
  });

  // ── ModelBreakdown tests ────────────────────────────────────────────────────

  group('ModelBreakdown', () {
    test('totalTokens is computed from input + output', () {
      const m = ModelBreakdown(
        model: 'gpt-4',
        provider: 'openai',
        callCount: 10,
        inputTokens: 1000,
        outputTokens: 500,
        costUsd: 0.50,
        avgLatencyMs: 800,
      );
      expect(m.totalTokens, 1500);
    });

    test('efficiency metrics compute correctly', () {
      const m = ModelBreakdown(
        model: 'claude-3',
        provider: 'anthropic',
        callCount: 20,
        inputTokens: 4000,
        outputTokens: 1000,
        costUsd: 2.0,
        avgLatencyMs: 600,
      );
      expect(m.costUsd / m.callCount, 0.1);
      expect(m.totalTokens / m.callCount, 250);
      expect(m.outputTokens / m.totalTokens, 0.2);
    });
  });

  // ── TokenTimeRange tests ────────────────────────────────────────────────────

  group('TokenTimeRange', () {
    test('has exactly 3 values', () {
      expect(TokenTimeRange.values.length, 3);
    });

    test('labels are human-readable', () {
      expect(TokenTimeRange.h24.label, '24h');
      expect(TokenTimeRange.d7.label, '7d');
      expect(TokenTimeRange.d30.label, '30d');
    });

    test('durations are correct', () {
      expect(TokenTimeRange.h24.duration, const Duration(hours: 24));
      expect(TokenTimeRange.d7.duration, const Duration(days: 7));
      expect(TokenTimeRange.d30.duration, const Duration(days: 30));
    });
  });

  // ── DashboardState edge cases ───────────────────────────────────────────────

  group('DashboardState edge cases', () {
    test('copyWith with both error and clearError prioritizes clear', () {
      final s = const DashboardState(errorMessage: 'old')
          .copyWith(errorMessage: 'new', clearError: true);
      expect(s.errorMessage, isNull);
    });

    test('copyWith chain preserves intermediate values', () {
      final s = const DashboardState()
          .copyWith(loading: true)
          .copyWith(range: TokenTimeRange.d30)
          .copyWith(loading: false);
      expect(s.loading, isFalse);
      expect(s.range, TokenTimeRange.d30);
    });

    test('models accessor returns empty list when no result', () {
      const s = DashboardState();
      expect(s.models, isEmpty);
      expect(s.spans, isEmpty);
      expect(s.activeGrants, isEmpty);
    });
  });

  // ── TimeSeriesPoint tests ───────────────────────────────────────────────────

  group('TimeSeriesPoint', () {
    test('stores label and value', () {
      const p = TimeSeriesPoint(label: '2025-01', value: 42.5);
      expect(p.label, '2025-01');
      expect(p.value, 42.5);
    });
  });
}
