import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:candela_desktop/theme/candela_theme.dart';
import 'package:candela_desktop/models/identity_state.dart';
import 'package:candela_desktop/screens/auth_debug/identity_card.dart';

void main() {
  group('IdentityCard', () {
    Widget buildApp(IdentityState identity) {
      return MaterialApp(
        theme: CandelaTheme.dark,
        home: Scaffold(
          body: IdentityCard(
            identity: identity,
            onRefresh: () {},
          ),
        ),
      );
    }

    testWidgets('shows email when authenticated', (WidgetTester tester) async {
      final identity = IdentityState(
        email: 'alice@example.com',
        project: 'my-project',
        tokenInfo: TokenInfo(
          expiresAt: DateTime.now().add(const Duration(hours: 1)),
          isValid: true,
        ),
        gcloudInstalled: true,
      );

      await tester.pumpWidget(buildApp(identity));
      expect(find.text('alice@example.com'), findsOneWidget);
    });

    testWidgets('shows Not authenticated when no email',
        (WidgetTester tester) async {
      const identity = IdentityState(gcloudInstalled: false);
      await tester.pumpWidget(buildApp(identity));
      expect(find.text('Not authenticated'), findsOneWidget);
    });

    testWidgets('shows GCP project when set', (WidgetTester tester) async {
      final identity = IdentityState(
        email: 'bob@example.com',
        project: 'test-project-123',
        gcloudInstalled: true,
        tokenInfo: TokenInfo(
          expiresAt: DateTime.now().add(const Duration(hours: 1)),
          isValid: true,
        ),
      );

      await tester.pumpWidget(buildApp(identity));
      expect(find.text('GCP Project: test-project-123'), findsOneWidget);
    });

    testWidgets('shows expired token status', (WidgetTester tester) async {
      final identity = IdentityState(
        email: 'user@test.com',
        gcloudInstalled: true,
        tokenInfo: TokenInfo(
          expiresAt: DateTime.now().subtract(const Duration(hours: 1)),
          isValid: false,
        ),
      );

      await tester.pumpWidget(buildApp(identity));
      expect(find.textContaining('Token expired'), findsOneWidget);
    });

    testWidgets('shows no token status', (WidgetTester tester) async {
      const identity = IdentityState(
        email: 'user@test.com',
        gcloudInstalled: true,
      );

      await tester.pumpWidget(buildApp(identity));
      expect(find.textContaining('No token'), findsOneWidget);
    });

    testWidgets('shows ADC badge when present', (WidgetTester tester) async {
      final identity = IdentityState(
        email: 'user@test.com',
        gcloudInstalled: true,
        adcInfo: const AdcInfo(path: '/test', type: 'authorized_user'),
        tokenInfo: TokenInfo(
          expiresAt: DateTime.now().add(const Duration(hours: 1)),
          isValid: true,
        ),
      );

      await tester.pumpWidget(buildApp(identity));
      expect(find.text('Application Default Credentials'), findsOneWidget);
    });

    testWidgets('shows initials in avatar', (WidgetTester tester) async {
      final identity = IdentityState(
        email: 'alice.baker@example.com',
        gcloudInstalled: true,
        tokenInfo: TokenInfo(
          expiresAt: DateTime.now().add(const Duration(hours: 1)),
          isValid: true,
        ),
      );

      await tester.pumpWidget(buildApp(identity));
      expect(find.text('AB'), findsOneWidget);
    });

    testWidgets('shows single initial for simple email',
        (WidgetTester tester) async {
      final identity = IdentityState(
        email: 'alice@example.com',
        gcloudInstalled: true,
        tokenInfo: TokenInfo(
          expiresAt: DateTime.now().add(const Duration(hours: 1)),
          isValid: true,
        ),
      );

      await tester.pumpWidget(buildApp(identity));
      expect(find.text('A'), findsOneWidget);
    });

    testWidgets('shows ? initial when no email', (WidgetTester tester) async {
      const identity = IdentityState(gcloudInstalled: false);
      await tester.pumpWidget(buildApp(identity));
      expect(find.text('?'), findsOneWidget);
    });

    testWidgets('Refresh button is present', (WidgetTester tester) async {
      const identity = IdentityState(gcloudInstalled: true);
      await tester.pumpWidget(buildApp(identity));
      expect(find.text('Refresh'), findsOneWidget);
    });

    testWidgets('ADC Login button is present', (WidgetTester tester) async {
      const identity = IdentityState(gcloudInstalled: true);
      await tester.pumpWidget(buildApp(identity));
      expect(find.text('ADC Login'), findsOneWidget);
    });
  });
}
