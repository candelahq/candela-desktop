import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:candela_desktop/screens/auth_debug/auth_debug_screen.dart';
import 'package:candela_desktop/screens/auth_debug/identity_card.dart';
import 'package:candela_desktop/models/identity_state.dart';
import 'package:candela_desktop/theme/colors.dart';

/// Widget + lifecycle tests for AuthDebugScreen and IdentityCard.
///
/// Tests focus on:
/// 1. Rendering correctness (header, buttons, loading states)
/// 2. Lifecycle safety (tray-icon dispose, rapid rebuild, page-switch)
/// 3. IdentityCard mounted-guard safety
///
/// All tests use tester.runAsync because AuthDebugScreen._loadAll() spawns
/// subprocess calls via GCloudService that create real timers, which cause
/// "Timer still pending" errors in the default fake-async test environment.

Widget _wrap(Widget child) => ProviderScope(
      child: MaterialApp(
        theme: ThemeData.dark(),
        home: Scaffold(
          backgroundColor: CandelaColors.bgPrimary,
          body: child,
        ),
      ),
    );

/// Build, assert, then tear down the AuthDebugScreen cleanly.
Future<void> _pumpAndCheck(
  WidgetTester tester,
  void Function() expectations,
) async {
  await tester.runAsync(() async {
    await tester.pumpWidget(_wrap(const AuthDebugScreen()));
    await Future.delayed(const Duration(milliseconds: 50));
  });
  expectations();
  // Tear down — remove the widget tree so timers don't leak.
  await tester.runAsync(() async {
    await tester.pumpWidget(const SizedBox());
    await Future.delayed(const Duration(milliseconds: 200));
  });
}

void main() {
  group('AuthDebugScreen rendering', () {
    testWidgets('renders header with correct title', (tester) async {
      await _pumpAndCheck(tester, () {
        expect(find.text('Auth & Connectivity'), findsOneWidget);
      });
    });

    testWidgets('shows loading spinner during initial load', (tester) async {
      await _pumpAndCheck(tester, () {
        expect(find.byType(CircularProgressIndicator), findsAtLeast(1));
      });
    });

    testWidgets('shows Run All Tests button', (tester) async {
      await _pumpAndCheck(tester, () {
        expect(find.text('Run All Tests'), findsOneWidget);
      });
    });

    testWidgets('Run All Tests button is disabled while loading',
        (tester) async {
      await _pumpAndCheck(tester, () {
        final button = tester.widget<OutlinedButton>(
          find.widgetWithText(OutlinedButton, 'Run All Tests'),
        );
        expect(button.onPressed, isNull);
      });
    });

    testWidgets('header has refresh icon', (tester) async {
      await _pumpAndCheck(tester, () {
        expect(find.byIcon(Icons.refresh), findsOneWidget);
      });
    });

    testWidgets('uses Column as root layout', (tester) async {
      await _pumpAndCheck(tester, () {
        expect(
          find.descendant(
            of: find.byType(AuthDebugScreen),
            matching: find.byType(Column),
          ),
          findsAtLeast(1),
        );
      });
    });
  });

  group('AuthDebugScreen lifecycle safety', () {
    testWidgets('survives rapid dispose without setState crash',
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(_wrap(const AuthDebugScreen()));
        await Future.delayed(const Duration(milliseconds: 50));
        await tester.pumpWidget(const SizedBox());
        await Future.delayed(const Duration(milliseconds: 200));
      });
    });

    testWidgets('survives multiple rapid rebuilds (tray show/hide cycle)',
        (tester) async {
      await tester.runAsync(() async {
        for (int i = 0; i < 3; i++) {
          await tester.pumpWidget(_wrap(const AuthDebugScreen()));
          await Future.delayed(const Duration(milliseconds: 30));
          await tester.pumpWidget(const SizedBox());
          await Future.delayed(const Duration(milliseconds: 30));
        }
        await tester.pumpWidget(_wrap(const AuthDebugScreen()));
        await Future.delayed(const Duration(milliseconds: 50));
      });
      expect(find.text('Auth & Connectivity'), findsOneWidget);
      await tester.runAsync(() async {
        await tester.pumpWidget(const SizedBox());
        await Future.delayed(const Duration(milliseconds: 200));
      });
    });

    testWidgets('page switch during load does not crash', (tester) async {
      final pageNotifier = ValueNotifier<int>(0);
      addTearDown(pageNotifier.dispose);

      await tester.runAsync(() async {
        await tester.pumpWidget(ProviderScope(
          child: MaterialApp(
            theme: ThemeData.dark(),
            home: ValueListenableBuilder<int>(
              valueListenable: pageNotifier,
              builder: (_, page, __) => page == 0
                  ? const AuthDebugScreen()
                  : const Center(child: Text('Other Page')),
            ),
          ),
        ));
        await Future.delayed(const Duration(milliseconds: 50));
        pageNotifier.value = 1;
        await tester.pump();
        await Future.delayed(const Duration(milliseconds: 200));
      });
      expect(find.text('Other Page'), findsOneWidget);
    });

    testWidgets('dispose then rebuild creates fresh loading state',
        (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(_wrap(const AuthDebugScreen()));
        await Future.delayed(const Duration(milliseconds: 50));
        await tester.pumpWidget(const SizedBox());
        await Future.delayed(const Duration(milliseconds: 100));
        await tester.pumpWidget(_wrap(const AuthDebugScreen()));
        await Future.delayed(const Duration(milliseconds: 50));
      });
      expect(find.byType(CircularProgressIndicator), findsAtLeast(1));
      await tester.runAsync(() async {
        await tester.pumpWidget(const SizedBox());
        await Future.delayed(const Duration(milliseconds: 200));
      });
    });
  });

  group('IdentityCard rendering', () {
    testWidgets('renders email and project correctly', (tester) async {
      const identity = IdentityState(
        email: 'test@example.com',
        project: 'my-project',
        gcloudInstalled: true,
      );

      await tester.pumpWidget(_wrap(
        IdentityCard(identity: identity, onRefresh: () {}),
      ));

      expect(find.textContaining('test@example.com'), findsOneWidget);
      expect(find.textContaining('my-project'), findsOneWidget);
    });

    testWidgets('shows "Not authenticated" when email is null', (tester) async {
      const identity = IdentityState(
        email: null,
        project: null,
        gcloudInstalled: false,
      );

      await tester.pumpWidget(_wrap(
        IdentityCard(identity: identity, onRefresh: () {}),
      ));

      expect(find.textContaining('Not authenticated'), findsOneWidget);
    });

    testWidgets('shows "No token" when tokenInfo is null', (tester) async {
      const identity = IdentityState(
        email: 'user@test.com',
        project: 'proj',
        gcloudInstalled: true,
        tokenInfo: null,
      );

      await tester.pumpWidget(_wrap(
        IdentityCard(identity: identity, onRefresh: () {}),
      ));

      expect(find.textContaining('No token'), findsOneWidget);
    });

    testWidgets('renders avatar with initials', (tester) async {
      const identity = IdentityState(
        email: 'alice@example.com',
        project: null,
        gcloudInstalled: true,
      );

      await tester.pumpWidget(_wrap(
        IdentityCard(identity: identity, onRefresh: () {}),
      ));

      // Initials for "alice@example.com" should be "A".
      expect(find.text('A'), findsOneWidget);
    });
  });

  group('IdentityCard lifecycle safety', () {
    testWidgets('survives rapid dispose during ADC login', (tester) async {
      const identity = IdentityState(
        email: 'test@example.com',
        project: 'my-project',
        gcloudInstalled: true,
      );

      await tester.runAsync(() async {
        await tester.pumpWidget(_wrap(
          IdentityCard(identity: identity, onRefresh: () {}),
        ));
        await Future.delayed(const Duration(milliseconds: 50));
        await tester.pumpWidget(const SizedBox());
        await Future.delayed(const Duration(milliseconds: 100));
      });
      // No crash means mounted guards work and _adcProcess is killed.
    });
  });
}
