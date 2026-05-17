import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../models/budget_info.dart';
import '../../models/candela_config.dart';
import '../../models/span_stats.dart';
import '../../services/gcloud_service.dart';
import '../../services/telemetry_service.dart';
import '../../theme/colors.dart';
import '../../providers.dart';
import '../../utils/format.dart';
import '../../widgets/local_services_card.dart';
import '../../widgets/model_selector_dropdown.dart';

/// Full-page "Today" view — shows daily budget, grants, remaining balance,
/// and today's spend at a glance.
class TodayScreen extends ConsumerStatefulWidget {
  const TodayScreen({super.key});

  @override
  ConsumerState<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends ConsumerState<TodayScreen> {
  TelemetryResult? _result;
  bool _loading = true;
  String? _error;
  bool _initialized = false;
  Timer? _autoRefresh;
  TelemetryService? _svc;
  bool _isTeamMode = false;
  String? _selectedModel;
  UsageSummary? _filteredSummary;
  DateTime _fetchedAt = DateTime.now();

  void _setSelectedModel(String? model) {
    setState(() => _selectedModel = model);
    _recalculateSummary();
  }

  void _recalculateSummary() {
    if (_result == null || _svc == null) {
      setState(() => _filteredSummary = null);
      return;
    }
    if (_selectedModel == null) {
      setState(() => _filteredSummary = _result!.summary);
      return;
    }
    final filteredSpans =
        _result!.spans.where((s) => s.model == _selectedModel).toList();
    final newSummary =
        _svc!.buildSummary(filteredSpans, TokenTimeRange.todayUtc, _fetchedAt);
    setState(() => _filteredSummary = newSummary);
  }

  @override
  void initState() {
    super.initState();
    _initService();
  }

  Future<void> _initService() async {
    if (_initialized) return;
    _initialized = true;

    final config = await ref.read(configServiceProvider).load();
    final isTeam = config.mode == CandelaMode.team &&
        config.remote != null &&
        config.remote!.isNotEmpty;

    TelemetryService svc;
    if (isTeam) {
      final gcloud = GCloudService();
      final audience = config.audience ?? config.remote ?? '';

      final tokenInfo = audience.isNotEmpty
          ? await gcloud.getIdToken(audience)
          : await gcloud.getTokenInfo();

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
    if (!mounted) return;
    _autoRefresh = Timer.periodic(const Duration(seconds: 30), (_) => _fetch());
  }

  bool _isFetching = false;

  Future<void> _fetch() async {
    if (!mounted || _svc == null || _isFetching) return;
    _isFetching = true;
    setState(() => _loading = true);
    try {
      final result = await _svc!.fetch(TokenTimeRange.todayUtc);

      if (!mounted) return;
      setState(() {
        _result = result;
        _fetchedAt = DateTime.now();
        _loading = false;
        _error = result == null
            ? 'Could not reach the Candela proxy.'
            : result.error == TelemetryErrorKind.authExpired
                ? 'Session expired — run: gcloud auth application-default login'
                : result.error != null
                    ? 'Backend unreachable.'
                    : null;
      });

      _recalculateSummary();
    } finally {
      _isFetching = false;
    }
  }

  @override
  void dispose() {
    _autoRefresh?.cancel();
    _svc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uniqueModels =
        _result?.models.map((m) => m.model).toSet().toList() ?? [];

    return Scaffold(
      backgroundColor: CandelaColors.bgPrimary,
      body: Column(
        children: [
          _buildHeader(uniqueModels),
          Expanded(
            child: _loading && _result == null
                ? const Center(
                    child:
                        CircularProgressIndicator(color: CandelaColors.accent))
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: _buildBody(_filteredSummary),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(List<String> uniqueModels) {
    final dateStr = DateFormat.yMMMMEEEEd().format(DateTime.now());

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
      decoration: const BoxDecoration(
        color: CandelaColors.bgSecondary,
        border: Border(bottom: BorderSide(color: CandelaColors.border)),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Today',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: CandelaColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                dateStr,
                style: const TextStyle(
                    fontSize: 12, color: CandelaColors.textMuted),
              ),
            ],
          ),
          const SizedBox(width: 12),
          _ModeBadge(isTeam: _isTeamMode),
          const Spacer(),
          if (uniqueModels.isNotEmpty) ...[
            ModelSelectorDropdown(
              models: uniqueModels,
              selected: _selectedModel,
              onChanged: _setSelectedModel,
            ),
            const SizedBox(width: 10),
          ],
          _RefreshButton(onRefresh: _fetch, loading: _loading),
        ],
      ),
    );
  }

  Widget _buildBody(UsageSummary? summary) {
    if (_error != null && _result == null) {
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        _ErrorCard(message: _error!),
        const SizedBox(height: 16),
        const LocalServicesCard(),
      ]);
    }

    final budget = _result?.budget;
    final grants = _result?.activeGrants ?? [];
    final remaining = _result?.totalRemainingUsd;
    final models = _result?.models ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_error != null) ...[
          _ErrorCard(message: _error!),
          const SizedBox(height: 16),
        ],
        // ── Hero: Total Remaining ──
        _HeroCard(
          budget: budget,
          totalRemainingUsd: remaining,
          todaySpend: summary?.totalCostUsd,
        ),
        const SizedBox(height: 16),
        // ── Quick Stats Row ──
        _QuickStats(summary: summary),
        const SizedBox(height: 16),
        // ── Budget + Grants breakdown ──
        if (budget != null) ...[
          _BudgetDetailCard(budget: budget, grants: grants),
          const SizedBox(height: 16),
        ],
        // ── Top models today ──
        if (models.isNotEmpty) ...[
          _TopModelsCard(models: models),
        ],
        // ── Local Services ──
        if (!_isTeamMode) ...[
          const LocalServicesCard(),
          const SizedBox(height: 16),
        ],
        // ── Empty state ──
        if (summary == null && budget == null && _error == null)
          _EmptyState(isTeamMode: _isTeamMode),
      ],
    );
  }
}

// ── Hero Card ─────────────────────────────────────────────────────────────────

class _HeroCard extends StatelessWidget {
  final BudgetInfo? budget;
  final double? totalRemainingUsd;
  final double? todaySpend;

  const _HeroCard({this.budget, this.totalRemainingUsd, this.todaySpend});

  @override
  Widget build(BuildContext context) {
    final spend = todaySpend ?? 0.0;
    final hasRemaining = totalRemainingUsd != null;
    final fraction = budget?.usedFraction ?? 0.0;
    final barColor = fraction >= 0.9
        ? CandelaColors.error
        : fraction >= 0.7
            ? CandelaColors.warning
            : CandelaColors.success;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            CandelaColors.bgSecondary,
            CandelaColors.bgTertiary.withAlpha(180),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CandelaColors.border),
      ),
      child: Row(
        children: [
          // Left: Today's spend
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "TODAY'S SPEND",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: CandelaColors.textMuted,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${spend.toStringAsFixed(4)}',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: CandelaColors.textPrimary,
                    fontFamily: 'SF Mono, monospace',
                    height: 1.0,
                  ),
                ),
                if (budget != null) ...[
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 6,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: fraction.clamp(0.0, 1.0),
                        backgroundColor: CandelaColors.bgElevated,
                        valueColor: AlwaysStoppedAnimation<Color>(barColor),
                        minHeight: 6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${(fraction * 100).round()}% of \$${budget!.limitUsd.toStringAsFixed(2)} daily budget used',
                    style: TextStyle(fontSize: 11, color: barColor),
                  ),
                ],
              ],
            ),
          ),
          // Right: Remaining balance
          if (hasRemaining)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: CandelaColors.bgPrimary.withAlpha(120),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: CandelaColors.borderSubtle),
              ),
              child: Column(
                children: [
                  const Text(
                    'REMAINING',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: CandelaColors.textMuted,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${totalRemainingUsd!.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: CandelaColors.success,
                      fontFamily: 'SF Mono, monospace',
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'budget + grants',
                    style:
                        TextStyle(fontSize: 10, color: CandelaColors.textMuted),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ── Quick Stats ───────────────────────────────────────────────────────────────

class _QuickStats extends StatelessWidget {
  final UsageSummary? summary;
  const _QuickStats({this.summary});

  @override
  Widget build(BuildContext context) {
    final s = summary;
    return Row(
      children: [
        _MiniStat(
          label: 'LLM CALLS',
          value: s != null ? '${s.totalCalls}' : '0',
          icon: Icons.bolt,
          color: CandelaColors.accent,
        ),
        const SizedBox(width: 12),
        _MiniStat(
          label: 'INPUT TOKENS',
          value: s != null ? formatTokenCount(s.totalInputTokens) : '0',
          icon: Icons.arrow_forward,
          color: const Color(0xFF60A5FA),
        ),
        const SizedBox(width: 12),
        _MiniStat(
          label: 'OUTPUT TOKENS',
          value: s != null ? formatTokenCount(s.totalOutputTokens) : '0',
          icon: Icons.arrow_back,
          color: const Color(0xFFA78BFA),
        ),
        const SizedBox(width: 12),
        _MiniStat(
          label: 'AVG LATENCY',
          value: s != null ? '${s.avgLatencyMs.round()}ms' : '—',
          icon: Icons.speed,
          color: const Color(0xFF4ADE80),
        ),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _MiniStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: CandelaColors.bgSecondary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: CandelaColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 12, color: color),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: CandelaColors.textMuted,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: CandelaColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Budget Detail Card ────────────────────────────────────────────────────────

class _BudgetDetailCard extends StatelessWidget {
  final BudgetInfo budget;
  final List<GrantInfo> grants;
  const _BudgetDetailCard({required this.budget, required this.grants});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now().toUtc();
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
          const Row(
            children: [
              Text('💰', style: TextStyle(fontSize: 16)),
              SizedBox(width: 8),
              Text(
                'Budget & Grants',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: CandelaColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Budget row
          _DetailRow(
            label: 'Daily Budget',
            spent: budget.spentUsd,
            limit: budget.limitUsd,
            fraction: budget.usedFraction,
            subtitle: budget.resetLabel,
            barColor: budget.isExhausted
                ? CandelaColors.error
                : budget.isNearLimit
                    ? CandelaColors.warning
                    : CandelaColors.success,
          ),
          // Grant rows
          for (final g in grants) ...[
            const SizedBox(height: 12),
            _DetailRow(
              label: g.displayLabel,
              spent: g.spentUsd,
              limit: g.amountUsd,
              fraction: g.usedFraction,
              subtitle: g.expiresAt != null
                  ? 'expires ${_daysLabel(g.expiresAt!, now)}'
                  : 'no expiry',
              barColor:
                  g.isExhausted ? CandelaColors.error : CandelaColors.accent,
              isExpiringSoon: g.expiresAt != null &&
                  g.expiresAt!.difference(now).inDays < 7,
            ),
          ],
        ],
      ),
    );
  }

  static String _daysLabel(DateTime dt, DateTime now) {
    final diff = dt.difference(now);
    if (diff.inDays > 0) return 'in ${diff.inDays}d';
    if (diff.inHours > 0) return 'in ${diff.inHours}h';
    return 'soon';
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final double spent;
  final double limit;
  final double fraction;
  final String subtitle;
  final Color barColor;
  final bool isExpiringSoon;

  const _DetailRow({
    required this.label,
    required this.spent,
    required this.limit,
    required this.fraction,
    required this.subtitle,
    required this.barColor,
    this.isExpiringSoon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: 100,
              child: Text(
                label,
                style: const TextStyle(
                    fontSize: 12, color: CandelaColors.textSecondary),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 6,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: fraction.clamp(0.0, 1.0),
                    backgroundColor: CandelaColors.bgTertiary,
                    valueColor: AlwaysStoppedAnimation<Color>(barColor),
                    minHeight: 6,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '\$${spent.toStringAsFixed(2)} / \$${limit.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 11,
                fontFamily: 'SF Mono, monospace',
                color: CandelaColors.textSecondary,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '${(fraction * 100).round()}%',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: barColor,
              ),
            ),
            if (isExpiringSoon) ...[
              const SizedBox(width: 4),
              const Text('⚠',
                  style: TextStyle(fontSize: 12, color: CandelaColors.warning)),
            ],
          ],
        ),
        const SizedBox(height: 3),
        Padding(
          padding: const EdgeInsets.only(left: 100),
          child: Text(
            subtitle,
            style:
                const TextStyle(fontSize: 10, color: CandelaColors.textMuted),
          ),
        ),
      ],
    );
  }
}

// ── Top Models Card ───────────────────────────────────────────────────────────

class _TopModelsCard extends StatelessWidget {
  final List<ModelBreakdown> models;
  const _TopModelsCard({required this.models});

  @override
  Widget build(BuildContext context) {
    final top = models.take(5).toList();
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
          const Row(
            children: [
              Icon(Icons.memory, size: 16, color: CandelaColors.textMuted),
              SizedBox(width: 8),
              Text(
                'Top Models Today',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: CandelaColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          for (var i = 0; i < top.length; i++) ...[
            if (i > 0) const SizedBox(height: 8),
            _ModelRow(model: top[i], rank: i + 1),
          ],
        ],
      ),
    );
  }
}

class _ModelRow extends StatelessWidget {
  final ModelBreakdown model;
  final int rank;
  const _ModelRow({required this.model, required this.rank});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 20,
          child: Text(
            '$rank',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: rank <= 3 ? CandelaColors.accent : CandelaColors.textMuted,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            model.model,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'monospace',
              fontWeight: FontWeight.w500,
              color: CandelaColors.textPrimary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(
          width: 60,
          child: Text(
            '${model.callCount} calls',
            style: const TextStyle(
                fontSize: 11, color: CandelaColors.textSecondary),
          ),
        ),
        SizedBox(
          width: 80,
          child: Text(
            '\$${model.costUsd.toStringAsFixed(4)}',
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 11,
              fontFamily: 'SF Mono, monospace',
              fontWeight: FontWeight.w600,
              color: CandelaColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Empty State ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final bool isTeamMode;
  const _EmptyState({required this.isTeamMode});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🕯️', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            const Text(
              'No activity today',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: CandelaColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isTeamMode
                  ? 'LLM calls through your team gateway will appear here.'
                  : 'Start your proxy and route traffic to see activity.',
              style: const TextStyle(
                  fontSize: 13, color: CandelaColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared widgets ────────────────────────────────────────────────────────────

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
                      strokeWidth: 2, color: CandelaColors.accent))
              : const Icon(Icons.refresh,
                  size: 16, color: CandelaColors.textMuted),
        ),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;
  const _ErrorCard({required this.message});

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
