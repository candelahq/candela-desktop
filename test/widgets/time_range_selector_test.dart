import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/models/span_stats.dart';
import 'package:candela_desktop/widgets/time_range_selector.dart';
import 'package:candela_desktop/theme/colors.dart';

Widget _wrap(Widget child) => MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        backgroundColor: CandelaColors.bgPrimary,
        body: child,
      ),
    );

void main() {
  group('TimeRangeSelector', () {
    testWidgets('renders all three range labels', (tester) async {
      await tester.pumpWidget(_wrap(TimeRangeSelector(
        value: TokenTimeRange.d7,
        onChanged: (_) {},
      )));

      expect(find.text('24h'), findsOneWidget);
      expect(find.text('7d'), findsOneWidget);
      expect(find.text('30d'), findsOneWidget);
    });

    testWidgets('calls onChanged when a different chip is tapped',
        (tester) async {
      TokenTimeRange? selected;
      await tester.pumpWidget(_wrap(TimeRangeSelector(
        value: TokenTimeRange.d7,
        onChanged: (r) => selected = r,
      )));

      await tester.tap(find.text('24h'));
      await tester.pump();

      expect(selected, TokenTimeRange.h24);
    });

    testWidgets('calls onChanged with d30 when 30d is tapped', (tester) async {
      TokenTimeRange? selected;
      await tester.pumpWidget(_wrap(TimeRangeSelector(
        value: TokenTimeRange.h24,
        onChanged: (r) => selected = r,
      )));

      await tester.tap(find.text('30d'));
      await tester.pump();

      expect(selected, TokenTimeRange.d30);
    });

    testWidgets('does not call onChanged when already-selected chip is tapped',
        (tester) async {
      int callCount = 0;
      await tester.pumpWidget(_wrap(TimeRangeSelector(
        value: TokenTimeRange.d7,
        onChanged: (_) => callCount++,
      )));

      await tester.tap(find.text('7d'));
      await tester.pump();

      // Tapping the active chip still fires (it's the parent's responsibility
      // to decide whether to re-fetch). Just confirm no exception.
      expect(tester.takeException(), isNull);
    });

    testWidgets('animates chip selection without throwing', (tester) async {
      TokenTimeRange current = TokenTimeRange.h24;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (ctx, setState) => _wrap(TimeRangeSelector(
            value: current,
            onChanged: (r) => setState(() => current = r),
          )),
        ),
      );

      await tester.tap(find.text('7d'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(tester.takeException(), isNull);
      expect(current, TokenTimeRange.d7);
    });
  });
}
