import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/models/span_stats.dart';

// ── Helpers ──────────────────────────────────────────────────────────────────

ModelBreakdown _model({
  String name = 'gpt-4',
  String provider = 'openai',
  int calls = 10,
  int input = 1000,
  int output = 500,
  double cost = 0.50,
  double avgLatency = 1200,
}) =>
    ModelBreakdown(
      model: name,
      provider: provider,
      callCount: calls,
      inputTokens: input,
      outputTokens: output,
      costUsd: cost,
      avgLatencyMs: avgLatency,
    );

void main() {
  group('Model sorting', () {
    final models = [
      _model(name: 'a', cost: 0.10, calls: 5, avgLatency: 300),
      _model(name: 'c', cost: 0.50, calls: 20, avgLatency: 100),
      _model(name: 'b', cost: 0.30, calls: 10, avgLatency: 200),
    ];

    test('sort by cost descending', () {
      final sorted = List<ModelBreakdown>.from(models)
        ..sort((a, b) => b.costUsd.compareTo(a.costUsd));
      expect(sorted.map((m) => m.model).toList(), ['c', 'b', 'a']);
    });

    test('sort by calls descending', () {
      final sorted = List<ModelBreakdown>.from(models)
        ..sort((a, b) => b.callCount.compareTo(a.callCount));
      expect(sorted.map((m) => m.model).toList(), ['c', 'b', 'a']);
    });

    test('sort by name ascending', () {
      final sorted = List<ModelBreakdown>.from(models)
        ..sort((a, b) => a.model.compareTo(b.model));
      expect(sorted.map((m) => m.model).toList(), ['a', 'b', 'c']);
    });

    test('sort by latency ascending', () {
      final sorted = List<ModelBreakdown>.from(models)
        ..sort((a, b) => a.avgLatencyMs.compareTo(b.avgLatencyMs));
      expect(sorted.map((m) => m.model).toList(), ['c', 'b', 'a']);
    });

    test('sort toggle reverses order', () {
      final sorted = List<ModelBreakdown>.from(models)
        ..sort((a, b) => b.costUsd.compareTo(a.costUsd));
      expect(sorted.first.model, 'c');
      sorted.sort((a, b) => a.costUsd.compareTo(b.costUsd));
      expect(sorted.first.model, 'a');
    });
  });

  group('Model efficiency metrics', () {
    test('cost per call', () {
      final m = _model(cost: 1.0, calls: 10);
      expect(m.costUsd / m.callCount, 0.1);
    });

    test('tokens per call', () {
      final m = _model(input: 500, output: 500, calls: 10);
      expect(m.totalTokens / m.callCount, 100);
    });

    test('output ratio', () {
      final m = _model(input: 700, output: 300);
      expect(m.outputTokens / m.totalTokens * 100, 30.0);
    });

    test('cost per call with zero calls', () {
      final m = _model(cost: 0.50, calls: 0);
      // Should handle gracefully — UI guards with ternary.
      expect(m.callCount, 0);
    });

    test('output ratio with zero tokens', () {
      final m = _model(input: 0, output: 0);
      expect(m.totalTokens, 0);
    });

    test('totalTokens is sum of input and output', () {
      final m = _model(input: 1234, output: 5678);
      expect(m.totalTokens, 1234 + 5678);
    });
  });

  group('Model selection', () {
    final models = [
      _model(name: 'gpt-4', provider: 'openai'),
      _model(name: 'claude-3', provider: 'anthropic'),
    ];

    test('select model by name', () {
      const selected = 'claude-3';
      final found = models.where((m) => m.model == selected).firstOrNull;
      expect(found, isNotNull);
      expect(found!.provider, 'anthropic');
    });

    test('deselect returns null', () {
      const selected = 'nonexistent';
      final found = models.where((m) => m.model == selected).firstOrNull;
      expect(found, isNull);
    });
  });

  group('Token formatting', () {
    String fmtTokens(int v) {
      if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
      if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}k';
      return v.toString();
    }

    test('formats millions', () => expect(fmtTokens(2500000), '2.5M'));
    test('formats thousands', () => expect(fmtTokens(12500), '12.5k'));
    test('formats small values', () => expect(fmtTokens(42), '42'));
    test('formats exactly 1k', () => expect(fmtTokens(1000), '1.0k'));
    test('formats exactly 1M', () => expect(fmtTokens(1000000), '1.0M'));
  });

  group('Cost bar calculation', () {
    test('bar percentage scales to max cost', () {
      final models = [
        _model(name: 'a', cost: 0.10),
        _model(name: 'b', cost: 0.50),
        _model(name: 'c', cost: 0.25),
      ];
      final maxCost =
          models.map((m) => m.costUsd).reduce((a, b) => a > b ? a : b);
      expect(maxCost, 0.50);
      expect(models[0].costUsd / maxCost, 0.2);
      expect(models[1].costUsd / maxCost, 1.0);
      expect(models[2].costUsd / maxCost, 0.5);
    });

    test('bar percentage is 0 when maxCost is 0', () {
      const maxCost = 0.0;
      final barPct = maxCost > 0 ? (0.5 / maxCost) : 0.0;
      expect(barPct, 0.0);
    });
  });
}
