import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../gen/candela/types/model_catalog.pb.dart';
import '../../providers.dart';
import '../../services/catalog_notifier.dart';
import '../../theme/colors.dart';

// ── Provider colors ──────────────────────────────────────────────────────────

const _providerColors = <String, Color>{
  'google': Color(0xFF60A5FA), // blue
  'anthropic': Color(0xFFF59E0B), // orange
  'openai': Color(0xFF34D399), // green
  'mistral': Color(0xFFA78BFA), // purple
  'deepseek': Color(0xFF2DD4BF), // teal
  'qwen': Color(0xFFF87171), // red
};

Color _colorForProvider(String provider) =>
    _providerColors[provider.toLowerCase()] ?? CandelaColors.textMuted;

// ── Category badge colors ────────────────────────────────────────────────────

Color _categoryColor(String category) {
  return switch (category.toLowerCase()) {
    'flagship' => const Color(0xFFF0A030),
    'lite' => const Color(0xFF60A5FA),
    'reasoning' => const Color(0xFFA78BFA),
    'code' => const Color(0xFF34D399),
    'embedding' => const Color(0xFF2DD4BF),
    _ => CandelaColors.textMuted,
  };
}

// ── Context window formatting ────────────────────────────────────────────────

String _formatContextWindow(int tokens) {
  if (tokens <= 0) return '—';
  if (tokens >= 1000000) {
    final m = tokens / 1000000;
    return m == m.roundToDouble()
        ? '${m.round()}M'
        : '${m.toStringAsFixed(1)}M';
  }
  final k = tokens / 1000;
  return k == k.roundToDouble() ? '${k.round()}K' : '${k.toStringAsFixed(1)}K';
}

// ── Price formatting ─────────────────────────────────────────────────────────

String _formatPrice(double price) {
  if (price <= 0) return '—';
  if (price < 0.01) return '\$${price.toStringAsFixed(4)}';
  if (price < 1) return '\$${price.toStringAsFixed(3)}';
  return '\$${price.toStringAsFixed(2)}';
}

// ── All providers list ───────────────────────────────────────────────────────

const _allProviders = [
  'All',
  'Google',
  'Anthropic',
  'OpenAI',
  'Mistral',
  'DeepSeek',
  'Qwen'
];

// ═════════════════════════════════════════════════════════════════════════════
// CatalogScreen
// ═════════════════════════════════════════════════════════════════════════════

class CatalogScreen extends ConsumerStatefulWidget {
  const CatalogScreen({super.key});

  @override
  ConsumerState<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends ConsumerState<CatalogScreen> {
  String _searchQuery = '';
  String _selectedProvider = 'All';

  @override
  Widget build(BuildContext context) {
    final catalogState = ref.watch(catalogProvider);
    final models = _filterModels(catalogState.models);

    return Scaffold(
      backgroundColor: CandelaColors.bgPrimary,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(catalogState),
          _buildSearchAndFilters(),
          Expanded(child: _buildBody(models, catalogState)),
        ],
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader(CatalogState state) {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 32, 32, 16),
      child: Row(
        children: [
          const Text(
            'Model Catalog',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: CandelaColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(width: 12),
          if (state.source.isNotEmpty) _buildSourceBadge(state.source),
          if (state.adminEditable) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: CandelaColors.success.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                    color: CandelaColors.success.withValues(alpha: 0.3)),
              ),
              child: const Text(
                'Admin',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: CandelaColors.success,
                ),
              ),
            ),
          ],
          const Spacer(),
          // Model count
          Text(
            '${state.models.length} models',
            style: const TextStyle(
              fontSize: 13,
              color: CandelaColors.textMuted,
            ),
          ),
          const SizedBox(width: 16),
          // Refresh button
          _IconActionButton(
            icon: Icons.refresh_rounded,
            tooltip: 'Refresh catalog',
            loading: state.loading,
            onTap: () => ref.read(catalogProvider.notifier).fetch(),
          ),
        ],
      ),
    );
  }

  Widget _buildSourceBadge(String source) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: CandelaColors.info.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: CandelaColors.info.withValues(alpha: 0.3)),
      ),
      child: Text(
        source,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: CandelaColors.info,
        ),
      ),
    );
  }

  // ── Search & Filters ──────────────────────────────────────────────────────

  Widget _buildSearchAndFilters() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar
          SizedBox(
            height: 40,
            child: TextField(
              style: const TextStyle(
                  fontSize: 13, color: CandelaColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search by model name or provider…',
                hintStyle: const TextStyle(
                    fontSize: 13, color: CandelaColors.textMuted),
                prefixIcon: const Icon(Icons.search_rounded,
                    size: 18, color: CandelaColors.textMuted),
                filled: true,
                fillColor: CandelaColors.bgSecondary,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: CandelaColors.borderSubtle),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: CandelaColors.borderSubtle),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: CandelaColors.accent),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (v) => setState(() => _searchQuery = v),
            ),
          ),
          const SizedBox(height: 12),
          // Provider filter chips
          Wrap(
            spacing: 8,
            children: _allProviders.map((p) {
              final isSelected = _selectedProvider == p;
              return FilterChip(
                label: Text(
                  p,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? CandelaColors.bgPrimary
                        : CandelaColors.textSecondary,
                  ),
                ),
                selected: isSelected,
                onSelected: (_) => setState(() => _selectedProvider = p),
                backgroundColor: CandelaColors.bgSecondary,
                selectedColor:
                    p == 'All' ? CandelaColors.accent : _colorForProvider(p),
                side: BorderSide(
                  color: isSelected
                      ? Colors.transparent
                      : CandelaColors.borderSubtle,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                showCheckmark: false,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ── Body ──────────────────────────────────────────────────────────────────

  Widget _buildBody(List<ModelCatalogEntry> models, CatalogState state) {
    if (state.loading && state.models.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: CandelaColors.accent),
      );
    }

    if (state.error != null && state.models.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded,
                size: 48, color: CandelaColors.error),
            const SizedBox(height: 16),
            const Text(
              'Failed to load catalog',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: CandelaColors.textPrimary),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 400,
              child: Text(
                state.error!,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 12, color: CandelaColors.textMuted),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              style:
                  FilledButton.styleFrom(backgroundColor: CandelaColors.accent),
              onPressed: () => ref.read(catalogProvider.notifier).fetch(),
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (models.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.menu_book_outlined,
                size: 48, color: CandelaColors.textMuted),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isNotEmpty || _selectedProvider != 'All'
                  ? 'No models match your filters'
                  : 'No models in catalog',
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: CandelaColors.textPrimary),
            ),
          ],
        ),
      );
    }

    return _buildTable(models, state);
  }

  // ── Table ─────────────────────────────────────────────────────────────────

  Widget _buildTable(List<ModelCatalogEntry> models, CatalogState state) {
    return Container(
      margin: const EdgeInsets.fromLTRB(32, 0, 32, 24),
      decoration: BoxDecoration(
        color: CandelaColors.bgSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CandelaColors.borderSubtle),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            // Header row
            _buildTableHeader(state),
            const Divider(height: 1, color: CandelaColors.borderSubtle),
            // Data rows
            Expanded(
              child: ListView.separated(
                itemCount: models.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, color: CandelaColors.borderSubtle),
                itemBuilder: (ctx, i) => _buildTableRow(models[i], state),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader(CatalogState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: CandelaColors.bgTertiary,
      child: Row(
        children: [
          const Expanded(flex: 5, child: _HeaderCell('Model ID')),
          const Expanded(flex: 2, child: _HeaderCell('Provider')),
          const Expanded(flex: 2, child: _HeaderCell('Category')),
          const Expanded(flex: 2, child: _HeaderCell('Input \$/1M')),
          const Expanded(flex: 2, child: _HeaderCell('Output \$/1M')),
          const Expanded(flex: 2, child: _HeaderCell('Context')),
          if (state.adminEditable)
            const SizedBox(width: 60, child: _HeaderCell('Enabled')),
          if (state.adminEditable) const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildTableRow(ModelCatalogEntry model, CatalogState state) {
    final isDisabled = !model.enabled;
    return Opacity(
      opacity: isDisabled ? 0.45 : 1.0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            // Model ID
            Expanded(
              flex: 5,
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      model.displayName.isNotEmpty
                          ? model.displayName
                          : model.modelId,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: CandelaColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isDisabled) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: CandelaColors.error.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Disabled',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: CandelaColors.error,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Provider badge
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _colorForProvider(model.provider)
                          .withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      model.provider,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _colorForProvider(model.provider),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Category badge
            Expanded(
              flex: 2,
              child: model.category.isNotEmpty
                  ? Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: _categoryColor(model.category)
                                .withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            model.category,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: _categoryColor(model.category),
                            ),
                          ),
                        ),
                      ],
                    )
                  : const Text('—',
                      style: TextStyle(
                          fontSize: 12, color: CandelaColors.textMuted)),
            ),
            // Input price
            Expanded(
              flex: 2,
              child: Text(
                _formatPrice(model.inputPerMillion),
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: 'JetBrains Mono',
                  color: CandelaColors.textSecondary,
                ),
              ),
            ),
            // Output price
            Expanded(
              flex: 2,
              child: Text(
                _formatPrice(model.outputPerMillion),
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: 'JetBrains Mono',
                  color: CandelaColors.textSecondary,
                ),
              ),
            ),
            // Context window
            Expanded(
              flex: 2,
              child: Text(
                _formatContextWindow(model.contextWindow.toInt()),
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: 'JetBrains Mono',
                  color: CandelaColors.textSecondary,
                ),
              ),
            ),
            // Enabled toggle
            if (state.adminEditable)
              SizedBox(
                width: 60,
                child: Switch(
                  value: model.enabled,
                  activeThumbColor: CandelaColors.success,
                  inactiveThumbColor: CandelaColors.textMuted,
                  inactiveTrackColor: CandelaColors.bgTertiary,
                  onChanged: (v) => ref
                      .read(catalogProvider.notifier)
                      .toggleEnabled(model.provider, model.modelId, v),
                ),
              ),
            // Delete button
            if (state.adminEditable)
              SizedBox(
                width: 48,
                child: _IconActionButton(
                  icon: Icons.delete_outline_rounded,
                  tooltip: 'Delete model',
                  iconColor: CandelaColors.error,
                  onTap: () => _confirmDelete(model.provider, model.modelId),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ── Delete confirmation ───────────────────────────────────────────────────

  void _confirmDelete(String provider, String modelId) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: CandelaColors.bgSecondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Delete Model',
          style: TextStyle(color: CandelaColors.textPrimary),
        ),
        content: Text(
          'Permanently delete "$modelId" from the catalog?\n\nThis cannot be undone.',
          style: const TextStyle(color: CandelaColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel',
                style: TextStyle(color: CandelaColors.textMuted)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: CandelaColors.error,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              ref.read(catalogProvider.notifier).deleteEntry(provider, modelId);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // ── Filtering ─────────────────────────────────────────────────────────────

  List<ModelCatalogEntry> _filterModels(List<ModelCatalogEntry> models) {
    var filtered = models;

    if (_selectedProvider != 'All') {
      final provLower = _selectedProvider.toLowerCase();
      filtered =
          filtered.where((m) => m.provider.toLowerCase() == provLower).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      filtered = filtered
          .where((m) =>
              m.modelId.toLowerCase().contains(q) ||
              m.displayName.toLowerCase().contains(q) ||
              m.provider.toLowerCase().contains(q))
          .toList();
    }

    return filtered;
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// Shared widgets
// ═════════════════════════════════════════════════════════════════════════════

class _HeaderCell extends StatelessWidget {
  final String label;
  const _HeaderCell(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: CandelaColors.textMuted,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _IconActionButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final bool loading;
  final Color? iconColor;

  const _IconActionButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.loading = false,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: loading ? null : onTap,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: loading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: CandelaColors.textMuted,
                  ),
                )
              : Icon(icon,
                  size: 18, color: iconColor ?? CandelaColors.textSecondary),
        ),
      ),
    );
  }
}
