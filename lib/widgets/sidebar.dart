import 'dart:io';
import 'package:flutter/material.dart';
import '../theme/colors.dart';

class CandelaSidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const CandelaSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  static const _items = [
    _NavItem(icon: Icons.shield_outlined, activeIcon: Icons.shield, label: 'Auth & Debug'),
    _NavItem(icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard, label: 'Dashboard'),
    _NavItem(icon: Icons.timeline_outlined, activeIcon: Icons.timeline, label: 'Traces'),
    _NavItem(icon: Icons.memory_outlined, activeIcon: Icons.memory, label: 'Models'),
  ];

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
                  width: 26, height: 26,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft, end: Alignment.bottomRight,
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
                      fontSize: 18, fontWeight: FontWeight.w700,
                      letterSpacing: -0.3, color: Colors.white,
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
          // Footer — connection status
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: CandelaColors.borderSubtle)),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: CandelaColors.bgTertiary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  CircleAvatar(radius: 3, backgroundColor: CandelaColors.success),
                  SizedBox(width: 8),
                  Text('v0.1.0', style: TextStyle(fontSize: 12, color: CandelaColors.textSecondary)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, _NavItem item) {
    final isActive = index == selectedIndex;
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Material(
        color: isActive ? CandelaColors.accentDim : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          hoverColor: CandelaColors.bgHover,
          onTap: () => onItemSelected(index),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Icon(
                  isActive ? item.activeIcon : item.icon,
                  size: 18,
                  color: isActive ? CandelaColors.accent : CandelaColors.textSecondary,
                ),
                const SizedBox(width: 10),
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
                    color: isActive ? CandelaColors.accent : CandelaColors.textSecondary,
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
  const _NavItem({required this.icon, required this.activeIcon, required this.label});
}
