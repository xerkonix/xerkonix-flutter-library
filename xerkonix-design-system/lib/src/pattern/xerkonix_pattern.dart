import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../palette/color.dart';
import '../shape/xerkonix_shape.dart';
import '../typography/xerkonix_typography.dart';

class XkKpiCard extends StatelessWidget {
  const XkKpiCard({
    super.key,
    required this.label,
    required this.value,
    this.suffix,
    this.delta,
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
    this.padding = const EdgeInsets.all(14),
  });

  final String label;
  final String value;
  final String? suffix;
  final String? delta;
  final BorderRadiusGeometry? borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final bg =
        backgroundColor ?? (isDark ? XkColor.darkSurface : XkColor.surface);
    final bd =
        borderColor ?? (isDark ? XkColor.darkBorderSoft : XkColor.borderSoft);
    final labelColor = isDark ? XkColor.darkTextMuted : XkColor.textMuted;
    final valueColor = isDark ? XkColor.darkTextStrong : XkColor.textStrong;
    final deltaColor = isDark ? XkColor.darkTextBody : XkColor.textBody;
    final suffixColor = isDark ? XkColor.darkAccent : XkColor.accent;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: borderRadius ?? XkShape.mdBorderRadius,
        border: Border.all(color: bd),
        boxShadow: XkShadow.resolve(brightness),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: XkTypo.metricMono.copyWith(color: labelColor),
          ),
          const SizedBox(height: 6),
          RichText(
            text: TextSpan(
              text: value,
              style: XkTypo.h1.copyWith(
                fontSize: 30,
                height: 1,
                color: valueColor,
              ),
              children: [
                if (suffix != null)
                  TextSpan(
                    text: suffix,
                    style: XkTypo.body.copyWith(
                      fontSize: 14,
                      height: 1.2,
                      color: suffixColor,
                    ),
                  ),
              ],
            ),
          ),
          if (delta != null) ...[
            const SizedBox(height: 6),
            Text(delta!, style: XkTypo.hint.copyWith(color: deltaColor)),
          ],
        ],
      ),
    );
  }
}

class XkConfidenceMeter extends StatelessWidget {
  const XkConfidenceMeter({
    super.key,
    required this.label,
    required this.value,
    this.valueText,
    this.startColor,
    this.endColor,
    this.borderRadius,
    this.height = 7,
  });

  final String label;
  final double value;
  final String? valueText;
  final Color? startColor;
  final Color? endColor;
  final BorderRadiusGeometry? borderRadius;
  final double height;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ratio = value.clamp(0.0, 1.0);
    final trackColor = isDark ? XkColor.darkSurface2 : XkColor.surface2;
    final headText = isDark ? XkColor.darkTextBody : XkColor.textBody;
    final base =
        startColor ?? (isDark ? XkColor.darkAccent : XkColor.accent);
    final end = endColor ?? _resolveGradientEnd(base, isDark);
    final valueLabel = valueText ?? '${(ratio * 100).round()}%';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: XkTypo.bodySmall.copyWith(fontSize: 12, color: headText),
              ),
            ),
            Text(valueLabel, style: XkTypo.fieldLabel.copyWith(color: base)),
          ],
        ),
        const SizedBox(height: XkLayout.spacingXs),
        ClipRRect(
          borderRadius: borderRadius ?? XkShape.fullBorderRadius,
          child: SizedBox(
            height: height,
            child: Stack(
              children: [
                Positioned.fill(child: ColoredBox(color: trackColor)),
                FractionallySizedBox(
                  widthFactor: ratio,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [base, end]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Color _resolveGradientEnd(Color color, bool isDark) {
    if (color == XkColor.accent || color == XkColor.darkAccent) {
      return isDark ? XkColor.darkAccentSoft : XkColor.accentSoft;
    }
    if (color == XkColor.success || color == XkColor.darkSuccess) {
      return isDark ? XkColor.darkSuccess : XkColor.successSoft;
    }
    if (color == XkColor.gray600 || color == XkColor.gray500) {
      return Color.lerp(color, Colors.white, isDark ? 0.18 : 0.38) ?? color;
    }
    return Color.lerp(color, Colors.white, isDark ? 0.18 : 0.32) ?? color;
  }
}

class XkTimelineItem {
  const XkTimelineItem({
    required this.time,
    required this.title,
    required this.description,
    this.color,
  });

  final String time;
  final String title;
  final String description;
  final Color? color;
}

class XkSignalTimeline extends StatelessWidget {
  const XkSignalTimeline({
    super.key,
    required this.items,
    this.padding = const EdgeInsets.all(14),
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
  });

  final List<XkTimelineItem> items;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry? borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final bg =
        backgroundColor ?? (isDark ? XkColor.darkSurface : XkColor.surface);
    final bd =
        borderColor ?? (isDark ? XkColor.darkBorderSoft : XkColor.borderSoft);
    final timeColor = isDark ? XkColor.darkTextMuted : XkColor.textMuted;
    final titleColor = isDark ? XkColor.darkTextStrong : XkColor.textStrong;
    final bodyColor = isDark ? XkColor.darkTextBody : XkColor.textBody;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: borderRadius ?? XkShape.mdBorderRadius,
        border: Border.all(color: bd),
        boxShadow: XkShadow.resolve(brightness),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < items.length; i++) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          items[i].color ??
                          (isDark ? XkColor.darkAccent : XkColor.accent),
                    ),
                  ),
                ),
                const SizedBox(width: XkLayout.spacingSm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        items[i].time,
                        style: XkTypo.metricMono.copyWith(color: timeColor),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        items[i].title,
                        style: XkTypo.fieldLabel.copyWith(color: titleColor),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        items[i].description,
                        style: XkTypo.bodySmall.copyWith(color: bodyColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (i != items.length - 1)
              const SizedBox(height: XkLayout.spacingSm),
          ],
        ],
      ),
    );
  }
}

class XkMetricTimeline extends StatefulWidget {
  const XkMetricTimeline({
    super.key,
    this.height = 220,
    this.animate = true,
    this.duration = const Duration(milliseconds: 4200),
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
  });

  final double height;
  final bool animate;
  final Duration duration;
  final BorderRadiusGeometry? borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;

  @override
  State<XkMetricTimeline> createState() =>
      _XkMetricTimelineState();
}

class _XkMetricTimelineState extends State<XkMetricTimeline>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    if (widget.animate) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant XkMetricTimeline oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
      if (widget.animate) {
        _controller.repeat();
      }
    }
    if (widget.animate != oldWidget.animate) {
      if (widget.animate) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final bg =
        widget.backgroundColor ??
        (isDark
            ? XkColor.darkSurface.withValues(alpha: 0.82)
            : XkColor.surface);
    final bd =
        widget.borderColor ??
        (isDark ? XkColor.darkBorderSoft : XkColor.borderSoft);

    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: widget.borderRadius ?? XkShape.mdBorderRadius,
        border: Border.all(color: bd),
        boxShadow: XkShadow.resolve(brightness),
      ),
      clipBehavior: Clip.antiAlias,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _MetricTimelinePainter(
              progress: widget.animate ? _controller.value : 0.0,
              isDark: isDark,
            ),
            child: const SizedBox.expand(),
          );
        },
      ),
    );
  }
}

class _MetricTimelinePainter extends CustomPainter {
  const _MetricTimelinePainter({required this.progress, required this.isDark});

  final double progress;
  final bool isDark;

  static const List<Offset> _engagement = [
    Offset(0.00, 0.60),
    Offset(0.10, 0.30),
    Offset(0.20, 0.52),
    Offset(0.30, 0.18),
    Offset(0.40, 0.34),
    Offset(0.50, 0.22),
    Offset(0.60, 0.54),
    Offset(0.70, 0.26),
    Offset(0.80, 0.53),
    Offset(0.90, 0.33),
    Offset(1.00, 0.37),
  ];

  static const List<Offset> _variation = [
    Offset(0.00, 0.72),
    Offset(0.10, 0.65),
    Offset(0.20, 0.70),
    Offset(0.30, 0.57),
    Offset(0.40, 0.68),
    Offset(0.50, 0.60),
    Offset(0.60, 0.74),
    Offset(0.70, 0.61),
    Offset(0.80, 0.73),
    Offset(0.90, 0.64),
    Offset(1.00, 0.67),
  ];

  static const List<Offset> _stability = [
    Offset(0.00, 0.45),
    Offset(0.10, 0.43),
    Offset(0.20, 0.39),
    Offset(0.30, 0.44),
    Offset(0.40, 0.36),
    Offset(0.50, 0.42),
    Offset(0.60, 0.38),
    Offset(0.70, 0.43),
    Offset(0.80, 0.39),
    Offset(0.90, 0.44),
    Offset(1.00, 0.40),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    _drawGrid(canvas, size);

    final engagementPath = _pathFromPoints(_engagement, size);
    final fillPath = Path.from(engagementPath)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          (isDark ? XkColor.darkAccent : XkColor.accent).withValues(
            alpha: 0.28,
          ),
          (isDark ? XkColor.darkAccent : XkColor.accent).withValues(
            alpha: 0.02,
          ),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(fillPath, fillPaint);

    _drawLine(
      canvas,
      _stability,
      size,
      isDark ? XkColor.gray500 : XkColor.gray600,
      1.7,
    );
    _drawLine(
      canvas,
      _variation,
      size,
      isDark ? XkColor.darkAccent : XkColor.accent,
      1.7,
      dashed: true,
    );
    _drawLine(
      canvas,
      _engagement,
      size,
      isDark ? XkColor.darkAccent : XkColor.accent,
      2,
    );

    final dot = _interpolate(_engagement, progress);
    canvas.drawCircle(
      Offset(dot.dx * size.width, dot.dy * size.height),
      4,
      Paint()..color = isDark ? XkColor.darkAccent : XkColor.accent,
    );
  }

  void _drawGrid(Canvas canvas, Size size) {
    final color = isDark
        ? XkColor.darkTextStrong.withValues(alpha: 0.08)
        : XkColor.textStrong.withValues(alpha: 0.06);
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    for (final y in [0.33, 0.66]) {
      canvas.drawLine(
        Offset(0, size.height * y),
        Offset(size.width, size.height * y),
        paint,
      );
    }
    for (var i = 1; i < 6; i++) {
      final x = size.width * (i / 6);
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  void _drawLine(
    Canvas canvas,
    List<Offset> points,
    Size size,
    Color color,
    double strokeWidth, {
    bool dashed = false,
  }) {
    final path = _pathFromPoints(points, size);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = strokeWidth
      ..color = color;

    if (!dashed) {
      canvas.drawPath(path, paint);
      return;
    }

    final dashedPath = Path();
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      const dash = 6.0;
      const gap = 4.0;
      while (distance < metric.length) {
        final end = math.min(distance + dash, metric.length).toDouble();
        dashedPath.addPath(metric.extractPath(distance, end), Offset.zero);
        distance += dash + gap;
      }
    }
    canvas.drawPath(dashedPath, paint);
  }

  Path _pathFromPoints(List<Offset> points, Size size) {
    final path = Path()
      ..moveTo(points.first.dx * size.width, points.first.dy * size.height);
    for (final p in points.skip(1)) {
      path.lineTo(p.dx * size.width, p.dy * size.height);
    }
    return path;
  }

  Offset _interpolate(List<Offset> points, double t) {
    final clamped = t.clamp(0.0, 1.0);
    final segment = clamped * (points.length - 1);
    final index = segment.floor();
    final next = math.min(index + 1, points.length - 1);
    final local = segment - index;
    return Offset(
      _lerpDouble(points[index].dx, points[next].dx, local),
      _lerpDouble(points[index].dy, points[next].dy, local),
    );
  }

  double _lerpDouble(double a, double b, double t) => a + (b - a) * t;

  @override
  bool shouldRepaint(covariant _MetricTimelinePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isDark != isDark;
  }
}

class XkHexagonRadar extends StatelessWidget {
  const XkHexagonRadar({
    super.key,
    this.values = const [0.86, 0.78, 0.71, 0.84, 0.69, 0.76],
    this.size = 220,
    this.color,
    this.accentColor,
    this.supportColor,
    this.gridColor,
  });

  final List<double> values;
  final double size;
  final Color? color;
  final Color? accentColor;
  final Color? supportColor;
  final Color? gridColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resolvedColor =
        color ?? (isDark ? XkColor.darkAccent : XkColor.accent);
    final resolvedAccent =
        accentColor ?? (isDark ? XkColor.darkAccent : XkColor.accent);
    final resolvedSupport =
        supportColor ?? (isDark ? XkColor.darkSuccess : XkColor.success);
    final resolvedGrid =
        gridColor ??
        (isDark
            ? XkColor.darkTextMuted.withValues(alpha: 0.35)
            : XkColor.border.withValues(alpha: 0.45));

    return SizedBox(
      width: size,
      height: size * 0.75,
      child: CustomPaint(
        painter: _HexagonRadarPainter(
          values: values,
          color: resolvedColor,
          accentColor: resolvedAccent,
          supportColor: resolvedSupport,
          gridColor: resolvedGrid,
        ),
      ),
    );
  }
}

class _HexagonRadarPainter extends CustomPainter {
  const _HexagonRadarPainter({
    required this.values,
    required this.color,
    required this.accentColor,
    required this.supportColor,
    required this.gridColor,
  });

  final List<double> values;
  final Color color;
  final Color accentColor;
  final Color supportColor;
  final Color gridColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * 0.42;
    final rings = [1.0, 0.72, 0.44];
    final gridPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = gridColor
      ..strokeWidth = 1;

    for (final ratio in rings) {
      canvas.drawPath(_polygon(center, radius * ratio), gridPaint);
    }
    for (var i = 0; i < 6; i++) {
      final p = _vertex(center, radius, i);
      canvas.drawLine(center, p, gridPaint);
    }

    final safe = List<double>.generate(
      6,
      (i) => i < values.length ? values[i].clamp(0.0, 1.0) : 0.0,
    );
    final valuePath = Path();
    for (var i = 0; i < 6; i++) {
      final p = _vertex(center, radius * safe[i], i);
      if (i == 0) {
        valuePath.moveTo(p.dx, p.dy);
      } else {
        valuePath.lineTo(p.dx, p.dy);
      }
    }
    valuePath.close();

    canvas.drawPath(
      valuePath,
      Paint()
        ..style = PaintingStyle.fill
        ..color = color.withValues(alpha: 0.18),
    );
    canvas.drawPath(
      valuePath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6
        ..color = color,
    );

    final pointColors = [color, supportColor, color, color, accentColor, color];
    for (var i = 0; i < 6; i++) {
      final p = _vertex(center, radius * safe[i], i);
      canvas.drawCircle(p, 3, Paint()..color = pointColors[i]);
    }
  }

  Path _polygon(Offset center, double radius) {
    final path = Path();
    for (var i = 0; i < 6; i++) {
      final p = _vertex(center, radius, i);
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    path.close();
    return path;
  }

  Offset _vertex(Offset center, double radius, int index) {
    final angle = -math.pi / 2 + (math.pi / 3) * index;
    return Offset(
      center.dx + radius * math.cos(angle),
      center.dy + radius * math.sin(angle),
    );
  }

  @override
  bool shouldRepaint(covariant _HexagonRadarPainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.color != color ||
        oldDelegate.accentColor != accentColor ||
        oldDelegate.supportColor != supportColor ||
        oldDelegate.gridColor != gridColor;
  }
}

class XkDistributionHeatmap extends StatelessWidget {
  const XkDistributionHeatmap({
    super.key,
    this.values = const [
      0.18,
      0.24,
      0.32,
      0.20,
      0.28,
      0.36,
      0.16,
      0.22,
      0.36,
      0.40,
      0.28,
      0.20,
      0.12,
      0.22,
      0.30,
      0.38,
      0.30,
      0.26,
      0.16,
      0.18,
      0.24,
      0.20,
      0.12,
      0.16,
    ],
    this.columns = 6,
    this.cellSize = 24,
    this.gap = 6,
    this.baseColor = XkColor.accent,
    this.accentColor = XkColor.accent,
    this.supportColor = XkColor.success,
  });

  final List<double> values;
  final int columns;
  final double cellSize;
  final double gap;
  final Color baseColor;
  final Color accentColor;
  final Color supportColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? XkColor.darkSurface : XkColor.surface;

    return Wrap(
      spacing: gap,
      runSpacing: gap,
      children: List.generate(values.length, (i) {
        final value = values[i].clamp(0.0, 1.0);
        final target = switch (i % columns) {
          1 || 4 => accentColor,
          3 => supportColor,
          _ => baseColor,
        };
        return Container(
          width: cellSize,
          height: cellSize,
          decoration: BoxDecoration(
            color: Color.lerp(surface, target, value),
            borderRadius: BorderRadius.circular(XkShape.radiusXs),
          ),
        );
      }),
    );
  }
}

class XkPriorityFunnel extends StatelessWidget {
  const XkPriorityFunnel({
    super.key,
    this.values = const [0.92, 0.76, 0.58, 0.40, 0.24],
    this.height = 10,
    this.gap = 10,
    this.color = XkColor.accent,
    this.accentColor = XkColor.accent,
    this.supportColor = XkColor.success,
  });

  final List<double> values;
  final double height;
  final double gap;
  final Color color;
  final Color accentColor;
  final Color supportColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final trackColor = isDark ? XkColor.darkSurface2 : XkColor.surface2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < values.length; i++) ...[
          _FunnelLane(
            widthFactor: values[i].clamp(0.0, 1.0),
            height: height,
            trackColor: trackColor,
            gradient: LinearGradient(
              colors: [accentColor, color, supportColor],
            ),
            opacity: 0.34 + (i * 0.14),
          ),
          if (i != values.length - 1) SizedBox(height: gap),
        ],
        const SizedBox(height: XkLayout.spacingMd),
        Wrap(
          spacing: XkLayout.spacingMd,
          runSpacing: XkLayout.spacingMd,
          children: [
            _FunnelVariant(
              title: 'Identity only',
              trackColor: trackColor,
              colorA: color,
              colorB: isDark ? XkColor.darkAccentSoft : XkColor.accentSoft,
            ),
            _FunnelVariant(
              title: 'Accent only',
              trackColor: trackColor,
              colorA: accentColor,
              colorB: isDark ? XkColor.darkAccentSoft : XkColor.accentSoft,
            ),
            _FunnelVariant(
              title: 'Support only',
              trackColor: trackColor,
              colorA: supportColor,
              colorB: isDark ? XkColor.darkSuccessSoft : XkColor.successSoft,
            ),
          ],
        ),
      ],
    );
  }
}

class _FunnelLane extends StatelessWidget {
  const _FunnelLane({
    required this.widthFactor,
    required this.height,
    required this.trackColor,
    required this.gradient,
    required this.opacity,
  });

  final double widthFactor;
  final double height;
  final Color trackColor;
  final Gradient gradient;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: XkShape.fullBorderRadius,
          color: trackColor,
        ),
        clipBehavior: Clip.antiAlias,
        child: Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: widthFactor,
            child: Opacity(
              opacity: opacity.clamp(0, 1).toDouble(),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: XkShape.fullBorderRadius,
                  gradient: gradient,
                ),
                child: SizedBox(height: height),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FunnelVariant extends StatelessWidget {
  const _FunnelVariant({
    required this.title,
    required this.trackColor,
    required this.colorA,
    required this.colorB,
  });

  final String title;
  final Color trackColor;
  final Color colorA;
  final Color colorB;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: XkTypo.fieldLabel),
          const SizedBox(height: XkLayout.spacingXs),
          for (final opacity in [0.34, 0.52, 0.72]) ...[
            _FunnelLane(
              widthFactor: opacity == 0.34
                  ? 0.90
                  : opacity == 0.52
                  ? 0.74
                  : 0.56,
              height: 8,
              trackColor: trackColor,
              gradient: LinearGradient(colors: [colorA, colorB]),
              opacity: opacity,
            ),
            if (opacity != 0.72) const SizedBox(height: XkLayout.spacingXs),
          ],
        ],
      ),
    );
  }
}

class XkDomainLayer {
  const XkDomainLayer({
    required this.key,
    required this.title,
    required this.phase,
    required this.description,
    required this.metrics,
    this.tabLabel,
  });

  final String key;
  final String title;
  final String phase;
  final String description;
  final List<MapEntry<String, String>> metrics;
  final String? tabLabel;
}

class XkDomainPatternTabs extends StatefulWidget {
  const XkDomainPatternTabs({
    super.key,
    this.layers = _defaultLayers,
    this.initialKey = 'input',
    this.borderRadius,
  });

  final List<XkDomainLayer> layers;
  final String initialKey;
  final BorderRadiusGeometry? borderRadius;

  // v1.3 labels: 수집 · 분석 · 상태 · 실행 (v1.2 Input/Pattern/State/Action Layer)
  static const List<XkDomainLayer> _defaultLayers = [
    XkDomainLayer(
      key: 'input',
      tabLabel: '1. 수집 · Collect',
      title: '수집 · Collect',
      phase: 'Capture',
      description: '다양한 입력 신호를 동일한 스키마로 정규화해 분석 기준을 안정적으로 맞춥니다.',
      metrics: [
        MapEntry('Input channels', '12'),
        MapEntry('Schema match', '98%'),
        MapEntry('Next', '분석 단계로'),
      ],
    ),
    XkDomainLayer(
      key: 'pattern',
      tabLabel: '2. 분석 · Analyze',
      title: '분석 · Analyze',
      phase: 'Synthesis',
      description: '반복 구간과 변동 구간을 분리해 공통 구조를 만들고 핵심 신호를 정리합니다.',
      metrics: [
        MapEntry('Pattern density', '72'),
        MapEntry('Noise ratio', '+18%'),
        MapEntry('Next', '상태 매핑으로'),
      ],
    ),
    XkDomainLayer(
      key: 'state',
      tabLabel: '3. 상태 · Map',
      title: '상태 · Map',
      phase: 'Mapping',
      description: '상태를 구조화해 변화가 큰 구간과 안정 구간을 동시에 보여줍니다.',
      metrics: [
        MapEntry('State nodes', '34'),
        MapEntry('Stable range', '62%'),
        MapEntry('Next', '실행 단계로'),
      ],
    ),
    XkDomainLayer(
      key: 'action',
      tabLabel: '4. 실행 · Act',
      title: '실행 · Act',
      phase: 'Output',
      description: '최종 상태를 기준으로 우선순위와 실행 포맷을 압축해 단일 뷰로 제공합니다.',
      metrics: [
        MapEntry('Priority slots', '3'),
        MapEntry('Action clarity', '상승'),
        MapEntry('Output', 'Execution brief'),
      ],
    ),
  ];

  @override
  State<XkDomainPatternTabs> createState() => _XkDomainPatternTabsState();
}

class _XkDomainPatternTabsState extends State<XkDomainPatternTabs> {
  late String _selectedKey;

  @override
  void initState() {
    super.initState();
    _selectedKey = widget.initialKey;
  }

  @override
  void didUpdateWidget(covariant XkDomainPatternTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    final validInitial = widget.layers.any((layer) => layer.key == widget.initialKey)
        ? widget.initialKey
        : (widget.layers.isNotEmpty ? widget.layers.first.key : '');
    final currentStillExists = widget.layers.any(
      (layer) => layer.key == _selectedKey,
    );

    if (widget.initialKey != oldWidget.initialKey) {
      _selectedKey = validInitial;
      return;
    }

    if (!currentStillExists) {
      _selectedKey = validInitial;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.layers.isEmpty) {
      return const SizedBox.shrink();
    }

    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final active = widget.layers.firstWhere(
      (layer) => layer.key == _selectedKey,
      orElse: () => widget.layers.first,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: XkLayout.spacingXs,
          runSpacing: XkLayout.spacingXs,
          children: widget.layers.map((layer) {
            final selected = layer.key == active.key;
            return OutlinedButton(
              onPressed: () => setState(() => _selectedKey = layer.key),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 9,
                ),
                backgroundColor: selected
                    ? (isDark ? XkColor.darkAccentSoft : XkColor.accentSoft)
                    : Colors.transparent,
                foregroundColor: selected
                    ? (isDark ? XkColor.darkAccent : XkColor.accentDeep)
                    : (isDark ? XkColor.darkTextBody : XkColor.textBody),
                side: BorderSide(
                  color: selected
                      ? (isDark ? XkColor.darkAccent : XkColor.accent)
                      : (isDark ? XkColor.darkBorder : XkColor.border),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: XkShape.fullBorderRadius,
                ),
                textStyle: XkTypo.buttonLabel,
              ),
              child: Text(layer.tabLabel ?? layer.title),
            );
          }).toList(),
        ),
        const SizedBox(height: XkLayout.spacingSm),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? XkColor.darkSurface : XkColor.surface,
            borderRadius: widget.borderRadius ?? XkShape.mdBorderRadius,
            border: Border.all(
              color: isDark ? XkColor.darkBorderSoft : XkColor.borderSoft,
            ),
            boxShadow: XkShadow.resolve(brightness),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(active.title, style: XkTypo.cardTitle),
                  const SizedBox(width: XkLayout.spacingXs),
                  Text(
                    active.phase,
                    style: XkTypo.metaMono.copyWith(
                      color: isDark ? XkColor.darkTextMuted : XkColor.textMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: XkLayout.spacingXs),
              Text(
                active.description,
                style: XkTypo.cardBody.copyWith(
                  color: isDark ? XkColor.darkTextBody : XkColor.textBody,
                ),
              ),
              const SizedBox(height: XkLayout.spacingSm),
              Wrap(
                spacing: XkLayout.spacingMd,
                runSpacing: XkLayout.spacingXs,
                children: active.metrics.map((metric) {
                  final valueColor = _metricValueColor(
                    metric.key,
                    metric.value,
                    isDark,
                  );
                  return SizedBox(
                    width: 170,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          metric.key,
                          style: XkTypo.bodySmall.copyWith(
                            color: isDark
                                ? XkColor.darkTextBody
                                : XkColor.textBody,
                          ),
                        ),
                        Text(
                          metric.value,
                          style: XkTypo.tableCode.copyWith(color: valueColor),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _metricValueColor(String label, String value, bool isDark) {
    if (label.contains('Schema') || label.contains('clarity')) {
      return isDark ? XkColor.darkSuccess : XkColor.success;
    }
    if (label.contains('Noise')) {
      return isDark ? XkColor.darkWarning : XkColor.warning;
    }
    return isDark ? XkColor.darkTextStrong : XkColor.textStrong;
  }
}
