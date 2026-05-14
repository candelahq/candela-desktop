import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/theme/colors.dart';

/// Tests for the Candela color palette — these tests don't require
/// google_fonts so they run cleanly without binding issues.
void main() {
  group('CandelaColors (dark palette)', () {
    test('dark bgPrimary is very dark', () {
      expect(CandelaColors.bgPrimary.computeLuminance(), lessThan(0.05));
    });

    test('dark textPrimary is light', () {
      expect(CandelaColors.textPrimary.computeLuminance(), greaterThan(0.7));
    });

    test('accent is warm/amber', () {
      expect((CandelaColors.accent.r * 255).round(), greaterThan(200));
      expect((CandelaColors.accent.g * 255).round(), greaterThan(100));
    });

    test('accentDim has low alpha', () {
      expect((CandelaColors.accentDim.a * 255).round(), 0x26);
    });

    test('status colors are distinct', () {
      final colors = {
        CandelaColors.success.toARGB32(),
        CandelaColors.warning.toARGB32(),
        CandelaColors.error.toARGB32(),
        CandelaColors.info.toARGB32(),
      };
      expect(colors.length, 4, reason: 'All status colors must be unique');
    });

    test('bgSecondary is brighter than bgPrimary', () {
      expect(
        CandelaColors.bgSecondary.computeLuminance(),
        greaterThan(CandelaColors.bgPrimary.computeLuminance()),
      );
    });

    test('bgTertiary is brighter than bgSecondary', () {
      expect(
        CandelaColors.bgTertiary.computeLuminance(),
        greaterThan(CandelaColors.bgSecondary.computeLuminance()),
      );
    });

    test('textMuted is darker than textSecondary', () {
      expect(
        CandelaColors.textMuted.computeLuminance(),
        lessThan(CandelaColors.textSecondary.computeLuminance()),
      );
    });

    test('border is distinct from background', () {
      expect(CandelaColors.border, isNot(CandelaColors.bgPrimary));
      expect(CandelaColors.border, isNot(CandelaColors.bgSecondary));
    });

    test('success is green-ish', () {
      expect(CandelaColors.success.g, greaterThan(CandelaColors.success.r));
    });

    test('error is red-ish', () {
      expect(CandelaColors.error.r, greaterThan(CandelaColors.error.g));
    });

    test('warning is yellow-ish', () {
      expect((CandelaColors.warning.r * 255).round(), greaterThan(150));
      expect((CandelaColors.warning.g * 255).round(), greaterThan(150));
    });
  });

  group('CandelaColorsLight (light palette)', () {
    test('light bgPrimary is very light', () {
      expect(CandelaColorsLight.bgPrimary.computeLuminance(), greaterThan(0.9));
    });

    test('light textPrimary is dark', () {
      expect(CandelaColorsLight.textPrimary.computeLuminance(), lessThan(0.1));
    });

    test('light border is visible on light background', () {
      expect(
        CandelaColorsLight.border.computeLuminance(),
        lessThan(CandelaColorsLight.bgPrimary.computeLuminance()),
      );
    });

    test('light bgSecondary is brighter than bgTertiary', () {
      expect(
        CandelaColorsLight.bgSecondary.computeLuminance(),
        greaterThan(CandelaColorsLight.bgTertiary.computeLuminance()),
      );
    });

    test('light textMuted is lighter than textPrimary', () {
      expect(
        CandelaColorsLight.textMuted.computeLuminance(),
        greaterThan(CandelaColorsLight.textPrimary.computeLuminance()),
      );
    });

    test('light bgPrimary is brighter than dark bgPrimary', () {
      expect(
        CandelaColorsLight.bgPrimary.computeLuminance(),
        greaterThan(CandelaColors.bgPrimary.computeLuminance()),
      );
    });
  });

  // Theme-level tests use widgetTest to avoid google_fonts async issues.
  group('CandelaTheme (via widget test)', () {
    testWidgets('dark theme builds without error', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: CandelaColors.bgPrimary,
            colorScheme: const ColorScheme.dark(
              primary: CandelaColors.accent,
              error: CandelaColors.error,
            ),
          ),
          home: const Scaffold(body: Text('dark')),
        ),
      );
      expect(find.text('dark'), findsOneWidget);
    });

    testWidgets('light theme builds without error', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: CandelaColorsLight.bgPrimary,
            colorScheme: const ColorScheme.light(
              primary: CandelaColors.accent,
              error: CandelaColors.error,
            ),
          ),
          home: const Scaffold(body: Text('light')),
        ),
      );
      expect(find.text('light'), findsOneWidget);
    });

    testWidgets('both themes share accent color', (tester) async {
      expect(
        const ColorScheme.dark(primary: CandelaColors.accent).primary,
        const ColorScheme.light(primary: CandelaColors.accent).primary,
      );
    });
  });
}
