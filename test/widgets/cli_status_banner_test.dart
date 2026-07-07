import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/widgets/cli_status_banner.dart';
import 'package:candela_desktop/theme/candela_theme.dart';

Widget _wrap(Widget child) => MaterialApp(
      theme: CandelaTheme.dark,
      home: Scaffold(body: child),
    );

void main() {
  group('CliStatusBanner', () {
    testWidgets('returns SizedBox.shrink when installed, up to date, no error',
        (tester) async {
      await tester.pumpWidget(_wrap(const CliStatusBanner(
        isInstalled: true,
        installedVersion: '1.0.0',
        latestVersion: '1.0.0',
        isBrewAvailable: true,
      )));

      expect(find.byType(SizedBox), findsOneWidget);
      // No banner content visible
      expect(find.byType(TextButton), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('shows error banner with error message and Dismiss button',
        (tester) async {
      await tester.pumpWidget(_wrap(const CliStatusBanner(
        isInstalled: true,
        installedVersion: '1.0.0',
        latestVersion: '1.0.0',
        isBrewAvailable: true,
        error: 'Something went wrong',
      )));

      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.text('Dismiss'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets(
        'shows brew-not-available warning on macOS, generic CLI message on other platforms',
        (tester) async {
      await tester.pumpWidget(_wrap(const CliStatusBanner(
        isInstalled: false,
        isBrewAvailable: false,
      )));

      if (Platform.isMacOS) {
        expect(find.textContaining('Homebrew is required'), findsOneWidget);
        expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
        // No action button
        expect(find.byType(TextButton), findsNothing);
      } else {
        // On non-macOS, brew warning is suppressed; falls through to
        // "not installed" banner instead.
        expect(find.textContaining('Candela CLI is required'), findsOneWidget);
        expect(find.byIcon(Icons.download_rounded), findsOneWidget);
      }
    });

    testWidgets('shows Install button when !isInstalled && isBrewAvailable',
        (tester) async {
      await tester.pumpWidget(_wrap(const CliStatusBanner(
        isInstalled: false,
        isBrewAvailable: true,
      )));

      if (Platform.isMacOS) {
        expect(find.text('Install via Homebrew'), findsOneWidget);
      } else {
        // On non-macOS, button label is null — no install button shown.
        expect(find.text('Install via Homebrew'), findsNothing);
      }
      expect(find.byIcon(Icons.download_rounded), findsOneWidget);
    });

    testWidgets('shows upgrade banner with version text when _hasUpgrade',
        (tester) async {
      await tester.pumpWidget(_wrap(const CliStatusBanner(
        isInstalled: true,
        installedVersion: '1.0.0',
        latestVersion: '2.0.0',
        isBrewAvailable: true,
      )));

      expect(find.textContaining('v1.0.0'), findsOneWidget);
      expect(find.textContaining('v2.0.0'), findsOneWidget);
      expect(find.text('Upgrade'), findsOneWidget);
      expect(find.byIcon(Icons.upgrade_rounded), findsOneWidget);
    });

    testWidgets('shows CircularProgressIndicator when isLoading is true',
        (tester) async {
      await tester.pumpWidget(_wrap(const CliStatusBanner(
        isInstalled: false,
        isBrewAvailable: true,
        isLoading: true,
      )));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // Button should be hidden when loading
      expect(find.byType(TextButton), findsNothing);
    });

    testWidgets('Dismiss button calls onDismissError callback', (tester) async {
      var dismissed = false;

      await tester.pumpWidget(_wrap(CliStatusBanner(
        isInstalled: true,
        installedVersion: '1.0.0',
        latestVersion: '1.0.0',
        isBrewAvailable: true,
        error: 'Oops',
        onDismissError: () => dismissed = true,
      )));

      await tester.tap(find.text('Dismiss'));
      expect(dismissed, isTrue);
    });

    testWidgets('action button calls onAction callback on macOS',
        (tester) async {
      var actionCalled = false;

      await tester.pumpWidget(_wrap(CliStatusBanner(
        isInstalled: false,
        isBrewAvailable: true,
        onAction: () => actionCalled = true,
      )));

      if (Platform.isMacOS) {
        await tester.tap(find.text('Install via Homebrew'));
        expect(actionCalled, isTrue);
      } else {
        // On non-macOS, no install button is shown.
        expect(find.text('Install via Homebrew'), findsNothing);
      }
    });

    testWidgets('shows correct icon for each state', (tester) async {
      // Error state
      await tester.pumpWidget(_wrap(const CliStatusBanner(
        isInstalled: true,
        isBrewAvailable: true,
        error: 'err',
      )));
      expect(find.byIcon(Icons.error_outline), findsOneWidget);

      // Brew not available
      await tester.pumpWidget(_wrap(const CliStatusBanner(
        isInstalled: false,
        isBrewAvailable: false,
      )));
      if (Platform.isMacOS) {
        expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
      } else {
        // Falls through to "not installed" on non-macOS.
        expect(find.byIcon(Icons.download_rounded), findsOneWidget);
      }

      // Not installed
      await tester.pumpWidget(_wrap(const CliStatusBanner(
        isInstalled: false,
        isBrewAvailable: true,
      )));
      expect(find.byIcon(Icons.download_rounded), findsOneWidget);

      // Upgrade available
      await tester.pumpWidget(_wrap(const CliStatusBanner(
        isInstalled: true,
        installedVersion: '1.0.0',
        latestVersion: '2.0.0',
        isBrewAvailable: true,
      )));
      expect(find.byIcon(Icons.upgrade_rounded), findsOneWidget);
    });
  });
}
