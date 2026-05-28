import 'package:flutter_test/flutter_test.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:candela_desktop/services/tray_service.dart';
import 'package:candela_desktop/services/process_manager.dart';

// ── Hand-rolled mock: MockProcessManager ────────────────────────────────────
//
// Extends ProcessManager (which itself extends ChangeNotifier) so it satisfies
// the type constraint in TrayService's constructor.
// Overrides methods to record calls for assertion without spawning processes.

class MockProcessManager extends ProcessManager {
  final List<String> calls = [];

  @override
  List<ManagedProcess> get all => [];

  @override
  Future<void> startAll() async {
    calls.add('startAll');
  }

  @override
  Future<void> stopAll() async {
    calls.add('stopAll');
  }

  @override
  Future<void> start(String name) async {
    calls.add('start:$name');
  }

  @override
  Future<void> stop(String name) async {
    calls.add('stop:$name');
  }
}

void main() {
  group('TrayService', () {
    // ── Constructor ─────────────────────────────────────────────────────

    group('constructor', () {
      test('accepts ProcessManager as required parameter', () {
        final mock = MockProcessManager();
        final service = TrayService(processManager: mock);
        expect(service.processManager, same(mock));
        // Clean up — no init() called, nothing to dispose except the mock.
      });

      test('accepts optional UpdateService parameter', () {
        final mock = MockProcessManager();
        // updateService is optional, so passing null should work.
        final service = TrayService(processManager: mock, updateService: null);
        expect(service.updateService, isNull);
      });
    });

    // ── onTrayMenuItemClick dispatching ──────────────────────────────────
    //
    // onTrayMenuItemClick is a public override from TrayListener.
    // We can call it directly with a MenuItem to test the switch dispatch.

    group('onTrayMenuItemClick', () {
      late MockProcessManager mockPM;
      late TrayService service;

      setUp(() {
        mockPM = MockProcessManager();
        service = TrayService(processManager: mockPM);
      });

      test('start_all dispatches processManager.startAll()', () {
        service.onTrayMenuItemClick(MenuItem(key: 'start_all', label: 'Start'));
        expect(mockPM.calls, contains('startAll'));
      });

      test('stop_all dispatches processManager.stopAll()', () {
        service.onTrayMenuItemClick(MenuItem(key: 'stop_all', label: 'Stop'));
        expect(mockPM.calls, contains('stopAll'));
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
        expect(mockPM.calls, isEmpty);
      });
    });

    // ── onTrayIconMouseDown ──────────────────────────────────────────────

    group('onTrayIconMouseDown', () {
      test('calls onShowWindow callback', () {
        final mockPM = MockProcessManager();
        final service = TrayService(processManager: mockPM);
        var showCalled = false;
        service.onShowWindow = () => showCalled = true;

        service.onTrayIconMouseDown();
        expect(showCalled, isTrue);
      });

      test('is no-op when onShowWindow is null', () {
        final mockPM = MockProcessManager();
        final service = TrayService(processManager: mockPM);
        service.onShowWindow = null;
        // Should not throw.
        service.onTrayIconMouseDown();
      });
    });

    // ── onShowWindow callback ───────────────────────────────────────────

    group('onShowWindow', () {
      test('can be set and cleared', () {
        final mockPM = MockProcessManager();
        final service = TrayService(processManager: mockPM);

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
