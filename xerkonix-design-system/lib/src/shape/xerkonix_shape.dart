import 'package:flutter/material.dart';

/// Shape tokens from Weave v3 (tokens.css).
///
/// Radius: 28 / 18 / 16 / 12 / pill 980.
class XkShape {
  XkShape._();

  static const double radiusXs = 12.0;
  static const double radiusSm = 12.0;
  static const double radiusCtl = 12.0;
  static const double radiusMd = 18.0;
  static const double radiusCard = 16.0;
  static const double radiusLg = 28.0;
  static const double radiusXl = 28.0;
  static const double radiusFull = 980.0;

  static const BorderRadius xsBorderRadius = BorderRadius.all(
    Radius.circular(radiusXs),
  );
  static const BorderRadius smBorderRadius = BorderRadius.all(
    Radius.circular(radiusSm),
  );
  static const BorderRadius ctlBorderRadius = BorderRadius.all(
    Radius.circular(radiusCtl),
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

/// Layout tokens from XERKONIX TACTILE Design System (tokens.css v2.1).
///
/// Spacing ladder (v2.1 `--sp-*`, 4px grid): 4 · 8 · 12 · 16 · 20 · 24 · 32 ·
/// 48 · 64. `spacingLg` (20) maps to the v2.1 `--sp-4h` half-step, which is
/// now an official ladder value.
class XkLayout {
  XkLayout._();

  static const double gridMax = 1400.0;
  static const double sidebarWidth = 220.0;

  static const double spacingXxs = 4.0; // --x-sp-1
  static const double spacingXs = 8.0; // --x-sp-2
  static const double spacingSm = 12.0; // --x-sp-3
  static const double spacingMd = 16.0; // --x-sp-4
  static const double spacingLg = 24.0; // --x-sp-5
  static const double spacingXl = 24.0; // --x-sp-5
  static const double spacing2xl = 32.0; // --x-sp-6
  static const double spacing3xl = 48.0; // --x-sp-7
  static const double spacing4xl = 48.0; // --x-sp-7

  static const double sectionLo = 84.0;
  static const double sectionHi = 110.0;

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

/// Neumorphic elevation tokens — XERKONIX TACTILE (tokens.css v2.1).
///
/// A **paired** highlight + lowlight shadow, so surfaces read as physically
/// extruded from a single top-left light source. A raised element casts a
/// lowlight to the bottom-right and a highlight to the top-left.
///
/// - LIGHT (`--neu-raise`): lowlight `rgba(146,148,166,.55)` at (7,7) blur 16
///   · highlight `#FFFFFF` at (-6,-6) blur 14.
/// - DARK (`--neu-raise`): lowlight `rgba(0,0,0,.62)` at (8,8) blur 18 ·
///   highlight **0** at (-5,-5) blur 12. Canonical rule: dark mode forbids
///   highlight shadows on dark surfaces — `--neu-light` is
///   `rgba(255,255,255,0)`, i.e. fully transparent, not "near-transparent".
///
/// Flutter's [BoxShadow] can only cast *outward*, so this class covers the
/// raised (extruded) treatment. The complementary **inset** (sunken) treatment
/// — which needs an inner shadow Flutter cannot express with [BoxDecoration]
/// alone — is provided by `XkNeumorphic` / `XkInsetShadowPainter`.
class XkShadow {
  XkShadow._();

  // --- Paired shadow colors (single top-left light source) ---
  // [v2.3] 캔버스가 밝아진 만큼 그림자 톤 보정.
  static const Color lightLowlight = Color(0x809093A6); // rgba(144,147,166,.5)
  static const Color lightHighlight = Color(0xFFFFFFFF);
  static const Color darkLowlight = Color(0x9E000000); // rgba(0,0,0,.62)
  // Dark highlight is exactly 0 (rgba(255,255,255,0)) — the canonical
  // "다크는 하이라이트 0" rule; keeping the slot preserves paired geometry.
  static const Color darkHighlight = Color(0x00FFFFFF);

  /// Raised surface — LIGHT. --x-lit, 광원 30° (--x-sx .866 · --x-sy .5).
  /// xy 오프셋은 양수만. 하이라이트는 inset 이라 BoxShadow 로 표현하지 않는다.
  static const List<BoxShadow> raisedLight = [
    BoxShadow(
      color: Color(0x381A1B22),
      offset: Offset(6.928, 4),
      blurRadius: 24,
      spreadRadius: -14,
    ),
    BoxShadow(
      color: Color(0x1F1A1B22),
      offset: Offset(13.856, 8),
      blurRadius: 40,
      spreadRadius: -30,
    ),
  ];

  /// Raised surface — DARK.
  static const List<BoxShadow> raisedDark = [
    BoxShadow(
      color: Color(0xBF000000),
      offset: Offset(6.928, 4),
      blurRadius: 24,
      spreadRadius: -14,
    ),
    BoxShadow(
      color: Color(0x80000000),
      offset: Offset(13.856, 8),
      blurRadius: 40,
      spreadRadius: -30,
    ),
  ];

  /// Lifted / floating surface (overlays, menus, toasts) — LIGHT.
  ///
  /// Canonical `--float` (v2.1, was `--raise`): floating layers use a single
  /// **downward** drop shadow — `0 14px 40px rgba(35,36,48,.14)` — not the
  /// paired neumorphic treatment, which is reserved for touchable layers.
  static const List<BoxShadow> liftedLight = [
    BoxShadow(
      color: Color(0x24232430), // rgba(35,36,48,.14)
      offset: Offset(0, 14),
      blurRadius: 40,
    ),
  ];

  /// Lifted / floating surface (overlays, menus, toasts) — DARK.
  ///
  /// Canonical dark `--float`: `0 16px 44px rgba(0,0,0,.55)` — single
  /// downward shadow, no highlight (다크는 하이라이트 0).
  static const List<BoxShadow> liftedDark = [
    BoxShadow(
      color: Color(0x8C000000), // rgba(0,0,0,.55)
      offset: Offset(0, 16),
      blurRadius: 44,
    ),
  ];

  /// Information layer, elevated card — LIGHT (canonical `--shadow-sm`, v2.2).
  ///
  /// Deliberately a different vocabulary from [raisedLight]: the neumorphic
  /// pair belongs to the **touchable** layer, this single soft drop belongs to
  /// the **information** layer. Use on at most one or two cards per section —
  /// if everything floats, nothing does.
  static const List<BoxShadow> elevatedLight = [
    BoxShadow(
      color: Color(0x122A2B35), // rgba(42,43,53,.07)
      offset: Offset(0, 2),
      blurRadius: 10,
    ),
    BoxShadow(
      color: Color(0x0D2A2B35), // rgba(42,43,53,.05)
      offset: Offset(0, 1),
      blurRadius: 3,
    ),
  ];

  /// Information layer, elevated card — DARK (canonical dark `--shadow-sm`).
  static const List<BoxShadow> elevatedDark = [
    BoxShadow(
      color: Color(0x6B000000), // rgba(0,0,0,.42)
      offset: Offset(0, 2),
      blurRadius: 10,
    ),
    BoxShadow(
      color: Color(0x4D000000), // rgba(0,0,0,.30)
      offset: Offset(0, 1),
      blurRadius: 3,
    ),
  ];

  /// Subtle raised treatment for small controls (chips, badges) — LIGHT
  /// (canonical `--neu-raise-sm`).
  static const List<BoxShadow> raisedSoftLight = [
    BoxShadow(
      color: Color(0x381A1B22),
      offset: Offset(3.464, 2),
      blurRadius: 12,
      spreadRadius: -4,
    ),
  ];

  /// Subtle raised treatment for small controls — DARK.
  static const List<BoxShadow> raisedSoftDark = [
    BoxShadow(
      color: Color(0xBF000000),
      offset: Offset(3.464, 2),
      blurRadius: 12,
      spreadRadius: -4,
    ),
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

  /// Floating-layer (`--float`) shadow for the given [brightness].
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
