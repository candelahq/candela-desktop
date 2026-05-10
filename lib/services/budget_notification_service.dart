import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../models/budget_info.dart';

// ── Threshold definitions ─────────────────────────────────────────────────────

/// Spend fraction thresholds that trigger a notification.
/// Only fires once per crossing to prevent repeated alerts on each poll cycle.
enum _BudgetThreshold {
  nearLimit(0.8, 'Budget at 80%', 'You have used 80% of your daily budget.'),
  exhausted(1.0, 'Budget exhausted', 'Your daily budget is fully used.');

  const _BudgetThreshold(this.fraction, this.title, this.body);
  final double fraction;
  final String title;
  final String body;
}

// ── Thin testable adapter ─────────────────────────────────────────────────────

/// Adapter interface for the notification plugin.
/// Exposed so tests can inject a pure-Dart fake without platform channel deps.
abstract interface class BudgetNotifAdapter {
  Future<bool?> initialize(InitializationSettings settings);
  Future<void> show(
      int id, String? title, String? body, NotificationDetails? details);
  Future<void> cancelAll();

  /// Request macOS notification permissions. No-op on other platforms.
  Future<void> requestMacOSPermissions();
}

/// Production adapter — wraps the real FlutterLocalNotificationsPlugin.
class _RealAdapter implements BudgetNotifAdapter {
  final FlutterLocalNotificationsPlugin _p;
  _RealAdapter(this._p);

  @override
  Future<bool?> initialize(InitializationSettings s) => _p.initialize(s);

  @override
  Future<void> show(
          int id, String? title, String? body, NotificationDetails? details) =>
      _p.show(id, title, body, details);

  @override
  Future<void> cancelAll() => _p.cancelAll();

  @override
  Future<void> requestMacOSPermissions() async {
    await _p
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: false, sound: false);
  }
}

// ── Service ───────────────────────────────────────────────────────────────────

/// Manages desktop system notifications for budget thresholds.
///
/// **De-duplication**: Each threshold (80%, 100%) fires at most once per budget
/// period. The service tracks the last notified threshold and only emits
/// a notification when the threshold is newly crossed upward.
///
/// **Display-only**: This service never influences billing or deduction order.
///
/// Inject [adapter] in tests to avoid real platform channel calls.
class BudgetNotificationService {
  final BudgetNotifAdapter _adapter;
  bool _initialized = false;

  /// Tracks the highest threshold fired for the current budget period.
  /// Reset to null when the period resets (spentUsd drops back near zero).
  _BudgetThreshold? _lastFiredThreshold;

  /// The `period_end` timestamp of the period for which we last fired.
  /// Used to detect period rollover and reset _lastFiredThreshold.
  DateTime? _lastPeriodEnd;

  BudgetNotificationService({BudgetNotifAdapter? adapter})
      : _adapter = adapter ?? _RealAdapter(FlutterLocalNotificationsPlugin());

  /// Named constructor for test injection.
  BudgetNotificationService.withAdapter(BudgetNotifAdapter adapter)
      : _adapter = adapter;

  /// Initialize the notification plugin. Safe to call multiple times.
  Future<void> init() async {
    if (_initialized) return;

    // macOS: request permission to show banners.
    if (Platform.isMacOS) {
      await _adapter.requestMacOSPermissions();
    }

    const initSettings = InitializationSettings(
      macOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
      linux: LinuxInitializationSettings(defaultActionName: 'Open Candela'),
    );

    await _adapter.initialize(initSettings);
    _initialized = true;
    debugPrint('[BudgetNotificationService] initialized');
  }

  /// Evaluate [budget] and fire a notification if a threshold is newly crossed.
  ///
  /// Call this on each telemetry poll cycle. Idempotent within a period.
  Future<void> evaluate(BudgetInfo budget) async {
    if (!_initialized) return;

    // Detect period rollover — reset threshold tracking.
    if (_lastPeriodEnd != null && budget.periodEnd != _lastPeriodEnd) {
      _lastFiredThreshold = null;
    }
    _lastPeriodEnd = budget.periodEnd;

    // Walk thresholds from highest to lowest; fire the highest newly crossed.
    for (final threshold in _BudgetThreshold.values.reversed) {
      if (budget.usedFraction >= threshold.fraction &&
          (_lastFiredThreshold == null ||
              _lastFiredThreshold!.fraction < threshold.fraction)) {
        await _fire(threshold, budget);
        _lastFiredThreshold = threshold;
        return; // One notification per poll cycle.
      }
    }
  }

  Future<void> _fire(_BudgetThreshold threshold, BudgetInfo budget) async {
    const details = NotificationDetails(
      macOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: false,
        presentSound: false,
        subtitle: 'Candela Budget Alert',
      ),
      linux: LinuxNotificationDetails(
        urgency: LinuxNotificationUrgency.normal,
      ),
    );

    await _adapter.show(
        threshold.index, threshold.title, threshold.body, details);

    debugPrint('[BudgetNotificationService] fired: ${threshold.name} '
        '(${(budget.usedFraction * 100).round()}% used)');
  }

  /// Cancel all pending budget notifications (e.g., on sign-out).
  Future<void> cancelAll() => _adapter.cancelAll();

  /// Expose whether any threshold has been fired (for testing).
  @visibleForTesting
  bool get hasActiveThreshold => _lastFiredThreshold != null;

  @visibleForTesting
  DateTime? get lastPeriodEnd => _lastPeriodEnd;
}
