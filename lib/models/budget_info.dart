/// Value objects for budget and grant data returned by GetMyUsage.
///
/// These are pure Dart — no Flutter dependency — making them trivially
/// unit-testable without a widget harness.
library;

// ── Budget ────────────────────────────────────────────────────────────────────

/// The period recurrence of a user budget.
enum BudgetPeriodKind { daily }

/// Snapshot of a user's recurring budget for the current period.
class BudgetInfo {
  const BudgetInfo({
    required this.limitUsd,
    required this.spentUsd,
    required this.tokensUsed,
    required this.period,
    required this.periodEnd,
  });

  /// Maximum spend allowed this period.
  final double limitUsd;

  /// Accumulated spend charged to the budget (grant overflow is not counted here).
  final double spentUsd;

  /// Tokens counted against the budget this period.
  final int tokensUsed;

  final BudgetPeriodKind period;

  /// When this period resets (UTC).
  final DateTime periodEnd;

  /// Remaining budget, floored at $0 (can never go negative in the UI).
  double get remainingUsd => (limitUsd - spentUsd).clamp(0.0, double.infinity);

  /// 0.0–1.0 fraction of budget consumed, clamped.
  double get usedFraction =>
      limitUsd > 0 ? (spentUsd / limitUsd).clamp(0.0, 1.0) : 0.0;

  /// True once spend reaches 80% of limit — triggers orange indicator.
  bool get isNearLimit => usedFraction >= 0.8;

  /// True when the budget is fully consumed.
  bool get isExhausted => spentUsd >= limitUsd;

  /// Human-readable time until period reset.
  String get resetLabel {
    final diff = periodEnd.toUtc().difference(DateTime.now().toUtc());
    if (diff.isNegative) return 'resetting';
    if (diff.inHours >= 1) {
      return 'resets in ${diff.inHours}h ${diff.inMinutes % 60}m';
    }
    return 'resets in ${diff.inMinutes}m';
  }
}

// ── Grant ─────────────────────────────────────────────────────────────────────

/// A one-time bonus budget grant.
class GrantInfo {
  const GrantInfo({
    required this.id,
    required this.amountUsd,
    required this.spentUsd,
    required this.reason,
    required this.grantedBy,
    this.expiresAt,
  });

  final String id;

  /// Total grant amount.
  final double amountUsd;

  /// How much of this grant has been consumed.
  final double spentUsd;

  /// Human-readable reason for the grant (e.g. "Onboarding bonus").
  final String reason;

  /// Admin email that issued the grant.
  final String grantedBy;

  /// When this grant expires (null = no expiry).
  final DateTime? expiresAt;

  /// Remaining grant balance, floored at $0.
  double get remainingUsd => (amountUsd - spentUsd).clamp(0.0, double.infinity);

  /// 0.0–1.0 fraction consumed, clamped.
  double get usedFraction =>
      amountUsd > 0 ? (spentUsd / amountUsd).clamp(0.0, 1.0) : 0.0;

  /// True when the grant expires within 7 days — triggers expiry warning.
  bool get isExpiringSoon {
    if (expiresAt == null) return false;
    return expiresAt!.difference(DateTime.now()).inDays < 7;
  }

  /// True when the grant is fully consumed.
  bool get isExhausted => spentUsd >= amountUsd;

  /// Human-readable label combining reason + expiry.
  String get displayLabel => reason.isNotEmpty ? reason : 'Grant';
}
