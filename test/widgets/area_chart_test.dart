import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/models/span_stats.dart';
import 'package:candela_desktop/widgets/area_chart.dart';
import 'package:candela_desktop/theme/colors.dart';

// ── Helpers ──────────────────────────────────────────────────────────────────

Widget _wrap(Widget child) => MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        backgroundColor: CandelaColors.bgPrimary,
        body: SizedBox(width: 600, height: 400, child: child),
      ),
    );

List<TimeSeriesPoint> _points(int n, {double base = 1.0}) => List.generate(
      n,
      (i) => TimeSeriesPoint(label: '${i}h', value: base + i.toDouble()),
    );

List<TimeSeriesPoint> _zeroPoints(int n) => List.generate(
      n,
      (i) => const TimeSeriesPoint(label: 'x', value: 0),
    );

CandelaAreaChart _chart({
  List<TimeSeriesPoint>? data,
  double height = 200,
  Color color = Colors.green,
  String emptyMessage = 'No data yet',
}) =>
    CandelaAreaChart(
      data: data ?? _points(24),
      height: height,
      color: color,
      formatValue: (v) => '\$${v.toStringAsFixed(2)}',
      emptyMessage: emptyMessage,
    );

// ── Empty / zero-value states ─────────────────────────────────────────────────

void main() {
  group('CandelaAreaChart — empty state', () {
    testWidgets('shows emptyMessage when data is empty', (tester) async {
      await tester.pumpWidget(_wrap(_chart(data: [])));
      expect(find.text('No data yet'), findsOneWidget);
    });

    testWidgets('shows emptyMessage when all values are zero', (tester) async {
      await tester.pumpWidget(_wrap(_chart(data: _zeroPoints(24))));
      expect(find.text('No data yet'), findsOneWidget);
    });

    testWidgets('custom emptyMessage is shown', (tester) async {
      await tester
          .pumpWidget(_wrap(_chart(data: [], emptyMessage: 'No cost data')));
      expect(find.text('No cost data'), findsOneWidget);
    });

    testWidgets('empty state uses the requested height', (tester) async {
      await tester.pumpWidget(_wrap(_chart(data: [], height: 150)));
      // The CandelaAreaChart wraps the empty message in a SizedBox with height=150.
      // We look for SizedBoxes whose height matches.
      final boxes = tester
          .widgetList<SizedBox>(find.byType(SizedBox))
          .where((b) => b.height == 150.0);
      expect(boxes, isNotEmpty);
    });
  });

  // ── Data rendering ────────────────────────────────────────────────────────

  group('CandelaAreaChart — with data', () {
    testWidgets('renders CustomPaint when data has non-zero values',
        (tester) async {
      await tester.pumpWidget(_wrap(_chart()));
      // Scaffold adds its own CustomPaint; our chart adds at least one more.
      expect(find.byType(CustomPaint), findsWidgets);
      // Specifically, CandelaAreaChart's CustomPaint is present.
      expect(
          find.descendant(
            of: find.byType(CandelaAreaChart),
            matching: find.byType(CustomPaint),
          ),
          findsOneWidget);
    });

    testWidgets('renders MouseRegion for hover interaction', (tester) async {
      await tester.pumpWidget(_wrap(_chart()));
      // MouseRegion is used by CandelaAreaChart for hover.
      expect(
          find.descendant(
            of: find.byType(CandelaAreaChart),
            matching: find.byType(MouseRegion),
          ),
          findsOneWidget);
    });

    testWidgets('renders with a single data point without throwing',
        (tester) async {
      await tester.pumpWidget(_wrap(
          _chart(data: [const TimeSeriesPoint(label: '00:00', value: 5.0)])));
      expect(tester.takeException(), isNull);
      expect(
          find.descendant(
            of: find.byType(CandelaAreaChart),
            matching: find.byType(CustomPaint),
          ),
          findsOneWidget);
    });

    testWidgets('renders with two data points without throwing',
        (tester) async {
      await tester.pumpWidget(_wrap(_chart(data: [
        const TimeSeriesPoint(label: '00:00', value: 1.0),
        const TimeSeriesPoint(label: '01:00', value: 2.0),
      ])));
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders 24-bucket dataset without throwing', (tester) async {
      await tester.pumpWidget(_wrap(_chart(data: _points(24))));
      expect(tester.takeException(), isNull);
    });

    testWidgets('different color does not throw', (tester) async {
      await tester.pumpWidget(
          _wrap(_chart(data: _points(8), color: const Color(0xFF60A5FA))));
      expect(tester.takeException(), isNull);
    });

    testWidgets('large values render correctly', (tester) async {
      final bigData = List.generate(
          24, (i) => TimeSeriesPoint(label: '$i', value: 1000000.0 * i));
      await tester.pumpWidget(_wrap(_chart(data: bigData)));
      expect(tester.takeException(), isNull);
    });

    testWidgets('tiny fractional values render correctly', (tester) async {
      final tinyData = List.generate(
          24, (i) => TimeSeriesPoint(label: '$i', value: 0.00001 * (i + 1)));
      await tester.pumpWidget(_wrap(_chart(data: tinyData)));
      expect(tester.takeException(), isNull);
    });
  });

  // ── Hover interaction ─────────────────────────────────────────────────────

  group('CandelaAreaChart — hover interaction', () {
    // Full gesture-based hover (context.size in setState) needs a real render
    // pass and is integration-test territory. Here we verify structural invariants.

    testWidgets('no tooltip visible before any hover', (tester) async {
      await tester.pumpWidget(_wrap(_chart(data: _points(24))));
      expect(find.byType(Positioned), findsNothing);
    });

    testWidgets('MouseRegion is present inside chart', (tester) async {
      await tester.pumpWidget(_wrap(_chart(data: _points(24))));
      expect(
          find.descendant(
            of: find.byType(CandelaAreaChart),
            matching: find.byType(MouseRegion),
          ),
          findsOneWidget);
    });

    testWidgets('Stack is used for tooltip overlay layer', (tester) async {
      await tester.pumpWidget(_wrap(_chart(data: _points(24))));
      expect(
          find.descendant(
            of: find.byType(CandelaAreaChart),
            matching: find.byType(Stack),
          ),
          findsOneWidget);
    });

    testWidgets('chart stays mounted through multiple pump cycles',
        (tester) async {
      await tester.pumpWidget(_wrap(_chart(data: _points(24))));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(CandelaAreaChart), findsOneWidget);
    });
  });

  // ── Height constraint ─────────────────────────────────────────────────────

  group('CandelaAreaChart — layout', () {
    testWidgets('chart respects custom height with data', (tester) async {
      await tester.pumpWidget(_wrap(_chart(data: _points(8), height: 120)));
      // SizedBox with height 120 should exist.
      final sizedBoxes = tester
          .widgetList<SizedBox>(find.byType(SizedBox))
          .where((b) => b.height == 120.0);
      expect(sizedBoxes, isNotEmpty);
    });

    testWidgets('updates when data changes', (tester) async {
      List<TimeSeriesPoint> data = _points(24);
      late StateSetter outerSetState;

      await tester.pumpWidget(StatefulBuilder(builder: (ctx, setState) {
        outerSetState = setState;
        return _wrap(CandelaAreaChart(
          data: data,
          height: 200,
          color: Colors.blue,
          formatValue: (v) => '${v.round()}',
          emptyMessage: 'empty',
        ));
      }));

      expect(
          find.descendant(
            of: find.byType(CandelaAreaChart),
            matching: find.byType(CustomPaint),
          ),
          findsOneWidget);

      outerSetState(() => data = []);
      await tester.pump();

      expect(find.text('empty'), findsOneWidget);
    });
  });
}
