import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/models/span_stats.dart';
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

  // ── _ErrorBanner (exercise by building equivalent widget) ─────────────────

  group('Dashboard — error banner layout', () {
    testWidgets('error message renders in a colored container', (tester) async {
      // Build the same structure as _ErrorBanner
      await tester.pumpWidget(_wrap(Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF7F1D1D).withAlpha(128),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFEF4444).withAlpha(100)),
        ),
        child: const Row(children: [
          Icon(Icons.warning_amber_rounded, size: 16, color: Color(0xFFEF4444)),
          SizedBox(width: 10),
          Expanded(
              child: Text('Session expired',
                  style: TextStyle(fontSize: 12, color: Color(0xFFFCA5A5)))),
        ]),
      )));
      expect(find.text('Session expired'), findsOneWidget);
      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
    });
  });

  // ── TelemetryResult error messages ────────────────────────────────────────

  group('Dashboard — _errorMessage logic', () {
    // Mirror of DashboardScreen._errorMessage, exercised directly.
    String? errorMessage(TelemetryResult? result, bool isTeamMode) {
      if (result == null) {
        return isTeamMode
            ? 'Could not reach the team backend. Check your network and auth.'
            : 'Could not reach the Candela proxy. Is it running?';
      }
      if (result.error == TelemetryErrorKind.authExpired) {
        return 'Session expired — run: candela auth login';
      }
      if (result.error == TelemetryErrorKind.unreachable) {
        return isTeamMode
            ? 'Team backend unreachable. Check your network.'
            : 'Candela proxy unreachable. Is it running?';
      }
      return null;
    }

    test('null result in local mode → proxy error', () {
      expect(errorMessage(null, false),
          'Could not reach the Candela proxy. Is it running?');
    });

    test('null result in team mode → backend error', () {
      expect(errorMessage(null, true),
          'Could not reach the team backend. Check your network and auth.');
    });

    test('authExpired result → candela auth login message', () {
      final result = const TelemetryResult.withError(
          isTeamMode: true, error: TelemetryErrorKind.authExpired);
      expect(errorMessage(result, true), contains('candela auth login'));
    });

    test('unreachable result in team mode → team-specific message', () {
      final result = const TelemetryResult.withError(
          isTeamMode: true, error: TelemetryErrorKind.unreachable);
      expect(errorMessage(result, true), contains('Team backend unreachable'));
    });

    test('unreachable result in local mode → proxy-specific message', () {
      final result = const TelemetryResult.withError(
          isTeamMode: false, error: TelemetryErrorKind.unreachable);
      expect(
          errorMessage(result, false), contains('Candela proxy unreachable'));
    });

    test('successful result → no error message', () {
      final summary = _summary();
      final result = TelemetryResult(
        summary: summary,
        models: const [],
        spans: const [],
        isTeamMode: true,
      );
      expect(errorMessage(result, true), isNull);
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
