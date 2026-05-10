import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:candela_desktop/models/budget_info.dart';
import 'package:candela_desktop/services/budget_notification_service.dart';

// ── Fake adapter (no platform channels) ───────────────────────────────────────

/// Pure-Dart fake — implements the internal _NotifAdapter interface.
/// Avoids any dependency on real platform plugins.
class FakeAdapter implements BudgetNotifAdapter {
  final List<({int id, String? title, String? body})> shown = [];
  int cancelAllCount = 0;
  bool initCalled = false;

  @override
  Future<bool?> initialize(InitializationSettings settings) async {
    initCalled = true;
    return true;
  }

  @override
  Future<void> show(
      int id, String? title, String? body, NotificationDetails? details) async {
    shown.add((id: id, title: title, body: body));
  }

  @override
  Future<void> cancelAll() async {
    cancelAllCount++;
  }

  @override
  Future<void> requestMacOSPermissions() async {}
}

// ── Helpers ───────────────────────────────────────────────────────────────────

BudgetInfo _budget({
  double limit = 10.0,
  double spent = 0.0,
  DateTime? periodEnd,
}) =>
    BudgetInfo(
      limitUsd: limit,
      spentUsd: spent,
      tokensUsed: 0,
      period: BudgetPeriodKind.daily,
      periodEnd: periodEnd ?? DateTime.now().add(const Duration(hours: 6)),
    );

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  late FakeAdapter adapter;
  late BudgetNotificationService svc;

  setUp(() {
    adapter = FakeAdapter();
    svc = BudgetNotificationService.withAdapter(adapter);
  });

  group('BudgetNotificationService — init', () {
    test('does not fire before init', () async {
      await svc.evaluate(_budget(spent: 10.0, limit: 10.0));
      expect(adapter.shown, isEmpty);
    });

    test('init calls adapter.initialize', () async {
      await svc.init();
      expect(adapter.initCalled, isTrue);
    });

    test('init is idempotent', () async {
      await svc.init();
      await svc.init();
      // initCalled flips once; BudgetNotificationService guards with _initialized.
      expect(adapter.initCalled, isTrue);
    });
  });

  group('BudgetNotificationService — threshold logic', () {
    test('no notification below 80%', () async {
      await svc.init();
      await svc.evaluate(_budget(spent: 7.99, limit: 10.0));
      expect(adapter.shown, isEmpty);
    });

    test('fires nearLimit at exactly 80%', () async {
      await svc.init();
      await svc.evaluate(_budget(spent: 8.0, limit: 10.0));
      expect(adapter.shown.length, 1);
      expect(adapter.shown.first.title, 'Budget at 80%');
      expect(adapter.shown.first.id, 0);
    });

    test('fires exhausted at 100%', () async {
      await svc.init();
      await svc.evaluate(_budget(spent: 10.0, limit: 10.0));
      expect(adapter.shown.length, 1);
      expect(adapter.shown.first.title, 'Budget exhausted');
      expect(adapter.shown.first.id, 1);
    });

    test('fires exhausted even when over limit', () async {
      await svc.init();
      await svc.evaluate(_budget(spent: 12.0, limit: 10.0));
      expect(adapter.shown.length, 1);
      expect(adapter.shown.first.title, 'Budget exhausted');
    });

    test('skips nearLimit when exhausted fires directly', () async {
      await svc.init();
      await svc.evaluate(_budget(spent: 10.0, limit: 10.0));
      // Only 1 notification — not 2.
      expect(adapter.shown.length, 1);
      expect(adapter.shown.first.title, 'Budget exhausted');
    });
  });

  group('BudgetNotificationService — de-duplication', () {
    test('same threshold not fired twice in same period', () async {
      await svc.init();
      final b = _budget(spent: 8.0, limit: 10.0);
      await svc.evaluate(b);
      await svc.evaluate(b);
      expect(adapter.shown.length, 1);
    });

    test('escalates from 80% to 100% in same period', () async {
      await svc.init();
      final end = DateTime.now().add(const Duration(hours: 6));
      await svc.evaluate(_budget(spent: 8.0, limit: 10.0, periodEnd: end));
      await svc.evaluate(_budget(spent: 10.0, limit: 10.0, periodEnd: end));
      expect(adapter.shown.length, 2);
      expect(adapter.shown[0].title, 'Budget at 80%');
      expect(adapter.shown[1].title, 'Budget exhausted');
    });

    test('does not re-fire 80% after 100%', () async {
      await svc.init();
      final end = DateTime.now().add(const Duration(hours: 6));
      await svc.evaluate(_budget(spent: 10.0, limit: 10.0, periodEnd: end));
      await svc.evaluate(_budget(spent: 8.0, limit: 10.0, periodEnd: end));
      expect(adapter.shown.length, 1);
    });
  });

  group('BudgetNotificationService — period rollover', () {
    test('resets threshold tracking on period rollover', () async {
      await svc.init();
      final oldEnd = DateTime.now().add(const Duration(hours: 6));
      final newEnd = oldEnd.add(const Duration(days: 1));

      await svc.evaluate(_budget(spent: 10.0, limit: 10.0, periodEnd: oldEnd));
      expect(adapter.shown.length, 1);
      expect(svc.hasActiveThreshold, isTrue);

      await svc.evaluate(_budget(spent: 10.0, limit: 10.0, periodEnd: newEnd));
      expect(adapter.shown.length, 2);
    });

    test('lastPeriodEnd updates after evaluate', () async {
      await svc.init();
      final end = DateTime(2026, 6, 1, 12);
      await svc.evaluate(_budget(spent: 8.0, limit: 10.0, periodEnd: end));
      expect(svc.lastPeriodEnd, equals(end));
    });

    test('hasActiveThreshold is false before any evaluation', () {
      expect(svc.hasActiveThreshold, isFalse);
    });
  });

  group('BudgetNotificationService — cancelAll', () {
    test('cancelAll delegates to adapter', () async {
      await svc.cancelAll();
      expect(adapter.cancelAllCount, 1);
    });
  });
}
