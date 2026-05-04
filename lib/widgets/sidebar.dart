import 'dart:io';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../services/update_service.dart';
import '../theme/colors.dart';

class CandelaSidebar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  /// Optional UpdateService — when provided, enables the update badge.
  final UpdateService? updateService;

  const CandelaSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    this.updateService,
  });

  @override
  State<CandelaSidebar> createState() => _CandelaSidebarState();
}

class _CandelaSidebarState extends State<CandelaSidebar> {
  String _version = '...';
  String? _newVersion;
  UpdateStatus _updateStatus = UpdateStatus.idle;

  static const _items = [
    _NavItem(
        icon: Icons.shield_outlined,
        activeIcon: Icons.shield,
        label: 'Auth & Debug'),
    _NavItem(
        icon: Icons.dashboard_outlined,
        activeIcon: Icons.dashboard,
        label: 'Dashboard'),
    _NavItem(
        icon: Icons.timeline_outlined,
        activeIcon: Icons.timeline,
        label: 'Traces'),
    _NavItem(
        icon: Icons.memory_outlined, activeIcon: Icons.memory, label: 'Models'),
  ];

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() => _version = 'v${info.version}');

    // Kick off update check if service is available.
    final svc = widget.updateService;
    if (svc != null) {
      // Initialize Sparkle for direct installs.
      await svc.initSparkle();
      // Check for updates.
      final newer = await svc.checkForUpdate(info.version);
      if (mounted) {
        setState(() {
          _newVersion = newer;
          _updateStatus = svc.status;
        });
      }
    }
  }

  void _handleUpdateTap() async {
    final svc = widget.updateService;
    if (svc == null) return;

    final channel = svc.detectChannel();
    if (channel == InstallChannel.direct) {
      // Try Sparkle native update dialog.
      final launched = await svc.checkForUpdatesViaSparkle();
      if (!launched && mounted) {
        // Sparkle not available (not macOS, missing binary, etc.)
        // Fall back to opening the releases page.
        _showUpdateSnackBar(
          'Update available! Download from candelahq.com/releases',
        );
      }
    } else {
      // Show instructions for managed channels.
      _showUpdateSnackBar(svc.updateInstructions(channel));
    }
  }

  void _showUpdateSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: CandelaColors.bgTertiary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      decoration: const BoxDecoration(
        color: CandelaColors.bgSecondary,
        border: Border(right: BorderSide(color: CandelaColors.borderSubtle)),
      ),
      child: Column(
        children: [
          // Empty draggable area for macOS traffic lights.
          SizedBox(height: Platform.isMacOS ? 36 : 8),
          // Logo row — below traffic lights.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [CandelaColors.accent, Color(0xFFFF8C00)],
                    ),
                  ),
                  child: const Center(
                    child: Text('🕯', style: TextStyle(fontSize: 13)),
                  ),
                ),
                const SizedBox(width: 10),
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [CandelaColors.accent, Color(0xFFFF8C00)],
                  ).createShader(bounds),
                  child: const Text(
                    'Candela',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, color: CandelaColors.borderSubtle),
          // Nav items
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Column(
                children: [
                  for (var i = 0; i < _items.length; i++)
                    _buildNavItem(i, _items[i]),
                ],
              ),
            ),
          ),
          // Footer — version display + update badge
          _buildVersionFooter(),
        ],
      ),
    );
  }

  Widget _buildVersionFooter() {
    final hasUpdate = _updateStatus == UpdateStatus.available;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: CandelaColors.borderSubtle)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: hasUpdate ? _handleUpdateTap : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color:
                hasUpdate ? CandelaColors.accentDim : CandelaColors.bgTertiary,
            borderRadius: BorderRadius.circular(8),
            border: hasUpdate
                ? Border.all(color: CandelaColors.accent.withValues(alpha: 0.3))
                : null,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 3,
                backgroundColor:
                    hasUpdate ? CandelaColors.accent : CandelaColors.success,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _version,
                  style: const TextStyle(
                    fontSize: 12,
                    color: CandelaColors.textSecondary,
                  ),
                ),
              ),
              if (hasUpdate) ...[
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: CandelaColors.accent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'v$_newVersion',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_upward_rounded,
                  size: 14,
                  color: CandelaColors.accent,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, _NavItem item) {
    final isActive = index == widget.selectedIndex;
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Material(
        color: isActive ? CandelaColors.accentDim : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          hoverColor: CandelaColors.bgHover,
          onTap: () => widget.onItemSelected(index),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Icon(
                  isActive ? item.activeIcon : item.icon,
                  size: 18,
                  color: isActive
                      ? CandelaColors.accent
                      : CandelaColors.textSecondary,
                ),
                const SizedBox(width: 10),
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
                    color: isActive
                        ? CandelaColors.accent
                        : CandelaColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItem(
      {required this.icon, required this.activeIcon, required this.label});
}
