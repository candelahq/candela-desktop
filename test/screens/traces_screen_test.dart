import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/models/span_stats.dart';

// ── Helpers ──────────────────────────────────────────────────────────────────

SpanRecord _span({
  String model = 'gpt-4',
  String provider = 'openai',
  String status = 'ok',
  int input = 100,
  int output = 50,
  double cost = 0.01,
  double duration = 500,
  DateTime? ts,
  String? spanId,
}) =>
    SpanRecord(
      traceId: 'trace-1',
      spanId: spanId ?? 'span-${model.hashCode}',
      name: 'chat',
      model: model,
      provider: provider,
      status: status,
      inputTokens: input,
      outputTokens: output,
      totalTokens: input + output,
      costUsd: cost,
      durationMs: duration,
      timestamp: ts ?? DateTime(2025, 1, 1),
    );

void main() {
  group('Trace filtering', () {
    final spans = [
      _span(model: 'gpt-4', provider: 'openai', status: 'ok', spanId: 's1'),
      _span(
          model: 'claude-3',
          provider: 'anthropic',
          status: 'error',
          spanId: 's2'),
      _span(model: 'gpt-4', provider: 'openai', status: 'ok', spanId: 's3'),
      _span(
          model: 'gemini-pro', provider: 'google', status: 'ok', spanId: 's4'),
    ];

    test('search by model name', () {
      final q = 'claude';
      final result =
          spans.where((s) => s.model.toLowerCase().contains(q)).toList();
      expect(result.length, 1);
      expect(result.first.model, 'claude-3');
    });

    test('search by provider', () {
      final q = 'anthropic';
      final result =
          spans.where((s) => s.provider.toLowerCase().contains(q)).toList();
      expect(result.length, 1);
    });

    test('filter by status', () {
      final result = spans.where((s) => s.status == 'error').toList();
      expect(result.length, 1);
      expect(result.first.provider, 'anthropic');
    });

    test('filter by model', () {
      final result = spans.where((s) => s.model == 'gpt-4').toList();
      expect(result.length, 2);
    });

    test('combined search and status filter', () {
      final q = 'gpt';
      final status = 'ok';
      final result = spans
          .where((s) => s.model.toLowerCase().contains(q) && s.status == status)
          .toList();
      expect(result.length, 2);
    });

    test('search with no matches returns empty', () {
      final q = 'nonexistent';
      final result =
          spans.where((s) => s.model.toLowerCase().contains(q)).toList();
      expect(result, isEmpty);
    });

    test('search by trace ID', () {
      final q = 'trace-1';
      final result =
          spans.where((s) => s.traceId.toLowerCase().contains(q)).toList();
      expect(result.length, 4);
    });

    test('search by span ID', () {
      final q = 's2';
      final result =
          spans.where((s) => s.spanId.toLowerCase().contains(q)).toList();
      expect(result.length, 1);
    });

    test('case-insensitive search', () {
      final q = 'GPT';
      final result = spans
          .where((s) => s.model.toLowerCase().contains(q.toLowerCase()))
          .toList();
      expect(result.length, 2);
    });
  });

  group('Trace sorting', () {
    final spans = [
      _span(
          model: 'a',
          cost: 0.05,
          duration: 100,
          input: 500,
          output: 200,
          ts: DateTime(2025, 1, 3),
          spanId: 'sa'),
      _span(
          model: 'c',
          cost: 0.01,
          duration: 300,
          input: 100,
          output: 50,
          ts: DateTime(2025, 1, 1),
          spanId: 'sc'),
      _span(
          model: 'b',
          cost: 0.10,
          duration: 200,
          input: 300,
          output: 100,
          ts: DateTime(2025, 1, 2),
          spanId: 'sb'),
    ];

    test('sort by timestamp descending', () {
      final sorted = List<SpanRecord>.from(spans)
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
      expect(sorted.map((s) => s.model).toList(), ['a', 'b', 'c']);
    });

    test('sort by timestamp ascending', () {
      final sorted = List<SpanRecord>.from(spans)
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
      expect(sorted.map((s) => s.model).toList(), ['c', 'b', 'a']);
    });

    test('sort by cost descending', () {
      final sorted = List<SpanRecord>.from(spans)
        ..sort((a, b) => b.costUsd.compareTo(a.costUsd));
      expect(sorted.map((s) => s.model).toList(), ['b', 'a', 'c']);
    });

    test('sort by latency ascending', () {
      final sorted = List<SpanRecord>.from(spans)
        ..sort((a, b) => a.durationMs.compareTo(b.durationMs));
      expect(sorted.map((s) => s.model).toList(), ['a', 'b', 'c']);
    });

    test('sort by model name ascending', () {
      final sorted = List<SpanRecord>.from(spans)
        ..sort((a, b) => a.model.compareTo(b.model));
      expect(sorted.map((s) => s.model).toList(), ['a', 'b', 'c']);
    });

    test('sort by total tokens descending', () {
      final sorted = List<SpanRecord>.from(spans)
        ..sort((a, b) => b.totalTokens.compareTo(a.totalTokens));
      expect(sorted.first.model, 'a'); // 500+200=700
    });
  });

  group('Available filter extraction', () {
    final spans = [
      _span(model: 'gpt-4', status: 'ok', spanId: 's1'),
      _span(model: 'claude-3', status: 'error', spanId: 's2'),
      _span(model: 'gpt-4', status: 'ok', spanId: 's3'),
      _span(model: 'gemini-pro', status: 'ok', spanId: 's4'),
    ];

    test('unique models', () {
      final models = spans.map((s) => s.model).toSet();
      expect(models, {'gpt-4', 'claude-3', 'gemini-pro'});
    });

    test('unique statuses', () {
      final statuses = spans.map((s) => s.status).toSet();
      expect(statuses, {'ok', 'error'});
    });
  });
}
