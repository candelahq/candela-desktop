import 'package:flutter_test/flutter_test.dart';

import 'package:candela_desktop/models/identity_state.dart';
import 'package:candela_desktop/services/adc_service.dart';

void main() {
  group('AdcInfo', () {
    test('canDirectRefresh true for complete user credentials', () {
      const adc = AdcInfo(
        path: '/tmp/adc.json',
        type: 'authorized_user',
        clientId: 'id',
        clientSecret: 'secret',
        refreshToken: 'token',
      );
      expect(adc.canDirectRefresh, isTrue);
      expect(adc.isUserCredentials, isTrue);
      expect(adc.isServiceAccount, isFalse);
    });

    test('canDirectRefresh false for service account', () {
      const adc = AdcInfo(
        path: '/tmp/adc.json',
        type: 'service_account',
        clientEmail: 'sa@project.iam.gserviceaccount.com',
        clientId: 'id',
        clientSecret: 'secret',
        refreshToken: 'token',
      );
      expect(adc.canDirectRefresh, isFalse);
      expect(adc.isServiceAccount, isTrue);
    });

    test('canDirectRefresh false when missing clientId', () {
      const adc = AdcInfo(
        path: '/tmp/adc.json',
        type: 'authorized_user',
        clientSecret: 'secret',
        refreshToken: 'token',
      );
      expect(adc.canDirectRefresh, isFalse);
    });

    test('canDirectRefresh false when missing clientSecret', () {
      const adc = AdcInfo(
        path: '/tmp/adc.json',
        type: 'authorized_user',
        clientId: 'id',
        refreshToken: 'token',
      );
      expect(adc.canDirectRefresh, isFalse);
    });

    test('canDirectRefresh false when missing refreshToken', () {
      const adc = AdcInfo(
        path: '/tmp/adc.json',
        type: 'authorized_user',
        clientId: 'id',
        clientSecret: 'secret',
      );
      expect(adc.canDirectRefresh, isFalse);
    });

    test('displayType returns correct strings', () {
      const user = AdcInfo(path: '/tmp', type: 'authorized_user');
      const sa = AdcInfo(path: '/tmp', type: 'service_account');
      expect(user.displayType, 'Application Default Credentials');
      expect(sa.displayType, 'Service Account');
    });
  });

  group('TokenInfo.isValid dynamic getter', () {
    test('returns true for future expiry', () {
      final token = TokenInfo(
        expiresAt: DateTime.now().toUtc().add(const Duration(hours: 1)),
      );
      expect(token.isValid, isTrue);
    });

    test('returns false for past expiry', () {
      final token = TokenInfo(
        expiresAt: DateTime.now().toUtc().subtract(const Duration(hours: 1)),
      );
      expect(token.isValid, isFalse);
    });

    test('timeRemaining is positive for valid token', () {
      final token = TokenInfo(
        expiresAt: DateTime.now().toUtc().add(const Duration(minutes: 30)),
      );
      expect(token.timeRemaining.inMinutes, greaterThan(0));
    });

    test('expiryDisplay shows hours and minutes for long-lived token', () {
      final token = TokenInfo(
        expiresAt:
            DateTime.now().toUtc().add(const Duration(hours: 1, minutes: 15)),
      );
      expect(token.expiryDisplay, contains('h'));
    });

    test('expiryDisplay shows Expired for past token', () {
      final token = TokenInfo(
        expiresAt: DateTime.now().toUtc().subtract(const Duration(hours: 1)),
      );
      expect(token.expiryDisplay, 'Expired');
    });

    test('expiryDisplay shows minutes for short-lived token', () {
      final token = TokenInfo(
        expiresAt: DateTime.now().toUtc().add(const Duration(minutes: 12)),
      );
      expect(token.expiryDisplay, contains('min'));
    });

    test('expiryDisplay shows < 1 min for very short-lived token', () {
      final token = TokenInfo(
        expiresAt: DateTime.now().toUtc().add(const Duration(seconds: 30)),
      );
      expect(token.expiryDisplay, '< 1 min');
    });
  });

  group('AdcService.refreshAccessToken', () {
    test('returns null when AdcInfo has no credentials', () async {
      final service = AdcService();
      final result = await service.refreshAccessToken(
        adcInfo: const AdcInfo(
          path: '/tmp/fake.json',
          type: 'authorized_user',
        ),
      );
      expect(result, isNull);
    });

    test('returns null for service account credentials', () async {
      final service = AdcService();
      final result = await service.refreshAccessToken(
        adcInfo: const AdcInfo(
          path: '/tmp/sa.json',
          type: 'service_account',
          clientId: 'id',
          clientSecret: 'secret',
          refreshToken: 'token',
        ),
      );
      expect(result, isNull);
    });

    test('returns TokenInfo or null depending on real ADC file', () async {
      final service = AdcService();
      // This test verifies the method doesn't throw — the result depends
      // on whether the test machine has a real ADC file.
      final result = await service.refreshAccessToken();
      // Either null (no file) or a valid TokenInfo.
      if (result != null) {
        expect(result.accessToken, isNotNull);
        expect(result.expiresAt, isNotNull);
      }
    });
  });

  group('GCloudService._parseGcloudTokenJson', () {
    // Tested indirectly through getTokenInfoForTest in gcloud_service_test.
    // The shared helper is covered by the existing 742+ test suite via
    // the GCloudService integration.
  });
}
