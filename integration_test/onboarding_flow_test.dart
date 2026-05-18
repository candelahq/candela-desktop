import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'test_helpers.dart';

/// End-to-end onboarding wizard test.
///
/// Validates:
///   - Onboarding shows when no config file exists
///   - Mode selection cards are interactive
///   - "Skip — use defaults" creates a config and transitions to main app
///   - Solo mode flow: mode select → provider select → "Get Started"
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late TestConfigHelper config;

  setUp(() async {
    mockPackageInfo();
    config = TestConfigHelper();
    await config.setUp();
    // Do NOT write config — onboarding should appear.
  });

  tearDown(() => config.tearDown());

  group('Onboarding flow', () {
    testWidgets('shows onboarding when no config exists', (tester) async {
      await pumpApp(tester, configHelper: config);

      // Should see the welcome screen (step 0 — mode selection).
      expect(find.text('Welcome to Candela'), findsOneWidget);
      expect(find.text('How will you use Candela?'), findsOneWidget);

      // All three mode cards should be visible.
      expect(find.text('Solo'), findsOneWidget);
      expect(find.text('Solo + Cloud'), findsOneWidget);
      expect(find.text('Team'), findsOneWidget);
    });

    testWidgets('skip to defaults creates config and enters main app',
        (tester) async {
      await pumpApp(tester, configHelper: config);

      // Verify we're on onboarding.
      expect(find.text('Welcome to Candela'), findsOneWidget);

      // Tap "Skip — use defaults".
      await tester.tap(find.text('Skip — use defaults'));
      await settleWithTimeout(tester);

      // Should now be in the main app shell (Today screen).
      expect(find.text('Today'), findsWidgets);

      // The config file should have been created.
      expect(File(config.configPath).existsSync(), isTrue,
          reason: 'Config file should be created after skip');
    });

    testWidgets('solo mode skips details and goes to provider selection',
        (tester) async {
      await pumpApp(tester, configHelper: config);

      // Tap Solo mode card.
      await tester.tap(find.text('Solo'));
      await settleWithTimeout(tester);

      // Should jump to step 2 (provider selection), skipping details.
      expect(find.text('Add Providers'), findsOneWidget);
      expect(find.text('Ollama'), findsOneWidget);
      expect(find.text('LM Studio'), findsOneWidget);
    });

    testWidgets('solo mode → select provider → get started', (tester) async {
      await pumpApp(tester, configHelper: config);

      // Step 0: Select Solo.
      await tester.tap(find.text('Solo'));
      await settleWithTimeout(tester);

      // Step 2: Provider selection. Select Ollama.
      expect(find.text('Add Providers'), findsOneWidget);
      await tester.tap(find.text('Ollama'));
      await settleWithTimeout(tester);

      // Tap "Get Started →".
      await tester.tap(find.text('Get Started →'));
      await settleWithTimeout(tester);

      // Should be in the main app now.
      expect(find.text('Today'), findsWidgets);

      // Config file should exist with the selected provider.
      final configContent = File(config.configPath).readAsStringSync();
      expect(configContent, contains('ollama'));
    });

    testWidgets('team mode shows details step with URL fields', (tester) async {
      await pumpApp(tester, configHelper: config);

      // Select Team mode.
      await tester.tap(find.text('Team'));
      await settleWithTimeout(tester);

      // Should see step 1 — team details.
      expect(find.text('👥 Team Setup'), findsOneWidget);
      expect(find.text('Remote URL'), findsOneWidget);

      // Next button should be disabled (no URL entered).
      final nextButton = tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Next →'));
      expect(nextButton.onPressed, isNull,
          reason: 'Next button should be disabled without valid URL');
    });

    testWidgets('back button from provider step returns to mode selection',
        (tester) async {
      await pumpApp(tester, configHelper: config);

      // Go to providers via Solo.
      await tester.tap(find.text('Solo'));
      await settleWithTimeout(tester);
      expect(find.text('Add Providers'), findsOneWidget);

      // Tap Back.
      await tester.tap(find.text('← Back'));
      await settleWithTimeout(tester);

      // Should be back to mode selection.
      expect(find.text('Welcome to Candela'), findsOneWidget);
    });
  });
}
