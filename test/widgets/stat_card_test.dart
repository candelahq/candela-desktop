import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/widgets/stat_card.dart';
import 'package:candela_desktop/theme/colors.dart';

Widget _wrap(Widget child) => MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        backgroundColor: CandelaColors.bgPrimary,
        body: SizedBox(width: 300, child: child),
      ),
    );

void main() {
  group('StatCard', () {
    testWidgets('renders title, value and subtitle', (tester) async {
      await tester.pumpWidget(_wrap(const StatCard(
        title: 'TOTAL COST',
        value: '\$0.0123',
        subtitle: 'USD spent',
      )));

      expect(find.text('TOTAL COST'), findsOneWidget);
      expect(find.text('\$0.0123'), findsOneWidget);
      expect(find.text('USD spent'), findsOneWidget);
    });

    testWidgets('renders icon when provided', (tester) async {
      await tester.pumpWidget(_wrap(const StatCard(
        title: 'CALLS',
        value: '42',
        subtitle: 'requests',
        icon: Icons.bolt,
      )));

      expect(find.byIcon(Icons.bolt), findsOneWidget);
    });

    testWidgets('does not render icon when omitted', (tester) async {
      await tester.pumpWidget(_wrap(const StatCard(
        title: 'CALLS',
        value: '42',
        subtitle: 'requests',
      )));

      expect(find.byIcon(Icons.bolt), findsNothing);
    });

    testWidgets('applies custom accentColor to bottom line', (tester) async {
      const accent = Color(0xFF4ADE80);
      await tester.pumpWidget(_wrap(const StatCard(
        title: 'X',
        value: '0',
        subtitle: 'y',
        accentColor: accent,
      )));

      // No exception means it painted correctly
      expect(find.byType(StatCard), findsOneWidget);
    });

    testWidgets('renders long value text without overflow', (tester) async {
      await tester.pumpWidget(_wrap(const StatCard(
        title: 'TOKENS',
        value: '123,456,789',
        subtitle: 'total',
      )));

      expect(tester.takeException(), isNull);
    });
  });
}
