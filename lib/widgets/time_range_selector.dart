import 'package:flutter/material.dart';
import '../models/span_stats.dart';
import '../theme/colors.dart';

/// 24h / 7d / 30d chip selector for the dashboard time range.
class TimeRangeSelector extends StatelessWidget {
  final TokenTimeRange value;
  final ValueChanged<TokenTimeRange> onChanged;

  const TimeRangeSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CandelaColors.bgSecondary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: CandelaColors.border),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: TokenTimeRange.values
            .map((r) => _RangeChip(
                  range: r,
                  selected: r == value,
                  onTap: () => onChanged(r),
                ))
            .toList(),
      ),
    );
  }
}

class _RangeChip extends StatelessWidget {
  final TokenTimeRange range;
  final bool selected;
  final VoidCallback onTap;

  const _RangeChip({
    required this.range,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: selected ? CandelaColors.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          range.label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? Colors.white : CandelaColors.textMuted,
          ),
        ),
      ),
    );
  }
}
