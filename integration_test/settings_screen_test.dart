import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'test_helpers.dart';

/// End-to-end settings screen test.
///
/// Validates:
///   - Settings screen renders all sections
///   - Theme toggle segmented button is interactive
///   - Port editors display current values
///   - Mode toggle shows current mode
///   - About section shows version info
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late TestConfigHelper config;

  setUp(() async {
    mockPackageInfo(version: '0.4.4');
    config = TestConfigHelper();
    await config.setUp();
    await config.writeSoloConfig(port: 9090);
  });

  tearDown(() => config.tearDown());

  group('Settings screen', () {
    testWidgets('renders all settings sections', (tester) async {
      await pumpApp(tester, overrides: config.overrides);

      // Navigate to Settings.
      await tester.tap(find.text('Settings'));
      await settleWithTimeout(tester);

      // Verify all section headings are present.
      expect(find.text('Settings'), findsWidgets);
      expect(find.text('Appearance'), findsOneWidget);
      expect(find.text('Startup'), findsOneWidget);
      expect(find.text('Network'), findsOneWidget);
      expect(find.text('Performance'), findsOneWidget);
      expect(find.text('Token Optimization'), findsOneWidget);
      expect(find.text('Mode'), findsOneWidget);
      expect(find.text('About'), findsOneWidget);
    });

    testWidgets('displays current proxy port', (tester) async {
      await pumpApp(tester, overrides: config.overrides);

      await tester.tap(find.text('Settings'));
      await settleWithTimeout(tester);

      // The port editor should show the configured port.
      expect(find.text('9090'), findsOneWidget);
    });

    testWidgets('displays version in About section', (tester) async {
      await pumpApp(tester, overrides: config.overrides);

      await tester.tap(find.text('Settings'));
      await settleWithTimeout(tester);

      expect(find.text('v0.4.4'), findsWidgets);
    });

    testWidgets('theme toggle buttons are present', (tester) async {
      await pumpApp(tester, overrides: config.overrides);

      await tester.tap(find.text('Settings'));
      await settleWithTimeout(tester);

      // Theme segmented button has System, Dark, Light options.
      // Note: 'System' may appear in both theme and caching sections.
      expect(find.text('System'), findsWidgets);
      expect(find.text('Dark'), findsOneWidget);
      expect(find.text('Light'), findsOneWidget);
    });

    testWidgets('shows solo mode as current mode', (tester) async {
      await pumpApp(tester, overrides: config.overrides);

      await tester.tap(find.text('Settings'));
      await settleWithTimeout(tester);

      // Mode section should show Solo/Team segmented button.
      expect(find.text('Solo'), findsWidgets);
      expect(find.text('Team'), findsWidgets);

      // Subtitle should indicate solo mode.
      expect(find.textContaining('solo mode'), findsOneWidget);
    });

    testWidgets('launch at login switch is present', (tester) async {
      await pumpApp(tester, overrides: config.overrides);

      await tester.tap(find.text('Settings'));
      await settleWithTimeout(tester);

      expect(find.text('Launch at login'), findsOneWidget);
      expect(find.byType(Switch), findsWidgets);
    });
  });
}
