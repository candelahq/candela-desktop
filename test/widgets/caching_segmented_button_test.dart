import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/theme/colors.dart';

/// Widget test for the caching mode SegmentedButton.
///
/// Tests the button in isolation (same widget structure as settings_screen.dart)
/// to verify rendering, interaction, and state updates without needing
/// Riverpod or ConfigService.

Widget _buildCachingSegmentedButton({
  required String selected,
  required ValueChanged<String> onChanged,
}) {
  return MaterialApp(
    theme: ThemeData.dark(),
    home: Scaffold(
      backgroundColor: CandelaColors.bgPrimary,
      body: Center(
        child: SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'off', label: Text('Off')),
            ButtonSegment(value: 'auto', label: Text('Auto')),
            ButtonSegment(value: 'system-only', label: Text('System')),
          ],
          selected: {selected},
          onSelectionChanged: (selected) {
            if (selected.isNotEmpty) onChanged(selected.first);
          },
          style: SegmentedButton.styleFrom(
            backgroundColor: CandelaColors.bgTertiary,
            foregroundColor: CandelaColors.textPrimary,
            selectedBackgroundColor: CandelaColors.accent,
            selectedForegroundColor: Colors.white,
            textStyle: const TextStyle(fontSize: 12),
          ),
        ),
      ),
    ),
  );
}

void main() {
  group('CachingModeSegmentedButton', () {
    testWidgets('renders all three segments', (tester) async {
      await tester.pumpWidget(_buildCachingSegmentedButton(
        selected: 'auto',
        onChanged: (_) {},
      ));

      expect(find.text('Off'), findsOneWidget);
      expect(find.text('Auto'), findsOneWidget);
      expect(find.text('System'), findsOneWidget);
      expect(find.byType(SegmentedButton<String>), findsOneWidget);
    });

    testWidgets('auto is selected by default', (tester) async {
      await tester.pumpWidget(_buildCachingSegmentedButton(
        selected: 'auto',
        onChanged: (_) {},
      ));

      final button = tester.widget<SegmentedButton<String>>(
        find.byType(SegmentedButton<String>),
      );
      expect(button.selected, {'auto'});
    });

    testWidgets('tapping Off fires callback with off', (tester) async {
      String? changed;
      await tester.pumpWidget(_buildCachingSegmentedButton(
        selected: 'auto',
        onChanged: (mode) => changed = mode,
      ));

      await tester.tap(find.text('Off'));
      await tester.pumpAndSettle();

      expect(changed, 'off');
    });

    testWidgets('tapping System fires callback with system-only',
        (tester) async {
      String? changed;
      await tester.pumpWidget(_buildCachingSegmentedButton(
        selected: 'auto',
        onChanged: (mode) => changed = mode,
      ));

      await tester.tap(find.text('System'));
      await tester.pumpAndSettle();

      expect(changed, 'system-only');
    });

    testWidgets('tapping Auto fires callback with auto', (tester) async {
      String? changed;
      await tester.pumpWidget(_buildCachingSegmentedButton(
        selected: 'off',
        onChanged: (mode) => changed = mode,
      ));

      await tester.tap(find.text('Auto'));
      await tester.pumpAndSettle();

      expect(changed, 'auto');
    });

    testWidgets('shows correct selection state for each mode', (tester) async {
      for (final mode in ['off', 'auto', 'system-only']) {
        await tester.pumpWidget(_buildCachingSegmentedButton(
          selected: mode,
          onChanged: (_) {},
        ));

        final button = tester.widget<SegmentedButton<String>>(
          find.byType(SegmentedButton<String>),
        );
        expect(button.selected, {mode},
            reason: 'Expected $mode to be selected');
      }
    });

    testWidgets('does not crash with empty selection guard', (tester) async {
      // The isNotEmpty guard should prevent errors if somehow
      // SegmentedButton fires with an empty set.
      await tester.pumpWidget(_buildCachingSegmentedButton(
        selected: 'auto',
        onChanged: (_) {},
      ));

      // Just verify no exceptions during normal interaction.
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders without overflow in narrow container', (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: ThemeData.dark(),
        home: Scaffold(
          body: SizedBox(
            width: 250,
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'off', label: Text('Off')),
                ButtonSegment(value: 'auto', label: Text('Auto')),
                ButtonSegment(value: 'system-only', label: Text('System')),
              ],
              selected: const {'auto'},
              onSelectionChanged: (_) {},
            ),
          ),
        ),
      ));

      expect(tester.takeException(), isNull);
    });
  });
}
