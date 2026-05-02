import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/app.dart';

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const CandelaApp());
    expect(find.text('Candela'), findsOneWidget);
  });
}
