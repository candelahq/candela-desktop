import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/models/identity_state.dart';

/// Tests for IdentityState — particularly the identity mismatch detection
/// that surfaces "ADC and gcloud auth are different accounts" warnings.

void main() {
  group('IdentityState.hasMismatchedIdentities', () {
    test('returns false when both emails are null', () {
      const state = IdentityState();
      expect(state.hasMismatchedIdentities, isFalse);
    });

    test('returns false when ADC email is null', () {
      final state = IdentityState(
        dashboardTokenInfo: TokenInfo(
          email: 'user@corp.com',
          expiresAt: _farFuture,
          isValid: true,
        ),
      );
      expect(state.hasMismatchedIdentities, isFalse);
    });

    test('returns false when dashboard email is null', () {
      final state = IdentityState(
        tokenInfo: TokenInfo(
          email: 'user@corp.com',
          expiresAt: _farFuture,
          isValid: true,
        ),
      );
      expect(state.hasMismatchedIdentities, isFalse);
    });

    test('returns false when emails match (same case)', () {
      final state = IdentityState(
        tokenInfo: TokenInfo(
          email: 'user@corp.com',
          expiresAt: _farFuture,
          isValid: true,
        ),
        dashboardTokenInfo: TokenInfo(
          email: 'user@corp.com',
          expiresAt: _farFuture,
          isValid: true,
        ),
      );
      expect(state.hasMismatchedIdentities, isFalse);
    });

    test('returns false when emails match (case-insensitive)', () {
      final state = IdentityState(
        tokenInfo: TokenInfo(
          email: 'User@Corp.com',
          expiresAt: _farFuture,
          isValid: true,
        ),
        dashboardTokenInfo: TokenInfo(
          email: 'user@corp.com',
          expiresAt: _farFuture,
          isValid: true,
        ),
      );
      expect(state.hasMismatchedIdentities, isFalse);
    });

    test('returns true when emails differ', () {
      final state = IdentityState(
        tokenInfo: TokenInfo(
          email: 'adc-user@corp.com',
          expiresAt: _farFuture,
          isValid: true,
        ),
        dashboardTokenInfo: TokenInfo(
          email: 'gcloud-user@corp.com',
          expiresAt: _farFuture,
          isValid: true,
        ),
      );
      expect(state.hasMismatchedIdentities, isTrue);
    });

    test('uses adcInfo.clientEmail when tokenInfo.email is null', () {
      final state = IdentityState(
        adcInfo: const AdcInfo(
          path: '/path',
          type: 'service_account',
          clientEmail: 'sa@project.iam.gserviceaccount.com',
        ),
        dashboardTokenInfo: TokenInfo(
          email: 'human@corp.com',
          expiresAt: _farFuture,
          isValid: true,
        ),
      );
      expect(state.hasMismatchedIdentities, isTrue);
    });

    test('prefers tokenInfo.email over adcInfo.clientEmail', () {
      final state = IdentityState(
        tokenInfo: TokenInfo(
          email: 'same@corp.com',
          expiresAt: _farFuture,
          isValid: true,
        ),
        adcInfo: const AdcInfo(
          path: '/path',
          type: 'authorized_user',
          clientEmail: 'different@corp.com',
        ),
        dashboardTokenInfo: TokenInfo(
          email: 'same@corp.com',
          expiresAt: _farFuture,
          isValid: true,
        ),
      );
      // tokenInfo.email matches dashboard, so no mismatch.
      expect(state.hasMismatchedIdentities, isFalse);
    });
  });

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
          isValid: false,
        ),
      );
      expect(state.isAuthenticated, isFalse);
    });

    test('returns true when email present and token valid', () {
      final state = IdentityState(
        email: 'user@corp.com',
        tokenInfo: TokenInfo(
          expiresAt: _farFuture,
          isValid: true,
        ),
      );
      expect(state.isAuthenticated, isTrue);
    });
  });

  group('TokenInfo', () {
    test('expiryDisplay shows Expired for past dates', () {
      final token = TokenInfo(expiresAt: _farPast, isValid: false);
      expect(token.expiryDisplay, 'Expired');
    });

    test('expiryDisplay shows hours for far future', () {
      final token = TokenInfo(expiresAt: _farFuture, isValid: true);
      expect(token.expiryDisplay, contains('h'));
    });
  });
}

final _farFuture = DateTime(2099);
final _farPast = DateTime(2020);
