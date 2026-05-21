import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/services/diagnostic_runner.dart';
import 'package:candela_desktop/services/config_service.dart';
import 'package:candela_desktop/services/candela_auth_service.dart';
import 'package:candela_desktop/services/adc_service.dart';
import 'package:candela_desktop/services/provider_test_service.dart';
import 'package:candela_desktop/models/diagnostic_entry.dart';

/// Integration test: DiagnosticRunner emits ordered entries and a final summary.
void main() {
  group('DiagnosticRunner — integration stream ordering', () {
    late DiagnosticRunner runner;
    late ConfigService configService;

    setUp(() {
      configService = ConfigService(configPath: '/tmp/nonexistent.yaml');
      runner = DiagnosticRunner(
        config: configService,
        candelaAuth: CandelaAuthService(),
        adc: AdcService(),
        providers: ProviderTestService(),
      );
    });

    tearDown(() => runner.dispose());

    test('runAll populates history and returns valid summary', () async {
      final summary = await runner.runAll();

      // Must have entries in history.
      expect(runner.history, isNotEmpty);

      // Summary totals should be non-negative.
      expect(summary.passed, greaterThanOrEqualTo(0));
      expect(summary.failed, greaterThanOrEqualTo(0));
      expect(summary.warned, greaterThanOrEqualTo(0));
      expect(summary.total, greaterThanOrEqualTo(1));

      // Last two entries should be the separator (info) + summary (pass/fail).
      final lastTwo = runner.history.sublist(runner.history.length - 2);
      expect(lastTwo[0].status, DiagnosticStatus.info); // separator line
      expect(
          lastTwo[1].status == DiagnosticStatus.pass ||
              lastTwo[1].status == DiagnosticStatus.fail,
          isTrue);
    });

    test('concurrent runAll returns same future', () async {
      final future1 = runner.runAll();
      final future2 = runner.runAll();

      final result1 = await future1;
      final result2 = await future2;

      // Both should complete with the same total (same run).
      expect(result1.total, result2.total);
      expect(result1.passed, result2.passed);
    });
  });
}
