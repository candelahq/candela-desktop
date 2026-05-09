import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/candela_config.dart';
import '../../models/span_stats.dart';
import '../../services/gcloud_service.dart';
import '../../services/telemetry_service.dart';
import '../../theme/colors.dart';
import '../../widgets/area_chart.dart';
import '../../widgets/model_breakdown_table.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/time_range_selector.dart';
import '../../main.dart' show configService;

/// Full-page token spend & usage dashboard.
///
/// Supports both modes transparently — picks the right data source
/// based on the user's config and shows a mode badge in the header.
///
/// • **Team mode** (`config.remote` set) → ConnectRPC backend, gcloud token.
/// • **Local mode** → `/_local/api/traces` on the sidecar.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  TokenTimeRange _range = TokenTimeRange.d7;
  TelemetryResult? _result;
  bool _loading = true;
  String? _error;
  bool _isTeamMode = false;
  Timer? _autoRefresh;
  TelemetryService? _svc;

  @override
  void initState() {
    super.initState();
    _initService();
  }

  Future<void> _initService() async {
    final config = await configService.load();
    final isTeam = config.mode == CandelaMode.team &&
        config.remote != null &&
        config.remote!.isNotEmpty;

    TelemetryService svc;
    if (isTeam) {
      // Fetch a gcloud ADC token for team backend auth.
      final gcloud = GCloudService();
      final tokenInfo = await gcloud.getTokenInfo();
      svc = TelemetryService(
        port: config.port,
        remoteUrl: config.remote,
        authToken: tokenInfo?.accessToken,
      );
    } else {
      svc = TelemetryService(port: config.port);
    }

    if (!mounted) return;
    setState(() {
      _svc = svc;
      _isTeamMode = isTeam;
    });

    await _fetch();
    _autoRefresh = Timer.periodic(const Duration(seconds: 30), (_) => _fetch());
  }

  Future<void> _fetch() async {
    if (!mounted || _svc == null) return;
    setState(() => _loading = true);
    final result = await _svc!.fetch(_range);
    if (!mounted) return;
    setState(() {
      _result = result;
      _loading = false;
      _error = result == null
          ? _isTeamMode
              ? 'Could not reach the team backend. Check your network and auth.'
              : 'Could not reach the Candela proxy. Is it running?'
          : null;
    });
  }

  void _setRange(TokenTimeRange r) {
    setState(() => _range = r);
    _fetch();
  }

  @override
  void dispose() {
    _autoRefresh?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CandelaColors.bgPrimary,
      body: Column(
        children: [
          _Header(
            range: _range,
            onRangeChanged: _setRange,
            onRefresh: _fetch,
            loading: _loading,
            isTeamMode: _isTeamMode,
          ),
          Expanded(
            child: _Body(
              result: _result,
              loading: _loading,
              error: _error,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final TokenTimeRange range;
  final ValueChanged<TokenTimeRange> onRangeChanged;
  final VoidCallback onRefresh;
  final bool loading;
  final bool isTeamMode;

  const _Header({
    required this.range,
    required this.onRangeChanged,
    required this.onRefresh,
    required this.loading,
    required this.isTeamMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: CandelaColors.bgSecondary,
        border: Border(bottom: BorderSide(color: CandelaColors.border)),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Token Spend',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: CandelaColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  _ModeBadge(isTeam: isTeamMode),
                ],
              ),
              const SizedBox(height: 2),
              const Text(
                'Usage & cost breakdown',
                style: TextStyle(fontSize: 11, color: CandelaColors.textMuted),
              ),
            ],
          ),
          const Spacer(),
          TimeRangeSelector(value: range, onChanged: onRangeChanged),
          const SizedBox(width: 10),
          _RefreshButton(onRefresh: onRefresh, loading: loading),
        ],
      ),
    );
  }
}

class _ModeBadge extends StatelessWidget {
  final bool isTeam;
  const _ModeBadge({required this.isTeam});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isTeam
            ? CandelaColors.accent.withAlpha(30)
            : CandelaColors.bgTertiary,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isTeam
              ? CandelaColors.accent.withAlpha(80)
              : CandelaColors.border,
        ),
      ),
      child: Text(
        isTeam ? 'Team' : 'Local',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: isTeam ? CandelaColors.accent : CandelaColors.textMuted,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

class _RefreshButton extends StatelessWidget {
  final VoidCallback onRefresh;
  final bool loading;
  const _RefreshButton({required this.onRefresh, required this.loading});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Refresh',
      child: InkWell(
        onTap: loading ? null : onRefresh,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: CandelaColors.bgTertiary,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: CandelaColors.border),
          ),
          child: loading
              ? const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: CandelaColors.accent,
                  ),
                )
              : const Icon(Icons.refresh,
                  size: 16, color: CandelaColors.textMuted),
        ),
      ),
    );
  }
}

// ── Body ──────────────────────────────────────────────────────────────────────

class _Body extends StatelessWidget {
  final TelemetryResult? result;
  final bool loading;
  final String? error;

  const _Body(
      {required this.result, required this.loading, required this.error});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (error != null) ...[
            _ErrorBanner(message: error!),
            const SizedBox(height: 16),
          ],
          _StatGrid(summary: result?.summary, loading: loading),
          const SizedBox(height: 20),
          _ChartRow(summary: result?.summary),
          const SizedBox(height: 20),
          ModelBreakdownTable(models: result?.models ?? []),
        ],
      ),
    );
  }
}

// ── Stat cards ────────────────────────────────────────────────────────────────

class _StatGrid extends StatelessWidget {
  final UsageSummary? summary;
  final bool loading;
  const _StatGrid({required this.summary, required this.loading});

  @override
  Widget build(BuildContext context) {
    final s = summary;
    return Row(
      children: [
        Expanded(
          child: StatCard(
            title: 'TOTAL COST',
            value: s != null ? '\$${s.totalCostUsd.toStringAsFixed(4)}' : '—',
            subtitle: 'USD spent',
            accentColor: const Color(0xFF4ADE80),
            icon: Icons.attach_money,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatCard(
            title: 'LLM CALLS',
            value: s != null ? _fmt(s.totalCalls) : '—',
            subtitle: 'Total requests',
            accentColor: CandelaColors.accent,
            icon: Icons.bolt,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatCard(
            title: 'INPUT TOKENS',
            value: s != null ? _fmtTok(s.totalInputTokens) : '—',
            subtitle: 'Prompt tokens',
            accentColor: const Color(0xFF60A5FA),
            icon: Icons.arrow_forward,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatCard(
            title: 'OUTPUT TOKENS',
            value: s != null ? _fmtTok(s.totalOutputTokens) : '—',
            subtitle: 'Completion tokens',
            accentColor: const Color(0xFFA78BFA),
            icon: Icons.arrow_back,
          ),
        ),
      ],
    );
  }

  static String _fmt(int v) =>
      v >= 1000 ? '${(v / 1000).toStringAsFixed(1)}k' : '$v';

  static String _fmtTok(int v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(2)}M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}k';
    return '$v';
  }
}

// ── Charts ────────────────────────────────────────────────────────────────────

class _ChartRow extends StatelessWidget {
  final UsageSummary? summary;
  const _ChartRow({required this.summary});

  @override
  Widget build(BuildContext context) {
    final s = summary;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _ChartCard(
            title: 'Cost Over Time',
            subtitle: s != null
                ? '\$${s.totalCostUsd.toStringAsFixed(4)} total'
                : null,
            chart: CandelaAreaChart(
              data: s?.costOverTime ?? [],
              height: 200,
              color: const Color(0xFF4ADE80),
              formatValue: (v) => '\$${v.toStringAsFixed(4)}',
              emptyMessage: 'No cost data yet',
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _ChartCard(
            title: 'Tokens Over Time',
            subtitle: s != null ? _fmtTok(s.totalTokens) : null,
            chart: CandelaAreaChart(
              data: s?.tokensOverTime ?? [],
              height: 200,
              color: const Color(0xFF60A5FA),
              formatValue: (v) => v >= 1000
                  ? '${(v / 1000).toStringAsFixed(1)}k'
                  : '${v.round()}',
              emptyMessage: 'No token data yet',
            ),
          ),
        ),
      ],
    );
  }

  static String _fmtTok(int v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(2)}M total';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}k total';
    return '$v total';
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget chart;
  const _ChartCard({required this.title, required this.chart, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CandelaColors.bgSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CandelaColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: CandelaColors.textPrimary)),
              if (subtitle != null)
                Text(subtitle!,
                    style: const TextStyle(
                        fontSize: 11,
                        color: CandelaColors.textMuted,
                        fontFamily: 'monospace')),
            ],
          ),
          const SizedBox(height: 16),
          chart,
        ],
      ),
    );
  }
}

// ── Error banner ──────────────────────────────────────────────────────────────

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF7F1D1D).withAlpha(128),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFEF4444).withAlpha(100)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded,
              size: 16, color: Color(0xFFEF4444)),
          const SizedBox(width: 10),
          Expanded(
              child: Text(message,
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xFFFCA5A5)))),
        ],
      ),
    );
  }
}
