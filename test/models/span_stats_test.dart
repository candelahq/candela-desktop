import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/models/span_stats.dart';

void main() {
  // ── SpanRecord.fromJson ───────────────────────────────────────────────────

  group('SpanRecord.fromJson', () {
    test('parses a complete valid object', () {
      final json = {
        'span_id': 'span-1',
        'trace_id': 'trace-1',
        'model': 'gpt-4o',
        'provider': 'openai',
        'input_tokens': 100,
        'output_tokens': 50,
        'total_tokens': 150,
        'cost_usd': 0.0025,
        'duration_ms': 832.5,
        'status': 'ok',
        'timestamp': '2025-01-01T12:00:00.000Z',
        'name': 'chat gpt-4o',
      };

      final s = SpanRecord.fromJson(json);

      expect(s.spanId, 'span-1');
      expect(s.traceId, 'trace-1');
      expect(s.model, 'gpt-4o');
      expect(s.provider, 'openai');
      expect(s.inputTokens, 100);
      expect(s.outputTokens, 50);
      expect(s.totalTokens, 150);
      expect(s.costUsd, closeTo(0.0025, 1e-9));
      expect(s.durationMs, closeTo(832.5, 1e-9));
      expect(s.status, 'ok');
      expect(s.name, 'chat gpt-4o');
    });

    test('uses safe defaults for missing fields', () {
      final s = SpanRecord.fromJson({});
      expect(s.spanId, '');
      expect(s.traceId, '');
      expect(s.model, 'unknown');
      expect(s.provider, 'local');
      expect(s.inputTokens, 0);
      expect(s.outputTokens, 0);
      expect(s.totalTokens, 0);
      expect(s.costUsd, 0.0);
      expect(s.durationMs, 0.0);
      expect(s.status, 'unset');
      expect(s.name, '');
    });

    test('truncates model string longer than 200 chars (H2)', () {
      final longModel = 'a' * 300;
      final s = SpanRecord.fromJson({'model': longModel});
      expect(s.model.length, 200);
    });

    test('truncates provider string longer than 200 chars (H2)', () {
      final longProvider = 'b' * 250;
      final s = SpanRecord.fromJson({'provider': longProvider});
      expect(s.provider.length, 200);
    });

    test('truncates name string longer than 200 chars (H2)', () {
      final longName = 'c' * 201;
      final s = SpanRecord.fromJson({'name': longName});
      expect(s.name.length, 200);
    });

    test('leaves strings at exactly 200 chars untouched', () {
      final exactly200 = 'd' * 200;
      final s = SpanRecord.fromJson({'model': exactly200});
      expect(s.model.length, 200);
    });

    test('handles num values for token/cost fields', () {
      final s = SpanRecord.fromJson({
        'input_tokens': 1000,
        'output_tokens': 500,
        'total_tokens': 1500,
        'cost_usd': 0.03,
        'duration_ms': 1200,
      });
      expect(s.inputTokens, 1000);
      expect(s.outputTokens, 500);
      expect(s.totalTokens, 1500);
    });

    test('falls back to DateTime.now() for invalid timestamp', () {
      final before = DateTime.now();
      final s = SpanRecord.fromJson({'timestamp': 'not-a-date'});
      final after = DateTime.now();
      expect(
          s.timestamp.isAfter(before) || s.timestamp.isAtSameMomentAs(before),
          isTrue);
      expect(s.timestamp.isBefore(after) || s.timestamp.isAtSameMomentAs(after),
          isTrue);
    });
  });

  // ── UsageSummary ─────────────────────────────────────────────────────────

  group('UsageSummary', () {
    const empty = <TimeSeriesPoint>[];

    test('totalTokens = inputTokens + outputTokens', () {
      const s = UsageSummary(
        totalCalls: 5,
        totalInputTokens: 300,
        totalOutputTokens: 150,
        totalCostUsd: 0.01,
        avgLatencyMs: 500,
        costOverTime: empty,
        tokensOverTime: empty,
        callsOverTime: empty,
      );
      expect(s.totalTokens, 450);
    });

    test('totalTokens is 0 when both components are 0', () {
      const s = UsageSummary(
        totalCalls: 0,
        totalInputTokens: 0,
        totalOutputTokens: 0,
        totalCostUsd: 0,
        avgLatencyMs: 0,
        costOverTime: empty,
        tokensOverTime: empty,
        callsOverTime: empty,
      );
      expect(s.totalTokens, 0);
    });
  });

  // ── ModelBreakdown ────────────────────────────────────────────────────────

  group('ModelBreakdown', () {
    test('totalTokens = inputTokens + outputTokens', () {
      const m = ModelBreakdown(
        model: 'claude-3',
        provider: 'anthropic',
        callCount: 10,
        inputTokens: 800,
        outputTokens: 400,
        costUsd: 0.05,
        avgLatencyMs: 1200,
      );
      expect(m.totalTokens, 1200);
    });
  });

  // ── TokenTimeRange ────────────────────────────────────────────────────────

  group('TokenTimeRange', () {
    test('h24 has 24-hour duration', () {
      expect(TokenTimeRange.h24.duration, const Duration(hours: 24));
      expect(TokenTimeRange.h24.label, '24h');
    });

    test('d7 has 7-day duration', () {
      expect(TokenTimeRange.d7.duration, const Duration(days: 7));
      expect(TokenTimeRange.d7.label, '7d');
    });

    test('d30 has 30-day duration', () {
      expect(TokenTimeRange.d30.duration, const Duration(days: 30));
      expect(TokenTimeRange.d30.label, '30d');
    });
  });
}
