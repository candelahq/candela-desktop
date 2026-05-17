import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'test_helpers.dart';

/// Smoke test: the full app boots to the main shell without crashing.
///
/// This validates:
///   - ProviderScope initialization (all Riverpod providers resolve)
///   - ConfigService loads the test config
///   - ProcessManager.configure() runs without error
///   - The widget tree renders to completion
///   - No unhandled exceptions during startup
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late TestConfigHelper config;

  setUp(() async {
    mockPackageInfo();
    config = TestConfigHelper();
    await config.setUp();
    await config.writeSoloConfig();
  });

  tearDown(() => config.tearDown());

  group('App boot', () {
    testWidgets('launches to main shell without crashing', (tester) async {
      await pumpApp(tester, overrides: config.overrides);

      // The sidebar should be visible — this means we got past onboarding
      // and the full AppShell rendered.
      // "Today" appears both in the sidebar nav and as the screen heading.
      expect(find.text('Today'), findsWidgets);
      expect(find.text('Candela'), findsWidgets);

      // No unhandled exceptions during boot.
      expect(tester.takeException(), isNull);
    });

    testWidgets('shows sidebar brand and nav items after boot', (tester) async {
      await pumpApp(tester, overrides: config.overrides);

      // Sidebar nav items should all be present.
      // "Today" appears twice (sidebar + screen heading), others once.
      expect(find.text('Today'), findsWidgets);
      expect(find.text('Diagnostics'), findsOneWidget);
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Traces'), findsOneWidget);
      expect(find.text('Models'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
