import 'package:flutter/material.dart';
import '../theme/colors.dart';

/// A compact summary card showing a label, large value, and subtitle.
/// Used in the 4-up stats grid at the top of the dashboard.
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Color? accentColor;
  final IconData? icon;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    this.accentColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final accent = accentColor ?? CandelaColors.accent;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CandelaColors.bgSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CandelaColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 14, color: accent),
                const SizedBox(width: 6),
              ],
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: CandelaColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: CandelaColors.textPrimary,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 11,
              color: CandelaColors.textMuted,
            ),
          ),
          const SizedBox(height: 6),
          // Bottom accent line
          Container(
            height: 2,
            width: 32,
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ],
      ),
    );
  }
}
