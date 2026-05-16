import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';
import 'process_manager.dart';
import 'update_service.dart';

/// Manages the macOS/Windows/Linux system tray icon and menu.
class TrayService with TrayListener {
  final ProcessManager processManager;
  final UpdateService? updateService;
  Timer? _updateTimer;
  Timer? _debounceTimer;
  VoidCallback? onShowWindow;

  TrayService({required this.processManager, this.updateService});

  Future<void> init() async {
    // Use a built-in icon path. For production, use a proper .png asset.
    // tray_manager requires an icon file path.
    final iconPath = _trayIconPath();
    if (iconPath != null) {
      await trayManager.setIcon(iconPath);
    }
    await trayManager.setToolTip('Candela — LLM Proxy');
    trayManager.addListener(this);

    // Initial menu build.
    await _updateMenu();

    // Refresh menu every 10s to reflect process state.
    _updateTimer =
        Timer.periodic(const Duration(seconds: 10), (_) => _updateMenu());

    // Also update when process state changes (debounced).
    processManager.addListener(_debouncedUpdate);
  }

  void _debouncedUpdate() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), _updateMenu);
  }

  String? _trayIconPath() {
    if (Platform.isMacOS) {
      // In production .app bundles, resolve relative to the executable.
      final exePath = Platform.resolvedExecutable;
      final bundleDir = exePath.contains('/Contents/MacOS/')
          ? exePath.substring(0, exePath.indexOf('/Contents/MacOS/'))
          : null;

      // Try bundle resources first (production).
      if (bundleDir != null) {
        final resourceIcon = File('$bundleDir/Contents/Resources/AppIcon.icns');
        if (resourceIcon.existsSync()) return resourceIcon.path;
      }

      // Fallback: dev mode — use source tree icon.
      final devIcon = File(
          '${Directory.current.path}/macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_32.png');
      if (devIcon.existsSync()) return devIcon.path;
    }
    return null;
  }

  Future<void> _updateMenu() async {
    final items = <MenuItem>[];

    // Process status section.
    for (final p in processManager.all) {
      final stateStr = switch (p.state) {
        ProcessState.running => '● Running :${p.port}',
        ProcessState.starting => '◐ Starting...',
        ProcessState.stopping => '◐ Stopping...',
        ProcessState.detecting => '◐ Detecting...',
        ProcessState.error => '✖ Error',
        ProcessState.notInstalled => '○ Not installed',
        ProcessState.stopped => '○ Stopped',
      };
      items.add(MenuItem(
        label: '${p.icon}  ${p.displayName}   $stateStr',
        disabled: true,
      ));
    }

    items.add(MenuItem.separator());

    // Controls.
    final hasRunning =
        processManager.all.any((p) => p.state == ProcessState.running);
    final hasStopped =
        processManager.all.any((p) => p.state == ProcessState.stopped);

    if (hasStopped) {
      items.add(MenuItem(
        key: 'start_all',
        label: '▶  Start All',
      ));
    }
    if (hasRunning) {
      items.add(MenuItem(
        key: 'stop_all',
        label: '■  Stop All',
      ));
    }

    items.add(MenuItem.separator());

    // Update available.
    if (updateService != null &&
        updateService!.status == UpdateStatus.available &&
        updateService!.latestVersion != null) {
      items.add(MenuItem(
        key: 'update',
        label: '↑  Update Available (${updateService!.latestVersion})',
      ));
    }

    items.add(MenuItem.separator());

    items.add(MenuItem(
      key: 'show',
      label: 'Show Window',
    ));

    items.add(MenuItem.separator());

    items.add(MenuItem(
      key: 'quit',
      label: 'Quit Candela',
    ));

    await trayManager.setContextMenu(Menu(items: items));
  }

  @override
  void onTrayIconMouseDown() {
    // Left click — toggle window.
    onShowWindow?.call();
  }

  @override
  void onTrayIconRightMouseDown() {
    trayManager.popUpContextMenu();
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    switch (menuItem.key) {
      case 'show':
        onShowWindow?.call();
        break;
      case 'start_all':
        processManager.startAll();
        break;
      case 'stop_all':
        processManager.stopAll();
        break;
      case 'quit':
        _quit();
        break;
      case 'update':
        _performUpdate();
        break;
    }
  }

  Future<void> _quit() async {
    await processManager.stopAll();
    // Give processes a moment to terminate gracefully.
    await Future.delayed(const Duration(milliseconds: 500));
    await windowManager.destroy();
    // Use SystemNavigator to allow Flutter cleanup instead of hard exit.
    SystemNavigator.pop();
  }

  Future<void> _performUpdate() async {
    if (updateService?.detectChannel() == InstallChannel.homebrew) {
      await processManager.stopAll();
      await updateService!.performBrewUpgrade();
    }
  }

  void dispose() {
    _updateTimer?.cancel();
    _debounceTimer?.cancel();
    processManager.removeListener(_debouncedUpdate);
    trayManager.removeListener(this);
  }
}
