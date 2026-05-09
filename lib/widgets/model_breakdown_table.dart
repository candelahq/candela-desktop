import 'package:flutter/material.dart';
import '../models/span_stats.dart';
import '../theme/colors.dart';

/// Sortable per-model cost + token breakdown table.
class ModelBreakdownTable extends StatefulWidget {
  final List<ModelBreakdown> models;

  const ModelBreakdownTable({super.key, required this.models});

  @override
  State<ModelBreakdownTable> createState() => _ModelBreakdownTableState();
}

enum _SortCol { cost, calls, tokens, latency }

class _ModelBreakdownTableState extends State<ModelBreakdownTable> {
  _SortCol _sortCol = _SortCol.cost;
  bool _ascending = false;

  List<ModelBreakdown> get _sorted {
    final list = List.of(widget.models);
    list.sort((a, b) {
      int cmp;
      switch (_sortCol) {
        case _SortCol.cost:
          cmp = a.costUsd.compareTo(b.costUsd);
        case _SortCol.calls:
          cmp = a.callCount.compareTo(b.callCount);
        case _SortCol.tokens:
          cmp = a.totalTokens.compareTo(b.totalTokens);
        case _SortCol.latency:
          cmp = a.avgLatencyMs.compareTo(b.avgLatencyMs);
      }
      return _ascending ? cmp : -cmp;
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final sorted = _sorted;
    if (sorted.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
          color: CandelaColors.bgSecondary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: CandelaColors.border),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('💰', style: TextStyle(fontSize: 36)),
            SizedBox(height: 12),
            Text(
              'No model data yet',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: CandelaColors.textPrimary),
            ),
            SizedBox(height: 6),
            Text(
              'Model breakdowns appear once LLM calls flow through the proxy.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: CandelaColors.textMuted),
            ),
          ],
        ),
      );
    }

    final maxCost =
        sorted.map((m) => m.costUsd).reduce((a, b) => a > b ? a : b);

    return Container(
      decoration: BoxDecoration(
        color: CandelaColors.bgSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CandelaColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Table header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              children: [
                const Text(
                  'Cost by Model',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: CandelaColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: CandelaColors.bgTertiary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${sorted.length} model${sorted.length != 1 ? 's' : ''}',
                    style: const TextStyle(
                        fontSize: 10, color: CandelaColors.textMuted),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: CandelaColors.border),

          // Column headings
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                const Expanded(flex: 3, child: SizedBox()),
                _ColHeader('Calls', _SortCol.calls, _sortCol, _ascending,
                    (c) => _setSort(c)),
                _ColHeader('Input', null, _sortCol, _ascending, null),
                _ColHeader('Output', null, _sortCol, _ascending, null),
                _ColHeader('Cost', _SortCol.cost, _sortCol, _ascending,
                    (c) => _setSort(c)),
                _ColHeader('Latency', _SortCol.latency, _sortCol, _ascending,
                    (c) => _setSort(c)),
                const SizedBox(width: 100),
              ],
            ),
          ),
          const Divider(height: 1, color: CandelaColors.border),

          // Rows
          ...sorted.map((m) => _ModelRow(m: m, maxCost: maxCost)),
        ],
      ),
    );
  }

  void _setSort(_SortCol col) {
    setState(() {
      if (_sortCol == col) {
        _ascending = !_ascending;
      } else {
        _sortCol = col;
        _ascending = false;
      }
    });
  }
}

class _ColHeader extends StatelessWidget {
  final String label;
  final _SortCol? col;
  final _SortCol activeCol;
  final bool ascending;
  final void Function(_SortCol)? onSort;

  const _ColHeader(
      this.label, this.col, this.activeCol, this.ascending, this.onSort);

  @override
  Widget build(BuildContext context) {
    final isActive = col != null && col == activeCol;
    return Expanded(
      child: GestureDetector(
        onTap: col != null && onSort != null ? () => onSort!(col!) : null,
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color:
                    isActive ? CandelaColors.accent : CandelaColors.textMuted,
                letterSpacing: 0.4,
              ),
            ),
            if (isActive) ...[
              const SizedBox(width: 3),
              Icon(
                ascending ? Icons.arrow_upward : Icons.arrow_downward,
                size: 10,
                color: CandelaColors.accent,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ModelRow extends StatefulWidget {
  final ModelBreakdown m;
  final double maxCost;
  const _ModelRow({required this.m, required this.maxCost});

  @override
  State<_ModelRow> createState() => _ModelRowState();
}

class _ModelRowState extends State<_ModelRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final m = widget.m;
    final barPct = widget.maxCost > 0 ? (m.costUsd / widget.maxCost) : 0.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        color: _hovered ? CandelaColors.bgTertiary : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
        child: Row(
          children: [
            // Model + provider
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    m.model,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    m.provider,
                    style: const TextStyle(
                        fontSize: 10, color: CandelaColors.textMuted),
                  ),
                ],
              ),
            ),
            // Calls
            Expanded(
              child: Text(
                _fmt(m.callCount.toDouble(), isCount: true),
                style: _mono,
              ),
            ),
            // Input tokens
            Expanded(
              child: Text(_fmtTokens(m.inputTokens), style: _mono),
            ),
            // Output tokens
            Expanded(
              child: Text(_fmtTokens(m.outputTokens), style: _mono),
            ),
            // Cost
            Expanded(
              child: Text(
                '\$${m.costUsd.toStringAsFixed(4)}',
                style: _mono.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            // Latency
            Expanded(
              child: Text(
                '${m.avgLatencyMs.toStringAsFixed(0)}ms',
                style: _mono,
              ),
            ),
            // Cost bar
            SizedBox(
              width: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: barPct,
                  minHeight: 6,
                  backgroundColor: CandelaColors.bgTertiary,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    CandelaColors.accent.withAlpha(200),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const _mono = TextStyle(
    fontFamily: 'monospace',
    fontSize: 12,
    color: Colors.white70,
  );

  String _fmt(double v, {bool isCount = false}) {
    if (isCount) return v.toInt().toString();
    if (v >= 1e6) return '${(v / 1e6).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}k';
    return v.toStringAsFixed(0);
  }

  String _fmtTokens(int v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}k';
    return v.toString();
  }
}
