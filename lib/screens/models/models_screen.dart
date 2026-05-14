import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/span_stats.dart';
import '../../services/telemetry_service.dart';
import '../../theme/colors.dart';
import '../../providers.dart';

/// Model catalog screen — shows per-model stats, cost, latency, volume.
class ModelsScreen extends ConsumerStatefulWidget {
  const ModelsScreen({super.key});

  @override
  ConsumerState<ModelsScreen> createState() => _ModelsScreenState();
}

class _ModelsScreenState extends ConsumerState<ModelsScreen> {
  TokenTimeRange _range = TokenTimeRange.d7;
  List<ModelBreakdown> _models = [];
  bool _loading = true;
  String? _error;
  Timer? _autoRefresh;
  TelemetryService? _svc;
  bool _initialized = false;
  String? _selectedModel;
  _ModelSortCol _sortCol = _ModelSortCol.cost;
  bool _ascending = false;
  double _maxCost = 0;

  @override
  void initState() {
    super.initState();
    _initService();
  }

  Future<void> _initService() async {
    if (_initialized) return;
    _initialized = true;
    final config = await ref.read(configServiceProvider).load();
    if (!mounted) return;
    _svc = TelemetryService(port: config.port);
    await _fetch();
    if (!mounted) return;
    _autoRefresh = Timer.periodic(const Duration(seconds: 30), (_) => _fetch());
  }

  Future<void> _fetch() async {
    if (!mounted || _svc == null) return;
    setState(() => _loading = true);
    try {
      final result = await _svc!.fetch(_range);
      if (!mounted) return;
      setState(() {
        _models = result?.models ?? [];
        _sortModels();
        _maxCost = _models.isEmpty
            ? 0
            : _models.map((m) => m.costUsd).reduce((a, b) => a > b ? a : b);
        _loading = false;
        _error = result == null ? 'Could not reach the proxy' : null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Failed to load models: $e';
      });
    }
  }

  void _sortModels() {
    _models.sort((a, b) {
      int cmp;
      switch (_sortCol) {
        case _ModelSortCol.cost:
          cmp = a.costUsd.compareTo(b.costUsd);
        case _ModelSortCol.calls:
          cmp = a.callCount.compareTo(b.callCount);
        case _ModelSortCol.tokens:
          cmp = a.totalTokens.compareTo(b.totalTokens);
        case _ModelSortCol.latency:
          cmp = a.avgLatencyMs.compareTo(b.avgLatencyMs);
        case _ModelSortCol.name:
          cmp = a.model.compareTo(b.model);
      }
      return _ascending ? cmp : -cmp;
    });
  }

  void _setSort(_ModelSortCol col) {
    setState(() {
      if (_sortCol == col) {
        _ascending = !_ascending;
      } else {
        _sortCol = col;
        _ascending = false;
      }
      _sortModels();
    });
  }

  @override
  void dispose() {
    _autoRefresh?.cancel();
    _svc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selected = _selectedModel != null
        ? _models.where((m) => m.model == _selectedModel).firstOrNull
        : null;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(children: [
        _buildHeader(),
        Expanded(
            child: _error != null
                ? Center(
                    child: Text(_error!,
                        style: const TextStyle(
                            color: CandelaColors.error, fontSize: 13)))
                : _models.isEmpty && !_loading
                    ? _buildEmpty()
                    : Row(children: [
                        Expanded(flex: 3, child: _buildModelList()),
                        if (selected != null)
                          Expanded(
                              flex: 2, child: _ModelDetail(model: selected)),
                      ])),
      ]),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
          color: CandelaColors.bgSecondary,
          border: Border(bottom: BorderSide(color: CandelaColors.border))),
      child: Row(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Models',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: CandelaColors.textPrimary)),
          const SizedBox(height: 2),
          Text('${_models.length} model${_models.length != 1 ? 's' : ''} seen',
              style: const TextStyle(
                  fontSize: 11, color: CandelaColors.textMuted)),
        ]),
        const Spacer(),
        _buildTimeChips(),
        const SizedBox(width: 10),
        _buildRefreshBtn(),
      ]),
    );
  }

  Widget _buildTimeChips() {
    return Container(
      decoration: BoxDecoration(
          color: CandelaColors.bgSecondary,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: CandelaColors.border)),
      padding: const EdgeInsets.all(3),
      child: Row(
          mainAxisSize: MainAxisSize.min,
          children: TokenTimeRange.values.map((r) {
            final active = r == _range;
            return GestureDetector(
              onTap: () {
                setState(() => _range = r);
                _fetch();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                    color: active ? CandelaColors.accent : Colors.transparent,
                    borderRadius: BorderRadius.circular(5)),
                child: Text(r.label,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                        color:
                            active ? Colors.white : CandelaColors.textMuted)),
              ),
            );
          }).toList()),
    );
  }

  Widget _buildRefreshBtn() {
    return Tooltip(
        message: 'Refresh',
        child: InkWell(
          onTap: _loading ? null : _fetch,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: CandelaColors.bgTertiary,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: CandelaColors.border)),
            child: _loading
                ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: CandelaColors.accent))
                : const Icon(Icons.refresh,
                    size: 16, color: CandelaColors.textMuted),
          ),
        ));
  }

  Widget _buildEmpty() {
    return const Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
      Text('🧠', style: TextStyle(fontSize: 48)),
      SizedBox(height: 16),
      Text('No models seen yet',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: CandelaColors.textPrimary)),
      SizedBox(height: 8),
      Text('Model data appears once LLM calls flow through the proxy.',
          style: TextStyle(fontSize: 13, color: CandelaColors.textSecondary)),
    ]));
  }

  Widget _buildModelList() {
    return Column(children: [
      Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          color: CandelaColors.bgSecondary,
          child: Row(children: [
            _colHeader('Model', _ModelSortCol.name, flex: 3),
            _colHeader('Calls', _ModelSortCol.calls),
            _colHeader('Tokens', _ModelSortCol.tokens),
            _colHeader('Cost', _ModelSortCol.cost),
            _colHeader('Avg Latency', _ModelSortCol.latency),
            const SizedBox(width: 100),
          ])),
      const Divider(height: 1, color: CandelaColors.border),
      Expanded(
          child: ListView.builder(
        itemCount: _models.length,
        itemBuilder: (_, i) => _ModelRow(
          model: _models[i],
          isSelected: _models[i].model == _selectedModel,
          maxCost: _maxCost,
          onTap: () => setState(() {
            _selectedModel =
                _models[i].model == _selectedModel ? null : _models[i].model;
          }),
        ),
      )),
    ]);
  }

  Widget _colHeader(String label, _ModelSortCol col, {int flex = 1}) {
    final active = _sortCol == col;
    return Expanded(
        flex: flex,
        child: GestureDetector(
          onTap: () => _setSort(col),
          child: Row(children: [
            Text(label,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color:
                        active ? CandelaColors.accent : CandelaColors.textMuted,
                    letterSpacing: 0.4)),
            if (active) ...[
              const SizedBox(width: 3),
              Icon(_ascending ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 10, color: CandelaColors.accent)
            ],
          ]),
        ));
  }
}

enum _ModelSortCol { name, calls, tokens, cost, latency }

class _ModelRow extends StatefulWidget {
  final ModelBreakdown model;
  final bool isSelected;
  final double maxCost;
  final VoidCallback onTap;
  const _ModelRow(
      {required this.model,
      required this.isSelected,
      required this.maxCost,
      required this.onTap});
  @override
  State<_ModelRow> createState() => _ModelRowState();
}

class _ModelRowState extends State<_ModelRow> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    final m = widget.model;
    final barPct = widget.maxCost > 0 ? (m.costUsd / widget.maxCost) : 0.0;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            color: widget.isSelected
                ? CandelaColors.accentDim
                : _hovered
                    ? CandelaColors.bgHover
                    : Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 11),
            child: Row(children: [
              Expanded(
                  flex: 3,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(m.model,
                            style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                            overflow: TextOverflow.ellipsis),
                        Text(m.provider,
                            style: const TextStyle(
                                fontSize: 10, color: CandelaColors.textMuted)),
                      ])),
              Expanded(child: Text('${m.callCount}', style: _mono)),
              Expanded(child: Text(_fmtTokens(m.totalTokens), style: _mono)),
              Expanded(
                  child: Text('\$${m.costUsd.toStringAsFixed(4)}',
                      style: _mono.copyWith(fontWeight: FontWeight.w600))),
              Expanded(
                  child: Text('${m.avgLatencyMs.toStringAsFixed(0)}ms',
                      style: _mono)),
              SizedBox(
                  width: 100,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: barPct,
                        minHeight: 6,
                        backgroundColor: CandelaColors.bgTertiary,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            CandelaColors.accent.withAlpha(200)),
                      ))),
            ]),
          )),
    );
  }

  static const _mono =
      TextStyle(fontFamily: 'monospace', fontSize: 12, color: Colors.white70);
}

class _ModelDetail extends StatelessWidget {
  final ModelBreakdown model;
  const _ModelDetail({required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: CandelaColors.bgSecondary,
          border: Border(left: BorderSide(color: CandelaColors.border))),
      child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(model.model,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'monospace',
                      color: CandelaColors.textPrimary)),
              const SizedBox(height: 4),
              Text(model.provider,
                  style: const TextStyle(
                      fontSize: 13, color: CandelaColors.textSecondary)),
              const SizedBox(height: 24),
              _statTile('Total Calls', '${model.callCount}', Icons.bolt,
                  CandelaColors.accent),
              _statTile('Total Cost', '\$${model.costUsd.toStringAsFixed(4)}',
                  Icons.attach_money, const Color(0xFF4ADE80)),
              _statTile('Input Tokens', _fmtTokens(model.inputTokens),
                  Icons.arrow_forward, const Color(0xFF60A5FA)),
              _statTile('Output Tokens', _fmtTokens(model.outputTokens),
                  Icons.arrow_back, const Color(0xFFA78BFA)),
              _statTile(
                  'Avg Latency',
                  '${model.avgLatencyMs.toStringAsFixed(0)}ms',
                  Icons.timer,
                  CandelaColors.warning),
              const SizedBox(height: 24),
              const Text('Efficiency',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: CandelaColors.textPrimary)),
              const SizedBox(height: 12),
              _metricBar(
                  'Cost/Call',
                  model.callCount > 0
                      ? '\$${(model.costUsd / model.callCount).toStringAsFixed(6)}'
                      : '—'),
              const SizedBox(height: 8),
              _metricBar(
                  'Tokens/Call',
                  model.callCount > 0
                      ? '${(model.totalTokens / model.callCount).round()}'
                      : '—'),
              const SizedBox(height: 8),
              _metricBar(
                  'Output Ratio',
                  model.totalTokens > 0
                      ? '${(model.outputTokens / model.totalTokens * 100).toStringAsFixed(1)}%'
                      : '—'),
            ],
          )),
    );
  }

  Widget _statTile(String label, String value, IconData icon, Color color) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(children: [
          Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                  color: color.withAlpha(25),
                  borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, size: 16, color: color)),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 11, color: CandelaColors.textMuted)),
                Text(value,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'monospace',
                        color: CandelaColors.textPrimary)),
              ])),
        ]));
  }

  Widget _metricBar(String label, String value) {
    return Row(children: [
      SizedBox(
          width: 90,
          child: Text(label,
              style: const TextStyle(
                  fontSize: 11, color: CandelaColors.textMuted))),
      Text(value,
          style: const TextStyle(
              fontSize: 12,
              fontFamily: 'monospace',
              color: CandelaColors.textPrimary)),
    ]);
  }
}

String _fmtTokens(int v) {
  if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
  if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}k';
  return v.toString();
}
