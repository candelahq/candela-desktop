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
        icon: Icons.today_outlined, activeIcon: Icons.today, label: 'Today'),
    _NavItem(
        icon: Icons.shield_outlined,
        activeIcon: Icons.shield,
        label: 'Diagnostics'),
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
    _NavItem(
        icon: Icons.menu_book_outlined,
        activeIcon: Icons.menu_book,
        label: 'Catalog'),
    _NavItem(
        icon: Icons.settings_outlined,
        activeIcon: Icons.settings,
        label: 'Settings'),
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
    switch (channel) {
      case InstallChannel.homebrew:
        _showBrewUpgradeDialog(svc);
      case InstallChannel.direct:
      case InstallChannel.unknown:
        final opened = await svc.openReleasesPage();
        if (!opened) {
          _showUpdateSnackBar(svc.updateInstructions(channel));
        }
      case InstallChannel.nix:
        _showUpdateSnackBar(svc.updateInstructions(channel));
    }
  }

  void _showBrewUpgradeDialog(UpdateService svc) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: CandelaColors.bgSecondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Update Candela',
          style: TextStyle(color: CandelaColors.textPrimary),
        ),
        content: Text(
          'A new version is available ($_version → v$_newVersion).\n\n'
          'This will run brew upgrade and relaunch the app.',
          style: const TextStyle(color: CandelaColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel',
                style: TextStyle(color: CandelaColors.textMuted)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: CandelaColors.accent,
            ),
            onPressed: () async {
              Navigator.of(ctx).pop();
              final success = await svc.performBrewUpgrade();
              if (!success && mounted) {
                _showUpdateSnackBar(
                    'Upgrade failed. Please run: brew upgrade candela');
              }
            },
            child: const Text('Update & Relaunch'),
          ),
        ],
      ),
    );
  }

  void _showUpdateSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: CandelaColors.textPrimary),
        ),
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
          // On macOS, reserve space for native traffic lights.
          // On Windows/Linux, the WindowTitleBar widget handles drag + controls.
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
    final isChecking = _updateStatus == UpdateStatus.checking;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: CandelaColors.borderSubtle)),
      ),
      child: hasUpdate
          ? // ── Update available: prominent banner ──
          InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: _handleUpdateTap,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: CandelaColors.accentDim,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: CandelaColors.accent.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.upgrade_rounded,
                        size: 16, color: CandelaColors.accent),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Update available',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: CandelaColors.accent,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '$_version → v$_newVersion',
                            style: const TextStyle(
                              fontSize: 10,
                              color: CandelaColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: CandelaColors.accent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Update',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : // ── Up to date: subtle version label ──
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 3,
                    backgroundColor: isChecking
                        ? CandelaColors.textMuted
                        : CandelaColors.success,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _version,
                    style: const TextStyle(
                      fontSize: 12,
                      color: CandelaColors.textMuted,
                    ),
                  ),
                  if (isChecking) ...[
                    const SizedBox(width: 8),
                    const SizedBox(
                      width: 10,
                      height: 10,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        color: CandelaColors.textMuted,
                      ),
                    ),
                  ],
                ],
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
