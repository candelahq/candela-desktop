import 'package:flutter/material.dart';

import '../../models/budget_info.dart';
import '../../theme/colors.dart';

/// Displays the user's spend waterfall: budget first, then active grants.
///
/// Hidden entirely when [budget] is null (solo/local mode or no budget
/// configured server-side). Grant rows are displayed in earliest-expiry-first
/// order — matching the server's actual deduction order. A display preference
/// pin (stored locally) floats one grant to the top without affecting billing.
class BudgetWaterfallCard extends StatefulWidget {
  final BudgetInfo budget;
  final List<GrantInfo> grants;

  /// Server-computed authoritative total (budget remainder + all grant remainders).
  final double? totalRemainingUsd;

  const BudgetWaterfallCard({
    super.key,
    required this.budget,
    required this.grants,
    this.totalRemainingUsd,
  });

  @override
  State<BudgetWaterfallCard> createState() => _BudgetWaterfallCardState();
}

class _BudgetWaterfallCardState extends State<BudgetWaterfallCard> {
  /// ID of the grant pinned to the top of the display list.
  /// Display-only — does not affect billing deduction order.
  String? _pinnedGrantId;

  List<GrantInfo> get _sortedGrants {
    if (_pinnedGrantId == null) return widget.grants;
    final pinned = widget.grants.where((g) => g.id == _pinnedGrantId).toList();
    final rest = widget.grants.where((g) => g.id != _pinnedGrantId).toList();
    return [...pinned, ...rest];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CandelaColors.bgSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CandelaColors.borderSubtle),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          const SizedBox(height: 12),
          _budgetRow(),
          if (widget.grants.isNotEmpty) ...[
            const SizedBox(height: 12),
            _grantsSection(),
          ],
          const SizedBox(height: 12),
          _footer(),
        ],
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        const Text('💰', style: TextStyle(fontSize: 16)),
        const SizedBox(width: 8),
        const Text(
          'Budget & Grants',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const Spacer(),
        if (widget.grants.isNotEmpty) _pinDropdown(),
      ],
    );
  }

  Widget _pinDropdown() {
    return Tooltip(
      message:
          'Deduction order is automatic (budget first, then soonest-expiring grant).\n'
          'This only changes display order.',
      child: PopupMenuButton<String?>(
        tooltip: '',
        initialValue: _pinnedGrantId,
        onSelected: (id) => setState(() => _pinnedGrantId = id),
        itemBuilder: (context) => [
          const PopupMenuItem<String?>(
            value: null,
            child: Text('Default order (earliest expiry first)'),
          ),
          ...widget.grants.map(
            (g) => PopupMenuItem<String>(
              value: g.id,
              child: Row(
                children: [
                  if (_pinnedGrantId == g.id)
                    const Text('⭐ ', style: TextStyle(fontSize: 12)),
                  Expanded(
                      child: Text(g.displayLabel,
                          overflow: TextOverflow.ellipsis)),
                ],
              ),
            ),
          ),
        ],
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: CandelaColors.bgTertiary,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: CandelaColors.borderSubtle),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _pinnedGrantId != null ? '⭐ Pin' : '⭐ Pin grant',
                style: const TextStyle(
                    fontSize: 11, color: CandelaColors.textSecondary),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_drop_down,
                  size: 14, color: CandelaColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }

  Widget _budgetRow() {
    final b = widget.budget;
    final barColor = b.isExhausted
        ? CandelaColors.error
        : b.isNearLimit
            ? CandelaColors.warning
            : CandelaColors.success;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const SizedBox(
              width: 80,
              child: Text(
                'Daily Budget',
                style:
                    TextStyle(fontSize: 12, color: CandelaColors.textSecondary),
              ),
            ),
            Expanded(
              child: _progressBar(b.usedFraction, barColor),
            ),
            const SizedBox(width: 8),
            Text(
              '\$${b.spentUsd.toStringAsFixed(2)} / \$${b.limitUsd.toStringAsFixed(2)}',
              style: const TextStyle(
                  fontSize: 11,
                  fontFamily: 'SF Mono, monospace',
                  color: CandelaColors.textSecondary),
            ),
            const SizedBox(width: 6),
            Text(
              '${(b.usedFraction * 100).round()}%',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: barColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 88),
          child: Text(
            b.resetLabel,
            style:
                const TextStyle(fontSize: 10, color: CandelaColors.textMuted),
          ),
        ),
      ],
    );
  }

  Widget _grantsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Active Grants',
          style: TextStyle(fontSize: 11, color: CandelaColors.textMuted),
        ),
        const SizedBox(height: 6),
        ..._sortedGrants.map((g) => _grantRow(g)),
      ],
    );
  }

  Widget _grantRow(GrantInfo g) {
    final isPinned = g.id == _pinnedGrantId;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          if (isPinned)
            const Text('⭐ ', style: TextStyle(fontSize: 11))
          else
            const SizedBox(width: 16),
          SizedBox(
            width: 64,
            child: Text(
              g.displayLabel,
              style: const TextStyle(
                  fontSize: 11, color: CandelaColors.textSecondary),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: _progressBar(
              g.usedFraction,
              g.isExhausted ? CandelaColors.error : CandelaColors.accent,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '\$${g.spentUsd.toStringAsFixed(2)} / \$${g.amountUsd.toStringAsFixed(2)}',
            style: const TextStyle(
                fontSize: 11,
                fontFamily: 'SF Mono, monospace',
                color: CandelaColors.textSecondary),
          ),
          if (g.isExpiringSoon) ...[
            const SizedBox(width: 6),
            Tooltip(
              message: g.expiresAt != null
                  ? 'Expires ${_daysLabel(g.expiresAt!)}'
                  : 'Expiring soon',
              child: const Text(
                '⚠',
                style: TextStyle(fontSize: 12, color: CandelaColors.warning),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _footer() {
    final remaining = widget.totalRemainingUsd;
    return Row(
      children: [
        const Spacer(),
        const Text(
          'Total available: ',
          style: TextStyle(fontSize: 11, color: CandelaColors.textMuted),
        ),
        Text(
          remaining != null ? '\$${remaining.toStringAsFixed(2)}' : '—',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            fontFamily: 'SF Mono, monospace',
            color: CandelaColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _progressBar(double fraction, Color color) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: 6,
          decoration: BoxDecoration(
            color: CandelaColors.bgTertiary,
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: fraction.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        );
      },
    );
  }

  String _daysLabel(DateTime dt) {
    final diff = dt.difference(DateTime.now());
    if (diff.inDays > 0) return 'in ${diff.inDays}d';
    if (diff.inHours > 0) return 'in ${diff.inHours}h';
    return 'soon';
  }
}
