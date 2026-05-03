import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:candela_desktop/theme/colors.dart';
import 'package:candela_desktop/theme/candela_theme.dart';

void main() {
  group('CandelaColors', () {
    test('all color constants are non-null', () {
      // Verify all colors exist and are valid.
      expect(CandelaColors.bgPrimary, isA<Color>());
      expect(CandelaColors.bgSecondary, isA<Color>());
      expect(CandelaColors.bgTertiary, isA<Color>());
      expect(CandelaColors.bgElevated, isA<Color>());
      expect(CandelaColors.bgHover, isA<Color>());
      expect(CandelaColors.textPrimary, isA<Color>());
      expect(CandelaColors.textSecondary, isA<Color>());
      expect(CandelaColors.textMuted, isA<Color>());
      expect(CandelaColors.border, isA<Color>());
      expect(CandelaColors.borderSubtle, isA<Color>());
      expect(CandelaColors.accent, isA<Color>());
      expect(CandelaColors.accentDim, isA<Color>());
      expect(CandelaColors.accentHover, isA<Color>());
      expect(CandelaColors.success, isA<Color>());
      expect(CandelaColors.warning, isA<Color>());
      expect(CandelaColors.error, isA<Color>());
      expect(CandelaColors.info, isA<Color>());
    });

    test('accent dim has reduced opacity', () {
      expect(CandelaColors.accentDim.a, lessThan(0.5));
    });

    test('status colors are distinct', () {
      final statusColors = {
        CandelaColors.success,
        CandelaColors.warning,
        CandelaColors.error,
        CandelaColors.info,
      };
      expect(statusColors.length, 4,
          reason: 'Status colors should all be distinct');
    });
  });

  group('CandelaTheme', () {
    testWidgets('dark theme has dark brightness', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CandelaTheme.dark,
          home: const Scaffold(body: Text('test')),
        ),
      );
      final theme = Theme.of(tester.element(find.text('test')));
      expect(theme.brightness, Brightness.dark);
    });

    testWidgets('scaffold uses bgPrimary', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CandelaTheme.dark,
          home: const Scaffold(body: Text('test')),
        ),
      );
      final theme = Theme.of(tester.element(find.text('test')));
      expect(theme.scaffoldBackgroundColor, CandelaColors.bgPrimary);
    });

    testWidgets('card theme has zero elevation', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CandelaTheme.dark,
          home: const Scaffold(body: Text('test')),
        ),
      );
      final theme = Theme.of(tester.element(find.text('test')));
      expect(theme.cardTheme.elevation, 0);
    });

    testWidgets('accent color is Candela amber', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CandelaTheme.dark,
          home: const Scaffold(body: Text('test')),
        ),
      );
      final theme = Theme.of(tester.element(find.text('test')));
      expect(theme.colorScheme.primary, CandelaColors.accent);
    });
  });
}
