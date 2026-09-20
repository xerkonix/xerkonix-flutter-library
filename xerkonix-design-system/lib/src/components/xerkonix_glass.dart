import 'dart:ui';

import 'package:flutter/material.dart';

import '../motion/xerkonix_motion.dart';
import '../palette/color.dart';
import '../shape/xerkonix_shape.dart';
import '../tactile/tactile_tokens.dart';
import '../typography/xerkonix_typography.dart';

/// Page ground. Delegates to current TACTILE canvas (dark #111111), not
/// product `#141414` glass radial.
class XkGround extends StatelessWidget {
  const XkGround({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final XkTactileTokens t = XkTactileTokens.of(Theme.of(context).brightness);
    return DecoratedBox(
      decoration: BoxDecoration(color: t.canvas),
      child: child,
    );
  }
}

/// CSS-like *outer* box-shadow: the border-box interior is punched out
/// (`dstOut`) so a translucent fill does not composite its own shadow.
/// Flutter [BoxDecoration] paints the full blurred shape *under* the fill.
/// Token color / offset / blur / spread are unchanged.
///
/// Wrap a translucent glass or control surface with this instead of putting
/// `boxShadow` on the same [DecoratedBox] as the fill.
class XkOuterShadow extends StatelessWidget {
  const XkOuterShadow({
    super.key,
    required this.borderRadius,
    required this.shadows,
    required this.child,
  });

  final BorderRadius borderRadius;
  final List<BoxShadow> shadows;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (shadows.isEmpty) {
      return child;
    }
    return CustomPaint(
      painter: XkOuterShadowPainter(
        borderRadius: borderRadius,
        shadows: shadows,
      ),
      child: child,
    );
  }
}

/// Paints [shadows] then subtracts the widget's own [RRect].
class XkOuterShadowPainter extends CustomPainter {
  const XkOuterShadowPainter({
    required this.borderRadius,
    required this.shadows,
  });

  final BorderRadius borderRadius;
  final List<BoxShadow> shadows;

  @override
  void paint(Canvas canvas, Size size) {
    final RRect shape = borderRadius.toRRect(Offset.zero & size);
    for (final BoxShadow shadow in shadows) {
      final double pad = shadow.blurRadius * 2 +
          shadow.spreadRadius.abs() +
          shadow.offset.distance +
          8;
      canvas.saveLayer((Offset.zero & size).inflate(pad), Paint());
      RRect drawn = shape.shift(shadow.offset);
      if (shadow.spreadRadius != 0) {
        drawn = drawn.inflate(shadow.spreadRadius);
      }
      canvas.drawRRect(drawn, shadow.toPaint());
      canvas.drawRRect(
        shape,
        Paint()
          ..color = const Color(0xFF000000)
          ..blendMode = BlendMode.dstOut,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(XkOuterShadowPainter oldDelegate) {
    return oldDelegate.borderRadius != borderRadius ||
        oldDelegate.shadows != shadows;
  }
}

/// Source glass roles (`--glass-reading` / `--glass-navigation` / `--glass-action`).
/// [XkGlass.ctl] maps to [action] so existing call sites stay valid.
enum XkGlassRole { reading, navigation, action }

/// Thin planar glass: role fill + one token sheen + plane edge. No gray groove.
class XkGlass extends StatefulWidget {
  const XkGlass({
    super.key,
    required this.child,
    this.borderRadius,
    this.padding,
    this.width,
    this.height,
    this.ctl = false,
    this.role,
    this.color,
    this.borderColor,
    this.onTap,
    this.semanticLabel,
  });

  final Widget child;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  /// Legacy alias of [XkGlassRole.action]. Ignored when [role] is set.
  final bool ctl;
  final XkGlassRole? role;
  /// Explicit fill. Null keeps the role glass token.
  final Color? color;
  /// Explicit hairline. Null keeps `--plane-edge`.
  final Color? borderColor;
  final VoidCallback? onTap;
  final String? semanticLabel;

  XkGlassRole get _role =>
      role ?? (ctl ? XkGlassRole.action : XkGlassRole.reading);

  @override
  State<XkGlass> createState() => _XkGlassState();
}

class _XkGlassState extends State<XkGlass> {
  bool _focus = false;

  @override
  Widget build(BuildContext context) {
    final Brightness b = Theme.of(context).brightness;
    final XkGlassRole resolved = widget._role;
    final bool action = resolved == XkGlassRole.action;
    final BorderRadius radius = (widget.borderRadius ??
            (action ? XkRadius.ctlBorderRadius : XkRadius.panelBorderRadius))
        .resolve(Directionality.of(context));
    final List<BoxShadow> shadows =
        action ? XkShadow.ctl(b) : XkShadow.glass(b);
    final Color fill = widget.color ??
        switch (resolved) {
          XkGlassRole.reading => XkColor.glassOf(b),
          XkGlassRole.navigation => XkColor.glassNavigationOf(b),
          XkGlassRole.action => XkColor.glassActionOf(b),
        };
    final Color edge = widget.borderColor ?? XkColor.planeEdgeOf(b);
    final double blur = switch (resolved) {
      XkGlassRole.reading => 36,
      XkGlassRole.navigation => 20,
      XkGlassRole.action => 8,
    };

    final List<Widget> layers = <Widget>[
      Positioned.fill(
        child: ColoredBox(color: fill),
      ),
    ];
    final Color sheen = XkColor.glossSheenOf(b);
    if (widget.color == null && sheen.a > 0) {
      // light.css: reading/nav `ellipse at 12% -90%` / action `50% -120%`.
      // Token alpha only — do not extra-multiply. Skip `--gloss-low` (alpha 0).
      layers.add(
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: action
                      ? const Alignment(0, -3.4)
                      : const Alignment(-0.76, -2.8),
                  radius: action ? 1.55 : 1.35,
                  colors: <Color>[sheen, sheen.withValues(alpha: 0)],
                ),
              ),
            ),
          ),
        ),
      );
    }
    layers.add(
      Padding(
        padding: widget.padding ??
            (action
                ? const EdgeInsets.symmetric(horizontal: 24, vertical: 12)
                : const EdgeInsets.all(XkLayout.spacingMd)),
        child: widget.child,
      ),
    );

    Widget surface = XkOuterShadow(
      borderRadius: radius,
      shadows: shadows,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          border: Border.all(color: edge),
        ),
        child: ClipRRect(
          borderRadius: radius,
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: blur,
              sigmaY: blur,
              tileMode: TileMode.clamp,
            ),
            child: Stack(children: layers),
          ),
        ),
      ),
    );

    surface = SizedBox(
      width: widget.width,
      height: widget.height,
      child: surface,
    );

    if (widget.onTap == null) {
      return surface;
    }
    return Semantics(
      button: true,
      enabled: true,
      label: widget.semanticLabel,
      child: FocusableActionDetector(
        mouseCursor: SystemMouseCursors.click,
        onFocusChange: (bool has) => setState(() => _focus = has),
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (ActivateIntent intent) {
              widget.onTap?.call();
              return null;
            },
          ),
          ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
            onInvoke: (ButtonActivateIntent intent) {
              widget.onTap?.call();
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: Stack(
            children: <Widget>[
              surface,
              if (_focus)
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: radius,
                        border: Border.all(
                          color: XkColor.aquaDeepOf(b),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
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
/// No solid `BoxShadow` — blur 0 / spread 0 of `--aqua-mid` paints an opaque bar.
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
        border: selected
            ? Border.all(color: XkColor.aquaMidOf(b))
            : Border.all(color: XkColor.none),
      ),
      child: Padding(padding: padding ?? EdgeInsets.zero, child: child),
    );
  }
}

/// Tag / badge / chip outline: [XkTypo.hint] (`--fs-caption` 13) · tag radius ·
/// `--rule` · `--ink-2`.
class XkTag extends StatefulWidget {
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
  State<XkTag> createState() => _XkTagState();
}

class _XkTagState extends State<XkTag> {
  bool _focus = false;

  @override
  Widget build(BuildContext context) {
    final Brightness b = Theme.of(context).brightness;
    final Color ink = widget.flag ? XkColor.aquaDeepOf(b) : XkColor.ink2Of(b);
    final Color border = widget.flag
        ? XkColor.aquaOf(b).withValues(alpha: 0.50)
        : XkColor.ruleOf(b);
    final Color? fill =
        widget.flag ? XkColor.aquaTintOf(b).withValues(alpha: 0.45) : null;
    final Widget body = DecoratedBox(
      decoration: BoxDecoration(
        color: fill,
        borderRadius: XkRadius.tagBorderRadius,
        border: Border.all(
          color: _focus ? XkColor.aquaDeepOf(b) : border,
          width: _focus ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Text(
          widget.label,
          style: XkTypo.hint.copyWith(color: ink),
        ),
      ),
    );
    if (widget.onTap == null) {
      return body;
    }
    return Semantics(
      button: true,
      enabled: true,
      child: FocusableActionDetector(
        mouseCursor: SystemMouseCursors.click,
        onFocusChange: (bool has) => setState(() => _focus = has),
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (ActivateIntent intent) {
              widget.onTap?.call();
              return null;
            },
          ),
          ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
            onInvoke: (ButtonActivateIntent intent) {
              widget.onTap?.call();
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: body,
        ),
      ),
    );
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
    // Kept for API compatibility. Inset grooves are not part of the
    // approved surface; hairline wells use [XkInset] instead.
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
