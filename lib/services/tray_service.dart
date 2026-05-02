import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';
import 'process_manager.dart';

/// Manages the macOS/Windows/Linux system tray icon and menu.
class TrayService with TrayListener {
  final ProcessManager processManager;
  Timer? _updateTimer;
  VoidCallback? onShowWindow;

  TrayService({required this.processManager});

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
    _updateTimer = Timer.periodic(const Duration(seconds: 10), (_) => _updateMenu());

    // Also update when process state changes.
    processManager.addListener(_updateMenu);
  }

  String? _trayIconPath() {
    // On macOS, use a template image for the menu bar.
    // For now, we'll use the app icon. In production, use a 22x22 template.
    if (Platform.isMacOS) {
      // Use the app icon as a fallback.
      final iconDir = '${Directory.current.path}/macos/Runner/Assets.xcassets/AppIcon.appiconset';
      final iconFile = File('$iconDir/app_icon_32.png');
      if (iconFile.existsSync()) return iconFile.path;
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
    final hasRunning = processManager.all.any((p) => p.state == ProcessState.running);
    final hasStopped = processManager.all.any((p) => p.state == ProcessState.stopped);

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
    }
  }

  Future<void> _quit() async {
    await processManager.stopAll();
    await windowManager.destroy();
    exit(0);
  }

  void dispose() {
    _updateTimer?.cancel();
    processManager.removeListener(_updateMenu);
    trayManager.removeListener(this);
  }
}
