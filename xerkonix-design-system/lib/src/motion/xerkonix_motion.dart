import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../palette/color.dart';
import '../shape/xerkonix_shape.dart';

/// Motion token values from Weave reference.
class XkMotionToken {
  XkMotionToken._();

  static const Duration observe = Duration(milliseconds: 160);
  static const Duration interpret = Duration(milliseconds: 230);
  static const Duration connect = Duration(milliseconds: 300);

  static const Duration statusBreath = Duration(milliseconds: 2600);
  static const Duration signalSweep = Duration(milliseconds: 2600);
  static const Duration waveDrift = Duration(milliseconds: 3800);
  static const Duration focusRipple = Duration(milliseconds: 2200);
  static const Duration cardSettle = Duration(milliseconds: 2800);
  static const Duration alertBeat = Duration(milliseconds: 1900);

  static const Curve ease = Cubic(0.2, 0, 0.1, 1);
  static const Curve spring = Cubic(0.34, 1.35, 0.64, 1);
}

/// Motion API surface for package users.
class XkMotion {
  XkMotion._();

  /// Existing API 유지: 밝기 기반 숨쉬기 효과.
  static Widget breathingLight({
    Duration duration = XkMotionToken.statusBreath,
    double minOpacity = 0.35,
    double maxOpacity = 1.0,
    Color? color,
    bool respectReducedMotion = true,
    required Widget child,
  }) {
    return _BreathingLight(
      duration: duration,
      minOpacity: minOpacity,
      maxOpacity: maxOpacity,
      color: color ?? XkColor.identity,
      respectReducedMotion: respectReducedMotion,
      child: child,
    );
  }

  /// Existing API 유지: 색상 펄스 효과.
  static Widget pulse({
    Duration duration = XkMotionToken.alertBeat,
    Curve curve = XkMotionToken.ease,
    Color? primaryColor,
    Color? secondaryColor,
    bool respectReducedMotion = true,
    required Widget child,
  }) {
    return _PulseAnimation(
      duration: duration,
      curve: curve,
      primaryColor: primaryColor ?? XkColor.identity,
      secondaryColor: secondaryColor ?? XkColor.signal,
      respectReducedMotion: respectReducedMotion,
      child: child,
    );
  }

  static Widget statusBreath({
    Duration duration = XkMotionToken.statusBreath,
    Color color = XkColor.identity,
    double size = 16,
    bool respectReducedMotion = true,
  }) {
    return XkStatusBreath(
      duration: duration,
      color: color,
      size: size,
      respectReducedMotion: respectReducedMotion,
    );
  }

  static Widget signalSweep({
    Duration duration = XkMotionToken.signalSweep,
    Color color = XkColor.identity,
    double width = 186,
    bool respectReducedMotion = true,
  }) {
    return XkSignalSweep(
      duration: duration,
      color: color,
      width: width,
      respectReducedMotion: respectReducedMotion,
    );
  }

  static Widget waveDrift({
    Duration duration = XkMotionToken.waveDrift,
    Color color = XkColor.identity,
    bool respectReducedMotion = true,
  }) {
    return XkWaveDrift(
      duration: duration,
      color: color,
      respectReducedMotion: respectReducedMotion,
    );
  }

  static Widget focusRipple({
    Duration duration = XkMotionToken.focusRipple,
    Color color = XkColor.identity,
    bool respectReducedMotion = true,
  }) {
    return XkFocusRipple(
      duration: duration,
      color: color,
      respectReducedMotion: respectReducedMotion,
    );
  }

  static Widget cardSettle({
    Duration duration = XkMotionToken.cardSettle,
    Widget? child,
    bool respectReducedMotion = true,
  }) {
    return XkCardSettle(
      duration: duration,
      child: child,
      respectReducedMotion: respectReducedMotion,
    );
  }

  static Widget alertBeat({
    Duration duration = XkMotionToken.alertBeat,
    Color color = XkColor.action,
    bool respectReducedMotion = true,
  }) {
    return XkAlertBeat(
      duration: duration,
      color: color,
      respectReducedMotion: respectReducedMotion,
    );
  }
}

/// HTML reference: Status Breath
class XkStatusBreath extends StatelessWidget {
  const XkStatusBreath({
    super.key,
    this.duration = XkMotionToken.statusBreath,
    this.size = 16,
    this.color = XkColor.identity,
    this.minScale = 0.8,
    this.maxScale = 1.22,
    this.minOpacity = 0.45,
    this.maxOpacity = 1,
    this.respectReducedMotion = true,
  });

  final Duration duration;
  final double size;
  final Color color;
  final double minScale;
  final double maxScale;
  final double minOpacity;
  final double maxOpacity;
  final bool respectReducedMotion;

  @override
  Widget build(BuildContext context) {
    return _XkLoopMotion(
      duration: duration,
      curve: Curves.easeInOut,
      respectReducedMotion: respectReducedMotion,
      builder: (context, value, reducedMotion) {
        final t = 0.5 - math.cos(value * math.pi * 2) / 2;
        final scale =
            reducedMotion ? 1.0 : (minScale + (maxScale - minScale) * t);
        final opacity =
            reducedMotion ? 1.0 : (minOpacity + (maxOpacity - minOpacity) * t);

        return Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: opacity,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// HTML reference: Signal Sweep
class XkSignalSweep extends StatelessWidget {
  const XkSignalSweep({
    super.key,
    this.duration = XkMotionToken.signalSweep,
    this.width = 186,
    this.trackHeight = 5,
    this.dotSize = 11,
    this.color = XkColor.identity,
    this.respectReducedMotion = true,
  });

  final Duration duration;
  final double width;
  final double trackHeight;
  final double dotSize;
  final Color color;
  final bool respectReducedMotion;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final trackColor = isDark
        ? XkColor.darkTextBody.withValues(alpha: 0.14)
        : XkColor.textBody.withValues(alpha: 0.12);

    return _XkLoopMotion(
      duration: duration,
      curve: Curves.linear,
      respectReducedMotion: respectReducedMotion,
      builder: (context, value, reducedMotion) {
        final travel = reducedMotion ? 0.5 : value;
        final left = -dotSize / 2 + (width + dotSize / 2) * travel;

        return SizedBox(
          width: width,
          height: math.max(trackHeight, dotSize),
          child: Stack(
            alignment: Alignment.centerLeft,
            clipBehavior: Clip.none,
            children: [
              Container(
                width: width,
                height: trackHeight,
                decoration: BoxDecoration(
                  borderRadius: XkShape.fullBorderRadius,
                  color: trackColor,
                ),
              ),
              Positioned(
                left: left,
                child: Container(
                  width: dotSize,
                  height: dotSize,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// HTML reference: Wave Drift
class XkWaveDrift extends StatelessWidget {
  const XkWaveDrift({
    super.key,
    this.duration = XkMotionToken.waveDrift,
    this.width = 192,
    this.height = 40,
    this.color = XkColor.identity,
    this.respectReducedMotion = true,
  });

  final Duration duration;
  final double width;
  final double height;
  final Color color;
  final bool respectReducedMotion;

  @override
  Widget build(BuildContext context) {
    return _XkLoopMotion(
      duration: duration,
      curve: Curves.linear,
      respectReducedMotion: respectReducedMotion,
      builder: (context, value, reducedMotion) {
        return CustomPaint(
          size: Size(width, height),
          painter: _WaveDriftPainter(
            color: color,
            phase: reducedMotion ? 0 : (value * 102),
          ),
        );
      },
    );
  }
}

class _WaveDriftPainter extends CustomPainter {
  const _WaveDriftPainter({
    required this.color,
    required this.phase,
  });

  final Color color;
  final double phase;

  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / 160;
    final sy = size.height / 28;

    final path = Path()
      ..moveTo(0 * sx, 14 * sy)
      ..cubicTo(10 * sx, 14 * sy, 14 * sx, 6 * sy, 24 * sx, 6 * sy)
      ..cubicTo(34 * sx, 6 * sy, 38 * sx, 18 * sy, 48 * sx, 18 * sy)
      ..cubicTo(58 * sx, 18 * sy, 62 * sx, 8 * sy, 72 * sx, 8 * sy)
      ..cubicTo(82 * sx, 8 * sy, 86 * sx, 18 * sy, 96 * sx, 18 * sy)
      ..cubicTo(106 * sx, 18 * sy, 110 * sx, 10 * sy, 120 * sx, 10 * sy)
      ..cubicTo(130 * sx, 10 * sy, 134 * sx, 16 * sy, 144 * sx, 16 * sy)
      ..cubicTo(152 * sx, 16 * sy, 156 * sx, 12 * sy, 160 * sx, 12 * sy);

    final dashedPath = _dashPath(path, dash: 10, gap: 7, phase: phase);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..color = color;

    canvas.drawPath(dashedPath, paint);
  }

  Path _dashPath(
    Path source, {
    required double dash,
    required double gap,
    required double phase,
  }) {
    final result = Path();
    final step = dash + gap;

    for (final metric in source.computeMetrics()) {
      var distance = -phase;
      while (distance < metric.length) {
        final start = _clamp(distance, 0, metric.length);
        final end = _clamp(distance + dash, 0, metric.length);
        if (end > start) {
          result.addPath(metric.extractPath(start, end), Offset.zero);
        }
        distance += step;
      }
    }

    return result;
  }

  double _clamp(double value, double min, double max) {
    if (value < min) {
      return min;
    }
    if (value > max) {
      return max;
    }
    return value;
  }

  @override
  bool shouldRepaint(covariant _WaveDriftPainter oldDelegate) {
    return oldDelegate.phase != phase || oldDelegate.color != color;
  }
}

/// HTML reference: Focus Ripple
class XkFocusRipple extends StatelessWidget {
  const XkFocusRipple({
    super.key,
    this.duration = XkMotionToken.focusRipple,
    this.size = 64,
    this.dotSize = 14,
    this.color = XkColor.identity,
    this.respectReducedMotion = true,
  });

  final Duration duration;
  final double size;
  final double dotSize;
  final Color color;
  final bool respectReducedMotion;

  @override
  Widget build(BuildContext context) {
    return _XkLoopMotion(
      duration: duration,
      curve: Curves.easeOut,
      respectReducedMotion: respectReducedMotion,
      builder: (context, value, reducedMotion) {
        final p1 = reducedMotion ? 0.0 : value;
        final p2 = reducedMotion ? 0.0 : ((value + 0.5) % 1.0);

        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _RippleRing(color: color, progress: p1, maxOpacity: 0.58),
              _RippleRing(color: color, progress: p2, maxOpacity: 0.58),
              Container(
                width: dotSize,
                height: dotSize,
                decoration: BoxDecoration(shape: BoxShape.circle, color: color),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RippleRing extends StatelessWidget {
  const _RippleRing({
    required this.color,
    required this.progress,
    required this.maxOpacity,
  });

  final Color color;
  final double progress;
  final double maxOpacity;

  @override
  Widget build(BuildContext context) {
    final scale = 0.5 + (2.2 - 0.5) * progress;
    final opacity = (1 - progress) * maxOpacity;

    return Transform.scale(
      scale: scale,
      child: Opacity(
        opacity: opacity,
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              width: 1,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}

/// HTML reference: Card Settle
class XkCardSettle extends StatelessWidget {
  const XkCardSettle({
    super.key,
    this.duration = XkMotionToken.cardSettle,
    this.child,
    this.respectReducedMotion = true,
  });

  final Duration duration;
  final Widget? child;
  final bool respectReducedMotion;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return _XkLoopMotion(
      duration: duration,
      curve: XkMotionToken.ease,
      respectReducedMotion: respectReducedMotion,
      builder: (context, value, reducedMotion) {
        final t = reducedMotion
            ? 1.0
            : (value <= 0.35 ? Curves.ease.transform(value / 0.35) : 1.0);
        final translateY = 7 * (1 - t);
        final scale = 0.97 + (1 - 0.97) * t;
        final opacity = 0.55 + (1 - 0.55) * t;

        final content = child ??
            Container(
              width: 120,
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDark ? XkColor.darkBorderMid : XkColor.borderMid,
                ),
                color: isDark ? XkColor.darkSurface : XkColor.surface,
              ),
            );

        return Transform.translate(
          offset: Offset(0, translateY),
          child: Transform.scale(
            scale: scale,
            child: Opacity(
              opacity: opacity,
              child: content,
            ),
          ),
        );
      },
    );
  }
}

/// HTML reference: Alert Beat
class XkAlertBeat extends StatelessWidget {
  const XkAlertBeat({
    super.key,
    this.duration = XkMotionToken.alertBeat,
    this.size = 72,
    this.dotSize = 16,
    this.color = XkColor.action,
    this.respectReducedMotion = true,
  });

  final Duration duration;
  final double size;
  final double dotSize;
  final Color color;
  final bool respectReducedMotion;

  @override
  Widget build(BuildContext context) {
    return _XkLoopMotion(
      duration: duration,
      curve: Curves.easeInOut,
      respectReducedMotion: respectReducedMotion,
      builder: (context, value, reducedMotion) {
        final p1 = reducedMotion ? 0.0 : value;
        final p2 = reducedMotion ? 0.0 : ((value + 0.35) % 1.0);

        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _AlertRing(color: color, progress: p1, maxOpacity: 0.45),
              _AlertRing(color: color, progress: p2, maxOpacity: 0.25),
              Container(
                width: dotSize,
                height: dotSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AlertRing extends StatelessWidget {
  const _AlertRing({
    required this.color,
    required this.progress,
    required this.maxOpacity,
  });

  final Color color;
  final double progress;
  final double maxOpacity;

  @override
  Widget build(BuildContext context) {
    final scale = 1 + ((31 / 16) * progress);
    final opacity = (1 - progress) * maxOpacity;

    return Transform.scale(
      scale: scale,
      child: Opacity(
        opacity: opacity,
        child: Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 1.6),
          ),
        ),
      ),
    );
  }
}

class _XkLoopMotion extends StatefulWidget {
  const _XkLoopMotion({
    required this.duration,
    required this.curve,
    required this.builder,
    required this.respectReducedMotion,
  });

  final Duration duration;
  final Curve curve;
  final Widget Function(BuildContext context, double value, bool reducedMotion)
      builder;
  final bool respectReducedMotion;

  @override
  State<_XkLoopMotion> createState() => _XkLoopMotionState();
}

class _XkLoopMotionState extends State<_XkLoopMotion>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this)
      ..repeat();
    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reducedMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (widget.respectReducedMotion && reducedMotion) {
      return widget.builder(context, 0.5, true);
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) => widget.builder(context, _animation.value, false),
    );
  }
}

class _BreathingLight extends StatefulWidget {
  const _BreathingLight({
    required this.child,
    required this.duration,
    required this.minOpacity,
    required this.maxOpacity,
    required this.color,
    required this.respectReducedMotion,
  });

  final Widget child;
  final Duration duration;
  final double minOpacity;
  final double maxOpacity;
  final Color color;
  final bool respectReducedMotion;

  @override
  State<_BreathingLight> createState() => _BreathingLightState();
}

class _BreathingLightState extends State<_BreathingLight>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: widget.minOpacity,
      end: widget.maxOpacity,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: XkMotionToken.ease,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reducedMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (widget.respectReducedMotion && reducedMotion) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return Opacity(
          opacity: _animation.value,
          child: widget.child,
        );
      },
    );
  }
}

class _PulseAnimation extends StatefulWidget {
  const _PulseAnimation({
    required this.child,
    required this.duration,
    required this.curve,
    required this.primaryColor,
    required this.secondaryColor,
    required this.respectReducedMotion,
  });

  final Widget child;
  final Duration duration;
  final Curve curve;
  final Color primaryColor;
  final Color secondaryColor;
  final bool respectReducedMotion;

  @override
  State<_PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<_PulseAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _blend(Color color1, Color color2, double ratio) {
    return Color.lerp(color1, color2, ratio) ?? color2;
  }

  @override
  Widget build(BuildContext context) {
    final reducedMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (widget.respectReducedMotion && reducedMotion) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        final blendedColor = _blend(
          widget.primaryColor,
          widget.secondaryColor,
          _animation.value,
        );

        return ColorFiltered(
          colorFilter: ColorFilter.mode(blendedColor, BlendMode.modulate),
          child: widget.child,
        );
      },
    );
  }
}
