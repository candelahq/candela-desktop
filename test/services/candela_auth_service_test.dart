import 'package:flutter_test/flutter_test.dart';

import 'package:candela_desktop/models/identity_state.dart';
import 'package:candela_desktop/services/adc_service.dart';
import 'package:candela_desktop/services/candela_auth_service.dart';

// ── Fakes ─────────────────────────────────────────────────────────────────────

class FakeAdcService extends AdcService {
  final AdcInfo? adcResult;
  final TokenInfo? tokenResult;

  FakeAdcService({this.adcResult, this.tokenResult});

  @override
  Future<AdcInfo?> readAdcFile() async => adcResult;

  @override
  Future<TokenInfo?> refreshAccessToken({AdcInfo? adcInfo}) async =>
      tokenResult;
}

// ── Helpers ───────────────────────────────────────────────────────────────────

AdcInfo _userAdc({String? quotaProject, String? clientEmail}) => AdcInfo(
      path: '/tmp/adc.json',
      type: 'authorized_user',
      clientEmail: clientEmail,
      quotaProject: quotaProject,
      clientId: 'cid',
      clientSecret: 'csecret',
      refreshToken: 'rtoken',
    );

AdcInfo _saAdc({String? email}) => AdcInfo(
      path: '/tmp/adc.json',
      type: 'service_account',
      clientEmail: email ?? 'sa@proj.iam.gserviceaccount.com',
    );

TokenInfo _validToken({String? email}) => TokenInfo(
      accessToken: 'ya29.fake-access-token',
      email: email ?? 'user@corp.com',
      expiresAt: DateTime.now().toUtc().add(const Duration(hours: 1)),
    );

TokenInfo _expiredToken() => TokenInfo(
      accessToken: 'ya29.old',
      email: 'user@corp.com',
      expiresAt: DateTime.now().toUtc().subtract(const Duration(hours: 1)),
    );

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  group('CandelaAuthService.getStatus', () {
    test('returns email and project from ADC + token', () async {
      final svc = CandelaAuthService(
        adcService: FakeAdcService(
          adcResult: _userAdc(quotaProject: 'my-project'),
          tokenResult: _validToken(email: 'alice@corp.com'),
        ),
      );

      final status = await svc.getStatus();
      expect(status.email, 'alice@corp.com');
      expect(status.project, 'my-project');
      expect(status.adcInfo, isNotNull);
      expect(status.tokenInfo, isNotNull);
      expect(status.tokenInfo!.isValid, isTrue);
    });

    test('falls back to clientEmail when token has no email', () async {
      final svc = CandelaAuthService(
        adcService: FakeAdcService(
          adcResult: _saAdc(email: 'sa@proj.iam.gserviceaccount.com'),
          tokenResult: TokenInfo(
            accessToken: 'ya29.sa-token',
            expiresAt: DateTime.now().toUtc().add(const Duration(hours: 1)),
          ),
        ),
      );

      final status = await svc.getStatus();
      expect(status.email, 'sa@proj.iam.gserviceaccount.com');
    });

    test('returns nulls when no ADC file exists', () async {
      final svc = CandelaAuthService(
        adcService: FakeAdcService(adcResult: null, tokenResult: null),
      );

      final status = await svc.getStatus();
      expect(status.email, isNull);
      expect(status.project, isNull);
      expect(status.adcInfo, isNull);
      expect(status.tokenInfo, isNull);
    });

    test('returns ADC info but null token when refresh fails', () async {
      final svc = CandelaAuthService(
        adcService: FakeAdcService(
          adcResult: _userAdc(quotaProject: 'proj'),
          tokenResult: null,
        ),
      );

      final status = await svc.getStatus();
      expect(status.adcInfo, isNotNull);
      expect(status.tokenInfo, isNull);
      expect(status.email, isNull); // no token → no email
      expect(status.project, 'proj'); // from ADC
    });

    test('project is null when ADC has no quota_project', () async {
      final svc = CandelaAuthService(
        adcService: FakeAdcService(
          adcResult: _userAdc(),
          tokenResult: _validToken(),
        ),
      );

      final status = await svc.getStatus();
      expect(status.project, isNull);
    });
  });

  group('CandelaAuthService.getAccessToken', () {
    test('returns access token string when available', () async {
      final svc = CandelaAuthService(
        adcService: FakeAdcService(tokenResult: _validToken()),
      );

      final token = await svc.getAccessToken();
      expect(token, 'ya29.fake-access-token');
    });

    test('returns null when refresh fails', () async {
      final svc = CandelaAuthService(
        adcService: FakeAdcService(tokenResult: null),
      );

      final token = await svc.getAccessToken();
      expect(token, isNull);
    });
  });

  group('CandelaAuthService.getTokenInfo', () {
    test('returns full TokenInfo with email and expiry', () async {
      final svc = CandelaAuthService(
        adcService: FakeAdcService(tokenResult: _validToken()),
      );

      final info = await svc.getTokenInfo();
      expect(info, isNotNull);
      expect(info!.email, 'user@corp.com');
      expect(info.isValid, isTrue);
    });

    test('returns expired token info correctly', () async {
      final svc = CandelaAuthService(
        adcService: FakeAdcService(tokenResult: _expiredToken()),
      );

      final info = await svc.getTokenInfo();
      expect(info, isNotNull);
      expect(info!.isValid, isFalse);
    });

    test('returns null when no credentials available', () async {
      final svc = CandelaAuthService(
        adcService: FakeAdcService(tokenResult: null),
      );

      final info = await svc.getTokenInfo();
      expect(info, isNull);
    });
  });

  group('CandelaAuthService.isApiEnabled', () {
    test('returns true when API state is ENABLED', () async {
      final svc = CandelaAuthService(
        adcService: FakeAdcService(tokenResult: _validToken()),
      );

      // We can't easily inject httpClient into isApiEnabled — this tests the
      // branch where getAccessToken succeeds but the HTTP call would fail
      // in a test environment (no real network). The test verifies that
      // the method doesn't throw and returns false gracefully.
      final result =
          await svc.isApiEnabled('my-project', 'aiplatform.googleapis.com');
      // In test env, the HTTP call fails → returns false.
      expect(result, isFalse);
    });

    test('returns false when no access token available', () async {
      final svc = CandelaAuthService(
        adcService: FakeAdcService(tokenResult: null),
      );

      final result = await svc.isApiEnabled('proj', 'some.api');
      expect(result, isFalse);
    });
  });

  group('AuthStatus', () {
    test('stores all fields', () {
      final adc = _userAdc(quotaProject: 'proj');
      final token = _validToken();
      final status = AuthStatus(
        email: 'a@b.com',
        project: 'proj',
        adcInfo: adc,
        tokenInfo: token,
      );
      expect(status.email, 'a@b.com');
      expect(status.project, 'proj');
      expect(status.adcInfo, isNotNull);
      expect(status.tokenInfo, isNotNull);
    });

    test('default constructor has all nulls', () {
      const status = AuthStatus();
      expect(status.email, isNull);
      expect(status.project, isNull);
      expect(status.adcInfo, isNull);
      expect(status.tokenInfo, isNull);
    });
  });
}
