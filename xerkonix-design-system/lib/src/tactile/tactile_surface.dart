import 'dart:ui';

import 'package:flutter/material.dart';

import 'tactile_tokens.dart';

/// TACTILE surface roles. Not every card is `.glass`.
enum XkTactileSurfaceRole {
  /// Information plane — `.panel` (`--panel-fill` + `--line`, radius 14).
  /// No blur, no `--shadow-float`.
  information,

  /// Floating glass — `.glass`.
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
    final Color fill;
    final Color border;
    final List<BoxShadow> shadows;
    final double blur;
    switch (role) {
      case XkTactileSurfaceRole.information:
        fill = t.panelFill;
        border = t.line;
        shadows = const <BoxShadow>[];
        blur = 0;
      case XkTactileSurfaceRole.glass:
        fill = t.glassFill;
        border = t.glassRim;
        shadows = <BoxShadow>[
          ...t.shadowFloat,
          BoxShadow(
            color: t.glassInset,
            offset: const Offset(0, 1),
            blurStyle: BlurStyle.inner,
          ),
        ];
        blur = t.glassBlur;
      case XkTactileSurfaceRole.overlay:
        fill = t.overlayFill;
        border = t.overlayBorder;
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
        });
    final BorderRadius resolved = radiusGeom.resolve(
      Directionality.maybeOf(context) ?? TextDirection.ltr,
    );

    Widget body = DecoratedBox(
      decoration: BoxDecoration(
        color: paintedFill,
        borderRadius: radiusGeom,
        border: Border.all(color: paintedBorder),
        boxShadow: shadows,
      ),
      child: padding == null ? child : Padding(padding: padding!, child: child),
    );

    body = ClipRRect(
      borderRadius: resolved,
      child: blur > 0
          ? BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
              child: body,
            )
          : body,
    );

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
