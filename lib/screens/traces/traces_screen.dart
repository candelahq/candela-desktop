import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/candela_config.dart';
import '../../models/span_stats.dart';
import '../../services/gcloud_service.dart';
import '../../services/telemetry_service.dart';
import '../../theme/colors.dart';
import '../../providers.dart';
import '../../widgets/scope_toggle.dart';

/// Full-page distributed trace viewer.
///
/// Shows a searchable, filterable list of LLM call spans with expandable
/// detail rows showing token counts, latency, cost, and timing.
class TracesScreen extends ConsumerStatefulWidget {
  const TracesScreen({super.key});

  @override
  ConsumerState<TracesScreen> createState() => _TracesScreenState();
}

class _TracesScreenState extends ConsumerState<TracesScreen> {
  TokenTimeRange _range = TokenTimeRange.d7;
  List<SpanRecord> _spans = [];
  List<SpanRecord> _filtered = [];
  bool _loading = true;
  String? _error;
  Timer? _autoRefresh;
  TelemetryService? _svc;
  bool _initialized = false;
  bool _isTeamMode = false;

  // Filters
  String _searchQuery = '';
  String? _statusFilter; // null = all
  String? _modelFilter; // null = all
  _TraceSortCol _sortCol = _TraceSortCol.timestamp;
  bool _ascending = false;

  // Cached filter options — computed once per fetch, not per rebuild.
  Set<String> _cachedModels = {};
  Set<String> _cachedStatuses = {};

  // Expansion
  String? _expandedSpanId;

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

    final isTeam = config.mode == CandelaMode.team &&
        config.remote != null &&
        config.remote!.isNotEmpty;

    if (isTeam) {
      _isTeamMode = true;
      final gcloud = GCloudService();
      final audience = config.audience ?? config.remote ?? '';
      final tokenInfo = audience.isNotEmpty
          ? await gcloud.getIdToken(audience)
          : await gcloud.getTokenInfo();
      _svc = TelemetryService(
        port: config.port,
        remoteUrl: config.remote,
        authToken: tokenInfo?.accessToken,
      );
    } else {
      _svc = TelemetryService(port: config.port);
    }

    await _fetch();
    if (!mounted) return;
    _autoRefresh = Timer.periodic(const Duration(seconds: 30), (_) => _fetch());
  }

  Future<void> _fetch() async {
    if (!mounted || _svc == null) return;
    setState(() => _loading = true);
    try {
      final result = await _svc!.fetch(_range,
          userScope:
              _isTeamMode ? ref.read(dashboardProvider).state.userScope : null);
      if (!mounted) return;
      setState(() {
        _spans = result?.spans ?? [];
        _cachedModels = _spans.map((s) => s.model).toSet();
        _cachedStatuses = _spans.map((s) => s.status).toSet();
        _loading = false;
        _error = result == null
            ? 'Could not reach the Candela proxy. Is it running?'
            : result.error != null
                ? 'Connection error'
                : null;
        _applyFilters();
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Failed to load traces: $e';
      });
    }
  }

  void _applyFilters() {
    var list = List<SpanRecord>.from(_spans);

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((s) {
        return s.model.toLowerCase().contains(q) ||
            s.provider.toLowerCase().contains(q) ||
            s.name.toLowerCase().contains(q) ||
            s.traceId.toLowerCase().contains(q) ||
            s.spanId.toLowerCase().contains(q);
      }).toList();
    }

    if (_statusFilter != null) {
      list = list.where((s) => s.status == _statusFilter).toList();
    }

    if (_modelFilter != null) {
      list = list.where((s) => s.model == _modelFilter).toList();
    }

    list.sort((a, b) {
      int cmp;
      switch (_sortCol) {
        case _TraceSortCol.timestamp:
          cmp = a.timestamp.compareTo(b.timestamp);
        case _TraceSortCol.model:
          cmp = a.model.compareTo(b.model);
        case _TraceSortCol.cost:
          cmp = a.costUsd.compareTo(b.costUsd);
        case _TraceSortCol.latency:
          cmp = a.durationMs.compareTo(b.durationMs);
        case _TraceSortCol.tokens:
          cmp = a.totalTokens.compareTo(b.totalTokens);
      }
      return _ascending ? cmp : -cmp;
    });

    _filtered = list;
  }

  void _setRange(TokenTimeRange r) {
    setState(() => _range = r);
    _fetch();
  }

  Set<String> get _availableModels => _cachedModels;

  Set<String> get _availableStatuses => _cachedStatuses;

  @override
  void dispose() {
    _autoRefresh?.cancel();
    _svc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          _buildHeader(),
          _buildFilterBar(),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
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
              const Text(
                'Traces',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: CandelaColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${_filtered.length} span${_filtered.length != 1 ? 's' : ''}',
                style: const TextStyle(
                    fontSize: 11, color: CandelaColors.textMuted),
              ),
            ],
          ),
          if (_isTeamMode) ...[
            const SizedBox(width: 12),
            ScopeToggle(
              scope: ref.watch(dashboardProvider).state.userScope,
              onChanged: (s) {
                ref.read(dashboardProvider).setUserScope(s);
                _fetch();
              },
            ),
          ],
          const Spacer(),
          _TimeRangeChips(value: _range, onChanged: _setRange),
          const SizedBox(width: 10),
          _RefreshButton(onRefresh: _fetch, loading: _loading),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: const BoxDecoration(
        color: CandelaColors.bgSecondary,
        border: Border(bottom: BorderSide(color: CandelaColors.borderSubtle)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: SizedBox(
              height: 34,
              child: TextField(
                onChanged: (v) => setState(() {
                  _searchQuery = v;
                  _applyFilters();
                }),
                style: const TextStyle(
                    fontSize: 13, color: CandelaColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Search by model, provider, trace ID…',
                  hintStyle: const TextStyle(
                      fontSize: 12, color: CandelaColors.textMuted),
                  prefixIcon: const Icon(Icons.search,
                      size: 16, color: CandelaColors.textMuted),
                  filled: true,
                  fillColor: CandelaColors.bgTertiary,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: CandelaColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: CandelaColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: CandelaColors.accent),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          _FilterDropdown(
            label: 'Model',
            value: _modelFilter,
            options: _availableModels.toList()..sort(),
            onChanged: (v) => setState(() {
              _modelFilter = v;
              _applyFilters();
            }),
          ),
          const SizedBox(width: 8),
          _FilterDropdown(
            label: 'Status',
            value: _statusFilter,
            options: _availableStatuses.toList()..sort(),
            onChanged: (v) => setState(() {
              _statusFilter = v;
              _applyFilters();
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_error != null && _spans.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning_amber_rounded,
                size: 48, color: CandelaColors.textMuted),
            const SizedBox(height: 12),
            Text(_error!,
                style: const TextStyle(color: CandelaColors.textSecondary)),
          ],
        ),
      );
    }

    if (_filtered.isEmpty && !_loading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🔍', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isNotEmpty ||
                      _modelFilter != null ||
                      _statusFilter != null
                  ? 'No spans match your filters'
                  : 'No traces yet',
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: CandelaColors.textPrimary),
            ),
            const SizedBox(height: 8),
            const Text(
              'Traces appear once LLM calls flow through the proxy.',
              style:
                  TextStyle(fontSize: 13, color: CandelaColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        _buildColumnHeaders(),
        const Divider(height: 1, color: CandelaColors.border),
        Expanded(
          child: ListView.builder(
            itemCount: _filtered.length,
            itemBuilder: (context, index) {
              final span = _filtered[index];
              final isExpanded = span.spanId == _expandedSpanId;
              return _SpanRow(
                span: span,
                isExpanded: isExpanded,
                onTap: () => setState(() {
                  _expandedSpanId = isExpanded ? null : span.spanId;
                }),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildColumnHeaders() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      color: CandelaColors.bgSecondary,
      child: Row(
        children: [
          _sortableHeader('Time', _TraceSortCol.timestamp, flex: 2),
          _sortableHeader('Model', _TraceSortCol.model, flex: 3),
          const _HeaderLabel('Provider', flex: 2),
          const _HeaderLabel('Status', flex: 1),
          _sortableHeader('Tokens', _TraceSortCol.tokens, flex: 2),
          _sortableHeader('Cost', _TraceSortCol.cost, flex: 1),
          _sortableHeader('Latency', _TraceSortCol.latency, flex: 1),
          const SizedBox(width: 32),
        ],
      ),
    );
  }

  Widget _sortableHeader(String label, _TraceSortCol col, {int flex = 1}) {
    final isActive = _sortCol == col;
    return Expanded(
      flex: flex,
      child: GestureDetector(
        onTap: () => setState(() {
          if (_sortCol == col) {
            _ascending = !_ascending;
          } else {
            _sortCol = col;
            _ascending = false;
          }
          _applyFilters();
        }),
        child: Row(
          children: [
            Text(label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color:
                      isActive ? CandelaColors.accent : CandelaColors.textMuted,
                  letterSpacing: 0.4,
                )),
            if (isActive) ...[
              const SizedBox(width: 3),
              Icon(_ascending ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 10, color: CandelaColors.accent),
            ],
          ],
        ),
      ),
    );
  }
}

enum _TraceSortCol { timestamp, model, cost, latency, tokens }

class _HeaderLabel extends StatelessWidget {
  final String text;
  final int flex;
  const _HeaderLabel(this.text, {this.flex = 1});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(text,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: CandelaColors.textMuted,
            letterSpacing: 0.4,
          )),
    );
  }
}

class _SpanRow extends StatefulWidget {
  final SpanRecord span;
  final bool isExpanded;
  final VoidCallback onTap;
  const _SpanRow(
      {required this.span, required this.isExpanded, required this.onTap});
  @override
  State<_SpanRow> createState() => _SpanRowState();
}

class _SpanRowState extends State<_SpanRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final s = widget.span;
    return Column(
      children: [
        MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              color: widget.isExpanded
                  ? CandelaColors.bgTertiary
                  : _hovered
                      ? CandelaColors.bgHover
                      : Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: Text(_formatTime(s.timestamp), style: _cellStyle)),
                  Expanded(
                      flex: 3,
                      child: Text(s.model,
                          style: _cellStyle.copyWith(
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                          overflow: TextOverflow.ellipsis)),
                  Expanded(flex: 2, child: Text(s.provider, style: _cellStyle)),
                  Expanded(flex: 1, child: _StatusBadge(status: s.status)),
                  Expanded(
                      flex: 2,
                      child: Text(
                          '${_fmtTokens(s.inputTokens)} → ${_fmtTokens(s.outputTokens)}',
                          style: _cellStyle.copyWith(fontFamily: 'monospace'))),
                  Expanded(
                      flex: 1,
                      child: Text('\$${s.costUsd.toStringAsFixed(4)}',
                          style: _cellStyle.copyWith(
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.w600))),
                  Expanded(
                      flex: 1,
                      child: Text('${s.durationMs.toStringAsFixed(0)}ms',
                          style: _cellStyle.copyWith(fontFamily: 'monospace'))),
                  SizedBox(
                      width: 32,
                      child: Icon(
                          widget.isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          size: 16,
                          color: CandelaColors.textMuted)),
                ],
              ),
            ),
          ),
        ),
        if (widget.isExpanded) _SpanDetail(span: s),
        const Divider(height: 1, color: CandelaColors.borderSubtle),
      ],
    );
  }

  static const _cellStyle = TextStyle(fontSize: 12, color: Colors.white70);
}

class _SpanDetail extends StatelessWidget {
  final SpanRecord span;
  const _SpanDetail({required this.span});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(48, 8, 24, 16),
      color: CandelaColors.bgTertiary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: _infoCol('Identifiers', [
                ('Span ID', span.spanId),
                ('Trace ID', span.traceId),
                ('Name', span.name),
              ])),
              Expanded(
                  child: _infoCol('Tokens', [
                ('Input', '${span.inputTokens}'),
                ('Output', '${span.outputTokens}'),
                ('Total', '${span.totalTokens}'),
              ])),
              Expanded(
                  child: _infoCol('Performance', [
                ('Latency', '${span.durationMs.toStringAsFixed(1)}ms'),
                ('Cost', '\$${span.costUsd.toStringAsFixed(6)}'),
                ('Status', span.status),
              ])),
              Expanded(
                  child: _infoCol('Timing', [
                ('Timestamp', span.timestamp.toIso8601String()),
                ('Provider', span.provider),
                ('Model', span.model),
              ])),
            ],
          ),
          const SizedBox(height: 12),
          Row(children: [
            const Text('Duration: ',
                style: TextStyle(fontSize: 11, color: CandelaColors.textMuted)),
            SizedBox(
                width: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: (span.durationMs / 10000).clamp(0.0, 1.0),
                    minHeight: 4,
                    backgroundColor: CandelaColors.bgElevated,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        _latencyColor(span.durationMs)),
                  ),
                )),
            const SizedBox(width: 8),
            Text('${span.durationMs.toStringAsFixed(0)}ms',
                style: TextStyle(
                    fontSize: 11,
                    fontFamily: 'monospace',
                    color: _latencyColor(span.durationMs))),
          ]),
        ],
      ),
    );
  }

  Widget _infoCol(String title, List<(String, String)> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: CandelaColors.textMuted,
                letterSpacing: 0.5)),
        const SizedBox(height: 6),
        for (final (label, value) in items)
          Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Row(children: [
                SizedBox(
                    width: 65,
                    child: Text(label,
                        style: const TextStyle(
                            fontSize: 11, color: CandelaColors.textMuted))),
                Expanded(
                    child: Text(value,
                        style: const TextStyle(
                            fontSize: 11,
                            fontFamily: 'monospace',
                            color: CandelaColors.textPrimary),
                        overflow: TextOverflow.ellipsis)),
              ])),
      ],
    );
  }

  static Color _latencyColor(double ms) {
    if (ms < 1000) return CandelaColors.success;
    if (ms < 5000) return CandelaColors.warning;
    return CandelaColors.error;
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (status) {
      'ok' => (CandelaColors.success, 'OK'),
      'error' => (CandelaColors.error, 'ERR'),
      _ => (CandelaColors.textMuted, status.toUpperCase()),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 10, fontWeight: FontWeight.w600, color: color)),
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> options;
  final ValueChanged<String?> onChanged;
  const _FilterDropdown(
      {required this.label,
      required this.value,
      required this.options,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: CandelaColors.bgTertiary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: CandelaColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          value: value,
          hint: Text(label,
              style: const TextStyle(
                  fontSize: 12, color: CandelaColors.textMuted)),
          dropdownColor: CandelaColors.bgSecondary,
          style:
              const TextStyle(fontSize: 12, color: CandelaColors.textPrimary),
          icon: const Icon(Icons.arrow_drop_down,
              size: 16, color: CandelaColors.textMuted),
          items: [
            DropdownMenuItem<String?>(value: null, child: Text('All $label')),
            ...options.map((o) => DropdownMenuItem(value: o, child: Text(o))),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _TimeRangeChips extends StatelessWidget {
  final TokenTimeRange value;
  final ValueChanged<TokenTimeRange> onChanged;
  const _TimeRangeChips({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CandelaColors.bgSecondary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: CandelaColors.border),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: TokenTimeRange.values
            .map((r) => GestureDetector(
                  onTap: () => onChanged(r),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: r == value
                          ? CandelaColors.accent
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(r.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight:
                              r == value ? FontWeight.w600 : FontWeight.w400,
                          color: r == value
                              ? Colors.white
                              : CandelaColors.textMuted,
                        )),
                  ),
                ))
            .toList(),
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

String _formatTime(DateTime dt) {
  final diff = DateTime.now().difference(dt);
  if (diff.inMinutes < 1) return 'just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  return '${dt.month}/${dt.day} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}

String _fmtTokens(int v) {
  if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
  if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}k';
  return v.toString();
}
