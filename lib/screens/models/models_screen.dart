import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../data/model_pricing.dart';
import '../../models/catalog_model_view.dart';
import '../../models/span_stats.dart';
import '../../providers.dart';
import '../../services/telemetry_service.dart';
import '../../theme/colors.dart';

/// Model catalog + usage screen with two tabs.
class ModelsScreen extends ConsumerStatefulWidget {
  const ModelsScreen({super.key});

  @override
  ConsumerState<ModelsScreen> createState() => _ModelsScreenState();
}

class _ModelsScreenState extends ConsumerState<ModelsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(children: [
        _buildHeader(),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              _CatalogTab(),
              _UsageTab(),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: const BoxDecoration(
          color: CandelaColors.bgSecondary,
          border: Border(bottom: BorderSide(color: CandelaColors.border))),
      child: Row(children: [
        const Text('Models',
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: CandelaColors.textPrimary)),
        const SizedBox(width: 24),
        SizedBox(
          width: 200,
          child: TabBar(
            controller: _tabController,
            labelStyle:
                const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            unselectedLabelStyle: const TextStyle(fontSize: 12),
            labelColor: CandelaColors.accent,
            unselectedLabelColor: CandelaColors.textMuted,
            indicatorColor: CandelaColors.accent,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerHeight: 0,
            tabs: const [
              Tab(text: 'Catalog'),
              Tab(text: 'Usage'),
            ],
          ),
        ),
        const Spacer(),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Tab 1: Catalog — shows models from team or local catalog
// ═══════════════════════════════════════════════════════════════════════════════

enum _CatalogSortCol { name, provider, inputPrice, outputPrice, category }

class _CatalogTab extends ConsumerStatefulWidget {
  const _CatalogTab();
  @override
  ConsumerState<_CatalogTab> createState() => _CatalogTabState();
}

class _CatalogTabState extends ConsumerState<_CatalogTab>
    with AutomaticKeepAliveClientMixin {
  _CatalogSortCol _sortCol = _CatalogSortCol.name;
  bool _ascending = true;
  String _search = '';
  String? _selectedModelId;

  @override
  bool get wantKeepAlive => true;

  List<CatalogModelView> _sort(List<CatalogModelView> models) {
    final filtered = _search.isEmpty
        ? models
        : models
            .where((m) =>
                m.modelId.toLowerCase().contains(_search.toLowerCase()) ||
                m.displayName.toLowerCase().contains(_search.toLowerCase()) ||
                m.provider.toLowerCase().contains(_search.toLowerCase()))
            .toList();

    filtered.sort((a, b) {
      int cmp;
      switch (_sortCol) {
        case _CatalogSortCol.name:
          cmp = a.displayName.compareTo(b.displayName);
        case _CatalogSortCol.provider:
          cmp = a.provider.compareTo(b.provider);
        case _CatalogSortCol.inputPrice:
          cmp = (a.inputPerMillion ?? 0).compareTo(b.inputPerMillion ?? 0);
        case _CatalogSortCol.outputPrice:
          cmp = (a.outputPerMillion ?? 0).compareTo(b.outputPerMillion ?? 0);
        case _CatalogSortCol.category:
          cmp = (a.category ?? '').compareTo(b.category ?? '');
      }
      if (cmp == 0 && _sortCol != _CatalogSortCol.name) {
        return a.displayName.compareTo(b.displayName);
      }
      return _ascending ? cmp : -cmp;
    });
    return filtered;
  }

  void _setSort(_CatalogSortCol col) {
    setState(() {
      if (_sortCol == col) {
        _ascending = !_ascending;
      } else {
        _sortCol = col;
        _ascending = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final catalogState = ref.watch(catalogProvider);

    // Determine source: if catalog has models with pricing, it's team mode.
    final isTeamMode = catalogState.models.isNotEmpty &&
        catalogState.models.any((m) => m.inputPerMillion > 0);

    // Convert to unified view models.
    final viewModels =
        catalogState.models.map(CatalogModelView.fromTeamEntry).toList();
    final sorted = _sort(viewModels);

    final selected = _selectedModelId != null
        ? sorted.where((m) => m.modelId == _selectedModelId).firstOrNull
        : null;

    if (catalogState.loading && catalogState.models.isEmpty) {
      return const Center(
          child: CircularProgressIndicator(color: CandelaColors.accent));
    }

    if (catalogState.error != null && catalogState.models.isEmpty) {
      return Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('📋', style: TextStyle(fontSize: 48)),
        const SizedBox(height: 16),
        const Text('Catalog Unavailable',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: CandelaColors.textPrimary)),
        const SizedBox(height: 8),
        Text(catalogState.error!,
            style: const TextStyle(
                fontSize: 13, color: CandelaColors.textSecondary)),
        const SizedBox(height: 16),
        TextButton.icon(
          onPressed: () => ref.read(catalogProvider.notifier).fetch(),
          icon: const Icon(Icons.refresh, size: 14),
          label: const Text('Retry'),
        ),
      ]));
    }

    if (sorted.isEmpty && _search.isEmpty) {
      return const Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text('📋', style: TextStyle(fontSize: 48)),
        SizedBox(height: 16),
        Text('No models in catalog',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: CandelaColors.textPrimary)),
        SizedBox(height: 8),
        Text('The model catalog will populate once the backend is configured.',
            style: TextStyle(fontSize: 13, color: CandelaColors.textSecondary)),
      ]));
    }

    return Column(children: [
      // Search + refresh bar
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        color: CandelaColors.bgSecondary,
        child: Row(children: [
          SizedBox(
            width: 240,
            height: 32,
            child: TextField(
              style: const TextStyle(fontSize: 12),
              decoration: InputDecoration(
                hintText: 'Search models…',
                hintStyle: const TextStyle(
                    fontSize: 12, color: CandelaColors.textMuted),
                prefixIcon: const Icon(Icons.search,
                    size: 14, color: CandelaColors.textMuted),
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: CandelaColors.border)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: CandelaColors.border)),
              ),
              onChanged: (v) => setState(() => _search = v),
            ),
          ),
          const Spacer(),
          Text('${sorted.length} models',
              style: const TextStyle(
                  fontSize: 11, color: CandelaColors.textMuted)),
          const SizedBox(width: 12),
          _RefreshButton(
            loading: catalogState.loading,
            onTap: () => ref.read(catalogProvider.notifier).fetch(),
          ),
        ]),
      ),
      const Divider(height: 1, color: CandelaColors.border),
      // Column headers
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        color: CandelaColors.bgSecondary,
        child: Row(children: [
          _colHeader('Model', _CatalogSortCol.name, flex: 3),
          _colHeader('Provider', _CatalogSortCol.provider, flex: 2),
          if (isTeamMode) ...[
            _colHeader('In \$/M', _CatalogSortCol.inputPrice),
            _colHeader('Out \$/M', _CatalogSortCol.outputPrice),
            _colHeader('Category', _CatalogSortCol.category),
            const Expanded(
                child: Text('Context',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: CandelaColors.textMuted,
                        letterSpacing: 0.4))),
          ] else ...[
            const Expanded(
                flex: 2,
                child: Text('Description',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: CandelaColors.textMuted,
                        letterSpacing: 0.4))),
            const Expanded(
                child: Text('Size',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: CandelaColors.textMuted,
                        letterSpacing: 0.4))),
          ],
        ]),
      ),
      const Divider(height: 1, color: CandelaColors.border),
      // Model rows
      Expanded(
        child: Row(children: [
          Expanded(
            flex: 3,
            child: ListView.builder(
              itemCount: sorted.length,
              itemBuilder: (_, i) => _CatalogRow(
                model: sorted[i],
                isTeamMode: isTeamMode,
                isSelected: sorted[i].modelId == _selectedModelId,
                onTap: () => setState(() {
                  _selectedModelId = sorted[i].modelId == _selectedModelId
                      ? null
                      : sorted[i].modelId;
                }),
              ),
            ),
          ),
          if (selected != null)
            Expanded(
              flex: 2,
              child: _CatalogDetail(model: selected),
            ),
        ]),
      ),
    ]);
  }

  Widget _colHeader(String label, _CatalogSortCol col, {int flex = 1}) {
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

// ── Catalog Row ──────────────────────────────────────────────────────────────

class _CatalogRow extends StatefulWidget {
  final CatalogModelView model;
  final bool isTeamMode;
  final bool isSelected;
  final VoidCallback onTap;
  const _CatalogRow({
    required this.model,
    required this.isTeamMode,
    required this.isSelected,
    required this.onTap,
  });
  @override
  State<_CatalogRow> createState() => _CatalogRowState();
}

class _CatalogRowState extends State<_CatalogRow> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    final m = widget.model;
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
              child: Row(children: [
                if (!m.enabled)
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                        color: CandelaColors.border.withAlpha(80),
                        borderRadius: BorderRadius.circular(3)),
                    child: const Text('OFF',
                        style: TextStyle(
                            fontSize: 8,
                            color: CandelaColors.textMuted,
                            fontWeight: FontWeight.w700)),
                  ),
                if (m.pinned)
                  const Padding(
                    padding: EdgeInsets.only(right: 6),
                    child: Icon(Icons.push_pin,
                        size: 12, color: CandelaColors.accent),
                  ),
                Flexible(
                  child: Text(m.displayName,
                      style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: m.enabled
                              ? Colors.white
                              : CandelaColors.textMuted),
                      overflow: TextOverflow.ellipsis),
                ),
              ]),
            ),
            Expanded(
              flex: 2,
              child: Text(m.provider,
                  style: const TextStyle(
                      fontSize: 11, color: CandelaColors.textSecondary)),
            ),
            if (widget.isTeamMode) ...[
              Expanded(
                child: Text(
                    m.inputPerMillion != null
                        ? '\$${m.inputPerMillion!.toStringAsFixed(2)}'
                        : '—',
                    style: _mono.copyWith(
                        color: CandelaColors.textSecondary, fontSize: 11)),
              ),
              Expanded(
                child: Text(
                    m.outputPerMillion != null
                        ? '\$${m.outputPerMillion!.toStringAsFixed(2)}'
                        : '—',
                    style: _mono.copyWith(
                        color: CandelaColors.textSecondary, fontSize: 11)),
              ),
              Expanded(
                child: Text(m.category ?? '—',
                    style: const TextStyle(
                        fontSize: 11, color: CandelaColors.textSecondary)),
              ),
              Expanded(
                child: Text(
                    m.contextWindow != null
                        ? _fmtTokens(m.contextWindow!)
                        : '—',
                    style: _mono.copyWith(
                        color: CandelaColors.textSecondary, fontSize: 11)),
              ),
            ] else ...[
              Expanded(
                flex: 2,
                child: Text(m.description ?? '—',
                    style: const TextStyle(
                        fontSize: 11, color: CandelaColors.textSecondary),
                    overflow: TextOverflow.ellipsis),
              ),
              Expanded(
                child: Text(m.sizeHint ?? '—',
                    style: _mono.copyWith(
                        color: CandelaColors.textSecondary, fontSize: 11)),
              ),
            ],
          ]),
        ),
      ),
    );
  }

  static const _mono =
      TextStyle(fontFamily: 'monospace', fontSize: 12, color: Colors.white70);
}

// ── Catalog Detail Panel ─────────────────────────────────────────────────────

class _CatalogDetail extends StatelessWidget {
  final CatalogModelView model;
  const _CatalogDetail({required this.model});

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
            Text(model.displayName,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'monospace',
                    color: CandelaColors.textPrimary)),
            const SizedBox(height: 4),
            Text(model.modelId,
                style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'monospace',
                    color: CandelaColors.textMuted)),
            const SizedBox(height: 4),
            Text(model.provider,
                style: const TextStyle(
                    fontSize: 13, color: CandelaColors.textSecondary)),
            if (model.description != null) ...[
              const SizedBox(height: 12),
              Text(model.description!,
                  style: const TextStyle(
                      fontSize: 13, color: CandelaColors.textSecondary)),
            ],
            const SizedBox(height: 24),
            if (model.hasPricing) ...[
              const Text('Pricing',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: CandelaColors.textPrimary)),
              const SizedBox(height: 12),
              _metricBar('Input / 1M tokens',
                  '\$${model.inputPerMillion!.toStringAsFixed(2)}'),
              const SizedBox(height: 8),
              _metricBar('Output / 1M tokens',
                  '\$${model.outputPerMillion!.toStringAsFixed(2)}'),
              if (model.inputPerMillionHigh != null) ...[
                const SizedBox(height: 8),
                _metricBar('Input (high tier)',
                    '\$${model.inputPerMillionHigh!.toStringAsFixed(2)}'),
              ],
              if (model.outputPerMillionHigh != null) ...[
                const SizedBox(height: 8),
                _metricBar('Output (high tier)',
                    '\$${model.outputPerMillionHigh!.toStringAsFixed(2)}'),
              ],
              if (model.discountPercent != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      color: const Color(0xFF4ADE80).withAlpha(25),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                          color: const Color(0xFF4ADE80).withAlpha(80))),
                  child: Text(
                      '${model.discountPercent!.toStringAsFixed(0)}% discount',
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4ADE80))),
                ),
              ],
            ],
            if (model.sizeHint != null) ...[
              const SizedBox(height: 24),
              const Text('Download',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: CandelaColors.textPrimary)),
              const SizedBox(height: 12),
              _metricBar('Size', model.sizeHint!),
            ],
            if (model.category != null) ...[
              const SizedBox(height: 24),
              _metricBar('Category', model.category!),
            ],
            if (model.contextWindow != null) ...[
              const SizedBox(height: 8),
              _metricBar('Context Window',
                  '${_fmtTokens(model.contextWindow!)} tokens'),
            ],
            if (!model.enabled) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    color: CandelaColors.warning.withAlpha(25),
                    borderRadius: BorderRadius.circular(6),
                    border:
                        Border.all(color: CandelaColors.warning.withAlpha(80))),
                child: const Text('Disabled in catalog',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: CandelaColors.warning)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _metricBar(String label, String value) {
    return Row(children: [
      SizedBox(
          width: 120,
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

// ═══════════════════════════════════════════════════════════════════════════════
// Tab 2: Usage — existing telemetry analytics (unchanged logic)
// ═══════════════════════════════════════════════════════════════════════════════

/// Filter mode for the usage model list.
enum _ModelFilter { all, used }

enum _UsageSortCol { name, calls, tokens, cost, latency }

class _UsageTab extends ConsumerStatefulWidget {
  const _UsageTab();
  @override
  ConsumerState<_UsageTab> createState() => _UsageTabState();
}

class _UsageTabState extends ConsumerState<_UsageTab>
    with AutomaticKeepAliveClientMixin {
  TokenTimeRange _range = TokenTimeRange.d7;
  List<ModelBreakdown> _models = [];
  List<ModelBreakdown> _allModels = [];
  bool _loading = true;
  String? _error;
  Timer? _autoRefresh;
  TelemetryService? _svc;
  bool _initialized = false;
  String? _selectedModel;
  _UsageSortCol _sortCol = _UsageSortCol.cost;
  bool _ascending = false;
  double _maxCost = 0;
  int _port = 8181;
  _ModelFilter _filter = _ModelFilter.all;

  @override
  bool get wantKeepAlive => true;

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
    _port = config.port;
    _svc = TelemetryService(port: _port);
    await _fetch();
    if (!mounted) return;
    _autoRefresh = Timer.periodic(const Duration(seconds: 30), (_) => _fetch());
  }

  /// Fetch available models from the proxy's /v1/models endpoint.
  Future<List<String>> _fetchAvailableModels() async {
    try {
      final resp = await http
          .get(Uri.parse('http://localhost:$_port/v1/models'))
          .timeout(const Duration(seconds: 5));
      if (resp.statusCode == 200) {
        final body = json.decode(resp.body);
        if (body is Map<String, dynamic>) {
          final data = body['data'];
          if (data is List) {
            return data
                .map((m) => m is Map ? m['id']?.toString() ?? '' : '')
                .where((n) => n.isNotEmpty)
                .toList();
          }
        }
      }
    } catch (_) {}
    return [];
  }

  /// Infer provider from model name.
  static String _inferProvider(String model) {
    final name = model.toLowerCase();
    if (name.contains('gemini')) return 'google';
    if (name.contains('claude')) return 'anthropic';
    if (name.contains('gpt') ||
        name.startsWith('o3') ||
        name.startsWith('o4')) {
      return 'openai';
    }
    if (name.contains('mistral') || name.contains('codestral')) {
      return 'mistral';
    }
    if (name.contains('deepseek')) return 'deepseek';
    if (name.contains('qwen')) return 'qwen';
    return 'other';
  }

  Future<void> _fetch() async {
    if (!mounted || _svc == null) return;
    setState(() => _loading = true);
    try {
      final results = await Future.wait([
        _svc!.fetch(_range),
        _svc!.isTeamMode ? Future.value(<String>[]) : _fetchAvailableModels(),
      ]);
      final result = results[0] as TelemetryResult?;
      final availableIds = results[1] as List<String>;

      if (!mounted) return;
      setState(() {
        // ignore: deprecated_member_use
        final usedModels = (result?.models ?? []).map((m) {
          final pricing = lookupPricing(m.model);
          if (pricing != null) {
            return m.withPricing(
              inputPerMillion: pricing.inputPerMillion,
              outputPerMillion: pricing.outputPerMillion,
            );
          }
          return m;
        }).toList();

        final usedNames = {for (final m in usedModels) m.model};

        final unusedModels =
            availableIds.where((id) => !usedNames.contains(id)).map((id) {
          // ignore: deprecated_member_use
          final pricing = lookupPricing(id);
          return ModelBreakdown(
            model: id,
            provider: _inferProvider(id),
            callCount: 0,
            inputTokens: 0,
            outputTokens: 0,
            costUsd: 0,
            avgLatencyMs: 0,
            inputPricePerMillion: pricing?.inputPerMillion,
            outputPricePerMillion: pricing?.outputPerMillion,
          );
        }).toList();

        _models = usedModels;
        _allModels = [...usedModels, ...unusedModels];
        _sortModels();
        final displayModels = _displayModels;
        _maxCost = displayModels.isEmpty
            ? 0
            : displayModels
                .map((m) => m.costUsd)
                .reduce((a, b) => a > b ? a : b);
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

  List<ModelBreakdown> get _displayModels =>
      _filter == _ModelFilter.used ? _models : _allModels;

  int _compare(ModelBreakdown a, ModelBreakdown b) {
    int cmp;
    switch (_sortCol) {
      case _UsageSortCol.cost:
        cmp = a.costUsd.compareTo(b.costUsd);
      case _UsageSortCol.calls:
        cmp = a.callCount.compareTo(b.callCount);
      case _UsageSortCol.tokens:
        cmp = a.totalTokens.compareTo(b.totalTokens);
      case _UsageSortCol.latency:
        cmp = a.avgLatencyMs.compareTo(b.avgLatencyMs);
      case _UsageSortCol.name:
        cmp = a.model.compareTo(b.model);
    }
    if (cmp == 0 && _sortCol != _UsageSortCol.name) {
      return a.model.compareTo(b.model);
    }
    return _ascending ? cmp : -cmp;
  }

  void _sortModels() {
    _models.sort(_compare);
    _allModels.sort(_compare);
  }

  void _setSort(_UsageSortCol col) {
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
    super.build(context);
    final display = _displayModels;
    final selected = _selectedModel != null
        ? display.where((m) => m.model == _selectedModel).firstOrNull
        : null;
    return Column(children: [
      _buildUsageHeader(),
      Expanded(
          child: _error != null
              ? Center(
                  child: Text(_error!,
                      style: const TextStyle(
                          color: CandelaColors.error, fontSize: 13)))
              : display.isEmpty && !_loading
                  ? _buildEmpty()
                  : Row(children: [
                      Expanded(flex: 3, child: _buildModelList()),
                      if (selected != null)
                        Expanded(flex: 2, child: _UsageDetail(model: selected)),
                    ])),
    ]);
  }

  Widget _buildUsageHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      color: CandelaColors.bgSecondary,
      child: Row(children: [
        Text(
            _filter == _ModelFilter.all
                ? '${_allModels.length} available · ${_models.length} used'
                : '${_models.length} model${_models.length != 1 ? 's' : ''} used',
            style:
                const TextStyle(fontSize: 11, color: CandelaColors.textMuted)),
        const Spacer(),
        _buildFilterChips(),
        const SizedBox(width: 10),
        _buildTimeChips(),
        const SizedBox(width: 10),
        _RefreshButton(loading: _loading, onTap: _loading ? null : _fetch),
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

  Widget _buildFilterChips() {
    return Container(
      decoration: BoxDecoration(
          color: CandelaColors.bgSecondary,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: CandelaColors.border)),
      padding: const EdgeInsets.all(3),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        for (final f in _ModelFilter.values)
          GestureDetector(
            onTap: () => setState(() => _filter = f),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                  color:
                      f == _filter ? CandelaColors.accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(5)),
              child: Text(f == _ModelFilter.all ? 'All Available' : 'Used',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          f == _filter ? FontWeight.w600 : FontWeight.w400,
                      color: f == _filter
                          ? Colors.white
                          : CandelaColors.textMuted)),
            ),
          ),
      ]),
    );
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
            _colHeader('Model', _UsageSortCol.name, flex: 3),
            const Expanded(
                child: Text('In \$/M',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: CandelaColors.textMuted,
                        letterSpacing: 0.4))),
            const Expanded(
                child: Text('Out \$/M',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: CandelaColors.textMuted,
                        letterSpacing: 0.4))),
            _colHeader('Calls', _UsageSortCol.calls),
            _colHeader('Tokens', _UsageSortCol.tokens),
            _colHeader('Cost', _UsageSortCol.cost),
            _colHeader('Avg Latency', _UsageSortCol.latency),
            const SizedBox(width: 100),
          ])),
      const Divider(height: 1, color: CandelaColors.border),
      Expanded(
          child: ListView.builder(
        itemCount: _displayModels.length,
        itemBuilder: (_, i) {
          final display = _displayModels;
          return _UsageRow(
            model: display[i],
            isSelected: display[i].model == _selectedModel,
            maxCost: _maxCost,
            onTap: () => setState(() {
              _selectedModel =
                  display[i].model == _selectedModel ? null : display[i].model;
            }),
          );
        },
      )),
    ]);
  }

  Widget _colHeader(String label, _UsageSortCol col, {int flex = 1}) {
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

// ── Usage Row ────────────────────────────────────────────────────────────────

class _UsageRow extends StatefulWidget {
  final ModelBreakdown model;
  final bool isSelected;
  final double maxCost;
  final VoidCallback onTap;
  const _UsageRow(
      {required this.model,
      required this.isSelected,
      required this.maxCost,
      required this.onTap});
  @override
  State<_UsageRow> createState() => _UsageRowState();
}

class _UsageRowState extends State<_UsageRow> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    final m = widget.model;
    final barPct = widget.maxCost > 0 ? (m.costUsd / widget.maxCost) : 0.0;
    final isUnused = m.callCount == 0;
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
                            style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: isUnused
                                    ? CandelaColors.textMuted
                                    : Colors.white),
                            overflow: TextOverflow.ellipsis),
                        Row(children: [
                          Text(m.provider,
                              style: const TextStyle(
                                  fontSize: 10,
                                  color: CandelaColors.textMuted)),
                          if (isUnused) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 1),
                              decoration: BoxDecoration(
                                  color: CandelaColors.border.withAlpha(80),
                                  borderRadius: BorderRadius.circular(4)),
                              child: const Text('available',
                                  style: TextStyle(
                                      fontSize: 9,
                                      color: CandelaColors.textMuted,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ],
                        ]),
                      ])),
              Expanded(
                  child: Text(
                      m.inputPricePerMillion != null
                          ? '\$${m.inputPricePerMillion!.toStringAsFixed(2)}'
                          : '—',
                      style: _mono.copyWith(
                          color: CandelaColors.textSecondary, fontSize: 11))),
              Expanded(
                  child: Text(
                      m.outputPricePerMillion != null
                          ? '\$${m.outputPricePerMillion!.toStringAsFixed(2)}'
                          : '—',
                      style: _mono.copyWith(
                          color: CandelaColors.textSecondary, fontSize: 11))),
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

// ── Usage Detail Panel ───────────────────────────────────────────────────────

class _UsageDetail extends StatelessWidget {
  final ModelBreakdown model;
  const _UsageDetail({required this.model});

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
              if (model.inputPricePerMillion != null) ...[
                const SizedBox(height: 24),
                const Text('List Pricing',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: CandelaColors.textPrimary)),
                const SizedBox(height: 12),
                _metricBar('Input / 1M tokens',
                    '\$${model.inputPricePerMillion!.toStringAsFixed(2)}'),
                const SizedBox(height: 8),
                _metricBar('Output / 1M tokens',
                    '\$${model.outputPricePerMillion!.toStringAsFixed(2)}'),
              ],
              if (model.cacheReadTokens > 0) ...[
                const SizedBox(height: 24),
                Builder(builder: (_) {
                  final eff = cacheEfficiencyLabel(
                      model.cacheReadTokens, model.inputTokens);
                  if (eff == null) return const SizedBox.shrink();
                  final badgeColor = switch (eff.tier) {
                    CacheEfficiencyTier.excellent => const Color(0xFF4ADE80),
                    CacheEfficiencyTier.good => CandelaColors.accent,
                    CacheEfficiencyTier.low => CandelaColors.warning,
                  };
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Cache Efficiency',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: CandelaColors.textPrimary)),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              color: badgeColor.withAlpha(25),
                              borderRadius: BorderRadius.circular(8),
                              border:
                                  Border.all(color: badgeColor.withAlpha(80))),
                          child: Text(
                              '${eff.label}  ${(eff.rate * 100).toStringAsFixed(1)}%',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'monospace',
                                  color: badgeColor)),
                        ),
                        const SizedBox(height: 8),
                        _metricBar(
                            'Cache Read', _fmtTokens(model.cacheReadTokens)),
                      ]);
                }),
              ],
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

// ── Shared Widgets ───────────────────────────────────────────────────────────

class _RefreshButton extends StatelessWidget {
  final bool loading;
  final VoidCallback? onTap;
  const _RefreshButton({required this.loading, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
        message: 'Refresh',
        child: InkWell(
          onTap: loading ? null : onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: CandelaColors.bgTertiary,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: CandelaColors.border)),
            child: loading
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
}

// ── Helpers ──────────────────────────────────────────────────────────────────

String _fmtTokens(int v) {
  if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
  if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}k';
  return v.toString();
}
