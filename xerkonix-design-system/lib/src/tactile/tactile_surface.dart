import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import 'tactile_tokens.dart';

/// TACTILE surface roles. Not every card is `.glass`.
enum XkTactileSurfaceRole {
  /// Information card — `.panel` (DS 2026-10-21): `--panel-fill` face,
  /// `--panel-blur` 20 (16 at 700 wide or less) with saturate 150%, outer
  /// edge `--panel-border` (3:1 or more on the ground), even inner ring
  /// `--glass-ring`, depth `--panel-shadow`. Inner dividers keep `line`.
  information,

  /// Floating glass — `.glass`: `--glass-fill`, blur 20, the same outer
  /// edge `--panel-border` and inner ring, `--glass-float-shadow`.
  glass,

  /// Dialog / toast — `.dialog` / `.toast` overlay fill.
  overlay,
}

class XkTactileSurface extends StatelessWidget {
  const XkTactileSurface({
    super.key,
    required this.child,
    this.role = XkTactileSurfaceRole.information,
    this.padding,
    this.width,
    this.onTap,
    this.fill,
    this.borderColor,
    this.radius,
  });

  final Widget child;
  final XkTactileSurfaceRole role;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final VoidCallback? onTap;

  /// Optional paint overrides. Do not change [role] blur / shadow.
  final Color? fill;
  final Color? borderColor;
  final BorderRadiusGeometry? radius;

  @override
  Widget build(BuildContext context) {
    final XkTactileTokens t = XkTactileTokens.of(Theme.of(context).brightness);
    // Flutter has no `prefers-reduced-transparency`; the platform contrast
    // setting is the closest signal. Then the face is opaque and unblurred,
    // and the edge, ring and depth stay (DS `.panel` fallback).
    final bool opaque = MediaQuery.maybeHighContrastOf(context) ?? false;
    final double? viewWidth = MediaQuery.maybeSizeOf(context)?.width;
    final bool narrow =
        viewWidth != null &&
        viewWidth <= XkTactileTokens.panelBlurMobileMaxWidth;
    final Color fill;
    final Color border;
    final Color? ring;
    final List<BoxShadow> shadows;
    final double blur;
    switch (role) {
      case XkTactileSurfaceRole.information:
        fill = opaque ? t.glassFallback : t.panelFill;
        border = t.panelBorder;
        ring = t.glassRing;
        shadows = t.panelShadow;
        blur = opaque
            ? 0
            : (narrow
                  ? XkTactileTokens.panelBlurMobile
                  : XkTactileTokens.panelBlur);
      case XkTactileSurfaceRole.glass:
        fill = opaque ? t.glassFallback : t.glassFill;
        border = t.panelBorder;
        ring = t.glassRing;
        shadows = t.glassFloatShadow;
        blur = opaque ? 0 : t.glassBlur;
      case XkTactileSurfaceRole.overlay:
        fill = t.overlayFill;
        border = t.overlayBorder;
        ring = null;
        shadows = t.shadowFloat;
        blur = XkTactileTokens.overlayBlur;
    }

    final Color paintedFill = this.fill ?? fill;
    final Color paintedBorder = borderColor ?? border;
    final BorderRadiusGeometry radiusGeom =
        radius ??
        BorderRadius.circular(switch (role) {
          XkTactileSurfaceRole.information => XkTactileTokens.panelRadius,
          XkTactileSurfaceRole.glass => XkTactileTokens.surfaceRadius,
          XkTactileSurfaceRole.overlay => XkTactileTokens.overlayRadius,
        });
    final BorderRadius resolved = radiusGeom.resolve(
      Directionality.maybeOf(context) ?? TextDirection.ltr,
    );

    Widget content = padding == null
        ? child
        : Padding(padding: padding!, child: child);
    // ListTile / InkWell ink must hit a Material between this fill and the
    // control. Without it, a panel DecoratedBox hides splashes and asserts.
    content = Material(type: MaterialType.transparency, child: content);

    // Face: fill and the inner ring, inside the blur clip.
    Widget body = DecoratedBox(
      key: const ValueKey<String>('xk-tactile-surface-face'),
      decoration: BoxDecoration(
        color: paintedFill,
        borderRadius: radiusGeom,
        border: XkTactileEdge(color: XkTactileTokens.clear, ring: ring),
      ),
      child: content,
    );

    body = ClipRRect(
      borderRadius: resolved,
      child: blur > 0
          ? BackdropFilter(
              filter: ImageFilter.compose(
                outer: _saturate(XkTactileTokens.glassSaturate),
                inner: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
              ),
              child: body,
            )
          : body,
    );

    // Outer edge on top, outside the anti-aliased clip: at a fractional
    // position the clip would otherwise thin the edge pixel.
    body = DecoratedBox(
      key: const ValueKey<String>('xk-tactile-surface-edge'),
      position: DecorationPosition.foreground,
      decoration: BoxDecoration(
        borderRadius: radiusGeom,
        border: XkTactileEdge(color: paintedBorder),
      ),
      child: body,
    );

    // Outer depth only. A BoxDecoration shadow is painted under the whole
    // box, so the translucent face would show its own shadow.
    if (shadows.isNotEmpty) {
      body = CustomPaint(
        painter: _XkTactileOuterShadowPainter(
          borderRadius: resolved,
          shadows: shadows,
        ),
        child: body,
      );
    }

    if (width != null) {
      body = SizedBox(width: width, child: body);
    }
    if (onTap == null) {
      return body;
    }
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: FocusableActionDetector(
        onFocusChange: (_) {},
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (ActivateIntent intent) {
              onTap!.call();
              return null;
            },
          ),
          ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
            onInvoke: (ButtonActivateIntent intent) {
              onTap!.call();
              return null;
            },
          ),
        },
        child: GestureDetector(onTap: onTap, child: body),
      ),
    );
  }
}

/// CSS `saturate(s)` as a colour matrix.
ColorFilter _saturate(double s) {
  return ColorFilter.matrix(<double>[
    0.213 + 0.787 * s, 0.715 - 0.715 * s, 0.072 - 0.072 * s, 0, 0, //
    0.213 - 0.213 * s, 0.715 + 0.285 * s, 0.072 - 0.072 * s, 0, 0, //
    0.213 - 0.213 * s, 0.715 - 0.715 * s, 0.072 + 0.928 * s, 0, 0, //
    0, 0, 0, 1, 0, //
  ]);
}

/// CSS outer `box-shadow`: paints [shadows], then removes the box itself
/// (`dstOut`) so the face shows the ground, not its own shadow.
class _XkTactileOuterShadowPainter extends CustomPainter {
  const _XkTactileOuterShadowPainter({
    required this.borderRadius,
    required this.shadows,
  });

  final BorderRadius borderRadius;
  final List<BoxShadow> shadows;

  @override
  void paint(Canvas canvas, Size size) {
    final RRect shape = borderRadius.toRRect(Offset.zero & size);
    for (final BoxShadow shadow in shadows) {
      final double pad =
          shadow.blurRadius * 2 +
          shadow.spreadRadius.abs() +
          shadow.offset.distance +
          8;
      canvas.saveLayer((Offset.zero & size).inflate(pad), Paint());
      final RRect drawn = shape
          .shift(shadow.offset)
          .inflate(shadow.spreadRadius);
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
  bool shouldRepaint(_XkTactileOuterShadowPainter oldDelegate) {
    return oldDelegate.borderRadius != borderRadius ||
        oldDelegate.shadows != shadows;
  }
}

/// Card and control edge: one 1px side colour, and an optional even inner
/// ring (`inset 0 0 0 1px <ring>`) painted under it.
///
/// A plain [Border] is anti-aliased. At a fractional position on a 1x screen
/// it splits the 1px line over two device pixels at about half strength each,
/// and the edge falls to 1.5–2.6:1 against the ground. Browsers snap borders
/// to device pixels; this does the same for the straight sides by painting
/// them without anti-aliasing, so each side is always whole device pixels of
/// [color] (one at 1x, two at 2x). Rounded corners stay anti-aliased.
///
/// It is still a [Border]: `top.color` etc. read as before.
class XkTactileEdge extends Border {
  XkTactileEdge({required Color color, this.ring})
    : super(
        top: BorderSide(color: color),
        right: BorderSide(color: color),
        bottom: BorderSide(color: color),
        left: BorderSide(color: color),
      );

  /// Inner ring colour, or null for none.
  final Color? ring;

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    TextDirection? textDirection,
    BoxShape shape = BoxShape.rectangle,
    BorderRadius? borderRadius,
  }) {
    if (shape != BoxShape.rectangle) {
      super.paint(
        canvas,
        rect,
        textDirection: textDirection,
        shape: shape,
        borderRadius: borderRadius,
      );
      return;
    }
    final double w = top.width;
    final RRect outer = (borderRadius ?? BorderRadius.zero)
        .toRRect(rect)
        .scaleRadii();
    final Color? ringColor = ring;
    if (ringColor != null && ringColor.a > 0) {
      canvas.drawRRect(
        outer.deflate(w + 0.5),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = ringColor,
      );
    }
    final Color c = top.color;
    if (c.a == 0 || w <= 0 || top.style == BorderStyle.none) {
      return;
    }
    final double l = rect.left;
    final double t = rect.top;
    final double r = rect.right;
    final double b = rect.bottom;
    final Paint side = Paint()
      ..color = c
      ..isAntiAlias = false;
    canvas
      ..drawRect(
        Rect.fromLTRB(l + outer.tlRadiusX, t, r - outer.trRadiusX, t + w),
        side,
      )
      ..drawRect(
        Rect.fromLTRB(l + outer.blRadiusX, b - w, r - outer.brRadiusX, b),
        side,
      )
      ..drawRect(
        Rect.fromLTRB(
          l,
          t + math.max(outer.tlRadiusY, w),
          l + w,
          b - math.max(outer.blRadiusY, w),
        ),
        side,
      )
      ..drawRect(
        Rect.fromLTRB(
          r - w,
          t + math.max(outer.trRadiusY, w),
          r,
          b - math.max(outer.brRadiusY, w),
        ),
        side,
      );
    final Path corners = Path();
    void corner(double x, double y, double cw, double ch) {
      if (cw > 0 && ch > 0) {
        corners.addRect(Rect.fromLTWH(x, y, cw, ch));
      }
    }

    corner(l, t, outer.tlRadiusX, outer.tlRadiusY);
    corner(r - outer.trRadiusX, t, outer.trRadiusX, outer.trRadiusY);
    corner(l, b - outer.blRadiusY, outer.blRadiusX, outer.blRadiusY);
    corner(
      r - outer.brRadiusX,
      b - outer.brRadiusY,
      outer.brRadiusX,
      outer.brRadiusY,
    );
    canvas
      ..save()
      ..clipPath(corners)
      ..drawRRect(
        outer.deflate(w / 2),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = w
          ..color = c,
      )
      ..restore();
  }

  @override
  bool operator ==(Object other) {
    return other is XkTactileEdge && other.ring == ring && super == other;
  }

  @override
  int get hashCode => Object.hash(super.hashCode, ring);
}
