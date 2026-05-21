import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart' as http_testing;

import 'package:candela_desktop/models/candela_config.dart';
import 'package:candela_desktop/models/diagnostic_entry.dart';
import 'package:candela_desktop/models/identity_state.dart';
import 'package:candela_desktop/services/adc_service.dart';
import 'package:candela_desktop/services/candela_auth_service.dart';
import 'package:candela_desktop/services/config_service.dart';
import 'package:candela_desktop/services/diagnostic_runner.dart';
import 'package:candela_desktop/services/provider_test_service.dart';

// ── Fake helpers ──────────────────────────────────────────────────────────────

/// Subclass ConfigService, override [load] to return a synthetic config.
class FakeConfigService extends ConfigService {
  final CandelaConfig _config;
  FakeConfigService(this._config);

  @override
  Future<CandelaConfig> load() async => _config;
}

/// Subclass CandelaAuthService to override CLI detection (advisory only).
class FakeCandelaAuthService extends CandelaAuthService {
  final bool installed;

  FakeCandelaAuthService({this.installed = true});

  @override
  Future<bool> isCandelaInstalled() async => installed;
}

/// Subclass AdcService to return a synthetic ADC file result and token.
class FakeAdcService extends AdcService {
  final AdcInfo? adc;
  final TokenInfo? token;
  FakeAdcService({this.adc, this.token});

  @override
  Future<AdcInfo?> readAdcFile() async => adc;

  @override
  Future<TokenInfo?> refreshAccessToken({AdcInfo? adcInfo}) async => token;
}

// ── Builders ──────────────────────────────────────────────────────────────────

CandelaConfig _soloConfig({List<ConfigIssue> issues = const []}) {
  return CandelaConfig(
    mode: CandelaMode.solo,
    port: 8181,
    providers: const [],
    path: '/tmp/fake.yaml',
    issues: issues,
  );
}

AdcInfo _fakeAdc({String? quotaProject}) => AdcInfo(
      path: '/tmp/adc.json',
      type: 'authorized_user',
      clientEmail: null,
      quotaProject: quotaProject,
    );

TokenInfo _validToken() => TokenInfo(
      accessToken: 'fake-token-abc',
      email: 'user@example.com',
      expiresAt: DateTime.now().toUtc().add(const Duration(hours: 1)),
    );

TokenInfo _expiredToken() => TokenInfo(
      accessToken: 'old-token',
      email: 'user@example.com',
      expiresAt: DateTime.now().toUtc().subtract(const Duration(hours: 1)),
    );

// Helper: build a runner with all parts controllable.
DiagnosticRunner _runner({
  CandelaConfig? config,
  bool candelaInstalled = true,
  TokenInfo? token,
  AdcInfo? adc,
  http.Client? httpClient,
}) {
  final proxyAndMockClient = httpClient ??
      http_testing.MockClient((_) async => http.Response('ok', 200));

  return DiagnosticRunner(
    config: FakeConfigService(config ?? _soloConfig()),
    candelaAuth: FakeCandelaAuthService(installed: candelaInstalled),
    adc: FakeAdcService(adc: adc, token: token),
    providers: ProviderTestService(client: proxyAndMockClient),
  );
}

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  group('DiagnosticRunner', () {
    late DiagnosticRunner runner;

    setUp(() {
      runner = DiagnosticRunner(
        config: ConfigService(),
        candelaAuth: CandelaAuthService(),
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
      final sub1 = runner.entries.listen((_) {});
      final sub2 = runner.entries.listen((_) {});
      sub1.cancel();
      sub2.cancel();
    });

    test('dispose can be called multiple times', () {
      runner.dispose();
      runner.dispose();
    });
  });

  group('DiagnosticEntry', () {
    test('constructs with all fields', () {
      final entry = DiagnosticEntry(
        status: DiagnosticStatus.pass,
        message: 'Candela CLI installed',
        timestamp: DateTime(2026, 5, 2, 14, 30),
      );
      expect(entry.status, DiagnosticStatus.pass);
      expect(entry.message, 'Candela CLI installed');
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

  // ── runAll() path coverage ──────────────────────────────────────────────────

  group('DiagnosticRunner runAll — candela CLI not installed (advisory)', () {
    late DiagnosticRunner runner;
    setUp(() => runner = _runner(candelaInstalled: false, adc: null));
    tearDown(() => runner.dispose());

    test('emits warning (not failure) for missing CLI', () async {
      await runner.runAll();
      expect(
        runner.history.any((e) =>
            e.status == DiagnosticStatus.warn &&
            e.message.contains('Candela CLI not found')),
        isTrue,
      );
    });

    test('diagnostics continue past missing CLI', () async {
      final summary = await runner.runAll();
      // Should have more than just the CLI check — config + ADC checks run.
      expect(summary.total, greaterThan(1));
      // Verify that the runner continues to subsequent steps (like config)
      // instead of early-exiting on CLI warning.
      expect(
        runner.history.any((e) => e.message.contains('Config loaded')),
        isTrue,
      );
    });

    test('isRunning is false after runAll completes', () async {
      await runner.runAll();
      expect(runner.isRunning, isFalse);
    });
  });

  group('DiagnosticRunner runAll — no ADC', () {
    late DiagnosticRunner runner;
    setUp(() => runner = _runner(
          candelaInstalled: true,
          token: null,
          adc: null,
        ));
    tearDown(() => runner.dispose());

    test('emits fail for missing ADC', () async {
      await runner.runAll();
      expect(
        runner.history.any((e) =>
            e.status == DiagnosticStatus.fail &&
            (e.message.contains('ADC') || e.message.contains('No ADC'))),
        isTrue,
      );
    });

    test('emits fail for missing token', () async {
      await runner.runAll();
      expect(
        runner.history.any((e) =>
            e.status == DiagnosticStatus.fail &&
            (e.message.contains('token') || e.message.contains('Token'))),
        isTrue,
      );
    });
  });

  group('DiagnosticRunner runAll — expired token', () {
    late DiagnosticRunner runner;
    setUp(() => runner = _runner(
          candelaInstalled: true,
          token: _expiredToken(),
          adc: _fakeAdc(),
        ));
    tearDown(() => runner.dispose());

    test('emits token-expired fail', () async {
      await runner.runAll();
      expect(
        runner.history.any((e) =>
            e.status == DiagnosticStatus.fail && e.message.contains('expired')),
        isTrue,
      );
    });
  });

  group('DiagnosticRunner runAll — valid token, proxy up', () {
    late DiagnosticRunner runner;
    setUp(() => runner = _runner(
          candelaInstalled: true,
          token: _validToken(),
          adc: _fakeAdc(quotaProject: 'my-gcp-project'),
          httpClient: http_testing.MockClient((req) async {
            if (req.url.path == '/v1/models') {
              return http.Response(
                '{"data":[{"id":"gemini-2.0-flash"}]}',
                200,
              );
            }
            return http.Response('ok', 200);
          }),
        ));
    tearDown(() => runner.dispose());

    test('runAll completes without throwing', () async {
      expect(() => runner.runAll(), returnsNormally);
      await runner.runAll();
    });

    test('history is cleared and repopulated on second run', () async {
      await runner.runAll();
      final firstCount = runner.history.length;
      await runner.runAll();
      // History is replaced, not accumulated.
      expect(runner.history.length, firstCount);
    });

    test('emits Candela CLI pass entry', () async {
      await runner.runAll();
      expect(
        runner.history.any(
          (e) =>
              e.status == DiagnosticStatus.pass &&
              e.message.contains('Candela CLI installed'),
        ),
        isTrue,
      );
    });

    test('emits token valid pass entry', () async {
      await runner.runAll();
      expect(
        runner.history.any(
          (e) =>
              e.status == DiagnosticStatus.pass &&
              e.message.contains('Token valid'),
        ),
        isTrue,
      );
    });

    test('emits project pass entry', () async {
      await runner.runAll();
      expect(
        runner.history.any(
          (e) =>
              e.status == DiagnosticStatus.pass &&
              e.message.contains('my-gcp-project'),
        ),
        isTrue,
      );
    });

    test('summary has at least 2 passed checks', () async {
      final summary = await runner.runAll();
      expect(summary.passed, greaterThanOrEqualTo(2));
    });
  });

  group('DiagnosticRunner runAll — no project configured', () {
    late DiagnosticRunner runner;
    setUp(() => runner = _runner(
          candelaInstalled: true,
          token: _validToken(),
          adc: _fakeAdc(), // no quotaProject
        ));
    tearDown(() => runner.dispose());

    test('emits project warning', () async {
      await runner.runAll();
      expect(
        runner.history.any((e) =>
            e.status == DiagnosticStatus.warn && e.message.contains('project')),
        isTrue,
      );
    });
  });

  group('DiagnosticRunner runAll — concurrent call returns same future', () {
    test('second runAll while running returns same result', () async {
      final runner = _runner(
        candelaInstalled: true,
        token: _validToken(),
        adc: _fakeAdc(),
      );
      final f1 = runner.runAll();
      final f2 = runner.runAll();
      final results = await Future.wait([f1, f2]);
      // Both futures should resolve — they share the same underlying run.
      expect(results[0].total, equals(results[1].total));
      runner.dispose();
    });
  });

  group('DiagnosticRunner runAll — config with errors', () {
    test('emits fail entries for config errors', () async {
      final runner = _runner(
        candelaInstalled: true,
        token: _validToken(),
        adc: _fakeAdc(),
        config: const CandelaConfig(
          mode: CandelaMode.solo,
          port: 8181,
          providers: [],
          path: '/tmp/fake.yaml',
          issues: [
            ConfigIssue(
              severity: IssueSeverity.error,
              message: 'Invalid proxy port',
            ),
          ],
        ),
      );
      await runner.runAll();
      expect(
        runner.history.any((e) =>
            e.status == DiagnosticStatus.fail && e.message.contains('Config')),
        isTrue,
      );
      runner.dispose();
    });
  });
}
