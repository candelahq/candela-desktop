import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/models/budget_info.dart';

void main() {
  group('BudgetInfo', () {
    test('remainingUsd is limit minus spent', () {
      final b = BudgetInfo(
        limitUsd: 10.0,
        spentUsd: 3.5,
        tokensUsed: 1000,
        period: BudgetPeriodKind.daily,
        periodEnd: DateTime.now().add(const Duration(hours: 12)),
      );
      expect(b.remainingUsd, closeTo(6.5, 0.001));
    });

    test('remainingUsd is floored at 0 when overspent', () {
      final b = BudgetInfo(
        limitUsd: 5.0,
        spentUsd: 7.0,
        tokensUsed: 2000,
        period: BudgetPeriodKind.daily,
        periodEnd: DateTime.now().add(const Duration(hours: 6)),
      );
      expect(b.remainingUsd, 0.0);
    });

    test('usedFraction clamped at 1.0 when over budget', () {
      final b = BudgetInfo(
        limitUsd: 5.0,
        spentUsd: 9.0,
        tokensUsed: 3000,
        period: BudgetPeriodKind.daily,
        periodEnd: DateTime.now().add(const Duration(hours: 1)),
      );
      expect(b.usedFraction, 1.0);
    });

    test('usedFraction is 0.0 when limitUsd is zero', () {
      final b = BudgetInfo(
        limitUsd: 0.0,
        spentUsd: 0.0,
        tokensUsed: 0,
        period: BudgetPeriodKind.daily,
        periodEnd: DateTime.now().add(const Duration(hours: 12)),
      );
      expect(b.usedFraction, 0.0);
    });

    test('isNearLimit triggers at exactly 80%', () {
      final b = BudgetInfo(
        limitUsd: 10.0,
        spentUsd: 8.0, // 80%
        tokensUsed: 0,
        period: BudgetPeriodKind.daily,
        periodEnd: DateTime.now().add(const Duration(hours: 4)),
      );
      expect(b.isNearLimit, isTrue);
    });

    test('isNearLimit is false below 80%', () {
      final b = BudgetInfo(
        limitUsd: 10.0,
        spentUsd: 7.99,
        tokensUsed: 0,
        period: BudgetPeriodKind.daily,
        periodEnd: DateTime.now().add(const Duration(hours: 4)),
      );
      expect(b.isNearLimit, isFalse);
    });

    test('isExhausted when spent >= limit', () {
      final b = BudgetInfo(
        limitUsd: 10.0,
        spentUsd: 10.0,
        tokensUsed: 0,
        period: BudgetPeriodKind.daily,
        periodEnd: DateTime.now().add(const Duration(hours: 2)),
      );
      expect(b.isExhausted, isTrue);
    });

    test('isExhausted is false when partially spent', () {
      final b = BudgetInfo(
        limitUsd: 10.0,
        spentUsd: 9.99,
        tokensUsed: 0,
        period: BudgetPeriodKind.daily,
        periodEnd: DateTime.now().add(const Duration(hours: 2)),
      );
      expect(b.isExhausted, isFalse);
    });

    test('resetLabel contains hours when > 1h remaining', () {
      final b = BudgetInfo(
        limitUsd: 10.0,
        spentUsd: 0.0,
        tokensUsed: 0,
        period: BudgetPeriodKind.daily,
        periodEnd:
            DateTime.now().toUtc().add(const Duration(hours: 6, minutes: 30)),
      );
      expect(b.resetLabel, contains('6h'));
    });

    test('resetLabel shows minutes when < 1h remaining', () {
      final b = BudgetInfo(
        limitUsd: 10.0,
        spentUsd: 0.0,
        tokensUsed: 0,
        period: BudgetPeriodKind.daily,
        periodEnd: DateTime.now().toUtc().add(const Duration(minutes: 45)),
      );
      // May be 44m or 45m depending on clock — just verify format contains a digit + m.
      expect(b.resetLabel, matches(RegExp(r'resets in \d+m')));
    });
  });

  group('GrantInfo', () {
    test('remainingUsd is amount minus spent', () {
      final g = GrantInfo(
        id: 'g1',
        amountUsd: 25.0,
        spentUsd: 4.0,
        reason: 'Onboarding',
        grantedBy: 'admin@example.com',
        expiresAt: DateTime.now().add(const Duration(days: 30)),
      );
      expect(g.remainingUsd, closeTo(21.0, 0.001));
    });

    test('remainingUsd is floored at 0 when fully consumed', () {
      final g = const GrantInfo(
        id: 'g2',
        amountUsd: 10.0,
        spentUsd: 12.0,
        reason: 'Beta bonus',
        grantedBy: 'admin@example.com',
      );
      expect(g.remainingUsd, 0.0);
    });

    test('usedFraction is clamped at 1.0', () {
      final g = const GrantInfo(
        id: 'g3',
        amountUsd: 5.0,
        spentUsd: 7.0,
        reason: 'Test',
        grantedBy: 'admin@example.com',
      );
      expect(g.usedFraction, 1.0);
    });

    test('isExpiringSoon is true when < 7 days', () {
      final g = GrantInfo(
        id: 'g4',
        amountUsd: 20.0,
        spentUsd: 0.0,
        reason: 'Expiring',
        grantedBy: 'admin@example.com',
        expiresAt: DateTime.now().add(const Duration(days: 3)),
      );
      expect(g.isExpiringSoon, isTrue);
    });

    test('isExpiringSoon is false when >= 7 days', () {
      final g = GrantInfo(
        id: 'g5',
        amountUsd: 20.0,
        spentUsd: 0.0,
        reason: 'Long-lived',
        grantedBy: 'admin@example.com',
        expiresAt: DateTime.now().add(const Duration(days: 30)),
      );
      expect(g.isExpiringSoon, isFalse);
    });

    test('isExpiringSoon is false when expiresAt is null', () {
      final g = const GrantInfo(
        id: 'g6',
        amountUsd: 50.0,
        spentUsd: 0.0,
        reason: 'Permanent',
        grantedBy: 'admin@example.com',
      );
      expect(g.isExpiringSoon, isFalse);
    });

    test('isExhausted when spent >= amount', () {
      final g = const GrantInfo(
        id: 'g7',
        amountUsd: 10.0,
        spentUsd: 10.0,
        reason: 'Used up',
        grantedBy: 'admin@example.com',
      );
      expect(g.isExhausted, isTrue);
    });

    test('displayLabel falls back to Grant when reason is empty', () {
      final g = const GrantInfo(
        id: 'g8',
        amountUsd: 10.0,
        spentUsd: 0.0,
        reason: '',
        grantedBy: 'admin@example.com',
      );
      expect(g.displayLabel, 'Grant');
    });

    test('displayLabel uses reason when set', () {
      final g = const GrantInfo(
        id: 'g9',
        amountUsd: 10.0,
        spentUsd: 0.0,
        reason: 'Hackathon prize',
        grantedBy: 'admin@example.com',
      );
      expect(g.displayLabel, 'Hackathon prize');
    });
  });
}
