import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/widgets/model_selector_dropdown.dart';
import 'package:candela_desktop/theme/candela_theme.dart';

Widget _wrap(Widget child) => MaterialApp(
      theme: CandelaTheme.dark,
      home: Scaffold(body: Center(child: child)),
    );

void main() {
  group('ModelSelectorDropdown', () {
    testWidgets('shows "All Models" hint when selected is null',
        (tester) async {
      await tester.pumpWidget(_wrap(ModelSelectorDropdown(
        models: const ['gpt-4', 'claude-3'],
        selected: null,
        onChanged: (_) {},
      )));

      // The hint "All Models" is shown
      expect(find.text('All Models'), findsOneWidget);
    });

    testWidgets('shows selected model name when selected is non-null',
        (tester) async {
      await tester.pumpWidget(_wrap(ModelSelectorDropdown(
        models: const ['gpt-4', 'claude-3'],
        selected: 'gpt-4',
        onChanged: (_) {},
      )));

      // The selected value is displayed (may appear twice — once as the
      // dropdown button text and once in the hidden menu item).
      expect(find.text('gpt-4'), findsWidgets);
    });

    testWidgets('works with empty models list', (tester) async {
      await tester.pumpWidget(_wrap(ModelSelectorDropdown(
        models: const [],
        selected: null,
        onChanged: (_) {},
      )));

      // Should still render without error
      expect(find.byType(ModelSelectorDropdown), findsOneWidget);
      expect(find.text('All Models'), findsOneWidget);
    });

    testWidgets('calls onChanged with model name when a model is tapped',
        (tester) async {
      String? changedValue = 'sentinel';

      await tester.pumpWidget(_wrap(ModelSelectorDropdown(
        models: const ['gpt-4', 'claude-3'],
        selected: null,
        onChanged: (value) => changedValue = value,
      )));

      // Open the dropdown
      await tester.tap(find.byType(ModelSelectorDropdown));
      await tester.pumpAndSettle();

      // Tap a model — "claude-3" will be in the overlay menu
      await tester.tap(find.text('claude-3').last);
      await tester.pumpAndSettle();

      expect(changedValue, 'claude-3');
    });

    testWidgets('calls onChanged(null) when "All Models" is tapped',
        (tester) async {
      String? changedValue = 'sentinel';

      await tester.pumpWidget(_wrap(ModelSelectorDropdown(
        models: const ['gpt-4', 'claude-3'],
        selected: 'gpt-4',
        onChanged: (value) => changedValue = value,
      )));

      // Open the dropdown
      await tester.tap(find.byType(ModelSelectorDropdown));
      await tester.pumpAndSettle();

      // Tap "All Models" (the null-value item) — use .last since the
      // dropdown button also contains text matching the selected value
      await tester.tap(find.text('All Models').last);
      await tester.pumpAndSettle();

      expect(changedValue, isNull);
    });
  });
}
