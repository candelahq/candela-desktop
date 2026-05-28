import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/services/adc_service.dart';
import 'package:candela_desktop/services/candela_auth_service.dart';
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
          budget: null,
          activeGrants: [],
          totalRemainingUsd: null,
        ),
      );
      expect(state.hasData, isTrue);
      expect(state.summary, isNotNull);
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

  // ── Basic construction / lifecycle ─────────────────────────────────────────

  group('DashboardController — lifecycle', () {
    test('isConfigured is false before configure()', () {
      final notifier = DashboardController();
      expect(notifier.isConfigured, isFalse);
      notifier.dispose();
    });

    test('notifies on state change via setRange', () async {
      final notifier = DashboardController();
      int notifyCount = 0;
      notifier.onStateChanged = (_) => notifyCount++;

      await notifier.setRange(TokenTimeRange.h24);
      expect(notifyCount, greaterThan(0));
      notifier.dispose();
    });

    test('dispose cancels timer', () {
      final notifier = DashboardController();
      notifier.startPolling(interval: const Duration(seconds: 1));
      notifier.dispose();
    });

    test('cache TTL defaults to 50 seconds', () {
      final notifier = DashboardController();
      expect(notifier.cacheTtl, const Duration(seconds: 50));
      notifier.dispose();
    });

    test('custom cache TTL is respected', () {
      final notifier = DashboardController(
        cacheTtl: const Duration(seconds: 60),
      );
      expect(notifier.cacheTtl, const Duration(seconds: 60));
      notifier.dispose();
    });

    test('buildFilteredSummary returns null when not configured', () {
      final notifier = DashboardController();
      expect(notifier.buildFilteredSummary(null), isNull);
      notifier.dispose();
    });
  });

  // ── CandelaAuthService integration tests ─────────────────────────────────

  group('DashboardController — CandelaAuthService auth', () {
    test('configure() in team mode does not call auth service', () async {
      final adc = _FakeAdcService(token: 'test-token-123');
      final auth = CandelaAuthService(adcService: adc);
      final notifier = DashboardController(candelaAuth: auth);

      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.team,
        remote: 'https://candela.example.com',
      ));

      // Proxy-routed: configure() never calls auth in team mode.
      expect(notifier.isConfigured, isTrue);
      expect(adc.refreshCallCount, 0);
      notifier.dispose();
    });

    test('configure() in solo mode does not call auth service', () async {
      final adc = _FakeAdcService(token: 'should-not-be-used');
      final auth = CandelaAuthService(adcService: adc);
      final notifier = DashboardController(candelaAuth: auth);

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
      final auth = CandelaAuthService(adcService: adc);
      final notifier = DashboardController(candelaAuth: auth);

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
      final auth = CandelaAuthService(adcService: adc);
      final notifier = DashboardController(candelaAuth: auth);

      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.team,
        remote: '', // empty → not team mode
      ));

      // Empty remote means isTeam evaluates to false.
      expect(adc.refreshCallCount, 0);
      notifier.dispose();
    });

    test('refreshToken returns token from auth service in team mode', () async {
      final adc = _FakeAdcService(token: 'fresh-token');
      final auth = CandelaAuthService(adcService: adc);
      final notifier = DashboardController(candelaAuth: auth);

      // Configure in team mode — no auth call from configure.
      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.team,
        remote: 'https://candela.example.com',
      ));

      // refreshToken always tries auth.getTokenInfo() regardless of mode.
      final token = await notifier.refreshToken();
      expect(token, 'fresh-token');
      notifier.dispose();
    });

    test('refreshToken returns null without ADC credentials', () async {
      final auth = CandelaAuthService(adcService: _NullAdcService());
      final notifier = DashboardController(candelaAuth: auth);

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

    test('refreshToken returns token even in solo mode', () async {
      final adc = _FakeAdcService(token: 'solo-token');
      final auth = CandelaAuthService(adcService: adc);
      final notifier = DashboardController(candelaAuth: auth);

      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.solo,
      ));

      // refreshToken no longer guards on team mode — always calls auth.
      final token = await notifier.refreshToken();
      expect(token, 'solo-token');
      expect(adc.refreshCallCount, 1);
      notifier.dispose();
    });

    test('configure() in team mode then re-configure in solo mode', () async {
      final adc = _FakeAdcService(token: 'team-token');
      final auth = CandelaAuthService(adcService: adc);
      final notifier = DashboardController(candelaAuth: auth);

      // First: team mode — no auth call from configure.
      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.team,
        remote: 'https://candela.example.com',
      ));
      expect(adc.refreshCallCount, 0);

      // Second: switch to solo.
      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.solo,
      ));
      expect(notifier.isConfigured, isTrue);
      // No AdcService calls from configure in either mode.
      expect(adc.refreshCallCount, 0);
      notifier.dispose();
    });

    test('refreshToken returns token after switching Team→Solo', () async {
      final adc = _FakeAdcService(token: 'team-token');
      final auth = CandelaAuthService(adcService: adc);
      final notifier = DashboardController(candelaAuth: auth);

      // Configure in team mode — no auth call from configure.
      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.team,
        remote: 'https://candela.example.com',
      ));
      expect(adc.refreshCallCount, 0);

      // Switch to solo mode.
      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.solo,
      ));

      // refreshToken no longer guards on team mode — always calls auth.
      final token = await notifier.refreshToken();
      expect(token, 'team-token');
      expect(adc.refreshCallCount, 1);
      notifier.dispose();
    });

    test('fetch() after Team→Solo does not trigger token refresh', () async {
      final adc = _ExpiryAdcService(
        token: 'expiring-team-token',
        expiresIn: const Duration(minutes: 2), // within refresh buffer
      );
      final auth = CandelaAuthService(adcService: adc);
      final notifier = DashboardController(candelaAuth: auth);

      // Configure in team mode — no auth call from configure.
      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.team,
        remote: 'https://candela.example.com',
      ));
      expect(adc.refreshCallCount, 0);

      // Switch to solo mode.
      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.solo,
      ));

      // _refreshTokenIfNeeded is a no-op — fetch never triggers token refresh.
      await notifier.fetch();
      expect(adc.refreshCallCount, 0);
      notifier.dispose();
    });

    test('Solo→Team→Solo→Team round-trip recovers auth correctly', () async {
      final adc = _FakeAdcService(token: 'round-trip-token');
      final auth = CandelaAuthService(adcService: adc);
      final notifier = DashboardController(candelaAuth: auth);

      // 1. Start in Solo — no auth call from configure.
      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.solo,
      ));
      expect(adc.refreshCallCount, 0);

      // 2. Switch to Team — still no auth call from configure.
      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.team,
        remote: 'https://candela.example.com',
      ));
      expect(adc.refreshCallCount, 0);
      // refreshToken always calls auth regardless of mode.
      var token = await notifier.refreshToken();
      expect(token, 'round-trip-token');
      expect(adc.refreshCallCount, 1);

      // 3. Switch back to Solo — refreshToken still works.
      // Note: CandelaAuthService caches the token (1hr expiry > 5min buffer),
      // so this call returns the cached token without calling AdcService.
      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.solo,
      ));
      token = await notifier.refreshToken();
      expect(token, 'round-trip-token');
      expect(adc.refreshCallCount, 1); // cached, no extra call

      // 4. Switch to Team again — auth still works (still cached).
      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.team,
        remote: 'https://v2.candela.example.com',
      ));
      expect(adc.refreshCallCount, 1); // no call from configure
      token = await notifier.refreshToken();
      expect(token, 'round-trip-token');
      expect(adc.refreshCallCount, 1); // still cached
      notifier.dispose();
    });

    test('polling timer after Team→Solo does not trigger token refresh',
        () async {
      final adc = _ExpiryAdcService(
        token: 'expiring-team-token',
        expiresIn: const Duration(minutes: 2), // within refresh buffer
      );
      final auth = CandelaAuthService(adcService: adc);
      final notifier = DashboardController(candelaAuth: auth);

      // Configure in team mode — no auth call from configure.
      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.team,
        remote: 'https://candela.example.com',
      ));
      expect(adc.refreshCallCount, 0);
      notifier.startPolling(interval: const Duration(milliseconds: 50));

      // Switch to solo mode — timer is still running.
      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.solo,
      ));

      // Let several timer ticks fire.
      await Future<void>.delayed(const Duration(milliseconds: 250));

      // _refreshTokenIfNeeded is a no-op — timer ticks never trigger refresh.
      expect(adc.refreshCallCount, 0);
      notifier.dispose();
    });

    test('onStateChanged fires after fetch completes', () async {
      final auth = CandelaAuthService(adcService: _NullAdcService());
      final notifier = DashboardController(candelaAuth: auth);
      final states = <DashboardState>[];
      notifier.onStateChanged = (s) => states.add(s);

      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.solo,
      ));

      // fetch() will fail (no local proxy running) but should still
      // fire onStateChanged to clear the loading state.
      await notifier.fetch();
      expect(states, isNotEmpty);
      expect(notifier.state.loading, isFalse);
      notifier.dispose();
    });

    test('state changes after dispose do not invoke callback', () async {
      final auth = CandelaAuthService(adcService: _NullAdcService());
      final notifier = DashboardController(candelaAuth: auth);
      int callbackCount = 0;
      notifier.onStateChanged = (_) => callbackCount++;
      notifier.dispose();

      // Setting state after dispose should not invoke the callback
      // and should not throw.
      notifier.state = const DashboardState(loading: true);
      expect(callbackCount, 0);
    });

    test('onStateChanged receives the new state snapshot', () async {
      final notifier = DashboardController();
      DashboardState? received;
      notifier.onStateChanged = (s) => received = s;

      await notifier.setRange(TokenTimeRange.h24);
      expect(received, isNotNull);
      expect(received!.range, TokenTimeRange.h24);
      notifier.dispose();
    });

    test('onStateChanged is not invoked when callback is null', () {
      // Ensures no NPE when no callback is registered.
      final notifier = DashboardController();
      expect(notifier.onStateChanged, isNull);
      // Trigger a state change without a registered callback.
      notifier.state = const DashboardState(loading: true);
      expect(notifier.state.loading, isTrue);
      notifier.dispose();
    });
  });

  // ── Token refresh lifecycle ───────────────────────────────────────────────

  group('DashboardController — token refresh lifecycle', () {
    test('fetch() does not trigger token refresh (proxy handles auth)',
        () async {
      // _refreshTokenIfNeeded is a no-op in proxy-routed architecture.
      final adc = _ExpiryAdcService(
        token: 'fresh-token',
        expiresIn: const Duration(hours: 1),
      );
      final auth = CandelaAuthService(adcService: adc);
      final notifier = DashboardController(candelaAuth: auth);

      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.team,
        remote: 'https://candela.example.com',
      ));
      expect(adc.refreshCallCount, 0); // configure no longer calls auth

      // fetch() should NOT trigger any refresh — proxy handles auth.
      await notifier.fetch();
      expect(adc.refreshCallCount, 0);
      notifier.dispose();
    });

    test('fetch() with near-expiry token does not trigger refresh', () async {
      // _refreshTokenIfNeeded is now a no-op.
      final adc = _ExpiryAdcService(
        token: 'expiring-token',
        expiresIn: const Duration(minutes: 2),
      );
      final auth = CandelaAuthService(adcService: adc);
      final notifier = DashboardController(candelaAuth: auth);

      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.team,
        remote: 'https://candela.example.com',
      ));
      expect(adc.refreshCallCount, 0);

      // fetch() no longer refreshes tokens — proxy handles auth.
      await notifier.fetch();
      expect(adc.refreshCallCount, 0);
      notifier.dispose();
    });

    test('fetch() with expired token does not trigger refresh', () async {
      // _refreshTokenIfNeeded is now a no-op.
      final adc = _ExpiryAdcService(
        token: 'expired-token',
        expiresIn: const Duration(minutes: -10),
      );
      final auth = CandelaAuthService(adcService: adc);
      final notifier = DashboardController(candelaAuth: auth);

      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.team,
        remote: 'https://candela.example.com',
      ));
      expect(adc.refreshCallCount, 0);

      await notifier.fetch();
      expect(adc.refreshCallCount, 0);
      notifier.dispose();
    });

    test('fetch() preserves service (no refresh attempt)', () async {
      // _refreshTokenIfNeeded is a no-op, so no refresh is attempted.
      final adc = _FailAfterNAdcService(
        token: 'original-token',
        expiresIn: const Duration(minutes: 3),
        failAfter: 1,
      );
      final auth = CandelaAuthService(adcService: adc);
      final notifier = DashboardController(candelaAuth: auth);

      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.team,
        remote: 'https://candela.example.com',
      ));
      expect(adc.refreshCallCount, 0);

      // fetch() does not attempt token refresh — proxy handles auth.
      await notifier.fetch();
      expect(adc.refreshCallCount, 0);
      // The notifier should still be configured.
      expect(notifier.isConfigured, isTrue);
      notifier.dispose();
    });

    test('fetch() in local mode skips token refresh entirely', () async {
      final adc = _FakeAdcService(token: 'should-not-be-used');
      final auth = CandelaAuthService(adcService: adc);
      final notifier = DashboardController(candelaAuth: auth);

      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.solo,
      ));
      expect(adc.refreshCallCount, 0);

      await notifier.fetch();
      // AdcService should never be called — _refreshTokenIfNeeded is a no-op.
      expect(adc.refreshCallCount, 0);
      notifier.dispose();
    });

    test('multiple fetches never trigger token refresh', () async {
      final adc = _ExpiryAdcService(
        token: 'long-lived',
        expiresIn: const Duration(hours: 1),
      );
      final auth = CandelaAuthService(adcService: adc);
      final notifier = DashboardController(candelaAuth: auth);

      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.team,
        remote: 'https://candela.example.com',
      ));

      // Multiple fetches — none should trigger refresh (proxy handles auth).
      await notifier.fetch();
      await notifier.fetch();
      await notifier.fetch();
      expect(adc.refreshCallCount, 0);
      notifier.dispose();
    });

    test('configure() disposes old TelemetryService on re-configure', () async {
      final adc = _FakeAdcService(token: 'token-v1');
      final auth = CandelaAuthService(adcService: adc);
      final notifier = DashboardController(candelaAuth: auth);

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
      // configure() never calls auth in proxy-routed architecture.
      expect(adc.refreshCallCount, 0);
      notifier.dispose();
    });

    test('fetch() clears loading state even on error', () async {
      final auth = CandelaAuthService(adcService: _NullAdcService());
      final notifier = DashboardController(candelaAuth: auth);

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

    test('setRange triggers onStateChanged', () async {
      final auth = CandelaAuthService(adcService: _NullAdcService());
      final notifier = DashboardController(candelaAuth: auth);
      final ranges = <TokenTimeRange>[];
      notifier.onStateChanged = (s) => ranges.add(s.range);

      await notifier.setRange(TokenTimeRange.h24);
      // Allow microtask to complete.
      await Future<void>.delayed(Duration.zero);
      expect(ranges, contains(TokenTimeRange.h24));
      notifier.dispose();
    });

    test('setUserScope updates state and fires callback', () async {
      final notifier = DashboardController();
      expect(notifier.state.userScope, UserScope.USER_SCOPE_PERSONAL);

      final scopes = <UserScope>[];
      notifier.onStateChanged = (s) => scopes.add(s.userScope);

      await notifier.setUserScope(UserScope.USER_SCOPE_GLOBAL);
      expect(notifier.state.userScope, UserScope.USER_SCOPE_GLOBAL);
      expect(scopes, contains(UserScope.USER_SCOPE_GLOBAL));
      notifier.dispose();
    });

    test('setUserScope invalidates cache (lastFetchAt)', () async {
      final notifier = DashboardController();

      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.solo,
      ));

      // Initial fetch populates cache timestamp.
      await notifier.fetch();
      expect(notifier.state.loading, isFalse);

      // Switching scope should invalidate cache and trigger re-fetch.
      final states = <DashboardState>[];
      notifier.onStateChanged = (s) => states.add(s);
      await notifier.setUserScope(UserScope.USER_SCOPE_PERSONAL);
      // At least one callback from setUserScope + fetch.
      expect(states, isNotEmpty);
      expect(notifier.state.userScope, UserScope.USER_SCOPE_PERSONAL);
      notifier.dispose();
    });

    test('setUserScope from PERSONAL to GLOBAL toggles correctly', () async {
      final notifier = DashboardController();

      await notifier.setUserScope(UserScope.USER_SCOPE_PERSONAL);
      expect(notifier.state.userScope, UserScope.USER_SCOPE_PERSONAL);

      await notifier.setUserScope(UserScope.USER_SCOPE_GLOBAL);
      expect(notifier.state.userScope, UserScope.USER_SCOPE_GLOBAL);
      notifier.dispose();
    });
  });

  // ── App lifecycle (visibility-aware polling) ──────────────────────────────

  group('DashboardController — onAppLifecycleChanged', () {
    test('resumed from paused triggers immediate fetch', () async {
      final notifier = DashboardController();
      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.solo,
      ));

      final states = <DashboardState>[];
      notifier.onStateChanged = (s) => states.add(s);

      // Simulate backgrounding then resuming.
      notifier.onAppLifecycleChanged(AppLifecycleState.paused);
      notifier.onAppLifecycleChanged(AppLifecycleState.resumed);

      // Allow the async fetch triggered by resume to complete.
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // Should have fired at least one state change from the fetch.
      expect(states, isNotEmpty);
      notifier.dispose();
    });

    test('paused state suppresses timer-driven fetches', () async {
      final notifier = DashboardController();
      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.solo,
      ));

      int fetchCount = 0;
      notifier.onStateChanged = (_) => fetchCount++;

      // Background the app.
      notifier.onAppLifecycleChanged(AppLifecycleState.paused);

      // Start polling with a very short interval.
      notifier.startPolling(interval: const Duration(milliseconds: 50));

      // Wait for a few ticks — none should trigger a fetch.
      await Future<void>.delayed(const Duration(milliseconds: 200));
      expect(fetchCount, 0);
      notifier.dispose();
    });

    test('resumed when already visible is a no-op', () async {
      final notifier = DashboardController();
      // Controller starts with _appVisible = true by default.

      int fetchCount = 0;
      notifier.onStateChanged = (_) => fetchCount++;

      // Resume while already visible — should not trigger a fetch.
      notifier.onAppLifecycleChanged(AppLifecycleState.resumed);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(fetchCount, 0);
      notifier.dispose();
    });

    test('hidden state is treated as not visible', () async {
      final notifier = DashboardController();
      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.solo,
      ));

      notifier.onAppLifecycleChanged(AppLifecycleState.hidden);

      int fetchCount = 0;
      notifier.onStateChanged = (_) => fetchCount++;

      // Start polling — should not fetch while hidden.
      notifier.startPolling(interval: const Duration(milliseconds: 50));
      await Future<void>.delayed(const Duration(milliseconds: 200));
      expect(fetchCount, 0);
      notifier.dispose();
    });

    test('resume after hidden triggers immediate fetch', () async {
      final notifier = DashboardController();
      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.solo,
      ));

      notifier.onAppLifecycleChanged(AppLifecycleState.hidden);

      final states = <DashboardState>[];
      notifier.onStateChanged = (s) => states.add(s);

      notifier.onAppLifecycleChanged(AppLifecycleState.resumed);
      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(states, isNotEmpty);
      notifier.dispose();
    });
  });

  // ── Polling / timer lifecycle ─────────────────────────────────────────────

  group('DashboardController — polling', () {
    test('startPolling can be called multiple times safely', () async {
      final notifier = DashboardController();
      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.solo,
      ));

      // Double-start should not throw or leak timers.
      notifier.startPolling(interval: const Duration(seconds: 60));
      notifier.startPolling(interval: const Duration(seconds: 30));
      notifier.dispose();
    });

    test('timer tick skips fetch when cache is fresh', () async {
      final notifier = DashboardController(
        cacheTtl: const Duration(seconds: 30),
      );
      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.solo,
      ));

      // Prime the cache by fetching.
      await notifier.fetch();

      int fetchCount = 0;
      notifier.onStateChanged = (_) => fetchCount++;

      // Start a fast-ticking timer — cache should suppress all ticks.
      notifier.startPolling(interval: const Duration(milliseconds: 50));
      await Future<void>.delayed(const Duration(milliseconds: 200));

      expect(fetchCount, 0);
      notifier.dispose();
    });
  });

  // ── Audience-specific ID token paths ──────────────────────────────────────

  group('DashboardController — audience ID token', () {
    test('configure() with audience+SA configures without calling auth',
        () async {
      final adc = _FakeAdcService(token: 'id-token-for-iap');
      final auth = CandelaAuthService(adcService: adc);
      final notifier = DashboardController(candelaAuth: auth);

      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.team,
        remote: 'https://candela.example.com',
        audience: 'https://iap-audience.example.com',
        iapServiceAccount: 'sa@project.iam.gserviceaccount.com',
      ));

      // Proxy-routed: configure() never calls auth, even with audience.
      expect(notifier.isConfigured, isTrue);
      expect(adc.refreshCallCount, 0);
      notifier.dispose();
    });

    test('refreshToken() with audience+SA returns token via getTokenInfo',
        () async {
      // refreshToken() now always calls auth.getTokenInfo() which returns
      // the access token from the FakeAdcService.
      final adc = _FakeAdcService(token: 'id-token-for-iap');
      final auth = CandelaAuthService(adcService: adc);
      final notifier = DashboardController(candelaAuth: auth);

      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.team,
        remote: 'https://candela.example.com',
        audience: 'https://iap-audience.example.com',
        iapServiceAccount: 'sa@project.iam.gserviceaccount.com',
      ));

      final token = await notifier.refreshToken();
      // refreshToken now calls getTokenInfo directly, returning the token.
      expect(token, 'id-token-for-iap');
      notifier.dispose();
    });

    test(
        'configure() with audience but no iapServiceAccount does not call auth',
        () async {
      final adc = _FakeAdcService(token: 'access-token-fallback');
      final auth = CandelaAuthService(adcService: adc);
      final notifier = DashboardController(candelaAuth: auth);

      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.team,
        remote: 'https://candela.example.com',
        audience: 'https://iap-audience.example.com',
        // iapServiceAccount intentionally omitted
      ));

      // Proxy-routed: configure() never calls auth.
      expect(notifier.isConfigured, isTrue);
      expect(adc.refreshCallCount, 0);
      notifier.dispose();
    });

    test('configure() with empty audience does not call auth', () async {
      final adc = _FakeAdcService(token: 'access-token-fallback');
      final auth = CandelaAuthService(adcService: adc);
      final notifier = DashboardController(candelaAuth: auth);

      await notifier.configure(const CandelaConfig(
        path: '/tmp/test',
        mode: CandelaMode.team,
        remote: 'https://candela.example.com',
        audience: '', // empty → no auth call regardless
      ));

      // Proxy-routed: configure() never calls auth.
      expect(notifier.isConfigured, isTrue);
      expect(adc.refreshCallCount, 0);
      notifier.dispose();
    });
  });

  // ── buildFilteredSummary edge cases ───────────────────────────────────────

  group('DashboardController — buildFilteredSummary', () {
    test('returns null when result is null', () {
      final notifier = DashboardController();
      expect(notifier.buildFilteredSummary('gpt-4'), isNull);
      notifier.dispose();
    });

    test('returns null when not configured', () {
      final notifier = DashboardController();
      expect(notifier.buildFilteredSummary(null), isNull);
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
