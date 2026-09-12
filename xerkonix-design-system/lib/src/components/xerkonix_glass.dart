import 'dart:ui';

import 'package:flutter/material.dart';

import '../motion/xerkonix_motion.dart';
import '../palette/color.dart';
import '../shape/xerkonix_shape.dart';

/// Canvas ground — one top-left radial (`--ground-hi` → `--canvas`).
class XkGround extends StatelessWidget {
  const XkGround({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final Brightness b = Theme.of(context).brightness;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: XkColor.canvasOf(b),
        gradient: RadialGradient(
          center: const Alignment(-1, -1),
          radius: 1.1,
          colors: <Color>[XkColor.groundHiOf(b), XkColor.canvasOf(b)],
          stops: const <double>[0, 0.62],
        ),
      ),
      child: child,
    );
  }
}

/// Thin planar glass: role fill + two radials + single edge. No 135° linear.
class XkGlass extends StatelessWidget {
  const XkGlass({
    super.key,
    required this.child,
    this.borderRadius,
    this.padding,
    this.width,
    this.height,
    this.ctl = false,
    this.onTap,
    this.semanticLabel,
  });

  final Widget child;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final bool ctl;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final Brightness b = Theme.of(context).brightness;
    final BorderRadius radius = borderRadius ??
        (ctl ? XkRadius.ctlBorderRadius : XkRadius.panelBorderRadius);
    final List<BoxShadow> shadows =
        ctl ? XkShadow.ctl(b) : XkShadow.glass(b);

    final Color fill =
        ctl ? XkColor.glassActionOf(b) : XkColor.glassOf(b);
    final double blur = ctl ? 8 : 36;
    Widget surface = DecoratedBox(
      decoration: BoxDecoration(borderRadius: radius, boxShadow: shadows),
      child: ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: fill,
                  borderRadius: radius,
                  border: Border.all(color: XkColor.planeEdgeOf(b)),
                ),
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: radius,
                    gradient: RadialGradient(
                      center: const Alignment(-0.8, -2.3),
                      radius: 1.4,
                      colors: <Color>[
                        XkColor.glossSheenOf(b),
                        XkColor.glossSheenOf(b).withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: radius,
                    gradient: RadialGradient(
                      center: const Alignment(1.1, 1.7),
                      radius: 1.3,
                      colors: <Color>[
                        XkColor.glossLowOf(b).withValues(alpha: 0.17),
                        XkColor.glossLowOf(b).withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: padding ??
                  (ctl
                      ? const EdgeInsets.symmetric(horizontal: 24, vertical: 12)
                      : const EdgeInsets.all(XkLayout.spacingMd)),
              child: child,
            ),
          ],
        ),
      ),
      ),
    );

    surface = SizedBox(width: width, height: height, child: surface);

    if (onTap == null) {
      return surface;
    }
    return Semantics(
      button: true,
      label: semanticLabel,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(onTap: onTap, child: surface),
      ),
    );
  }
}

/// Panel-inside inset (`--inset-bg` + `--rule` ring).
class XkInset extends StatelessWidget {
  const XkInset({
    super.key,
    required this.child,
    this.borderRadius,
    this.padding,
    this.width,
    this.height,
  });

  final Widget child;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final Brightness b = Theme.of(context).brightness;
    final BorderRadius radius = borderRadius ?? XkRadius.insetBorderRadius;
    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: XkColor.insetBgOf(b),
          borderRadius: radius,
          border: Border.all(color: XkColor.ruleOf(b)),
        ),
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: child,
        ),
      ),
    );
  }
}

/// Selected state: `--aqua-tint` 30% fill + `--aqua-mid` 1px ring.
class XkSelected extends StatelessWidget {
  const XkSelected({
    super.key,
    required this.child,
    this.borderRadius,
    this.padding,
    this.selected = true,
  });

  final Widget child;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final Brightness b = Theme.of(context).brightness;
    final BorderRadius radius = borderRadius ?? XkRadius.insetBorderRadius;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: selected ? XkColor.selectedFill(b) : null,
        borderRadius: radius,
        boxShadow: selected
            ? <BoxShadow>[
                BoxShadow(
                  color: XkColor.aquaMidOf(b),
                  offset: Offset.zero,
                  blurRadius: 0,
                  spreadRadius: 0,
                ),
              ]
            : null,
        border: selected
            ? Border.all(color: XkColor.aquaMidOf(b))
            : Border.all(color: XkColor.ruleOf(b).withValues(alpha: 0)),
      ),
      child: Padding(padding: padding ?? EdgeInsets.zero, child: child),
    );
  }
}

/// Tag / badge / chip outline: 11px · 6px · `--rule` · `--ink-2`.
class XkTag extends StatelessWidget {
  const XkTag({
    super.key,
    required this.label,
    this.flag = false,
    this.onTap,
  });

  final String label;
  final bool flag;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Brightness b = Theme.of(context).brightness;
    final Color ink = flag ? XkColor.aquaDeepOf(b) : XkColor.ink2Of(b);
    final Color border = flag
        ? XkColor.aquaOf(b).withValues(alpha: 0.50)
        : XkColor.ruleOf(b);
    final Color? fill =
        flag ? XkColor.aquaTintOf(b).withValues(alpha: 0.45) : null;
    final Widget body = DecoratedBox(
      decoration: BoxDecoration(
        color: fill,
        borderRadius: XkRadius.tagBorderRadius,
        border: Border.all(color: border),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Pretendard',
            package: 'xerkonix_design_system',
            fontSize: 11,
            height: 1.4,
            color: ink,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
    if (onTap == null) {
      return body;
    }
    return GestureDetector(onTap: onTap, child: body);
  }
}

/// One-way 108° sweep overlay for gem buttons. Disabled / reduced-motion: none.
class XkGemSweep extends StatefulWidget {
  const XkGemSweep({
    super.key,
    required this.enabled,
    this.duration = XkMotionToken.sweep,
  });

  final bool enabled;
  final Duration duration;

  @override
  State<XkGemSweep> createState() => _XkGemSweepState();
}

/// 1px inner highlight on the lit (top-left) edge.
class XkInsetShadowPainter extends CustomPainter {
  const XkInsetShadowPainter({
    required this.borderRadius,
    required this.lowlight,
    required this.highlight,
    this.distance = 1.0,
    this.blur = 0.5,
    this.intensity = 1.0,
  });

  final BorderRadius borderRadius;
  final Color lowlight;
  final Color highlight;
  final double distance;
  final double blur;
  final double intensity;

  @override
  void paint(Canvas canvas, Size size) {
    final double k = intensity.clamp(0.0, 2.0);
    final double d = distance * k;
    final double b = blur * k;
    if (size.isEmpty || d <= 0) {
      return;
    }

    final Rect rect = Offset.zero & size;
    final RRect rrect = borderRadius.toRRect(rect);

    canvas.save();
    canvas.clipRRect(rrect);

    final Path punched = Path()
      ..addRect(rect.inflate(d + b + 4))
      ..addRRect(rrect)
      ..fillType = PathFillType.evenOdd;

    final Paint high = Paint()
      ..color = lowlight
      ..maskFilter = b > 0 ? MaskFilter.blur(BlurStyle.normal, b) : null;
    canvas.save();
    canvas.translate(d, d);
    canvas.drawPath(punched, high);
    canvas.restore();

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant XkInsetShadowPainter old) {
    return old.borderRadius != borderRadius ||
        old.lowlight != lowlight ||
        old.highlight != highlight ||
        old.distance != distance ||
        old.blur != blur ||
        old.intensity != intensity;
  }
}

class _XkGemSweepState extends State<XkGemSweep>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    if (widget.enabled) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant XkGemSweep oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }
    if (widget.enabled && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.enabled && _controller.isAnimating) {
      _controller.stop();
      _controller.value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool reduced =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (!widget.enabled || reduced) {
      if (_controller.isAnimating) {
        _controller.stop();
      }
      return const SizedBox.expand();
    }
    if (!_controller.isAnimating) {
      _controller.repeat();
    }
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? _) {
          // 0..0.72: 100% → 0% position; rest holds. One-way.
          final double t = _controller.value;
          final double pos = t <= 0.72 ? (1 - t / 0.72) : 0;
          return DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-1 + 2 * pos, -0.3),
                end: Alignment(-1 + 2 * pos + 0.55, 0.4),
                colors: <Color>[
                  XkColor.mixWhite.withValues(alpha: 0),
                  XkColor.mixWhite.withValues(alpha: 0.62),
                  XkColor.mixWhite.withValues(alpha: 0.18),
                  XkColor.mixWhite.withValues(alpha: 0),
                ],
                stops: const <double>[0.34, 0.45, 0.49, 0.58],
              ),
            ),
          );
        },
      ),
    );
  }
}
