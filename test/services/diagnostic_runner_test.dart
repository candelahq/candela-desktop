import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/models/diagnostic_entry.dart';
import 'package:candela_desktop/services/diagnostic_runner.dart';
import 'package:candela_desktop/services/config_service.dart';
import 'package:candela_desktop/services/gcloud_service.dart';
import 'package:candela_desktop/services/adc_service.dart';
import 'package:candela_desktop/services/provider_test_service.dart';

void main() {
  group('DiagnosticRunner', () {
    late DiagnosticRunner runner;

    setUp(() {
      runner = DiagnosticRunner(
        config: ConfigService(),
        gcloud: GCloudService(),
        adc: AdcService(),
        providers: ProviderTestService(),
      );
    });

    tearDown(() {
      runner.dispose();
    });

    test('starts not running', () {
      expect(runner.isRunning, isFalse);
    });

    test('history starts empty', () {
      expect(runner.history, isEmpty);
    });

    test('entries stream is broadcast', () {
      // Should be able to listen multiple times.
      final sub1 = runner.entries.listen((_) {});
      final sub2 = runner.entries.listen((_) {});
      sub1.cancel();
      sub2.cancel();
    });

    test('dispose can be called multiple times', () {
      runner.dispose();
      runner.dispose(); // should not throw
    });
  });

  group('DiagnosticEntry', () {
    test('constructs with all fields', () {
      final entry = DiagnosticEntry(
        status: DiagnosticStatus.pass,
        message: 'gcloud installed',
        timestamp: DateTime(2026, 5, 2, 14, 30),
      );
      expect(entry.status, DiagnosticStatus.pass);
      expect(entry.message, 'gcloud installed');
      expect(entry.timestamp.hour, 14);
    });

    test('constructs with fail status', () {
      final entry = DiagnosticEntry(
        status: DiagnosticStatus.fail,
        message: 'no token',
        timestamp: DateTime.now(),
      );
      expect(entry.status, DiagnosticStatus.fail);
    });

    test('constructs with running status', () {
      final entry = DiagnosticEntry(
        status: DiagnosticStatus.running,
        message: 'checking...',
        timestamp: DateTime.now(),
      );
      expect(entry.status, DiagnosticStatus.running);
    });
  });

  group('DiagnosticSummary', () {
    test('total is sum of all', () {
      const summary = DiagnosticSummary(passed: 5, failed: 2, warned: 3);
      expect(summary.total, 10);
    });

    test('allPassed when no failures', () {
      const summary = DiagnosticSummary(passed: 10, failed: 0, warned: 5);
      expect(summary.allPassed, isTrue);
    });

    test('not allPassed when failures exist', () {
      const summary = DiagnosticSummary(passed: 10, failed: 1, warned: 0);
      expect(summary.allPassed, isFalse);
    });

    test('zero summary', () {
      const summary = DiagnosticSummary(passed: 0, failed: 0, warned: 0);
      expect(summary.allPassed, isTrue);
      expect(summary.total, 0);
    });
  });
}
