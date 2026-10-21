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
  /// edge `--panel-border` and inner ring, `--shadow-float`.
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
        shadows = t.shadowFloat;
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
    final BorderRadiusGeometry radiusGeom = radius ??
        BorderRadius.circular(switch (role) {
          XkTactileSurfaceRole.information => XkTactileTokens.panelRadius,
          XkTactileSurfaceRole.glass => XkTactileTokens.surfaceRadius,
          XkTactileSurfaceRole.overlay => XkTactileTokens.overlayRadius,
        },);
    final BorderRadius resolved = radiusGeom.resolve(
      Directionality.maybeOf(context) ?? TextDirection.ltr,
    );

    Widget content =
        padding == null ? child : Padding(padding: padding!, child: child);
    // ListTile / InkWell ink must hit a Material between this fill and the
    // control. Without it, a panel DecoratedBox hides splashes and asserts.
    content = Material(type: MaterialType.transparency, child: content);
    if (ring != null) {
      content = CustomPaint(
        painter: _XkTactileRingPainter(borderRadius: resolved, color: ring),
        child: content,
      );
    }

    Widget body = DecoratedBox(
      decoration: BoxDecoration(
        color: paintedFill,
        borderRadius: radiusGeom,
        border: Border.all(color: paintedBorder),
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

/// `inset 0 0 0 1px <ring>` — one even ring just inside the 1px edge,
/// under the content.
class _XkTactileRingPainter extends CustomPainter {
  const _XkTactileRingPainter({
    required this.borderRadius,
    required this.color,
  });

  final BorderRadius borderRadius;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final RRect ring = borderRadius.toRRect(Offset.zero & size).deflate(1.5);
    canvas.drawRRect(
      ring,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = color,
    );
  }

  @override
  bool shouldRepaint(_XkTactileRingPainter oldDelegate) {
    return oldDelegate.borderRadius != borderRadius ||
        oldDelegate.color != color;
  }
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
