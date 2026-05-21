import 'package:candela_desktop/gen/candela/types/user.pbenum.dart';
import 'package:candela_desktop/widgets/scope_toggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildToggle({
    required UserScope scope,
    required ValueChanged<UserScope> onChanged,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: ScopeToggle(scope: scope, onChanged: onChanged),
      ),
    );
  }

  group('ScopeToggle', () {
    testWidgets('renders My and All labels', (tester) async {
      await tester.pumpWidget(buildToggle(
        scope: UserScope.USER_SCOPE_PERSONAL,
        onChanged: (_) {},
      ));

      expect(find.text('My'), findsOneWidget);
      expect(find.text('All'), findsOneWidget);
    });

    testWidgets('tapping All when in PERSONAL fires GLOBAL', (tester) async {
      UserScope? received;
      await tester.pumpWidget(buildToggle(
        scope: UserScope.USER_SCOPE_PERSONAL,
        onChanged: (s) => received = s,
      ));

      await tester.tap(find.text('All'));
      expect(received, UserScope.USER_SCOPE_GLOBAL);
    });

    testWidgets('tapping My when in GLOBAL fires PERSONAL', (tester) async {
      UserScope? received;
      await tester.pumpWidget(buildToggle(
        scope: UserScope.USER_SCOPE_GLOBAL,
        onChanged: (s) => received = s,
      ));

      await tester.tap(find.text('My'));
      expect(received, UserScope.USER_SCOPE_PERSONAL);
    });

    testWidgets('tapping already-active My does not fire callback',
        (tester) async {
      int callCount = 0;
      await tester.pumpWidget(buildToggle(
        scope: UserScope.USER_SCOPE_PERSONAL,
        onChanged: (_) => callCount++,
      ));

      await tester.tap(find.text('My'));
      expect(callCount, 0);
    });

    testWidgets('tapping already-active All does not fire callback',
        (tester) async {
      int callCount = 0;
      await tester.pumpWidget(buildToggle(
        scope: UserScope.USER_SCOPE_GLOBAL,
        onChanged: (_) => callCount++,
      ));

      await tester.tap(find.text('All'));
      expect(callCount, 0);
    });

    testWidgets('active chip uses bold font weight', (tester) async {
      await tester.pumpWidget(buildToggle(
        scope: UserScope.USER_SCOPE_PERSONAL,
        onChanged: (_) {},
      ));

      final myText = tester.widget<Text>(find.text('My'));
      final allText = tester.widget<Text>(find.text('All'));
      expect(myText.style?.fontWeight, FontWeight.w600);
      expect(allText.style?.fontWeight, FontWeight.w400);
    });

    testWidgets('switching scope flips font weights', (tester) async {
      await tester.pumpWidget(buildToggle(
        scope: UserScope.USER_SCOPE_GLOBAL,
        onChanged: (_) {},
      ));

      final myText = tester.widget<Text>(find.text('My'));
      final allText = tester.widget<Text>(find.text('All'));
      expect(myText.style?.fontWeight, FontWeight.w400);
      expect(allText.style?.fontWeight, FontWeight.w600);
    });
  });
}
