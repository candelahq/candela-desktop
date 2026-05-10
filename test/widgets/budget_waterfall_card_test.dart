import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:candela_desktop/models/budget_info.dart';
import 'package:candela_desktop/widgets/budget_waterfall_card.dart';
import 'package:candela_desktop/theme/candela_theme.dart';

Widget buildApp({
  required BudgetInfo budget,
  List<GrantInfo> grants = const [],
  double? totalRemainingUsd,
}) {
  return MaterialApp(
    theme: CandelaTheme.dark,
    home: Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BudgetWaterfallCard(
            budget: budget,
            grants: grants,
            totalRemainingUsd: totalRemainingUsd,
          ),
        ),
      ),
    ),
  );
}

BudgetInfo makeBudget({
  double limit = 10.0,
  double spent = 4.0,
  int tokens = 1000,
  DateTime? periodEnd,
}) =>
    BudgetInfo(
      limitUsd: limit,
      spentUsd: spent,
      tokensUsed: tokens,
      period: BudgetPeriodKind.daily,
      periodEnd: periodEnd ?? DateTime.now().add(const Duration(hours: 6)),
    );

GrantInfo makeGrant({
  String id = 'g1',
  double amount = 25.0,
  double spent = 2.0,
  String reason = 'Onboarding bonus',
  String grantedBy = 'admin@example.com',
  DateTime? expiresAt,
}) =>
    GrantInfo(
      id: id,
      amountUsd: amount,
      spentUsd: spent,
      reason: reason,
      grantedBy: grantedBy,
      expiresAt: expiresAt ?? DateTime.now().add(const Duration(days: 30)),
    );

void main() {
  group('BudgetWaterfallCard', () {
    testWidgets('shows Budget & Grants header', (tester) async {
      await tester.pumpWidget(buildApp(budget: makeBudget()));
      expect(find.text('Budget & Grants'), findsOneWidget);
    });

    testWidgets('shows Daily Budget label', (tester) async {
      await tester.pumpWidget(buildApp(budget: makeBudget()));
      expect(find.text('Daily Budget'), findsOneWidget);
    });

    testWidgets('shows spend / limit amounts', (tester) async {
      await tester
          .pumpWidget(buildApp(budget: makeBudget(spent: 4.0, limit: 10.0)));
      expect(find.textContaining('\$4.00 / \$10.00'), findsOneWidget);
    });

    testWidgets('shows usage percentage', (tester) async {
      await tester
          .pumpWidget(buildApp(budget: makeBudget(spent: 8.0, limit: 10.0)));
      expect(find.text('80%'), findsOneWidget);
    });

    testWidgets('shows reset countdown label', (tester) async {
      await tester.pumpWidget(buildApp(budget: makeBudget()));
      // Should show some form of "resets in Xh" or "resets in Xm"
      expect(find.textContaining('resets'), findsOneWidget);
    });

    testWidgets('shows total available footer', (tester) async {
      await tester
          .pumpWidget(buildApp(budget: makeBudget(), totalRemainingUsd: 31.50));
      expect(find.textContaining('\$31.50'), findsOneWidget);
    });

    testWidgets('shows dash when totalRemainingUsd is null', (tester) async {
      await tester.pumpWidget(buildApp(budget: makeBudget()));
      expect(find.text('—'), findsOneWidget);
    });

    testWidgets('shows Active Grants section when grants are present',
        (tester) async {
      await tester
          .pumpWidget(buildApp(budget: makeBudget(), grants: [makeGrant()]));
      expect(find.text('Active Grants'), findsOneWidget);
    });

    testWidgets('shows grant reason text', (tester) async {
      await tester.pumpWidget(buildApp(
          budget: makeBudget(),
          grants: [makeGrant(reason: 'Onboarding bonus')]));
      expect(find.textContaining('Onboarding'), findsOneWidget);
    });

    testWidgets('shows grant spend/amount', (tester) async {
      await tester.pumpWidget(buildApp(
          budget: makeBudget(), grants: [makeGrant(amount: 25.0, spent: 2.0)]));
      expect(find.textContaining('\$2.00 / \$25.00'), findsOneWidget);
    });

    testWidgets('shows expiry warning ⚠ for soon-expiring grant',
        (tester) async {
      final soonGrant =
          makeGrant(expiresAt: DateTime.now().add(const Duration(days: 2)));
      await tester
          .pumpWidget(buildApp(budget: makeBudget(), grants: [soonGrant]));
      expect(find.text('⚠'), findsOneWidget);
    });

    testWidgets('does not show ⚠ for grant expiring far away', (tester) async {
      final farGrant =
          makeGrant(expiresAt: DateTime.now().add(const Duration(days: 60)));
      await tester
          .pumpWidget(buildApp(budget: makeBudget(), grants: [farGrant]));
      expect(find.text('⚠'), findsNothing);
    });

    testWidgets('shows no Active Grants section when grants list is empty',
        (tester) async {
      await tester.pumpWidget(buildApp(budget: makeBudget(), grants: []));
      expect(find.text('Active Grants'), findsNothing);
    });

    testWidgets('pin dropdown is present when grants exist', (tester) async {
      await tester
          .pumpWidget(buildApp(budget: makeBudget(), grants: [makeGrant()]));
      expect(find.textContaining('Pin'), findsOneWidget);
    });

    testWidgets('no pin dropdown when grants are empty', (tester) async {
      await tester.pumpWidget(buildApp(budget: makeBudget(), grants: []));
      expect(find.textContaining('Pin'), findsNothing);
    });

    testWidgets('multiple grants all render', (tester) async {
      await tester.pumpWidget(buildApp(
        budget: makeBudget(),
        grants: [
          makeGrant(id: 'g1', reason: 'Onboarding'),
          makeGrant(id: 'g2', reason: 'Beta bonus'),
        ],
      ));
      expect(find.textContaining('Onboarding'), findsOneWidget);
      expect(find.textContaining('Beta'), findsOneWidget);
    });
  });
}
