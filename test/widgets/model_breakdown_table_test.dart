import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/models/span_stats.dart';
import 'package:candela_desktop/widgets/model_breakdown_table.dart';
import 'package:candela_desktop/theme/colors.dart';

Widget _wrap(Widget child) => MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        backgroundColor: CandelaColors.bgPrimary,
        body: SizedBox(width: 1200, child: child),
      ),
    );

const _gpt = ModelBreakdown(
  model: 'gpt-4o',
  provider: 'openai',
  callCount: 10,
  inputTokens: 5000,
  outputTokens: 2000,
  costUsd: 0.50,
  avgLatencyMs: 800,
);

const _claude = ModelBreakdown(
  model: 'claude-3-5-sonnet',
  provider: 'anthropic',
  callCount: 5,
  inputTokens: 3000,
  outputTokens: 1500,
  costUsd: 0.25,
  avgLatencyMs: 1200,
);

const _cheap = ModelBreakdown(
  model: 'gemini-flash',
  provider: 'google',
  callCount: 50,
  inputTokens: 10000,
  outputTokens: 5000,
  costUsd: 0.01,
  avgLatencyMs: 200,
);

void main() {
  group('ModelBreakdownTable — empty state', () {
    testWidgets('shows empty state message when models list is empty',
        (tester) async {
      await tester.pumpWidget(_wrap(const ModelBreakdownTable(models: [])));
      expect(find.text('No model data yet'), findsOneWidget);
      expect(find.text('💰'), findsOneWidget);
    });

    testWidgets('empty state has no model rows', (tester) async {
      await tester.pumpWidget(_wrap(const ModelBreakdownTable(models: [])));
      expect(find.text('gpt-4o'), findsNothing);
    });
  });

  group('ModelBreakdownTable — rendering', () {
    testWidgets('renders model names', (tester) async {
      await tester.pumpWidget(
          _wrap(const ModelBreakdownTable(models: [_gpt, _claude])));
      expect(find.text('gpt-4o'), findsOneWidget);
      expect(find.text('claude-3-5-sonnet'), findsOneWidget);
    });

    testWidgets('renders provider names', (tester) async {
      await tester.pumpWidget(
          _wrap(const ModelBreakdownTable(models: [_gpt, _claude])));
      expect(find.text('openai'), findsOneWidget);
      expect(find.text('anthropic'), findsOneWidget);
    });

    testWidgets('renders model count badge', (tester) async {
      await tester.pumpWidget(
          _wrap(const ModelBreakdownTable(models: [_gpt, _claude])));
      expect(find.text('2 models'), findsOneWidget);
    });

    testWidgets('renders singular model count', (tester) async {
      await tester.pumpWidget(_wrap(const ModelBreakdownTable(models: [_gpt])));
      expect(find.text('1 model'), findsOneWidget);
    });

    testWidgets('renders column headers', (tester) async {
      await tester.pumpWidget(_wrap(const ModelBreakdownTable(models: [_gpt])));
      expect(find.text('Calls'), findsOneWidget);
      expect(find.text('Cost'), findsOneWidget);
      expect(find.text('Latency'), findsOneWidget);
      expect(find.text('Input'), findsOneWidget);
      expect(find.text('Output'), findsOneWidget);
    });

    testWidgets('renders cost bar (LinearProgressIndicator)', (tester) async {
      await tester.pumpWidget(
          _wrap(const ModelBreakdownTable(models: [_gpt, _claude])));
      expect(find.byType(LinearProgressIndicator), findsWidgets);
    });

    testWidgets('renders without errors for three models', (tester) async {
      await tester.pumpWidget(
          _wrap(const ModelBreakdownTable(models: [_gpt, _claude, _cheap])));
      expect(tester.takeException(), isNull);
      expect(find.text('3 models'), findsOneWidget);
    });
  });

  group('ModelBreakdownTable — default sort (cost descending)', () {
    testWidgets('highest-cost model appears first by default', (tester) async {
      // Default sort is cost descending — _gpt ($0.50) > _claude ($0.25) > _cheap ($0.01)
      await tester.pumpWidget(
          _wrap(const ModelBreakdownTable(models: [_cheap, _claude, _gpt])));

      final gptPos = tester.getTopLeft(find.text('gpt-4o')).dy;
      final claudePos = tester.getTopLeft(find.text('claude-3-5-sonnet')).dy;
      final cheapPos = tester.getTopLeft(find.text('gemini-flash')).dy;

      expect(gptPos, lessThan(claudePos));
      expect(claudePos, lessThan(cheapPos));
    });
  });

  group('ModelBreakdownTable — sorting', () {
    testWidgets('tapping Calls header sorts by call count', (tester) async {
      await tester.pumpWidget(
          _wrap(const ModelBreakdownTable(models: [_gpt, _claude, _cheap])));

      await tester.tap(find.text('Calls'));
      await tester.pump();

      // After first tap, descending: _cheap (50) > _gpt (10) > _claude (5)
      final cheapPos = tester.getTopLeft(find.text('gemini-flash')).dy;
      final gptPos = tester.getTopLeft(find.text('gpt-4o')).dy;
      expect(cheapPos, lessThan(gptPos));
    });

    testWidgets('tapping Calls twice reverses sort to ascending',
        (tester) async {
      await tester.pumpWidget(
          _wrap(const ModelBreakdownTable(models: [_gpt, _claude, _cheap])));

      await tester.tap(find.text('Calls'));
      await tester.pump();
      await tester.tap(find.text('Calls'));
      await tester.pump();

      // Ascending: _claude (5) first
      final claudePos = tester.getTopLeft(find.text('claude-3-5-sonnet')).dy;
      final cheapPos = tester.getTopLeft(find.text('gemini-flash')).dy;
      expect(claudePos, lessThan(cheapPos));
    });

    testWidgets('tapping Cost header re-sorts by cost', (tester) async {
      await tester.pumpWidget(
          _wrap(const ModelBreakdownTable(models: [_gpt, _claude, _cheap])));

      // Tap Calls first to change sort, then tap Cost to re-sort.
      await tester.tap(find.text('Calls'));
      await tester.pump();
      await tester.tap(find.text('Cost'));
      await tester.pump();

      // Should now be cost-descending: gpt > claude > cheap
      final gptPos = tester.getTopLeft(find.text('gpt-4o')).dy;
      final claudePos = tester.getTopLeft(find.text('claude-3-5-sonnet')).dy;
      expect(gptPos, lessThan(claudePos));
    });

    testWidgets('tapping Latency sorts by latency', (tester) async {
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
          _wrap(const ModelBreakdownTable(models: [_gpt, _claude, _cheap])));

      await tester.tap(find.text('Latency'));
      await tester.pump();

      // Descending latency: _claude (1200) > _gpt (800) > _cheap (200)
      final claudePos = tester.getTopLeft(find.text('claude-3-5-sonnet')).dy;
      final cheapPos = tester.getTopLeft(find.text('gemini-flash')).dy;
      expect(claudePos, lessThan(cheapPos));
    });
  });

  group('ModelBreakdownTable — didUpdateWidget', () {
    testWidgets('updates when models prop changes', (tester) async {
      var models = [_gpt];
      late StateSetter outerSetState;

      await tester.pumpWidget(StatefulBuilder(
        builder: (ctx, setState) {
          outerSetState = setState;
          return _wrap(ModelBreakdownTable(models: models));
        },
      ));

      expect(find.text('gpt-4o'), findsOneWidget);
      expect(find.text('claude-3-5-sonnet'), findsNothing);

      outerSetState(() => models = [_gpt, _claude]);
      await tester.pump();

      expect(find.text('claude-3-5-sonnet'), findsOneWidget);
      expect(find.text('2 models'), findsOneWidget);
    });
  });

  group('ModelBreakdownTable — hover interaction', () {
    testWidgets('hovering a row does not throw', (tester) async {
      await tester.pumpWidget(
          _wrap(const ModelBreakdownTable(models: [_gpt, _claude])));

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer();
      addTearDown(gesture.removePointer);

      await gesture.moveTo(tester.getCenter(find.text('gpt-4o')));
      await tester.pump();

      expect(tester.takeException(), isNull);
    });
  });
}
