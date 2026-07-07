import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications_windows/flutter_local_notifications_windows.dart';

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

  /// Initialize Windows notifications. No-op on other platforms.
  Future<void> initializeWindows(WindowsInitializationSettings settings);

  /// Show a Windows-native notification. No-op on other platforms.
  Future<void> showWindows(
      int id, String? title, String? body, WindowsNotificationDetails? details);
}

/// Production adapter — wraps the real FlutterLocalNotificationsPlugin
/// and Windows-specific plugin.
class _RealAdapter implements BudgetNotifAdapter {
  final FlutterLocalNotificationsPlugin _p;
  FlutterLocalNotificationsWindows? _windowsPlugin;
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

  @override
  Future<void> initializeWindows(WindowsInitializationSettings settings) async {
    _windowsPlugin = FlutterLocalNotificationsWindows();
    await _windowsPlugin!.initialize(settings);
  }

  @override
  Future<void> showWindows(int id, String? title, String? body,
      WindowsNotificationDetails? details) async {
    await _windowsPlugin?.show(id, title, body, details: details);
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
  ///
  /// Supports macOS, Linux, and Windows. On Windows, uses the dedicated
  /// `flutter_local_notifications_windows` plugin directly since the main
  /// plugin's InitializationSettings doesn't include Windows yet.
  ///
  /// Note: On Windows, `cancelAll()` may silently fail without MSIX
  /// packaging (no package identity), but `show()` works without it.
  Future<void> init() async {
    if (_initialized) return;

    if (Platform.isWindows) {
      const windowsSettings = WindowsInitializationSettings(
        appName: 'Candela Desktop',
        appUserModelId: 'com.candelahq.candela-desktop',
        guid: 'd3b07384-d113-4ec8-9d0b-0e8f6d2c5a3b',
      );
      await _adapter.initializeWindows(windowsSettings);
    } else {
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
    }

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
    if (Platform.isWindows) {
      const windowsDetails = WindowsNotificationDetails(
        subtitle: 'Candela Budget Alert',
      );
      await _adapter.showWindows(
          threshold.index, threshold.title, threshold.body, windowsDetails);
    } else {
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
    }

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
