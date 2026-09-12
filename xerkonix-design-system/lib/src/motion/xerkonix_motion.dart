import 'package:flutter/material.dart';

import '../palette/color.dart';
import '../shape/xerkonix_shape.dart';

/// Motion tokens from tokens.css v4.0.0.
///
/// `--t-state` .9s · `--t-hover` .25s · `--ease-out` · `--ease-sweep`.
class XkMotionToken {
  XkMotionToken._();

  static const Duration hover = Duration(milliseconds: 250);
  static const Duration state = Duration(milliseconds: 900);
  static const Duration sweep = Duration(seconds: 6);
  static const Duration loader = Duration(milliseconds: 1400);

  /// v3 aliases.
  @Deprecated('Use XkMotionToken.hover')
  static const Duration observe = hover;
  @Deprecated('Use XkMotionToken.hover')
  static const Duration resolve = hover;
  @Deprecated('Use XkMotionToken.state')
  static const Duration settle = state;

  @Deprecated('Removed in v4 — no pulse')
  static const Duration statusPulse = Duration(milliseconds: 0);
  @Deprecated('Removed in v4 — sweep lives on gem only')
  static const Duration signalSweep = sweep;
  @Deprecated('Removed in v4')
  static const Duration rhythmLine = Duration(milliseconds: 0);
  @Deprecated('Removed in v4')
  static const Duration focusRipple = Duration(milliseconds: 0);
  @Deprecated('Removed in v4')
  static const Duration cardSettle = state;
  @Deprecated('Removed in v4 — no pulse')
  static const Duration alertPulse = Duration(milliseconds: 0);

  /// `--ease-out`: cubic-bezier(.2,.8,.2,1)
  static const Curve easeOut = Cubic(0.2, 0.8, 0.2, 1);

  /// `--ease-sweep`: cubic-bezier(.4,0,.5,1)
  static const Curve easeSweep = Cubic(0.4, 0, 0.5, 1);

  @Deprecated('Use XkMotionToken.easeOut')
  static const Curve ease = easeOut;

  /// v3 spring — empty compat, maps to ease-out (no bounce).
  @Deprecated('Use XkMotionToken.easeOut — bounce/spring is gone')
  static const Curve spring = easeOut;
}

/// Motion API. Sweep is gem-only; loaders are LTR bars.
class XkMotion {
  XkMotion._();

  static const Duration hover = XkMotionToken.hover;
  static const Duration state = XkMotionToken.state;

  @Deprecated('Use XkMotion.hover')
  static const Duration observe = hover;
  @Deprecated('Use XkMotion.hover')
  static const Duration resolve = hover;
  @Deprecated('Use XkMotion.state')
  static const Duration settle = state;

  /// v3 breathing — returns [child] unchanged (pulse is gone).
  static Widget breathingLight({
    Duration duration = XkMotionToken.hover,
    double minOpacity = 0.35,
    double maxOpacity = 1.0,
    Color? color,
    bool respectReducedMotion = true,
    required Widget child,
  }) {
    return child;
  }

  /// v3 pulse — returns [child] unchanged.
  static Widget pulse({
    Duration duration = XkMotionToken.hover,
    Curve curve = XkMotionToken.easeOut,
    Color? primaryColor,
    Color? secondaryColor,
    bool respectReducedMotion = true,
    required Widget child,
  }) {
    return child;
  }

  static Widget statusPulse({
    Duration duration = XkMotionToken.hover,
    Color color = XkColor.aquaMid,
    double size = 16,
    bool respectReducedMotion = true,
  }) {
    return XkStatusPulse(
      duration: duration,
      color: color,
      size: size,
      respectReducedMotion: respectReducedMotion,
    );
  }

  static Widget signalSweep({
    Duration duration = XkMotionToken.loader,
    Color color = XkColor.aquaMid,
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

  static Widget rhythmLine({
    Duration duration = XkMotionToken.hover,
    Color color = XkColor.aquaMid,
    bool respectReducedMotion = true,
  }) {
    return XkRhythmLine(
      duration: duration,
      color: color,
      respectReducedMotion: respectReducedMotion,
    );
  }

  static Widget focusRipple({
    Duration duration = XkMotionToken.hover,
    Color color = XkColor.aquaMid,
    bool respectReducedMotion = true,
  }) {
    return XkFocusRipple(
      duration: duration,
      color: color,
      respectReducedMotion: respectReducedMotion,
    );
  }

  static Widget cardSettle({
    Duration duration = XkMotionToken.state,
    Widget? child,
    bool respectReducedMotion = true,
  }) {
    return XkCardSettle(
      duration: duration,
      respectReducedMotion: respectReducedMotion,
      child: child,
    );
  }

  static Widget alertPulse({
    Duration duration = XkMotionToken.hover,
    Color color = XkColor.bad,
    bool respectReducedMotion = true,
  }) {
    return XkAlertPulse(
      duration: duration,
      color: color,
      respectReducedMotion: respectReducedMotion,
    );
  }
}

/// Static status dot — pulse loops are gone in v4.
class XkStatusPulse extends StatelessWidget {
  const XkStatusPulse({
    super.key,
    this.duration = XkMotionToken.hover,
    this.size = 16,
    this.color = XkColor.aquaMid,
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
    final Color ink = XkColor.themed(color, Theme.of(context).brightness);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: ink),
    );
  }
}

/// LTR loader bar on a `--rule` track. Replaces the v3 traveling-dot sweep.
class XkSignalSweep extends StatelessWidget {
  const XkSignalSweep({
    super.key,
    this.duration = XkMotionToken.loader,
    this.width = 186,
    this.trackHeight = 2,
    this.dotSize = 11,
    this.color = XkColor.aquaMid,
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
    return SizedBox(
      width: width,
      child: XkLoader(
        duration: duration,
        respectReducedMotion: respectReducedMotion,
        color: color,
      ),
    );
  }
}

/// Static rhythm line — infinite dash drift is gone.
class XkRhythmLine extends StatelessWidget {
  const XkRhythmLine({
    super.key,
    this.duration = XkMotionToken.hover,
    this.width = 192,
    this.height = 40,
    this.color = XkColor.aquaMid,
    this.respectReducedMotion = true,
  });

  final Duration duration;
  final double width;
  final double height;
  final Color color;
  final bool respectReducedMotion;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _StaticLinePainter(
          color: XkColor.themed(color, Theme.of(context).brightness),
        ),
      ),
    );
  }
}

class _StaticLinePainter extends CustomPainter {
  const _StaticLinePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..color = color;
    final double y = size.height / 2;
    canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
  }

  @override
  bool shouldRepaint(covariant _StaticLinePainter oldDelegate) =>
      oldDelegate.color != color;
}

/// Static focus mark — ripple loops are gone.
class XkFocusRipple extends StatelessWidget {
  const XkFocusRipple({
    super.key,
    this.duration = XkMotionToken.hover,
    this.size = 64,
    this.dotSize = 14,
    this.color = XkColor.aquaMid,
    this.respectReducedMotion = true,
  });

  final Duration duration;
  final double size;
  final double dotSize;
  final Color color;
  final bool respectReducedMotion;

  @override
  Widget build(BuildContext context) {
    final Color ink = XkColor.themed(color, Theme.of(context).brightness);
    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: Container(
          width: dotSize,
          height: dotSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 1.5, color: ink),
          ),
        ),
      ),
    );
  }
}

/// One-shot card entry (`--t-state`). No loop, no scale.
class XkCardSettle extends StatelessWidget {
  const XkCardSettle({
    super.key,
    this.duration = XkMotionToken.state,
    this.child,
    this.respectReducedMotion = true,
  });

  final Duration duration;
  final Widget? child;
  final bool respectReducedMotion;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Widget content = child ??
        Container(
          width: 120,
          height: 64,
          decoration: BoxDecoration(
            borderRadius: XkRadius.cardBorderRadius,
            border: Border.all(color: XkColor.ruleOf(Theme.of(context).brightness)),
            color: isDark ? XkColor.darkGroundHi : XkColor.groundHi,
          ),
        );
    return content;
  }
}

/// Static alert mark — pulse loops are gone.
class XkAlertPulse extends StatelessWidget {
  const XkAlertPulse({
    super.key,
    this.duration = XkMotionToken.hover,
    this.size = 72,
    this.dotSize = 16,
    this.color = XkColor.bad,
    this.respectReducedMotion = true,
  });

  final Duration duration;
  final double size;
  final double dotSize;
  final Color color;
  final bool respectReducedMotion;

  @override
  Widget build(BuildContext context) {
    final Color ink = XkColor.themed(color, Theme.of(context).brightness);
    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: Container(
          width: dotSize,
          height: dotSize,
          decoration: BoxDecoration(shape: BoxShape.circle, color: ink),
        ),
      ),
    );
  }
}

/// `.x-loader` — `--rule` track, `--aqua-mid` bar left → right 1.4s.
///
/// No infinite spin. Reduced motion / disableAnimations freezes the bar.
class XkLoader extends StatefulWidget {
  const XkLoader({
    super.key,
    this.duration = XkMotionToken.loader,
    this.color,
    this.respectReducedMotion = true,
    this.height = 2,
    this.semanticLabel,
  });

  final Duration duration;
  final Color? color;
  final bool respectReducedMotion;
  final double height;
  final String? semanticLabel;

  @override
  State<XkLoader> createState() => _XkLoaderState();
}

class _XkLoaderState extends State<XkLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
  }

  @override
  void didUpdateWidget(covariant XkLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
      if (_controller.isAnimating) {
        _controller.repeat();
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
    final Brightness brightness = Theme.of(context).brightness;
    final Color track = XkColor.ruleOf(brightness);
    final Color fill =
        widget.color ?? XkColor.aquaMidOf(brightness);
    final bool reduced = widget.respectReducedMotion &&
        (MediaQuery.maybeOf(context)?.disableAnimations ?? false);

    if (reduced) {
      if (_controller.isAnimating) {
        _controller.stop();
      }
      return Semantics(
        label: widget.semanticLabel,
        child: _LoaderTrack(
          height: widget.height,
          track: track,
          fill: fill,
          t: 0.35,
        ),
      );
    }

    if (!_controller.isAnimating) {
      _controller.repeat();
    }
    return Semantics(
      label: widget.semanticLabel,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? _) {
          return _LoaderTrack(
            height: widget.height,
            track: track,
            fill: fill,
            t: _controller.value,
          );
        },
      ),
    );
  }
}

class _LoaderTrack extends StatelessWidget {
  const _LoaderTrack({
    required this.height,
    required this.track,
    required this.fill,
    required this.t,
  });

  final double height;
  final Color track;
  final Color fill;
  final double t;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: track,
          borderRadius: BorderRadius.circular(height / 2),
        ),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints c) {
            final double bar = c.maxWidth * 0.28;
            // 0: fully left of track, 1: fully right (translateX 360% in CSS).
            final double x = (c.maxWidth + bar) * t - bar;
            return Stack(
              children: <Widget>[
                Positioned(
                  left: x,
                  top: 0,
                  bottom: 0,
                  width: bar,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: fill,
                      borderRadius: BorderRadius.circular(height / 2),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
