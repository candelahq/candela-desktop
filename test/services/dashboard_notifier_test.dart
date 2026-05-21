import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/services/adc_service.dart';
import 'package:candela_desktop/services/dashboard_notifier.dart';
import 'package:candela_desktop/services/telemetry_service.dart';
import 'package:candela_desktop/models/candela_config.dart';
import 'package:candela_desktop/models/span_stats.dart';
import 'package:candela_desktop/models/identity_state.dart';
import 'package:candela_desktop/gen/candela/types/user.pbenum.dart';

void main() {
  group('DashboardState', () {
    test('default state has no data', () {
      const state = DashboardState();
      expect(state.hasData, isFalse);
      expect(state.loading, isFalse);
      expect(state.errorMessage, isNull);
      expect(state.range, TokenTimeRange.d7);
      expect(state.models, isEmpty);
      expect(state.spans, isEmpty);
      expect(state.summary, isNull);
      expect(state.budget, isNull);
      expect(state.activeGrants, isEmpty);
      expect(state.totalRemainingUsd, isNull);
    });

    test('copyWith preserves unchanged fields', () {
      const state = DashboardState(
        loading: true,
        range: TokenTimeRange.d30,
      );
      final updated = state.copyWith(loading: false);
      expect(updated.loading, isFalse);
      expect(updated.range, TokenTimeRange.d30); // preserved
    });

    test('copyWith can clear error', () {
      final state =
          const DashboardState(errorMessage: 'fail').copyWith(clearError: true);
      expect(state.errorMessage, isNull);
    });

    test('copyWith can set error', () {
      final state = const DashboardState().copyWith(errorMessage: 'oops');
      expect(state.errorMessage, 'oops');
    });

    test('copyWith with result updates hasData', () {
      final state = const DashboardState().copyWith(
        result: const TelemetryResult(
          summary: UsageSummary(
            totalCalls: 5,
            totalInputTokens: 100,
            totalOutputTokens: 50,
            totalCostUsd: 0.1,
            avgLatencyMs: 500.0,
            costOverTime: [],
            tokensOverTime: [],
            callsOverTime: [],
          ),
          models: [],
          spans: [],
          isTeamMode: false,
        ),
      );
      expect(state.hasData, isTrue);
      expect(state.summary!.totalCalls, 5);
    });

    test('isTeamMode delegates to result', () {
      final state = const DashboardState().copyWith(
        result: const TelemetryResult.empty(isTeamMode: true),
      );
      expect(state.isTeamMode, isTrue);
    });

    test('error delegates to result', () {
      final state = const DashboardState().copyWith(
        result: const TelemetryResult.withError(
          isTeamMode: false,
          error: TelemetryErrorKind.authExpired,
        ),
      );
      expect(state.error, TelemetryErrorKind.authExpired);
    });

    test('range changes via copyWith', () {
      final state = const DashboardState(range: TokenTimeRange.d7)
          .copyWith(range: TokenTimeRange.h24);
      expect(state.range, TokenTimeRange.h24);
    });

    test('default userScope is PERSONAL', () {
      const state = DashboardState();
      expect(state.userScope, UserScope.USER_SCOPE_PERSONAL);
    });

    test('copyWith preserves userScope when not specified', () {
      final state = const DashboardState(
        userScope: UserScope.USER_SCOPE_GLOBAL,
      ).copyWith(loading: true);
      expect(state.userScope, UserScope.USER_SCOPE_GLOBAL);
    });

    test('copyWith updates userScope', () {
      final state = const DashboardState()
          .copyWith(userScope: UserScope.USER_SCOPE_PERSONAL);
      expect(state.userScope, UserScope.USER_SCOPE_PERSONAL);
    });

    test('copyWith can switch scope from PERSONAL to GLOBAL', () {
      final state = const DashboardState(
        userScope: UserScope.USER_SCOPE_PERSONAL,
      ).copyWith(userScope: UserScope.USER_SCOPE_GLOBAL);
      expect(state.userScope, UserScope.USER_SCOPE_GLOBAL);
    });
  });

  group('DashboardNotifier', () {
    test('initial state is loading', () {
      final notifier = DashboardNotifier();
      expect(notifier.state.loading, isTrue);
      notifier.dispose();
    });

    test('isConfigured false before configure', () {
      final notifier = DashboardNotifier();
      expect(notifier.isConfigured, isFalse);
      notifier.dispose();
    });

    test('notifies on state change via setRange', () {
      final notifier = DashboardNotifier();
      int notifyCount = 0;
      notifier.addListener(() => notifyCount++);

      notifier.setRange(TokenTimeRange.h24);
      Future.delayed(const Duration(milliseconds: 200), () {
        expect(notifyCount, greaterThan(0));
        notifier.dispose();
      });
    });

    test('dispose cancels timer', () {
      final notifier = DashboardNotifier();
      notifier.startPolling(interval: const Duration(seconds: 1));
      notifier.dispose();
    });

    test('cache TTL defaults to 50 seconds', () {
      final notifier = DashboardNotifier();
      expect(notifier.cacheTtl, const Duration(seconds: 50));
      notifier.dispose();
    });

    test('custom cache TTL is respected', () {
      final notifier = DashboardNotifier(
        cacheTtl: const Duration(seconds: 60),
      );
      expect(notifier.cacheTtl, const Duration(seconds: 60));
      notifier.dispose();
    });

    test('buildFilteredSummary returns null when not configured', () {
      final notifier = DashboardNotifier();
      expect(notifier.buildFilteredSummary(null), isNull);
      notifier.dispose();
    });
  });

  // ── AdcService integration tests ──────────────────────────────────────────

  group('DashboardNotifier — AdcService auth', () {
    test('configure() in team mode uses AdcService token', () async {
      final adc = _FakeAdcService(token: 'test-token-123');
      final notifier = DashboardNotifier(adcService: adc);

      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.team,
        remote: 'https://candela.example.com',
      ));

      expect(notifier.isConfigured, isTrue);
      expect(adc.refreshCallCount, 1);
      notifier.dispose();
    });

    test('configure() in solo mode does not call AdcService', () async {
      final adc = _FakeAdcService(token: 'should-not-be-used');
      final notifier = DashboardNotifier(adcService: adc);

      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.solo,
      ));

      expect(notifier.isConfigured, isTrue);
      expect(adc.refreshCallCount, 0);
      notifier.dispose();
    });

    test('configure() in team mode with null token still configures', () async {
      final adc = _NullAdcService();
      final notifier = DashboardNotifier(adcService: adc);

      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.team,
        remote: 'https://candela.example.com',
      ));

      // TelemetryService is created even without a token (will get 401 at
      // fetch time, which is handled gracefully).
      expect(notifier.isConfigured, isTrue);
      notifier.dispose();
    });

    test('configure() with empty remote stays in local mode', () async {
      final adc = _FakeAdcService(token: 'should-not-be-used');
      final notifier = DashboardNotifier(adcService: adc);

      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.team,
        remote: '', // empty → not team mode
      ));

      // Empty remote means isTeam evaluates to false.
      expect(adc.refreshCallCount, 0);
      notifier.dispose();
    });

    test('refreshToken returns token from AdcService in team mode', () async {
      final adc = _FakeAdcService(token: 'fresh-token');
      final notifier = DashboardNotifier(adcService: adc);

      // Must configure in team mode first — refreshToken guards on _remoteUrl.
      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.team,
        remote: 'https://candela.example.com',
      ));

      final token = await notifier.refreshToken();
      expect(token, 'fresh-token');
      notifier.dispose();
    });

    test('refreshToken returns null without ADC credentials', () async {
      final notifier = DashboardNotifier(adcService: _NullAdcService());

      // Configure in team mode but with null-returning AdcService.
      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.team,
        remote: 'https://candela.example.com',
      ));

      final token = await notifier.refreshToken();
      expect(token, isNull);
      notifier.dispose();
    });

    test('refreshToken returns null in solo mode', () async {
      final adc = _FakeAdcService(token: 'should-not-be-used');
      final notifier = DashboardNotifier(adcService: adc);

      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.solo,
      ));

      final token = await notifier.refreshToken();
      expect(token, isNull);
      // AdcService should not have been called for refreshToken.
      expect(adc.refreshCallCount, 0);
      notifier.dispose();
    });

    test('configure() in team mode then re-configure in solo mode', () async {
      final adc = _FakeAdcService(token: 'team-token');
      final notifier = DashboardNotifier(adcService: adc);

      // First: team mode.
      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.team,
        remote: 'https://candela.example.com',
      ));
      expect(adc.refreshCallCount, 1);

      // Second: switch to solo.
      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.solo,
      ));
      expect(notifier.isConfigured, isTrue);
      // No additional AdcService call for solo mode.
      expect(adc.refreshCallCount, 1);
      notifier.dispose();
    });

    test('notifyListeners fires after fetch completes', () async {
      final adc = _NullAdcService();
      final notifier = DashboardNotifier(adcService: adc);
      int notifyCount = 0;
      notifier.addListener(() => notifyCount++);

      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.solo,
      ));

      // fetch() will fail (no local proxy running) but should still
      // notify listeners to clear the loading state.
      await notifier.fetch();
      expect(notifyCount, greaterThan(0));
      expect(notifier.state.loading, isFalse);
      notifier.dispose();
    });

    test('safe notification after dispose does not throw', () async {
      final notifier = DashboardNotifier(adcService: _NullAdcService());
      notifier.dispose();

      // Should not throw — guarded by _disposed flag.
      notifier.notifyListeners();
    });
  });

  // ── Token refresh lifecycle ───────────────────────────────────────────────

  group('DashboardNotifier — token refresh lifecycle', () {
    test('fetch() skips token refresh when token is still fresh', () async {
      // Token expires in 1 hour — well outside the 5-minute refresh buffer.
      final adc = _ExpiryAdcService(
        token: 'fresh-token',
        expiresIn: const Duration(hours: 1),
      );
      final notifier = DashboardNotifier(adcService: adc);

      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.team,
        remote: 'https://candela.example.com',
      ));
      expect(adc.refreshCallCount, 1); // initial configure

      // fetch() should NOT trigger another refresh.
      await notifier.fetch();
      expect(adc.refreshCallCount, 1); // still 1
      notifier.dispose();
    });

    test('fetch() triggers token refresh when token is near expiry', () async {
      // Token expires in 2 minutes — within the 5-minute buffer.
      final adc = _ExpiryAdcService(
        token: 'expiring-token',
        expiresIn: const Duration(minutes: 2),
      );
      final notifier = DashboardNotifier(adcService: adc);

      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.team,
        remote: 'https://candela.example.com',
      ));
      expect(adc.refreshCallCount, 1); // initial configure

      // fetch() should trigger a refresh (token is within 5-min buffer).
      await notifier.fetch();
      expect(adc.refreshCallCount, 2); // refreshed!
      notifier.dispose();
    });

    test('fetch() triggers refresh when token is already expired', () async {
      // Token expired 10 minutes ago.
      final adc = _ExpiryAdcService(
        token: 'expired-token',
        expiresIn: const Duration(minutes: -10),
      );
      final notifier = DashboardNotifier(adcService: adc);

      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.team,
        remote: 'https://candela.example.com',
      ));
      expect(adc.refreshCallCount, 1);

      await notifier.fetch();
      expect(adc.refreshCallCount, 2);
      notifier.dispose();
    });

    test('fetch() preserves service when refresh fails but token still valid',
        () async {
      // First configure with a token expiring in 3 minutes (within buffer).
      final adc = _FailAfterNAdcService(
        token: 'original-token',
        expiresIn: const Duration(minutes: 3),
        failAfter: 1, // first call succeeds, second call returns null
      );
      final notifier = DashboardNotifier(adcService: adc);

      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.team,
        remote: 'https://candela.example.com',
      ));
      expect(adc.refreshCallCount, 1); // configure succeeded

      // fetch() tries to refresh (within buffer), but refresh returns null.
      // Since the token hasn't actually expired, the existing service should
      // be preserved.
      await notifier.fetch();
      expect(adc.refreshCallCount, 2); // attempted refresh
      // The notifier should still be configured (service not wiped).
      expect(notifier.isConfigured, isTrue);
      notifier.dispose();
    });

    test('fetch() in local mode skips token refresh entirely', () async {
      final adc = _FakeAdcService(token: 'should-not-be-used');
      final notifier = DashboardNotifier(adcService: adc);

      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.solo,
      ));
      expect(adc.refreshCallCount, 0);

      await notifier.fetch();
      // AdcService should never be called in local mode.
      expect(adc.refreshCallCount, 0);
      notifier.dispose();
    });

    test('multiple fetches with fresh token only refresh once', () async {
      final adc = _ExpiryAdcService(
        token: 'long-lived',
        expiresIn: const Duration(hours: 1),
      );
      final notifier = DashboardNotifier(adcService: adc);

      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.team,
        remote: 'https://candela.example.com',
      ));

      // Multiple fetches — none should trigger refresh.
      await notifier.fetch();
      await notifier.fetch();
      await notifier.fetch();
      expect(adc.refreshCallCount, 1); // only the initial configure
      notifier.dispose();
    });

    test('configure() disposes old TelemetryService on re-configure', () async {
      final adc = _FakeAdcService(token: 'token-v1');
      final notifier = DashboardNotifier(adcService: adc);

      // First configure.
      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.team,
        remote: 'https://candela.example.com',
      ));
      expect(notifier.isConfigured, isTrue);

      // Re-configure — should cleanly replace the TelemetryService.
      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.team,
        remote: 'https://v2.candela.example.com',
      ));
      expect(notifier.isConfigured, isTrue);
      expect(adc.refreshCallCount, 2); // one per configure
      notifier.dispose();
    });

    test('fetch() clears loading state even on error', () async {
      final notifier = DashboardNotifier(adcService: _NullAdcService());

      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.solo,
      ));

      expect(notifier.state.loading, isTrue); // initial state

      // Fetch will fail (no local proxy), but should still clear loading.
      await notifier.fetch();
      expect(notifier.state.loading, isFalse);
      notifier.dispose();
    });

    test('setRange triggers notification', () async {
      final notifier = DashboardNotifier(adcService: _NullAdcService());
      final ranges = <TokenTimeRange>[];
      notifier.addListener(() => ranges.add(notifier.state.range));

      notifier.setRange(TokenTimeRange.h24);
      // Allow microtask to complete.
      await Future<void>.delayed(Duration.zero);
      expect(ranges, contains(TokenTimeRange.h24));
      notifier.dispose();
    });

    test('setUserScope updates state and notifies', () async {
      final notifier = DashboardNotifier(adcService: _NullAdcService());
      expect(notifier.state.userScope, UserScope.USER_SCOPE_PERSONAL);

      final scopes = <UserScope>[];
      notifier.addListener(() => scopes.add(notifier.state.userScope));

      await notifier.setUserScope(UserScope.USER_SCOPE_GLOBAL);
      expect(notifier.state.userScope, UserScope.USER_SCOPE_GLOBAL);
      expect(scopes, contains(UserScope.USER_SCOPE_GLOBAL));
      notifier.dispose();
    });

    test('setUserScope invalidates cache (lastFetchAt)', () async {
      final notifier = DashboardNotifier(adcService: _NullAdcService());

      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.solo,
      ));

      // Initial fetch populates cache timestamp.
      await notifier.fetch();
      expect(notifier.state.loading, isFalse);

      // Switching scope should invalidate cache and trigger re-fetch.
      int notifyCount = 0;
      notifier.addListener(() => notifyCount++);
      await notifier.setUserScope(UserScope.USER_SCOPE_PERSONAL);
      // At least one notification from setUserScope + fetch.
      expect(notifyCount, greaterThanOrEqualTo(1));
      expect(notifier.state.userScope, UserScope.USER_SCOPE_PERSONAL);
      notifier.dispose();
    });

    test('setUserScope from PERSONAL to GLOBAL toggles correctly', () async {
      final notifier = DashboardNotifier(adcService: _NullAdcService());

      await notifier.setUserScope(UserScope.USER_SCOPE_PERSONAL);
      expect(notifier.state.userScope, UserScope.USER_SCOPE_PERSONAL);

      await notifier.setUserScope(UserScope.USER_SCOPE_GLOBAL);
      expect(notifier.state.userScope, UserScope.USER_SCOPE_GLOBAL);
      notifier.dispose();
    });
  });
}

// ── Test doubles ──────────────────────────────────────────────────────────────

/// Stub that always returns null — simulates missing/invalid ADC credentials.
class _NullAdcService extends AdcService {
  @override
  Future<TokenInfo?> refreshAccessToken({AdcInfo? adcInfo}) async => null;
}

/// Fake that returns a controllable token and tracks call count.
class _FakeAdcService extends AdcService {
  final String token;
  int refreshCallCount = 0;

  _FakeAdcService({required this.token});

  @override
  Future<TokenInfo?> refreshAccessToken({AdcInfo? adcInfo}) async {
    refreshCallCount++;
    return TokenInfo(
      accessToken: token,
      expiresAt: DateTime.now().toUtc().add(const Duration(hours: 1)),
    );
  }
}

/// Fake with controllable token expiry for testing refresh lifecycle.
class _ExpiryAdcService extends AdcService {
  final String token;
  final Duration expiresIn;
  int refreshCallCount = 0;

  _ExpiryAdcService({required this.token, required this.expiresIn});

  @override
  Future<TokenInfo?> refreshAccessToken({AdcInfo? adcInfo}) async {
    refreshCallCount++;
    return TokenInfo(
      accessToken: token,
      expiresAt: DateTime.now().toUtc().add(expiresIn),
    );
  }
}

/// Fake that succeeds for the first [failAfter] calls, then returns null.
/// Simulates transient OAuth2 refresh failures.
class _FailAfterNAdcService extends AdcService {
  final String token;
  final Duration expiresIn;
  final int failAfter;
  int refreshCallCount = 0;

  _FailAfterNAdcService({
    required this.token,
    required this.expiresIn,
    required this.failAfter,
  });

  @override
  Future<TokenInfo?> refreshAccessToken({AdcInfo? adcInfo}) async {
    refreshCallCount++;
    if (refreshCallCount > failAfter) return null;
    return TokenInfo(
      accessToken: token,
      expiresAt: DateTime.now().toUtc().add(expiresIn),
    );
  }
}
