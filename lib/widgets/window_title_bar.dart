import 'dart:io';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import '../theme/colors.dart';

/// Custom window title bar for non-macOS platforms.
///
/// On macOS, the native traffic lights (close/minimize/zoom) are rendered by
/// the OS even with `TitleBarStyle.hidden`. On Windows and Linux, hiding the
/// title bar removes all window controls, so we provide custom ones.
///
/// Uses [DragToMoveArea] for the drag region (scoped to the spacer only,
/// not the buttons) to avoid gesture conflicts with button taps.
class WindowTitleBar extends StatelessWidget {
  const WindowTitleBar({super.key});

  @override
  Widget build(BuildContext context) {
    // macOS renders native traffic lights — no custom controls needed.
    if (Platform.isMacOS) return const SizedBox.shrink();

    return SizedBox(
      height: 36,
      child: Row(
        children: [
          // Drag-to-move area — scoped to the spacer only so button taps
          // are never swallowed by the pan gesture recognizer.
          const Expanded(child: DragToMoveArea(child: SizedBox.expand())),
          // ── Window control buttons ──
          _WindowButton(
            icon: Icons.minimize,
            semanticLabel: 'Minimize',
            onPressed: () => windowManager.minimize(),
            hoverColor: CandelaColors.bgTertiary,
          ),
          _MaximizeButton(),
          _WindowButton(
            icon: Icons.close,
            semanticLabel: 'Close',
            onPressed: () => windowManager.close(),
            hoverColor: const Color(0xFFE81123),
            hoverIconColor: Colors.white,
          ),
        ],
      ),
    );
  }
}

/// A stateful maximize/restore button that tracks the window state.
class _MaximizeButton extends StatefulWidget {
  @override
  State<_MaximizeButton> createState() => _MaximizeButtonState();
}

class _MaximizeButtonState extends State<_MaximizeButton> with WindowListener {
  bool _isMaximized = false;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _checkMaximized();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  Future<void> _checkMaximized() async {
    final maximized = await windowManager.isMaximized();
    if (mounted && maximized != _isMaximized) {
      setState(() => _isMaximized = maximized);
    }
  }

  @override
  void onWindowMaximize() => setState(() => _isMaximized = true);

  @override
  void onWindowUnmaximize() => setState(() => _isMaximized = false);

  @override
  Widget build(BuildContext context) {
    return _WindowButton(
      icon: _isMaximized ? Icons.filter_none : Icons.crop_square,
      semanticLabel: _isMaximized ? 'Restore' : 'Maximize',
      onPressed: () async {
        if (_isMaximized) {
          await windowManager.unmaximize();
        } else {
          await windowManager.maximize();
        }
      },
      hoverColor: CandelaColors.bgTertiary,
    );
  }
}

/// A single window control button with hover effect, accessibility, and
/// pointer cursor affordance.
class _WindowButton extends StatefulWidget {
  final IconData icon;
  final String semanticLabel;
  final VoidCallback onPressed;
  final Color hoverColor;
  final Color? hoverIconColor;

  const _WindowButton({
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
    required this.hoverColor,
    this.hoverIconColor,
  });

  @override
  State<_WindowButton> createState() => _WindowButtonState();
}

class _WindowButtonState extends State<_WindowButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.semanticLabel,
      child: Tooltip(
        message: widget.semanticLabel,
        waitDuration: const Duration(milliseconds: 800),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hovering = true),
          onExit: (_) => setState(() => _hovering = false),
          child: GestureDetector(
            onTap: widget.onPressed,
            child: Container(
              width: 46,
              height: 36,
              color: _hovering ? widget.hoverColor : Colors.transparent,
              child: Center(
                child: Icon(
                  widget.icon,
                  size: 16,
                  color: _hovering && widget.hoverIconColor != null
                      ? widget.hoverIconColor
                      : CandelaColors.textSecondary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
