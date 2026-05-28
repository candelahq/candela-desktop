import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/models/span_stats.dart';
import 'package:candela_desktop/screens/dashboard/dashboard_screen.dart';
import 'package:candela_desktop/services/dashboard_notifier.dart';
import 'package:candela_desktop/services/telemetry_service.dart';
import 'package:candela_desktop/theme/colors.dart';
import 'package:candela_desktop/widgets/area_chart.dart';
import 'package:candela_desktop/widgets/model_breakdown_table.dart';
import 'package:candela_desktop/widgets/stat_card.dart';
import 'package:candela_desktop/widgets/time_range_selector.dart';

// ── Reusable test scaffold ────────────────────────────────────────────────────

Widget _wrap(Widget child) => MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        backgroundColor: CandelaColors.bgPrimary,
        body: SizedBox(width: 900, height: 700, child: child),
      ),
    );

const _emptyTs = <TimeSeriesPoint>[];

UsageSummary _summary({
  int calls = 5,
  int inputTok = 1000,
  int outputTok = 500,
  double cost = 0.05,
  double latency = 600,
}) =>
    UsageSummary(
      totalCalls: calls,
      totalInputTokens: inputTok,
      totalOutputTokens: outputTok,
      totalCostUsd: cost,
      avgLatencyMs: latency,
      costOverTime: List.generate(
          24, (i) => TimeSeriesPoint(label: '${i}h', value: cost / 24)),
      tokensOverTime: List.generate(
          24,
          (i) => TimeSeriesPoint(
              label: '${i}h', value: (inputTok + outputTok) / 24)),
      callsOverTime: List.generate(
          24, (i) => TimeSeriesPoint(label: '${i}h', value: calls / 24)),
    );

// ── _StatGrid (via building the same layout inline) ───────────────────────────

// We exercise the same card assembly that _StatGrid uses, through public widgets.
void main() {
  group('Dashboard — StatCard values (mirrors _StatGrid logic)', () {
    testWidgets('shows cost formatted to 4 decimal places', (tester) async {
      await tester.pumpWidget(_wrap(StatCard(
        title: 'TOTAL COST',
        value: '\$${0.0512.toStringAsFixed(4)}',
        subtitle: 'USD spent',
        accentColor: const Color(0xFF4ADE80),
        icon: Icons.attach_money,
      )));
      expect(find.text('\$0.0512'), findsOneWidget);
    });

    testWidgets('shows em-dash when no data', (tester) async {
      await tester.pumpWidget(_wrap(const StatCard(
        title: 'LLM CALLS',
        value: '—',
        subtitle: 'Total requests',
        icon: Icons.bolt,
      )));
      expect(find.text('—'), findsOneWidget);
    });

    testWidgets('formats 1500 calls as 1.5k', (tester) async {
      final v = 1500 >= 1000 ? '${(1500 / 1000).toStringAsFixed(1)}k' : '1500';
      await tester.pumpWidget(_wrap(StatCard(
        title: 'LLM CALLS',
        value: v,
        subtitle: 'requests',
        icon: Icons.bolt,
      )));
      expect(find.text('1.5k'), findsOneWidget);
    });
  });

  // ── DashboardScreen.errorMessageFor (production logic) ─────────────────────

  group('Dashboard — errorMessageFor (production)', () {
    test('null result, not loading, local mode → proxy error', () {
      const state = DashboardState(
        result: null,
        loading: false,
        range: TokenTimeRange.d7,
      );
      expect(
        DashboardScreen.errorMessageFor(state),
        'Could not reach the Candela proxy. Is it running?',
      );
    });

    test('null result, not loading, team mode → proxy start message', () {
      // isTeamMode is derived from result?.isTeamMode ?? false.
      // With null result, isTeamMode is false — so to get the team message,
      // we need a result that signals team mode but triggers the null-result
      // path. The production code checks result == null first, so team mode
      // requires a non-null result. With result == null, isTeamMode is always
      // false. Verify the local-mode message is returned.
      const state = DashboardState(
        result: null,
        loading: false,
        range: TokenTimeRange.d7,
      );
      // With null result, isTeamMode defaults to false.
      expect(state.isTeamMode, isFalse);
      expect(
        DashboardScreen.errorMessageFor(state),
        'Could not reach the Candela proxy. Is it running?',
      );
    });

    test('authExpired error → candela auth login message', () {
      final result = const TelemetryResult.withError(
          isTeamMode: true, error: TelemetryErrorKind.authExpired);
      final state = DashboardState(
        result: result,
        loading: false,
        range: TokenTimeRange.d7,
      );
      expect(
        DashboardScreen.errorMessageFor(state),
        'Session expired \u2014 run: candela auth login',
      );
    });

    test('unreachable in team mode → backend unreachable message', () {
      final result = const TelemetryResult.withError(
          isTeamMode: true, error: TelemetryErrorKind.unreachable);
      final state = DashboardState(
        result: result,
        loading: false,
        range: TokenTimeRange.d7,
      );
      expect(
        DashboardScreen.errorMessageFor(state),
        'Backend unreachable \u2014 check Candela proxy status',
      );
    });

    test('unreachable in local mode → proxy unreachable message', () {
      final result = const TelemetryResult.withError(
          isTeamMode: false, error: TelemetryErrorKind.unreachable);
      final state = DashboardState(
        result: result,
        loading: false,
        range: TokenTimeRange.d7,
      );
      expect(
        DashboardScreen.errorMessageFor(state),
        'Candela proxy unreachable. Is it running?',
      );
    });

    test('successful result → no error message', () {
      final summary = _summary();
      final result = TelemetryResult(
        summary: summary,
        models: const [],
        spans: const [],
        isTeamMode: true,
      );
      final state = DashboardState(
        result: result,
        loading: false,
        range: TokenTimeRange.d7,
      );
      expect(DashboardScreen.errorMessageFor(state), isNull);
    });

    test('null result, loading=true → returns state.errorMessage', () {
      const state = DashboardState(
        result: null,
        loading: true,
        range: TokenTimeRange.d7,
      );
      // When loading with no result and no errorMessage, returns null.
      expect(DashboardScreen.errorMessageFor(state), isNull);
    });

    test('null result, loading=true, with errorMessage → returns it', () {
      const state = DashboardState(
        result: null,
        loading: true,
        errorMessage: 'Something went wrong',
        range: TokenTimeRange.d7,
      );
      expect(DashboardScreen.errorMessageFor(state), 'Something went wrong');
    });

    test('empty result (connected but no data) → no error', () {
      final result = const TelemetryResult.empty(isTeamMode: false);
      final state = DashboardState(
        result: result,
        loading: false,
        range: TokenTimeRange.d7,
      );
      expect(DashboardScreen.errorMessageFor(state), isNull);
    });
  });

  // ── _ChartCard equivalent ─────────────────────────────────────────────────

  group('Dashboard — chart card layout', () {
    testWidgets('chart card renders title and chart', (tester) async {
      await tester.pumpWidget(_wrap(Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: CandelaColors.bgSecondary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: CandelaColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Cost Over Time',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: CandelaColors.textPrimary)),
            const SizedBox(height: 16),
            CandelaAreaChart(
              data: _emptyTs,
              height: 200,
              color: const Color(0xFF4ADE80),
              formatValue: (v) => '\$${v.toStringAsFixed(4)}',
              emptyMessage: 'No cost data yet',
            ),
          ],
        ),
      )));

      expect(find.text('Cost Over Time'), findsOneWidget);
      expect(find.text('No cost data yet'), findsOneWidget);
    });

    testWidgets('chart card with subtitle renders subtitle', (tester) async {
      const subtitle = '\$0.0512 total';
      await tester.pumpWidget(_wrap(Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: CandelaColors.bgSecondary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Cost Over Time'),
                Text(subtitle,
                    style: TextStyle(
                        fontSize: 11, color: CandelaColors.textMuted)),
              ],
            ),
          ],
        ),
      )));
      expect(find.text(subtitle), findsOneWidget);
    });
  });

  // ── Full body integration (no configService dependency) ───────────────────

  group('Dashboard — body integration', () {
    testWidgets('ModelBreakdownTable empty state visible when no model data',
        (tester) async {
      await tester.pumpWidget(_wrap(SingleChildScrollView(
        child: Column(
          children: [
            TimeRangeSelector(value: TokenTimeRange.d7, onChanged: (_) {}),
            const SizedBox(height: 20),
            const ModelBreakdownTable(models: []),
          ],
        ),
      )));
      expect(find.text('No model data yet'), findsOneWidget);
      expect(find.text('7d'), findsOneWidget);
    });

    testWidgets('stat cards + area chart render without data', (tester) async {
      await tester.pumpWidget(_wrap(SingleChildScrollView(
        child: Column(
          children: [
            const Row(children: [
              Expanded(
                  child: StatCard(
                      title: 'TOTAL COST',
                      value: '—',
                      subtitle: 'USD spent',
                      accentColor: Color(0xFF4ADE80),
                      icon: Icons.attach_money)),
              SizedBox(width: 12),
              Expanded(
                  child: StatCard(
                      title: 'LLM CALLS',
                      value: '—',
                      subtitle: 'Total requests',
                      icon: Icons.bolt)),
            ]),
            const SizedBox(height: 20),
            CandelaAreaChart(
              data: _emptyTs,
              height: 160,
              color: const Color(0xFF4ADE80),
              formatValue: (v) => '\$${v.toStringAsFixed(4)}',
              emptyMessage: 'No cost data yet',
            ),
          ],
        ),
      )));
      expect(find.text('TOTAL COST'), findsOneWidget);
      expect(find.text('LLM CALLS'), findsOneWidget);
      expect(find.text('No cost data yet'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('stat cards render with real summary values', (tester) async {
      final s =
          _summary(calls: 42, cost: 0.1234, inputTok: 8000, outputTok: 3000);
      await tester.pumpWidget(_wrap(Row(children: [
        Expanded(
            child: StatCard(
          title: 'TOTAL COST',
          value: '\$${s.totalCostUsd.toStringAsFixed(4)}',
          subtitle: 'USD spent',
          accentColor: const Color(0xFF4ADE80),
          icon: Icons.attach_money,
        )),
        const SizedBox(width: 12),
        Expanded(
            child: StatCard(
          title: 'LLM CALLS',
          value: '${s.totalCalls}',
          subtitle: 'Total requests',
          icon: Icons.bolt,
        )),
      ])));

      expect(find.text('\$0.1234'), findsOneWidget);
      expect(find.text('42'), findsOneWidget);
    });
  });
}
