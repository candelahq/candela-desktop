import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'test_helpers.dart';

/// End-to-end dashboard empty state test.
///
/// Validates:
///   - Dashboard renders without crashing when no proxy is running
///   - Empty/error state is shown gracefully
///   - No unhandled exceptions from telemetry fetch failure
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late TestConfigHelper config;

  setUp(() async {
    mockPackageInfo();
    config = TestConfigHelper();
    await config.setUp();
    // Use a port that almost certainly has nothing listening — avoids
    // false positives from a real candela proxy.
    await config.writeSoloConfig(port: 59999);
  });

  tearDown(() => config.tearDown());

  group('Dashboard empty state', () {
    testWidgets('renders without crash when proxy is unreachable',
        (tester) async {
      await pumpApp(tester, configHelper: config);

      // Navigate to Dashboard.
      await tester.tap(find.text('Dashboard'));
      await settleWithTimeout(tester, duration: const Duration(seconds: 3));

      // The dashboard should render — either with an error banner or empty
      // state, but NOT crash.
      expect(tester.takeException(), isNull);
    });

    testWidgets('Today screen handles proxy down gracefully', (tester) async {
      await pumpApp(tester, configHelper: config);

      // We start on Today — it should render without crash even when the
      // proxy is unreachable. The screen may show zero-value stats,
      // empty state, or an error banner depending on runtime behavior.
      await settleWithTimeout(tester, duration: const Duration(seconds: 3));

      // The key assertion: no unhandled exceptions from fetch failures.
      expect(find.text('Today'), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Traces screen handles no data gracefully', (tester) async {
      await pumpApp(tester, configHelper: config);

      await tester.tap(find.text('Traces'));
      await settleWithTimeout(tester, duration: const Duration(seconds: 3));

      // Should render without crash.
      expect(tester.takeException(), isNull);
    });

    testWidgets('Models screen handles no data gracefully', (tester) async {
      await pumpApp(tester, configHelper: config);

      await tester.tap(find.text('Models'));
      await settleWithTimeout(tester, duration: const Duration(seconds: 3));

      // Should render without crash.
      expect(tester.takeException(), isNull);
    });
  });
}
