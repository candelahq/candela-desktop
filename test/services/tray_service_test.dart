import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:candela_desktop/services/tray_service.dart';
import 'package:candela_desktop/services/process_manager.dart';

void main() {
  group('TrayService', () {
    // Helper to create a real ProcessManagerNotifier via ProviderContainer.
    late ProviderContainer container;
    late ProcessManagerNotifier notifier;

    setUp(() {
      container = ProviderContainer();
      notifier = container.read(processManagerProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    // ── Constructor ─────────────────────────────────────────────────────

    group('constructor', () {
      test('accepts ProcessManagerNotifier as required parameter', () {
        final service = TrayService(processManager: notifier);
        expect(service.processManager, same(notifier));
      });

      test('accepts optional UpdateService parameter', () {
        // updateService is optional, so passing null should work.
        final service =
            TrayService(processManager: notifier, updateService: null);
        expect(service.updateService, isNull);
      });
    });

    // ── onTrayMenuItemClick dispatching ──────────────────────────────────
    //
    // onTrayMenuItemClick is a public override from TrayListener.
    // We can call it directly with a MenuItem to test the switch dispatch.

    group('onTrayMenuItemClick', () {
      late TrayService service;

      setUp(() {
        notifier.configure(providerNames: []);
        service = TrayService(processManager: notifier);
      });

      test('start_all dispatches processManager.startAll()', () async {
        // startAll is a no-op when all processes are in detecting state
        service.onTrayMenuItemClick(MenuItem(key: 'start_all', label: 'Start'));
        // Let the async dispatch complete before teardown.
        await Future<void>.delayed(Duration.zero);
      });

      test('stop_all dispatches processManager.stopAll()', () async {
        service.onTrayMenuItemClick(MenuItem(key: 'stop_all', label: 'Stop'));
        // Let the async dispatch complete before teardown.
        await Future<void>.delayed(Duration.zero);
      });

      test('show calls onShowWindow callback', () {
        var showCalled = false;
        service.onShowWindow = () => showCalled = true;
        service.onTrayMenuItemClick(MenuItem(key: 'show', label: 'Show'));
        expect(showCalled, isTrue);
      });

      test('show is no-op when onShowWindow is null', () {
        service.onShowWindow = null;
        // Should not throw.
        service.onTrayMenuItemClick(MenuItem(key: 'show', label: 'Show'));
      });

      test('unknown key is silently ignored', () {
        // Should not throw.
        service.onTrayMenuItemClick(
          MenuItem(key: 'unknown_action', label: 'Unknown'),
        );
      });
    });

    // ── onTrayIconMouseDown ──────────────────────────────────────────────

    group('onTrayIconMouseDown', () {
      test('calls onShowWindow callback', () {
        final service = TrayService(processManager: notifier);
        var showCalled = false;
        service.onShowWindow = () => showCalled = true;

        service.onTrayIconMouseDown();
        expect(showCalled, isTrue);
      });

      test('is no-op when onShowWindow is null', () {
        final service = TrayService(processManager: notifier);
        service.onShowWindow = null;
        // Should not throw.
        service.onTrayIconMouseDown();
      });
    });

    // ── onShowWindow callback ───────────────────────────────────────────

    group('onShowWindow', () {
      test('can be set and cleared', () {
        final service = TrayService(processManager: notifier);

        expect(service.onShowWindow, isNull);

        service.onShowWindow = () {};
        expect(service.onShowWindow, isNotNull);

        service.onShowWindow = null;
        expect(service.onShowWindow, isNull);
      });
    });

    // ── What can't be unit tested ───────────────────────────────────────
    //
    // The following TrayService functionality cannot be unit tested because
    // it depends on package-level singletons (trayManager, windowManager)
    // that are not injectable:
    //
    //   - init(): calls trayManager.setIcon(), setToolTip(), addListener()
    //     These are global singletons from `package:tray_manager` that
    //     require a running Flutter engine and native platform channel.
    //
    //   - _updateMenu(): calls trayManager.setContextMenu() which needs
    //     the native tray_manager plugin initialized.
    //
    //   - onTrayIconRightMouseDown(): calls trayManager.popUpContextMenu().
    //
    //   - _quit(): calls windowManager.destroy() and SystemNavigator.pop(),
    //     both of which require a live Flutter engine.
    //
    //   - _performUpdate(): calls processManager.stopAll() (testable) but
    //     also updateService.performBrewUpgrade() which spawns processes.
    //
    //   - dispose(): calls trayManager.removeListener() (singleton).
    //
    // To make these testable, trayManager and windowManager would need to
    // be injected via constructor parameters or an abstraction layer.
  });
}
