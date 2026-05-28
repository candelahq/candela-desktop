import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/screens/onboarding/onboarding_screen.dart';
import 'package:candela_desktop/services/config_service.dart';
import 'package:candela_desktop/theme/candela_theme.dart';

/// Widget tests for OnboardingScreen — validates the 3-step onboarding wizard
/// (mode selection → details → providers) including navigation, validation,
/// and provider display logic.

/// A fake ConfigService whose writeInitialConfig completes synchronously
/// (no real file I/O, no Process.run). Needed because Flutter's test zone
/// cannot execute real async I/O from fire-and-forget widget handlers.
class FakeConfigService extends ConfigService {
  bool writeCalled = false;
  Map<String, dynamic>? lastConfig;
  bool shouldThrow = false;

  FakeConfigService() : super(configPath: '/dev/null');

  @override
  Future<void> writeInitialConfig(Map<String, dynamic> config) async {
    if (shouldThrow) {
      throw StateError('Config file already exists (fake)');
    }
    writeCalled = true;
    lastConfig = config;
  }
}

Widget _wrap(Widget child) => MaterialApp(
      theme: CandelaTheme.dark,
      home: Scaffold(body: child),
    );

void main() {
  late Directory tempDir;
  late ConfigService configService;
  late String testConfigPath;
  late int onCompleteCount;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('candela_onboarding_test_');
    testConfigPath = '${tempDir.path}/config.yaml';
    configService = ConfigService(configPath: testConfigPath);
    onCompleteCount = 0;
  });

  tearDown(() {
    if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
  });

  Widget buildScreen() => _wrap(
        OnboardingScreen(
          configService: configService,
          onComplete: () => onCompleteCount++,
        ),
      );

  /// Pump the onboarding screen with a viewport large enough to avoid
  /// RenderFlex overflow (the wizard is ~900px tall at step 0).
  Future<void> pumpScreen(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());
    addTearDown(() => tester.view.resetDevicePixelRatio());
    await tester.pumpWidget(buildScreen());
  }

  // ── Step 0: Mode Selection ──

  group('Step 0 — Mode Selection', () {
    testWidgets('shows Welcome to Candela title', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Welcome to Candela'), findsOneWidget);
    });

    testWidgets('shows 3 mode cards: Solo, Solo + Cloud, Team', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Solo'), findsOneWidget);
      expect(find.text('Solo + Cloud'), findsOneWidget);
      expect(find.text('Team'), findsOneWidget);
    });

    testWidgets('shows Skip — use defaults button', (tester) async {
      await pumpScreen(tester);
      expect(find.text('Skip — use defaults'), findsOneWidget);
    });

    testWidgets('tapping Skip calls onComplete', (tester) async {
      // Use FakeConfigService to avoid real I/O in fake-async zone.
      final fake = FakeConfigService();
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());
      addTearDown(() => tester.view.resetDevicePixelRatio());
      await tester.pumpWidget(_wrap(
        OnboardingScreen(
          configService: fake,
          onComplete: () => onCompleteCount++,
        ),
      ));
      await tester.tap(find.text('Skip — use defaults'));
      await tester.pumpAndSettle();
      expect(onCompleteCount, 1);
      expect(fake.writeCalled, isTrue);
    });

    testWidgets('tapping Solo mode card shows check icon (selected state)',
        (tester) async {
      await pumpScreen(tester);
      // Tapping Solo immediately jumps to step 2 (providers), so verify
      // that step 2 content appears instead of looking for selection UI.
      await tester.tap(find.text('Solo'));
      await tester.pumpAndSettle();
      // Should now be on step 2 (providers).
      expect(find.text('Add Providers'), findsOneWidget);
    });

    testWidgets('tapping Solo jumps to step 2 (providers), skipping step 1',
        (tester) async {
      await pumpScreen(tester);
      await tester.tap(find.text('Solo'));
      await tester.pumpAndSettle();
      // Step 2 content visible.
      expect(find.text('Add Providers'), findsOneWidget);
      // Step 1 content not visible.
      expect(find.text('Remote URL'), findsNothing);
      expect(find.text('GCP Project'), findsNothing);
    });

    testWidgets('tapping Team goes to step 1 (details)', (tester) async {
      await pumpScreen(tester);
      await tester.tap(find.text('Team'));
      await tester.pumpAndSettle();
      // Step 1 team content visible.
      expect(find.text('👥 Team Setup'), findsOneWidget);
      expect(find.text('Remote URL'), findsOneWidget);
    });

    testWidgets('tapping Solo + Cloud goes to step 1 (details)',
        (tester) async {
      await pumpScreen(tester);
      await tester.tap(find.text('Solo + Cloud'));
      await tester.pumpAndSettle();
      // Step 1 cloud content visible.
      expect(find.text('☁️ Cloud Setup'), findsOneWidget);
      expect(find.text('GCP Project'), findsOneWidget);
    });
  });

  // ── Step 1: Details ──

  group('Step 1 — Details', () {
    testWidgets('Team mode shows Remote URL and Audience text fields',
        (tester) async {
      await pumpScreen(tester);
      await tester.tap(find.text('Team'));
      await tester.pumpAndSettle();

      expect(find.text('Remote URL'), findsOneWidget);
      expect(
        find.text('Audience (optional — defaults to remote URL)'),
        findsOneWidget,
      );
    });

    testWidgets('Cloud mode shows GCP Project and Region text fields',
        (tester) async {
      await pumpScreen(tester);
      await tester.tap(find.text('Solo + Cloud'));
      await tester.pumpAndSettle();

      expect(find.text('GCP Project'), findsOneWidget);
      expect(find.text('Region'), findsOneWidget);
    });

    testWidgets('Back button returns to step 0', (tester) async {
      await pumpScreen(tester);
      await tester.tap(find.text('Team'));
      await tester.pumpAndSettle();

      // Verify we're on step 1.
      expect(find.text('👥 Team Setup'), findsOneWidget);

      // Tap Back.
      await tester.tap(find.text('← Back'));
      await tester.pumpAndSettle();

      // Should be back on step 0.
      expect(find.text('Welcome to Candela'), findsOneWidget);
    });

    testWidgets('Team mode: Next is disabled until valid HTTPS URL entered',
        (tester) async {
      await pumpScreen(tester);
      await tester.tap(find.text('Team'));
      await tester.pumpAndSettle();

      // Next button should be disabled (onPressed is null).
      final nextButton = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Next →'),
      );
      expect(nextButton.onPressed, isNull);
    });

    testWidgets('Team mode: Next enabled after entering valid HTTPS URL',
        (tester) async {
      await pumpScreen(tester);
      await tester.tap(find.text('Team'));
      await tester.pumpAndSettle();

      // Enter a valid URL.
      await tester.enterText(
        find.byType(TextField).first,
        'https://candela.example.com',
      );
      await tester.pumpAndSettle();

      // Next button should now be enabled.
      final nextButton = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Next →'),
      );
      expect(nextButton.onPressed, isNotNull);
    });

    testWidgets('Team mode: Next remains disabled with HTTP (non-HTTPS) URL',
        (tester) async {
      await pumpScreen(tester);
      await tester.tap(find.text('Team'));
      await tester.pumpAndSettle();

      // Enter an HTTP URL (not HTTPS).
      await tester.enterText(
        find.byType(TextField).first,
        'http://candela.example.com',
      );
      await tester.pumpAndSettle();

      // Next button should still be disabled — UrlValidator rejects non-https.
      final nextButton = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Next →'),
      );
      expect(nextButton.onPressed, isNull);
    });

    testWidgets('Cloud mode: Next disabled when GCP Project is empty',
        (tester) async {
      await pumpScreen(tester);
      await tester.tap(find.text('Solo + Cloud'));
      await tester.pumpAndSettle();

      // GCP Project field is empty by default; Next should be disabled.
      final nextButton = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Next →'),
      );
      expect(nextButton.onPressed, isNull);
    });

    testWidgets('Cloud mode: Next enabled after entering GCP Project',
        (tester) async {
      await pumpScreen(tester);
      await tester.tap(find.text('Solo + Cloud'));
      await tester.pumpAndSettle();

      // Enter a project name.
      await tester.enterText(
        find.byType(TextField).first,
        'my-gcp-project',
      );
      await tester.pumpAndSettle();

      // Next button should now be enabled.
      final nextButton = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Next →'),
      );
      expect(nextButton.onPressed, isNotNull);
    });

    testWidgets('Team mode: Next navigates to step 2 (providers)',
        (tester) async {
      await pumpScreen(tester);
      await tester.tap(find.text('Team'));
      await tester.pumpAndSettle();

      // Enter a valid URL.
      await tester.enterText(
        find.byType(TextField).first,
        'https://candela.example.com',
      );
      await tester.pumpAndSettle();

      // Tap Next.
      await tester.tap(find.text('Next →'));
      await tester.pumpAndSettle();

      // Should be on step 2.
      expect(find.text('Add Providers'), findsOneWidget);
    });
  });

  // ── Step 2: Provider Selection ──

  group('Step 2 — Providers', () {
    testWidgets('Solo mode shows only local providers (ollama, vllm, lmstudio)',
        (tester) async {
      await pumpScreen(tester);
      await tester.tap(find.text('Solo'));
      await tester.pumpAndSettle();

      // Local providers should be visible.
      expect(find.text('Ollama'), findsOneWidget);
      expect(find.text('vLLM'), findsOneWidget);
      expect(find.text('LM Studio'), findsOneWidget);

      // Cloud providers should NOT be visible.
      expect(find.text('Google / Gemini'), findsNothing);
      expect(find.text('Anthropic / Claude'), findsNothing);
      expect(find.text('OpenAI'), findsNothing);
    });

    testWidgets('Cloud mode shows cloud + local providers', (tester) async {
      await pumpScreen(tester);
      await tester.tap(find.text('Solo + Cloud'));
      await tester.pumpAndSettle();

      // Enter GCP project to pass validation.
      await tester.enterText(find.byType(TextField).first, 'my-project');
      await tester.pumpAndSettle();

      // Navigate to providers.
      await tester.tap(find.text('Next →'));
      await tester.pumpAndSettle();

      // Cloud providers visible.
      expect(find.text('Google / Gemini'), findsOneWidget);
      expect(find.text('Anthropic / Claude'), findsOneWidget);
      expect(find.text('OpenAI'), findsOneWidget);

      // Local providers also visible.
      expect(find.text('Ollama'), findsOneWidget);
      expect(find.text('vLLM'), findsOneWidget);
      expect(find.text('LM Studio'), findsOneWidget);
    });

    testWidgets('Team mode shows cloud + local providers', (tester) async {
      await pumpScreen(tester);
      await tester.tap(find.text('Team'));
      await tester.pumpAndSettle();

      // Enter valid URL to pass validation.
      await tester.enterText(
        find.byType(TextField).first,
        'https://candela.example.com',
      );
      await tester.pumpAndSettle();

      // Navigate to providers.
      await tester.tap(find.text('Next →'));
      await tester.pumpAndSettle();

      // Cloud providers visible.
      expect(find.text('Google / Gemini'), findsOneWidget);
      expect(find.text('Anthropic / Claude'), findsOneWidget);
      expect(find.text('OpenAI'), findsOneWidget);

      // Local providers also visible.
      expect(find.text('Ollama'), findsOneWidget);
      expect(find.text('vLLM'), findsOneWidget);
      expect(find.text('LM Studio'), findsOneWidget);
    });

    testWidgets('provider tiles toggle on tap via checkbox', (tester) async {
      await pumpScreen(tester);
      await tester.tap(find.text('Solo'));
      await tester.pumpAndSettle();

      // Initially, Ollama checkbox should be unchecked.
      final checkboxesBefore = tester.widgetList<Checkbox>(
        find.byType(Checkbox),
      );
      expect(checkboxesBefore.first.value, isFalse);

      // Tap the Ollama tile.
      await tester.tap(find.text('Ollama'));
      await tester.pumpAndSettle();

      // Checkbox should now be checked.
      final checkboxesAfter = tester.widgetList<Checkbox>(
        find.byType(Checkbox),
      );
      expect(checkboxesAfter.first.value, isTrue);

      // Tap again to deselect.
      await tester.tap(find.text('Ollama'));
      await tester.pumpAndSettle();

      final checkboxesToggled = tester.widgetList<Checkbox>(
        find.byType(Checkbox),
      );
      expect(checkboxesToggled.first.value, isFalse);
    });

    testWidgets('Get Started button is present', (tester) async {
      await pumpScreen(tester);
      await tester.tap(find.text('Solo'));
      await tester.pumpAndSettle();

      expect(find.text('Get Started →'), findsOneWidget);
    });

    testWidgets('Back button returns to step 0 for solo mode', (tester) async {
      await pumpScreen(tester);
      await tester.tap(find.text('Solo'));
      await tester.pumpAndSettle();

      // On step 2.
      expect(find.text('Add Providers'), findsOneWidget);

      // Tap Back.
      await tester.tap(find.text('← Back'));
      await tester.pumpAndSettle();

      // Should return to step 0.
      expect(find.text('Welcome to Candela'), findsOneWidget);
    });

    testWidgets('Back button returns to step 1 for team mode', (tester) async {
      await pumpScreen(tester);
      await tester.tap(find.text('Team'));
      await tester.pumpAndSettle();

      // Enter valid URL.
      await tester.enterText(
        find.byType(TextField).first,
        'https://candela.example.com',
      );
      await tester.pumpAndSettle();

      // Navigate to providers.
      await tester.tap(find.text('Next →'));
      await tester.pumpAndSettle();

      // On step 2.
      expect(find.text('Add Providers'), findsOneWidget);

      // Tap Back.
      await tester.tap(find.text('← Back'));
      await tester.pumpAndSettle();

      // Should return to step 1.
      expect(find.text('👥 Team Setup'), findsOneWidget);
    });

    testWidgets('Back button returns to step 1 for cloud mode', (tester) async {
      await pumpScreen(tester);
      await tester.tap(find.text('Solo + Cloud'));
      await tester.pumpAndSettle();

      // Enter GCP project.
      await tester.enterText(find.byType(TextField).first, 'my-project');
      await tester.pumpAndSettle();

      // Navigate to providers.
      await tester.tap(find.text('Next →'));
      await tester.pumpAndSettle();

      // On step 2.
      expect(find.text('Add Providers'), findsOneWidget);

      // Tap Back.
      await tester.tap(find.text('← Back'));
      await tester.pumpAndSettle();

      // Should return to step 1.
      expect(find.text('☁️ Cloud Setup'), findsOneWidget);
    });

    testWidgets('Get Started writes config and calls onComplete',
        (tester) async {
      // Use FakeConfigService to avoid real file I/O in fake-async zone.
      // Note: _saveAndFinish also calls the static findAvailablePort()
      // (ServerSocket.bind), which requires runAsync to escape fake-async.
      final fake = FakeConfigService();
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());
      addTearDown(() => tester.view.resetDevicePixelRatio());
      await tester.pumpWidget(_wrap(
        OnboardingScreen(
          configService: fake,
          onComplete: () => onCompleteCount++,
        ),
      ));
      await tester.tap(find.text('Solo'));
      await tester.pumpAndSettle();

      // Select a provider.
      await tester.tap(find.text('Ollama'));
      await tester.pumpAndSettle();

      // Tap Get Started — pump to trigger the handler, then runAsync to
      // let ServerSocket.bind (findAvailablePort) complete in real async.
      await tester.tap(find.text('Get Started →'));
      await tester.pump();
      await tester.runAsync(() async {
        for (var i = 0; i < 100; i++) {
          await Future<void>.delayed(const Duration(milliseconds: 50));
          if (onCompleteCount > 0) break;
        }
      });
      await tester.pump();

      expect(onCompleteCount, 1);
      expect(fake.writeCalled, isTrue);
      expect(fake.lastConfig?['providers'], isNotNull);
    });
  });

  // ── Edge Cases ──

  group('Edge cases', () {
    testWidgets('shows SnackBar on save failure when config already exists',
        (tester) async {
      // Use FakeConfigService configured to throw.
      final fake = FakeConfigService()..shouldThrow = true;
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());
      addTearDown(() => tester.view.resetDevicePixelRatio());
      await tester.pumpWidget(_wrap(
        OnboardingScreen(
          configService: fake,
          onComplete: () => onCompleteCount++,
        ),
      ));
      await tester.tap(find.text('Skip — use defaults'));
      await tester.pumpAndSettle();

      // onComplete should NOT have been called.
      expect(onCompleteCount, 0);

      // SnackBar with error message should be visible.
      expect(find.textContaining('Failed to save config'), findsOneWidget);
    });

    testWidgets('shows subtitle descriptions for each mode card',
        (tester) async {
      await pumpScreen(tester);
      expect(
        find.text('Local observability — no cloud, no auth'),
        findsOneWidget,
      );
      expect(
        find.text('Your own GCP project (Vertex AI)'),
        findsOneWidget,
      );
      expect(
        find.text('Shared Candela server (requires auth)'),
        findsOneWidget,
      );
    });

    testWidgets('step 0 shows How will you use Candela subtitle',
        (tester) async {
      await pumpScreen(tester);
      expect(find.text('How will you use Candela?'), findsOneWidget);
    });

    testWidgets('step 2 shows provider subtitle text', (tester) async {
      await pumpScreen(tester);
      await tester.tap(find.text('Solo'));
      await tester.pumpAndSettle();

      expect(
        find.text('Select the LLM providers you want to use'),
        findsOneWidget,
      );
    });

    testWidgets('multiple providers can be selected simultaneously',
        (tester) async {
      await pumpScreen(tester);
      await tester.tap(find.text('Solo'));
      await tester.pumpAndSettle();

      // Select Ollama and vLLM.
      await tester.tap(find.text('Ollama'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('vLLM'));
      await tester.pumpAndSettle();

      // Both should be checked.
      final checkboxes =
          tester.widgetList<Checkbox>(find.byType(Checkbox)).toList();
      // Order: Ollama (0), vLLM (1), LM Studio (2).
      expect(checkboxes[0].value, isTrue);
      expect(checkboxes[1].value, isTrue);
      expect(checkboxes[2].value, isFalse);
    });

    testWidgets('region field has default value us-central1 in cloud mode',
        (tester) async {
      await pumpScreen(tester);
      await tester.tap(find.text('Solo + Cloud'));
      await tester.pumpAndSettle();

      // The Region TextField should have the default value.
      final regionField = tester.widget<TextField>(
        find.byType(TextField).at(1),
      );
      expect(regionField.controller?.text, 'us-central1');
    });
  });
}
