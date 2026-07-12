import 'package:flutter/material.dart';

/// Shape tokens from XERKONIX TACTILE Design System.
///
/// Radius scale (4px grid, unchanged from Weave v1.5):
/// xs 6 · sm 10 · md 14 · lg 18 · xl 22 · pill 999.
class XkShape {
  XkShape._();

  static const double radiusXs = 6.0;
  static const double radiusSm = 10.0;
  static const double radiusMd = 14.0;
  static const double radiusLg = 18.0;
  static const double radiusXl = 22.0;
  static const double radiusFull = 999.0;

  static const BorderRadius xsBorderRadius = BorderRadius.all(
    Radius.circular(radiusXs),
  );
  static const BorderRadius smBorderRadius = BorderRadius.all(
    Radius.circular(radiusSm),
  );
  static const BorderRadius mdBorderRadius = BorderRadius.all(
    Radius.circular(radiusMd),
  );
  static const BorderRadius lgBorderRadius = BorderRadius.all(
    Radius.circular(radiusLg),
  );
  static const BorderRadius xlBorderRadius = BorderRadius.all(
    Radius.circular(radiusXl),
  );
  static const BorderRadius fullBorderRadius = BorderRadius.all(
    Radius.circular(radiusFull),
  );

  // Backward-compatible aliases
  static const double radiusSmall = radiusSm;
  static const double radiusMedium = radiusMd;
  static const double radiusLarge = radiusLg;

  static const BorderRadius defaultBorderRadius = smBorderRadius;
  static const BorderRadius smallBorderRadius = xsBorderRadius;
  static const BorderRadius largeBorderRadius = mdBorderRadius;
}

/// Layout tokens from XERKONIX Design System v1.3
class XkLayout {
  XkLayout._();

  static const double gridMax = 1400.0;
  static const double sidebarWidth = 220.0;

  static const double spacingXxs = 4.0;
  static const double spacingXs = 8.0;
  static const double spacingSm = 10.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 20.0;
  static const double spacingXl = 24.0;
  static const double spacing2xl = 32.0;

  // Backward-compatible aliases
  static const double spacingExtraLarge = spacing2xl;
  static const double spacingLarge = spacingXl;
  static const double spacingMedium = spacingMd;
  static const double spacingSmall = spacingSm;
  static const double spacingExtraSmall = spacingXs;

  static const double lineHeightTight = 1.2;
  static const double lineHeightNormal = 1.55;
  static const double lineHeightRelaxed = 1.65;
  static const double lineHeightLoose = 2.0;

  static const double letterSpacingTight = -0.2;
  static const double letterSpacingNormal = 0.0;
  static const double letterSpacingWide = 0.2;
  static const double letterSpacingWider = 0.6;
}

enum XkShadowLevel { sm, md, lg }

/// Neumorphic elevation tokens — XERKONIX TACTILE.
///
/// TACTILE replaces the single soft drop of Weave v1.5 with a **paired**
/// highlight + lowlight shadow, so surfaces read as physically extruded from a
/// single top-left light source. A raised element casts a lowlight to the
/// bottom-right and a highlight to the top-left.
///
/// - LIGHT: lowlight `rgba(146,148,166,.55)` at (7,7) blur 16 · highlight
///   `#FFFFFF` at (-6,-6) blur 14.
/// - DARK: lowlight `rgba(0,0,0,.62)` at (7,7) blur 16 · highlight a
///   near-transparent white at (-6,-6) blur 14.
///
/// Flutter's [BoxShadow] can only cast *outward*, so this class covers the
/// raised (extruded) treatment. The complementary **inset** (sunken) treatment
/// — which needs an inner shadow Flutter cannot express with [BoxDecoration]
/// alone — is provided by `XkNeumorphic` / `XkInsetShadowPainter`.
class XkShadow {
  XkShadow._();

  // --- Paired shadow colors (single top-left light source) ---
  static const Color lightLowlight = Color(0x8C9294A6); // rgba(146,148,166,.55)
  static const Color lightHighlight = Color(0xFFFFFFFF);
  static const Color darkLowlight = Color(0x9E000000); // rgba(0,0,0,.62)
  static const Color darkHighlight = Color(0x0FFFFFFF); // near-transparent

  /// Raised surface (resting card / chip / button) — LIGHT.
  static const List<BoxShadow> raisedLight = [
    BoxShadow(color: lightLowlight, offset: Offset(7, 7), blurRadius: 16),
    BoxShadow(color: lightHighlight, offset: Offset(-6, -6), blurRadius: 14),
  ];

  /// Raised surface (resting card / chip / button) — DARK.
  static const List<BoxShadow> raisedDark = [
    BoxShadow(color: darkLowlight, offset: Offset(7, 7), blurRadius: 16),
    BoxShadow(color: darkHighlight, offset: Offset(-6, -6), blurRadius: 14),
  ];

  /// Lifted / floating surface (overlays, hovered) — LIGHT (deeper offsets).
  static const List<BoxShadow> liftedLight = [
    BoxShadow(color: lightLowlight, offset: Offset(11, 11), blurRadius: 24),
    BoxShadow(color: lightHighlight, offset: Offset(-9, -9), blurRadius: 20),
  ];

  /// Lifted / floating surface (overlays, hovered) — DARK (deeper offsets).
  static const List<BoxShadow> liftedDark = [
    BoxShadow(color: darkLowlight, offset: Offset(11, 11), blurRadius: 24),
    BoxShadow(color: darkHighlight, offset: Offset(-9, -9), blurRadius: 20),
  ];

  /// Subtle raised treatment for small controls (chips, badges) — LIGHT.
  static const List<BoxShadow> raisedSoftLight = [
    BoxShadow(color: lightLowlight, offset: Offset(3, 3), blurRadius: 8),
    BoxShadow(color: lightHighlight, offset: Offset(-3, -3), blurRadius: 7),
  ];

  /// Subtle raised treatment for small controls (chips, badges) — DARK.
  static const List<BoxShadow> raisedSoftDark = [
    BoxShadow(color: darkLowlight, offset: Offset(3, 3), blurRadius: 8),
    BoxShadow(color: darkHighlight, offset: Offset(-3, -3), blurRadius: 7),
  ];

  /// Subtle paired raised shadow for small controls, by [brightness].
  static List<BoxShadow> raisedSoft(Brightness brightness) =>
      brightness == Brightness.dark ? raisedSoftDark : raisedSoftLight;

  // Level aliases (sm/md = raised, lg = lifted) keep the 3-tier [resolve] API.
  static const List<BoxShadow> lightSm = raisedLight;
  static const List<BoxShadow> lightMd = raisedLight;
  static const List<BoxShadow> lightLg = liftedLight;
  static const List<BoxShadow> darkSm = raisedDark;
  static const List<BoxShadow> darkMd = raisedDark;
  static const List<BoxShadow> darkLg = liftedDark;

  /// Paired raised shadow for the given [brightness].
  static List<BoxShadow> raised(Brightness brightness) =>
      brightness == Brightness.dark ? raisedDark : raisedLight;

  /// Paired lifted (floating) shadow for the given [brightness].
  static List<BoxShadow> lifted(Brightness brightness) =>
      brightness == Brightness.dark ? liftedDark : liftedLight;

  static List<BoxShadow> resolve(
    Brightness brightness, [
    XkShadowLevel level = XkShadowLevel.sm,
  ]) {
    final isDark = brightness == Brightness.dark;
    switch (level) {
      case XkShadowLevel.sm:
        return isDark ? darkSm : lightSm;
      case XkShadowLevel.md:
        return isDark ? darkMd : lightMd;
      case XkShadowLevel.lg:
        return isDark ? darkLg : lightLg;
    }
  }
}
