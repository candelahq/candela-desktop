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
    if (_pinnedGrantId == null || widget.grants.isEmpty) return widget.grants;
    final grants = List<GrantInfo>.from(widget.grants);
    final index = grants.indexWhere((g) => g.id == _pinnedGrantId);
    if (index != -1) {
      final pinned = grants.removeAt(index);
      grants.insert(0, pinned);
    }
    return grants;
  }

  @override
  void didUpdateWidget(BudgetWaterfallCard old) {
    super.didUpdateWidget(old);
    // Clear stale pin if the pinned grant has expired and been removed.
    if (_pinnedGrantId != null &&
        !widget.grants.any((g) => g.id == _pinnedGrantId)) {
      _pinnedGrantId = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Single clock sample for the entire build — prevents divergence between
    // resetLabel, isExpiringSoon, and _daysLabel when called on the same frame.
    final now = DateTime.now().toUtc();
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
          _budgetRow(now),
          if (widget.grants.isNotEmpty) ...[
            const SizedBox(height: 12),
            _grantsSection(now),
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

  Widget _budgetRow(DateTime now) {
    final b = widget.budget;
    final barColor = b.isExhausted
        ? CandelaColors.error
        : b.isNearLimit
            ? CandelaColors.warning
            : CandelaColors.success;

    // Compute resetLabel with the build-time clock to stay in sync with grants.
    final diff = b.periodEnd.toUtc().difference(now);
    final resetLabel = diff.isNegative
        ? 'resetting'
        : diff.inHours >= 1
            ? 'resets in ${diff.inHours}h ${diff.inMinutes % 60}m'
            : 'resets in ${diff.inMinutes}m';

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
            resetLabel,
            style:
                const TextStyle(fontSize: 10, color: CandelaColors.textMuted),
          ),
        ),
      ],
    );
  }

  Widget _grantsSection(DateTime now) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Active Grants',
          style: TextStyle(fontSize: 11, color: CandelaColors.textMuted),
        ),
        const SizedBox(height: 6),
        ..._sortedGrants.map((g) => _grantRow(g, now)),
      ],
    );
  }

  Widget _grantRow(GrantInfo g, DateTime now) {
    final isPinned = g.id == _pinnedGrantId;
    // Use build-time clock for consistent expiry state.
    final expiringSoon =
        g.expiresAt != null && g.expiresAt!.difference(now).inDays < 7;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
              if (expiringSoon) ...[
                const SizedBox(width: 6),
                Tooltip(
                  message: g.expiresAt != null
                      ? 'Expires ${_daysLabel(g.expiresAt!, now)}'
                      : 'Expiring soon',
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: CandelaColors.warning.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                          color: CandelaColors.warning.withValues(alpha: 0.4)),
                    ),
                    child: const Text(
                      '⚠ expiring',
                      style: TextStyle(
                          fontSize: 9,
                          color: CandelaColors.warning,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 2),
          Padding(
            padding:
                const EdgeInsets.only(left: 80), // aligns with bar (16 + 64)
            child: Text(
              g.grantedBy.isNotEmpty
                  ? 'by ${g.grantedBy}${_expirySubtitle(g, now)}'
                  : g.expiresAt != null
                      ? 'expires ${_daysLabel(g.expiresAt!, now)}'
                      : '',
              style:
                  const TextStyle(fontSize: 10, color: CandelaColors.textMuted),
              overflow: TextOverflow.ellipsis,
            ),
          ),
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
    // No LayoutBuilder needed — FractionallySizedBox derives its own
    // fraction from the Expanded parent, avoiding N+1 layout sub-passes.
    return SizedBox(
      height: 6,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: LinearProgressIndicator(
          value: fraction.clamp(0.0, 1.0),
          backgroundColor: CandelaColors.bgTertiary,
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 6,
        ),
      ),
    );
  }

  String _expirySubtitle(GrantInfo g, DateTime now) {
    if (g.expiresAt == null) return '';
    return ' · expires ${_daysLabel(g.expiresAt!, now)}';
  }

  String _daysLabel(DateTime dt, DateTime now) {
    final diff = dt.difference(now);
    if (diff.inDays > 0) return 'in ${diff.inDays}d';
    if (diff.inHours > 0) return 'in ${diff.inHours}h';
    return 'soon';
  }
}
