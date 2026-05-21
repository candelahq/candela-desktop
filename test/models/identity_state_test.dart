import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/models/identity_state.dart';

/// Tests for IdentityState — authentication status and token display.
///
/// The legacy `hasMismatchedIdentities` and `dashboardTokenInfo` tests have been
/// removed: all identities now come from a single ADC source, so mismatch
/// detection is no longer applicable.

void main() {
  group('IdentityState.isAuthenticated', () {
    test('returns false when email is null', () {
      const state = IdentityState();
      expect(state.isAuthenticated, isFalse);
    });

    test('returns false when tokenInfo is null', () {
      const state = IdentityState(email: 'user@corp.com');
      expect(state.isAuthenticated, isFalse);
    });

    test('returns false when token is expired', () {
      final state = IdentityState(
        email: 'user@corp.com',
        tokenInfo: TokenInfo(
          expiresAt: _farPast,
        ),
      );
      expect(state.isAuthenticated, isFalse);
    });

    test('returns true when email present and token valid', () {
      final state = IdentityState(
        email: 'user@corp.com',
        tokenInfo: TokenInfo(
          expiresAt: _farFuture,
        ),
      );
      expect(state.isAuthenticated, isTrue);
    });

    test('returns false when email present but no tokenInfo', () {
      const state = IdentityState(email: 'user@corp.com');
      expect(state.isAuthenticated, isFalse);
    });
  });

  group('IdentityState fields', () {
    test('stores project', () {
      const state = IdentityState(project: 'my-gcp-project');
      expect(state.project, 'my-gcp-project');
    });

    test('stores adcInfo', () {
      const state = IdentityState(
        adcInfo: AdcInfo(
          path: '/home/.config/gcloud/adc.json',
          type: 'authorized_user',
          clientEmail: 'user@example.com',
        ),
      );
      expect(state.adcInfo, isNotNull);
      expect(state.adcInfo!.type, 'authorized_user');
    });

    test('defaults are all null', () {
      const state = IdentityState();
      expect(state.email, isNull);
      expect(state.project, isNull);
      expect(state.adcInfo, isNull);
      expect(state.tokenInfo, isNull);
    });
  });

  group('AdcInfo', () {
    test('isServiceAccount returns true for service_account type', () {
      const adc = AdcInfo(path: '/p', type: 'service_account');
      expect(adc.isServiceAccount, isTrue);
      expect(adc.isUserCredentials, isFalse);
    });

    test('isUserCredentials returns true for authorized_user type', () {
      const adc = AdcInfo(path: '/p', type: 'authorized_user');
      expect(adc.isUserCredentials, isTrue);
      expect(adc.isServiceAccount, isFalse);
    });

    test('canDirectRefresh requires user credentials with all OAuth2 fields',
        () {
      const withAll = AdcInfo(
        path: '/p',
        type: 'authorized_user',
        clientId: 'cid',
        clientSecret: 'csecret',
        refreshToken: 'rtoken',
      );
      expect(withAll.canDirectRefresh, isTrue);

      const withoutSecret = AdcInfo(
        path: '/p',
        type: 'authorized_user',
        clientId: 'cid',
        refreshToken: 'rtoken',
      );
      expect(withoutSecret.canDirectRefresh, isFalse);

      const saWithAll = AdcInfo(
        path: '/p',
        type: 'service_account',
        clientId: 'cid',
        clientSecret: 'csecret',
        refreshToken: 'rtoken',
      );
      expect(saWithAll.canDirectRefresh, isFalse);
    });

    test('displayType returns human-readable type', () {
      const sa = AdcInfo(path: '/p', type: 'service_account');
      expect(sa.displayType, 'Service Account');

      const user = AdcInfo(path: '/p', type: 'authorized_user');
      expect(user.displayType, 'Application Default Credentials');
    });
  });

  group('TokenInfo', () {
    test('expiryDisplay shows Expired for past dates', () {
      final token = TokenInfo(expiresAt: _farPast);
      expect(token.expiryDisplay, 'Expired');
    });

    test('expiryDisplay shows hours for far future', () {
      final token = TokenInfo(expiresAt: _farFuture);
      expect(token.expiryDisplay, contains('h'));
    });

    test('isValid returns true for future token', () {
      final token = TokenInfo(expiresAt: _farFuture);
      expect(token.isValid, isTrue);
    });

    test('isValid returns false for past token', () {
      final token = TokenInfo(expiresAt: _farPast);
      expect(token.isValid, isFalse);
    });

    test('timeRemaining is positive for future tokens', () {
      final token = TokenInfo(expiresAt: _farFuture);
      expect(token.timeRemaining.isNegative, isFalse);
    });

    test('timeRemaining is negative for expired tokens', () {
      final token = TokenInfo(expiresAt: _farPast);
      expect(token.timeRemaining.isNegative, isTrue);
    });
  });
}

final _farFuture = DateTime(2099);
final _farPast = DateTime(2020);
