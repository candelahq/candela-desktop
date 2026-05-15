import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:candela_desktop/screens/today/today_screen.dart';
import 'package:candela_desktop/theme/colors.dart';

/// Widget tests for TodayScreen — tests the rendering and structural
/// correctness of the Today page at different data states.

Widget _wrap(Widget child) => ProviderScope(
      child: MaterialApp(
        theme: ThemeData.dark(),
        home: Scaffold(
          backgroundColor: CandelaColors.bgPrimary,
          body: child,
        ),
      ),
    );

void main() {
  group('TodayScreen', () {
    testWidgets('renders and shows loading state', (tester) async {
      await tester.pumpWidget(_wrap(const TodayScreen()));
      // During init, it shows at least one loading spinner.
      expect(find.byType(CircularProgressIndicator), findsAtLeast(1));
    });

    testWidgets('shows Today title in header', (tester) async {
      await tester.pumpWidget(_wrap(const TodayScreen()));
      expect(find.text('Today'), findsOneWidget);
    });

    testWidgets('shows Local badge by default', (tester) async {
      await tester.pumpWidget(_wrap(const TodayScreen()));
      // The mode badge shows "Local" when config is local mode.
      expect(find.text('Local'), findsOneWidget);
    });

    testWidgets('shows date in header', (tester) async {
      await tester.pumpWidget(_wrap(const TodayScreen()));
      // DateFormat.yMMMMEEEEd() produces e.g. "Wednesday, May 14, 2026"
      final now = DateTime.now();
      // Just verify a month name substring is present (locale-aware).
      final months = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ];
      expect(find.textContaining(months[now.month - 1]), findsOneWidget);
    });
  });
}
