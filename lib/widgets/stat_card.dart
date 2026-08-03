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
  final double? changePercent;
  final List<double>? sparklineData;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    this.accentColor,
    this.icon,
    this.changePercent,
    this.sparklineData,
  });

  Widget _buildTrendBadge(double percent) {
    final isNeutral = percent.abs() <= 1.0;
    final isPositive = percent > 1.0;

    final color = isNeutral
        ? CandelaColors.textMuted
        : (isPositive ? const Color(0xFFEF4444) : const Color(0xFF4ADE80));

    final icon = isNeutral ? '→' : (isPositive ? '↑' : '↓');
    final valStr = '${percent.abs().toStringAsFixed(0)}%';

    return Text(
      '$icon $valStr',
      style: TextStyle(
        color: color,
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
    );
  }

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: CandelaColors.textMuted,
                  ),
                ),
              ),
              if (changePercent != null) const SizedBox(width: 6),
              if (changePercent != null) _buildTrendBadge(changePercent!),
            ],
          ),
          const SizedBox(height: 6),
          // Sparkline or Bottom accent line
          if (sparklineData != null && sparklineData!.length > 1)
            SizedBox(
              height: 24,
              width: double.infinity,
              child: CustomPaint(
                painter: _SparklinePainter(
                  data: sparklineData!,
                  color: accent,
                ),
              ),
            )
          else
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

class _SparklinePainter extends CustomPainter {
  final List<double> data;
  final Color color;

  _SparklinePainter({required this.data, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final double maxVal = data.reduce((a, b) => a > b ? a : b);
    final double minVal = data.reduce((a, b) => a < b ? a : b);
    final double range = maxVal - minVal == 0 ? 1 : maxVal - minVal;

    final double xStep = size.width / (data.length - 1);

    final path = Path();
    for (int i = 0; i < data.length; i++) {
      final x = i * xStep;
      final y = size.height - ((data[i] - minVal) / range) * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    // Paint fill first so stroke is on top
    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final paintFill = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;
    canvas.drawPath(fillPath, paintFill);

    // Paint stroke
    final paintStroke = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, paintStroke);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) {
    return oldDelegate.data != data || oldDelegate.color != color;
  }
}
