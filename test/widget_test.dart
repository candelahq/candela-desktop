import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:candela_desktop/theme/candela_theme.dart';

void main() {
  testWidgets('CandelaTheme applies dark theme', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: CandelaTheme.dark,
        home: const Scaffold(body: Text('Candela')),
      ),
    );
    expect(find.text('Candela'), findsOneWidget);
  });
}
