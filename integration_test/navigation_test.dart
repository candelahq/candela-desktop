import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'test_helpers.dart';

/// End-to-end sidebar navigation test.
///
/// Validates:
///   - Every sidebar tab is tappable
///   - Each screen renders without throwing
///   - Active tab highlighting works
///   - The AnimatedSwitcher correctly swaps screen content
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

  group('Sidebar navigation', () {
    testWidgets('can navigate to every tab without crashing', (tester) async {
      await pumpApp(tester, overrides: config.overrides);

      // Start on Today (index 0) — text appears in sidebar + heading.
      expect(find.text('Today'), findsWidgets);

      // The nav items and their expected screen markers.
      final tabs = [
        ('Diagnostics', Icons.shield),
        ('Dashboard', Icons.dashboard),
        ('Traces', Icons.timeline),
        ('Models', Icons.memory),
        ('Settings', Icons.settings),
      ];

      for (final (label, activeIcon) in tabs) {
        await tester.tap(find.text(label));
        await settleWithTimeout(tester);

        // The active icon should switch to the filled variant.
        expect(find.byIcon(activeIcon), findsOneWidget,
            reason: '$label tab should show active icon');

        // No exceptions from rendering.
        expect(tester.takeException(), isNull,
            reason: '$label screen should render without error');
      }
    });

    testWidgets('navigating back to Today works', (tester) async {
      await pumpApp(tester, overrides: config.overrides);

      // Navigate away from Today.
      await tester.tap(find.text('Dashboard'));
      await settleWithTimeout(tester);
      expect(find.byIcon(Icons.dashboard), findsOneWidget);

      // Navigate back to Today — tap the first match (sidebar nav item).
      await tester.tap(find.text('Today').first);
      await settleWithTimeout(tester);
      expect(find.byIcon(Icons.today), findsOneWidget);
    });

    testWidgets('rapid tab switching does not crash', (tester) async {
      await pumpApp(tester, overrides: config.overrides);

      // Rapidly switch tabs without waiting for settle.
      final tabNames = [
        'Diagnostics',
        'Dashboard',
        'Traces',
        'Models',
        'Settings',
        'Today',
      ];

      for (final name in tabNames) {
        // Use .first to handle 'Today' appearing in sidebar + heading.
        await tester.tap(find.text(name).first);
        await tester.pump(const Duration(milliseconds: 50));
      }

      // Now settle — everything should stabilize without crash.
      await settleWithTimeout(tester);
      expect(tester.takeException(), isNull);
    });

    testWidgets('sidebar shows version string', (tester) async {
      await pumpApp(tester, overrides: config.overrides);
      expect(find.textContaining('v0.0.0-test'), findsOneWidget);
    });
  });
}
