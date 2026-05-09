import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/span_stats.dart';
import '../theme/colors.dart';

/// A smooth area chart with an interactive hover tooltip.
/// Pure Flutter custom painter — zero external dependencies.
class CandelaAreaChart extends StatefulWidget {
  final List<TimeSeriesPoint> data;
  final double height;
  final Color color;
  final String Function(double) formatValue;
  final String emptyMessage;

  const CandelaAreaChart({
    super.key,
    required this.data,
    this.height = 180,
    this.color = CandelaColors.accent,
    required this.formatValue,
    this.emptyMessage = 'No data',
  });

  @override
  State<CandelaAreaChart> createState() => _CandelaAreaChartState();
}

class _CandelaAreaChartState extends State<CandelaAreaChart> {
  int? _hoveredIndex;
  Offset? _hoverPos;

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty || widget.data.every((p) => p.value == 0)) {
      return SizedBox(
        height: widget.height,
        child: Center(
          child: Text(
            widget.emptyMessage,
            style: const TextStyle(
              color: CandelaColors.textMuted,
              fontSize: 13,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: widget.height,
      child: MouseRegion(
        onHover: (e) => _onHover(e.localPosition),
        onExit: (_) => setState(() {
          _hoveredIndex = null;
          _hoverPos = null;
        }),
        child: Stack(
          children: [
            CustomPaint(
              painter: _AreaPainter(
                data: widget.data,
                color: widget.color,
                hoveredIndex: _hoveredIndex,
              ),
              size: Size.infinite,
            ),
            if (_hoveredIndex != null && _hoverPos != null)
              _Tooltip(
                pos: _hoverPos!,
                label: widget.data[_hoveredIndex!].label,
                value: widget.formatValue(widget.data[_hoveredIndex!].value),
                containerWidth: context.size?.width ?? 400,
                containerHeight: widget.height,
              ),
          ],
        ),
      ),
    );
  }

  void _onHover(Offset pos) {
    const padL = 48.0, padR = 12.0;
    final w = context.size?.width ?? 400;
    final chartW = w - padL - padR;
    if (chartW <= 0 || widget.data.isEmpty) return;

    final relX = pos.dx - padL;
    final n = widget.data.length;
    final idx = (relX / chartW * (n - 1)).round().clamp(0, n - 1);

    if (idx != _hoveredIndex) {
      setState(() {
        _hoveredIndex = idx;
        _hoverPos = pos;
      });
    }
  }
}

// ── Painter ─────────────────────────────────────────────────────────────────

const _padT = 8.0, _padB = 28.0, _padL = 48.0, _padR = 12.0;

class _AreaPainter extends CustomPainter {
  final List<TimeSeriesPoint> data;
  final Color color;
  final int? hoveredIndex;

  _AreaPainter({
    required this.data,
    required this.color,
    this.hoveredIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final chartW = size.width - _padL - _padR;
    final chartH = size.height - _padT - _padB;
    if (chartW <= 0 || chartH <= 0) return;

    final maxVal = data.map((p) => p.value).reduce(math.max);
    if (maxVal <= 0) return;

    // Compute pixel positions.
    final pts = List.generate(data.length, (i) {
      final x = _padL + (i / math.max(data.length - 1, 1)) * chartW;
      final y = _padT + chartH - (data[i].value / maxVal) * chartH;
      return Offset(x, y);
    });

    // Grid lines + Y axis labels.
    const tickCount = 4;
    final gridPaint = Paint()
      ..color = CandelaColors.border.withAlpha(128)
      ..strokeWidth = 1;
    final labelStyle = const TextStyle(
      color: CandelaColors.textMuted,
      fontSize: 10,
    );

    for (int i = 0; i <= tickCount; i++) {
      final val = (maxVal / tickCount) * i;
      final y = _padT + chartH - (val / maxVal) * chartH;
      canvas.drawLine(Offset(_padL, y), Offset(_padL + chartW, y), gridPaint);

      final tp = TextPainter(
        text: TextSpan(text: _compact(val), style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(_padL - tp.width - 6, y - tp.height / 2));
    }

    // X-axis labels — show every nth to avoid crowding.
    final labelStep = math.max(1, data.length ~/ 6);
    for (int i = 0; i < pts.length; i++) {
      if (i % labelStep != 0 && i != pts.length - 1) continue;
      final tp = TextPainter(
        text: TextSpan(text: data[i].label, style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(pts[i].dx - tp.width / 2, _padT + chartH + 6));
    }

    // Area fill.
    final areaPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withAlpha(76), color.withAlpha(5)],
      ).createShader(Rect.fromLTWH(_padL, _padT, chartW, chartH));

    final areaPath = _buildSmoothedPath(pts)
      ..lineTo(pts.last.dx, _padT + chartH)
      ..lineTo(pts.first.dx, _padT + chartH)
      ..close();
    canvas.drawPath(areaPath, areaPaint);

    // Line.
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(_buildSmoothedPath(pts), linePaint);

    // Hover indicator.
    if (hoveredIndex != null && hoveredIndex! < pts.length) {
      final hp = pts[hoveredIndex!];
      final vlinePaint = Paint()
        ..color = color.withAlpha(128)
        ..strokeWidth = 1;
      canvas.drawLine(
          Offset(hp.dx, _padT), Offset(hp.dx, _padT + chartH), vlinePaint);

      canvas.drawCircle(
        hp,
        5,
        Paint()..color = CandelaColors.bgPrimary,
      );
      canvas.drawCircle(
        hp,
        4,
        Paint()..color = color,
      );
    }
  }

  /// Catmull-Rom-style smoothed cubic Bézier path.
  Path _buildSmoothedPath(List<Offset> pts) {
    if (pts.length < 2) {
      return Path()..moveTo(pts.first.dx, pts.first.dy);
    }
    const s = 0.2;
    final p = Path()..moveTo(pts.first.dx, pts.first.dy);

    for (int i = 1; i < pts.length; i++) {
      final prev2 = pts[math.max(i - 2, 0)];
      final prev = pts[i - 1];
      final curr = pts[i];
      final next = pts[math.min(i + 1, pts.length - 1)];

      final cp1 = _controlPoint(prev, prev2, curr, false, s);
      final cp2 = _controlPoint(curr, prev, next, true, s);
      p.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, curr.dx, curr.dy);
    }
    return p;
  }

  Offset _controlPoint(
      Offset p, Offset prev, Offset next, bool reverse, double smoothing) {
    final dx = next.dx - prev.dx;
    final dy = next.dy - prev.dy;
    final len = math.sqrt(dx * dx + dy * dy) * smoothing;
    final angle = math.atan2(dy, dx) + (reverse ? math.pi : 0);
    return Offset(p.dx + math.cos(angle) * len, p.dy + math.sin(angle) * len);
  }

  String _compact(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}k';
    if (v < 1 && v > 0) return v.toStringAsFixed(4);
    return v.toStringAsFixed(0);
  }

  @override
  bool shouldRepaint(_AreaPainter old) =>
      old.data != data ||
      old.color != color ||
      old.hoveredIndex != hoveredIndex;
}

// ── Tooltip overlay ──────────────────────────────────────────────────────────

class _Tooltip extends StatelessWidget {
  final Offset pos;
  final String label;
  final String value;
  final double containerWidth;
  final double containerHeight;

  const _Tooltip({
    required this.pos,
    required this.label,
    required this.value,
    required this.containerWidth,
    required this.containerHeight,
  });

  @override
  Widget build(BuildContext context) {
    const w = 90.0, h = 46.0;
    final left = (pos.dx - w / 2).clamp(0.0, containerWidth - w);
    final top = (pos.dy - h - 10).clamp(0.0, containerHeight - h);

    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: w,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: CandelaColors.bgTertiary,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: CandelaColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(76),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: CandelaColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
