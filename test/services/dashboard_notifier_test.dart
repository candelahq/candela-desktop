import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/services/dashboard_notifier.dart';
import 'package:candela_desktop/services/telemetry_service.dart';
import 'package:candela_desktop/models/span_stats.dart';

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
  });

  group('DashboardNotifier', () {
    test('initial state is loading', () {
      final notifier = DashboardNotifier(
        telemetry: TelemetryService(port: 9999),
      );
      expect(notifier.state.loading, isTrue);
      notifier.dispose();
    });

    test('notifies on state change', () {
      final notifier = DashboardNotifier(
        telemetry: TelemetryService(port: 9999),
      );
      int notifyCount = 0;
      notifier.addListener(() => notifyCount++);

      notifier.setRange(TokenTimeRange.h24);
      Future.delayed(const Duration(milliseconds: 200), () {
        expect(notifyCount, greaterThan(0));
        notifier.dispose();
      });
    });

    test('dispose cancels timer', () {
      final notifier = DashboardNotifier(
        telemetry: TelemetryService(port: 9999),
      );
      notifier.startPolling(interval: const Duration(seconds: 1));
      notifier.dispose();
    });

    test('refreshToken returns null without gcloud service', () async {
      final notifier = DashboardNotifier(
        telemetry: TelemetryService(port: 9999),
      );
      final token = await notifier.refreshToken();
      expect(token, isNull);
      notifier.dispose();
    });
  });
}
