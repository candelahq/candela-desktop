import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/models/candela_config.dart';
import 'package:candela_desktop/models/identity_state.dart';
import 'package:candela_desktop/models/provider_status.dart';
import 'package:candela_desktop/models/diagnostic_entry.dart';

void main() {
  group('CandelaConfig', () {
    test('hasErrors is true only for error-level issues', () {
      const config = CandelaConfig(
        path: '/test',
        issues: [
          ConfigIssue(severity: IssueSeverity.warning, message: 'warn'),
          ConfigIssue(severity: IssueSeverity.info, message: 'info'),
        ],
      );
      expect(config.hasErrors, isFalse);
      expect(config.hasWarnings, isTrue);
    });

    test('hasErrors is true when error exists', () {
      const config = CandelaConfig(
        path: '/test',
        issues: [
          ConfigIssue(severity: IssueSeverity.error, message: 'err'),
        ],
      );
      expect(config.hasErrors, isTrue);
    });

    test('defaults are sensible', () {
      const config = CandelaConfig(path: '/test');
      expect(config.port, 8181);
      expect(config.lmStudioPort, 1234);
      expect(config.mode, CandelaMode.solo);
      expect(config.providers, isEmpty);
      expect(config.issues, isEmpty);
    });
  });

  group('TokenInfo', () {
    test('expiryDisplay shows Expired for past tokens', () {
      final token = TokenInfo(
        expiresAt: DateTime.now().subtract(const Duration(hours: 1)),
        isValid: false,
      );
      expect(token.expiryDisplay, 'Expired');
    });

    test('expiryDisplay shows < 1 min for nearly-expired tokens', () {
      final token = TokenInfo(
        expiresAt: DateTime.now().add(const Duration(seconds: 30)),
        isValid: true,
      );
      expect(token.expiryDisplay, '< 1 min');
    });

    test('expiryDisplay shows minutes for mid-range tokens', () {
      final token = TokenInfo(
        expiresAt: DateTime.now().add(const Duration(minutes: 45)),
        isValid: true,
      );
      // Might be 44 or 45 due to execution time.
      expect(token.expiryDisplay, matches(RegExp(r'^\d+ min$')));
    });

    test('expiryDisplay shows hours for long-lived tokens', () {
      final token = TokenInfo(
        expiresAt: DateTime.now().add(const Duration(hours: 2, minutes: 15)),
        isValid: true,
      );
      expect(token.expiryDisplay, contains('2h'));
    });
  });

  group('IdentityState', () {
    test('isAuthenticated requires email, valid token', () {
      const state = IdentityState(email: null);
      expect(state.isAuthenticated, isFalse);
    });

    test('isAuthenticated true with valid token and email', () {
      final state = IdentityState(
        email: 'test@example.com',
        tokenInfo: TokenInfo(
          expiresAt: DateTime.now().add(const Duration(hours: 1)),
          isValid: true,
        ),
      );
      expect(state.isAuthenticated, isTrue);
    });
  });

  group('AdcInfo', () {
    test('isServiceAccount detects SA type', () {
      const adc = AdcInfo(path: '/test', type: 'service_account');
      expect(adc.isServiceAccount, isTrue);
      expect(adc.isUserCredentials, isFalse);
      expect(adc.displayType, 'Service Account');
    });

    test('isUserCredentials detects user type', () {
      const adc = AdcInfo(path: '/test', type: 'authorized_user');
      expect(adc.isServiceAccount, isFalse);
      expect(adc.isUserCredentials, isTrue);
      expect(adc.displayType, 'Application Default Credentials');
    });
  });

  group('ProviderStatus', () {
    test('isHealthy only true for connected state', () {
      const connected = ProviderStatus(
        name: 'test', displayName: 'Test', state: ProviderState.connected,
      );
      expect(connected.isHealthy, isTrue);

      for (final state in ProviderState.values.where((s) => s != ProviderState.connected)) {
        final status = ProviderStatus(name: 'test', displayName: 'Test', state: state);
        expect(status.isHealthy, isFalse, reason: 'Expected $state to not be healthy');
      }
    });

    test('port field is accessible', () {
      const status = ProviderStatus(
        name: 'proxy', displayName: 'Proxy', state: ProviderState.connected, port: 8181,
      );
      expect(status.port, 8181);
    });
  });

  group('DiagnosticSummary', () {
    test('allPassed is true when failed is 0', () {
      const summary = DiagnosticSummary(passed: 5, failed: 0, warned: 2);
      expect(summary.allPassed, isTrue);
      expect(summary.total, 7);
    });

    test('allPassed is false when failed > 0', () {
      const summary = DiagnosticSummary(passed: 3, failed: 1, warned: 0);
      expect(summary.allPassed, isFalse);
      expect(summary.total, 4);
    });
  });

  group('VertexAIConfig', () {
    test('effectiveRegion defaults to us-central1', () {
      const vtx = VertexAIConfig(project: 'my-proj');
      expect(vtx.effectiveRegion, 'us-central1');
    });

    test('effectiveRegion uses provided region', () {
      const vtx = VertexAIConfig(project: 'my-proj', region: 'europe-west4');
      expect(vtx.effectiveRegion, 'europe-west4');
    });
  });
}
