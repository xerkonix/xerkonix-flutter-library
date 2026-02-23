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
    this.padding = const EdgeInsets.all(XkLayout.spacingMd),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg =
        backgroundColor ?? (isDark ? XkColor.darkSurface : XkColor.surface);
    final bd =
        borderColor ?? (isDark ? XkColor.darkBorderSoft : XkColor.borderSoft);
    final labelColor = isDark ? XkColor.darkTextSoft : XkColor.textSoft;
    final valueColor = isDark ? XkColor.darkText : XkColor.text;
    final deltaColor = isDark ? XkColor.darkTextBody : XkColor.textBody;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: borderRadius ?? XkShape.mdBorderRadius,
        border: Border.all(color: bd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: XkTypo.metaMono.copyWith(
              fontSize: 11,
              color: labelColor,
            ),
          ),
          const SizedBox(height: XkLayout.spacingXs),
          RichText(
            text: TextSpan(
              text: value,
              style: XkTypo.h1.copyWith(fontSize: 32, color: valueColor),
              children: [
                if (suffix != null)
                  TextSpan(
                    text: suffix,
                    style: XkTypo.bodyLarge.copyWith(color: valueColor),
                  ),
              ],
            ),
          ),
          if (delta != null) ...[
            const SizedBox(height: XkLayout.spacingXs),
            Text(
              delta!,
              style: XkTypo.body.copyWith(
                fontSize: 12,
                color: deltaColor,
              ),
            ),
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
    this.height = 10,
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
    final trackColor = isDark ? XkColor.darkSurfaceDeep : XkColor.surfaceDeep;
    final headText = isDark ? XkColor.darkTextBody : XkColor.textBody;
    final valueLabel = valueText ?? '${(ratio * 100).round()}%';
    final s = startColor ?? XkColor.identity;
    final e = endColor ?? XkColor.identitySoft;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: XkTypo.body.copyWith(fontSize: 12, color: headText),
              ),
            ),
            Text(
              valueLabel,
              style: XkTypo.label.copyWith(
                fontSize: 12,
                color: s,
              ),
            ),
          ],
        ),
        const SizedBox(height: XkLayout.spacingXs),
        ClipRRect(
          borderRadius: borderRadius ?? XkShape.fullBorderRadius,
          child: SizedBox(
            height: height,
            child: Stack(
              children: [
                Positioned.fill(
                  child: ColoredBox(color: trackColor),
                ),
                FractionallySizedBox(
                  widthFactor: ratio,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [s, e],
                      ),
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
    this.padding = const EdgeInsets.all(XkLayout.spacingMd),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg =
        backgroundColor ?? (isDark ? XkColor.darkSurface : XkColor.surface);
    final bd =
        borderColor ?? (isDark ? XkColor.darkBorderSoft : XkColor.borderSoft);
    final timeColor = isDark ? XkColor.darkTextSoft : XkColor.textSoft;
    final titleColor = isDark ? XkColor.darkText : XkColor.text;
    final bodyColor = isDark ? XkColor.darkTextBody : XkColor.textBody;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: borderRadius ?? XkShape.mdBorderRadius,
        border: Border.all(color: bd),
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
                      color: items[i].color ?? XkColor.identity,
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
                        style: XkTypo.metaMono.copyWith(
                          fontSize: 10,
                          color: timeColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        items[i].title,
                        style: XkTypo.label.copyWith(
                          fontSize: 12,
                          color: titleColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        items[i].description,
                        style: XkTypo.body.copyWith(
                          fontSize: 12,
                          color: bodyColor,
                        ),
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

class XkSignalOverviewMonitor extends StatefulWidget {
  const XkSignalOverviewMonitor({
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
  State<XkSignalOverviewMonitor> createState() =>
      _XkSignalOverviewMonitorState();
}

class _XkSignalOverviewMonitorState extends State<XkSignalOverviewMonitor>
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
  void didUpdateWidget(covariant XkSignalOverviewMonitor oldWidget) {
    super.didUpdateWidget(oldWidget);
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = widget.backgroundColor ??
        (isDark
            ? XkColor.darkSurface.withValues(alpha: 0.82)
            : XkColor.surface);
    final bd = widget.borderColor ??
        (isDark ? XkColor.darkBorderSoft : XkColor.borderSoft);

    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: widget.borderRadius ?? XkShape.mdBorderRadius,
        border: Border.all(color: bd),
      ),
      clipBehavior: Clip.antiAlias,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _SignalOverviewPainter(
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

class _SignalOverviewPainter extends CustomPainter {
  const _SignalOverviewPainter({
    required this.progress,
    required this.isDark,
  });

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

  static const List<Offset> _stress = [
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
    final grid = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = (isDark ? XkColor.darkBorderSoft : XkColor.borderSoft)
          .withValues(alpha: 0.9);

    for (var i = 1; i <= 4; i++) {
      final y = size.height * i / 5;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    for (var i = 1; i <= 5; i++) {
      final x = size.width * i / 6;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }

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
          XkColor.identity.withValues(alpha: 0.28),
          XkColor.identity.withValues(alpha: 0.02),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(fillPath, fillPaint);

    _drawLine(
        canvas, _stability, size, XkColor.success.withValues(alpha: 0.8), 1.8);
    _drawLine(
        canvas, _stress, size, XkColor.action.withValues(alpha: 0.85), 1.8,
        dashed: true);
    _drawLine(canvas, _engagement, size, XkColor.identity, 2.1);

    final dot = _interpolate(_engagement, progress);
    canvas.drawCircle(
      Offset(dot.dx * size.width, dot.dy * size.height),
      4,
      Paint()..color = XkColor.identity,
    );
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
      const dash = 8.0;
      const gap = 6.0;
      while (distance < metric.length) {
        final end = math.min(distance + dash, metric.length);
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
      lerpDouble(points[index].dx, points[next].dx, local),
      lerpDouble(points[index].dy, points[next].dy, local),
    );
  }

  double lerpDouble(double a, double b, double t) => a + (b - a) * t;

  @override
  bool shouldRepaint(covariant _SignalOverviewPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isDark != isDark;
  }
}

class XkHexagonRadar extends StatelessWidget {
  const XkHexagonRadar({
    super.key,
    this.values = const [0.86, 0.78, 0.71, 0.84, 0.69, 0.76],
    this.size = 220,
    this.color = XkColor.identity,
    this.accentColor = XkColor.action,
  });

  final List<double> values;
  final double size;
  final Color color;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * 0.75,
      child: CustomPaint(
        painter: _HexagonRadarPainter(
          values: values,
          color: color,
          accentColor: accentColor,
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
  });

  final List<double> values;
  final Color color;
  final Color accentColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * 0.42;
    final rings = [1.0, 0.72, 0.44];
    final gridPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = XkColor.borderMid.withValues(alpha: 0.5)
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
        ..color = color.withValues(alpha: 0.2),
    );
    canvas.drawPath(
      valuePath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8
        ..color = color,
    );

    for (var i = 0; i < 6; i++) {
      final p = _vertex(center, radius * safe[i], i);
      canvas.drawCircle(
        p,
        3,
        Paint()..color = i.isOdd ? accentColor : color,
      );
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
        oldDelegate.accentColor != accentColor;
  }
}

class XkClusterMatrix extends StatelessWidget {
  const XkClusterMatrix({
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
    this.baseColor = XkColor.identity,
    this.accentColor = XkColor.action,
  });

  final List<double> values;
  final int columns;
  final double cellSize;
  final double gap;
  final Color baseColor;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: gap,
      runSpacing: gap,
      children: List.generate(values.length, (i) {
        final value = values[i].clamp(0.0, 1.0);
        final isAccent = i % columns == columns - 1 || i % 5 == 0;
        final target = isAccent ? accentColor : baseColor;
        return Container(
          width: cellSize,
          height: cellSize,
          decoration: BoxDecoration(
            color: Color.lerp(XkColor.surface, target, value),
            borderRadius: BorderRadius.circular(XkShape.radiusXs),
          ),
        );
      }),
    );
  }
}

class XkFlowCompression extends StatelessWidget {
  const XkFlowCompression({
    super.key,
    this.values = const [0.92, 0.76, 0.58, 0.40, 0.24],
    this.height = 10,
    this.gap = 10,
    this.color = XkColor.identity,
  });

  final List<double> values;
  final double height;
  final double gap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < values.length; i++) ...[
          Row(
            children: [
              Expanded(
                child: Container(
                  height: height,
                  decoration: BoxDecoration(
                    borderRadius: XkShape.fullBorderRadius,
                    color: XkColor.surfaceSoft,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: values[i].clamp(0.0, 1.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: XkShape.fullBorderRadius,
                          color: color.withValues(alpha: 0.36 + (i * 0.14)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (i != values.length - 1) SizedBox(height: gap),
        ],
      ],
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
  });

  final String key;
  final String title;
  final String phase;
  final String description;
  final List<MapEntry<String, String>> metrics;
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

  static const List<XkDomainLayer> _defaultLayers = [
    XkDomainLayer(
      key: 'input',
      title: 'Input Pattern',
      phase: 'Capture',
      description: '다양한 입력 신호를 동일한 스키마로 정규화해 분석 기준을 안정적으로 맞춥니다.',
      metrics: [
        MapEntry('Input channels', '12'),
        MapEntry('Schema match', '98%'),
        MapEntry('Next', 'Pattern synthesis'),
      ],
    ),
    XkDomainLayer(
      key: 'pattern',
      title: 'Pattern Layer',
      phase: 'Synthesis',
      description: '반복 구간과 변동 구간을 분리해 공통 구조를 만들고 핵심 신호를 정리합니다.',
      metrics: [
        MapEntry('Pattern density', '72'),
        MapEntry('Noise ratio', '+18%'),
        MapEntry('Next', 'State mapping'),
      ],
    ),
    XkDomainLayer(
      key: 'state',
      title: 'State Layer',
      phase: 'Mapping',
      description: '상태를 구조화해 변화가 큰 구간과 안정 구간을 동시에 보여줍니다.',
      metrics: [
        MapEntry('State nodes', '34'),
        MapEntry('Stable range', '61.7%'),
        MapEntry('Next', 'Action compression'),
      ],
    ),
    XkDomainLayer(
      key: 'action',
      title: 'Action Pattern',
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
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
                backgroundColor: selected
                    ? (isDark ? XkColor.darkIdentityWash : XkColor.identityWash)
                    : Colors.transparent,
                side: BorderSide(
                  color: selected
                      ? XkColor.identity
                      : (isDark ? XkColor.darkBorderMid : XkColor.borderMid),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: XkShape.fullBorderRadius,
                ),
              ),
              child: Text(layer.title),
            );
          }).toList(),
        ),
        const SizedBox(height: XkLayout.spacingSm),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(XkLayout.spacingMd),
          decoration: BoxDecoration(
            color: isDark ? XkColor.darkSurface : XkColor.surface,
            borderRadius: widget.borderRadius ?? XkShape.mdBorderRadius,
            border: Border.all(
              color: isDark ? XkColor.darkBorderSoft : XkColor.borderSoft,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(active.title, style: XkTypo.h3.copyWith(fontSize: 18)),
                  const SizedBox(width: XkLayout.spacingXs),
                  Text(
                    active.phase,
                    style: XkTypo.metaMono.copyWith(
                      color: isDark ? XkColor.darkTextSoft : XkColor.textSoft,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: XkLayout.spacingXs),
              Text(
                active.description,
                style: XkTypo.body.copyWith(
                  fontSize: 12,
                  color: isDark ? XkColor.darkTextBody : XkColor.textBody,
                ),
              ),
              const SizedBox(height: XkLayout.spacingSm),
              for (final metric in active.metrics) ...[
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        metric.key,
                        style: XkTypo.metaMono.copyWith(
                          fontSize: 11,
                          color:
                              isDark ? XkColor.darkTextSoft : XkColor.textSoft,
                        ),
                      ),
                    ),
                    Text(
                      metric.value,
                      style: XkTypo.label.copyWith(fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
