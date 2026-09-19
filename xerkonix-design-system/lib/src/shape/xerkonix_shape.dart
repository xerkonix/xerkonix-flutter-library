import 'package:flutter/material.dart';

import '../palette/color.dart';

/// Radius tokens from TACTILE (`--r-panel/card/inset/ctl/tag/graphic`).
///
/// 11 / 11 / 8 / 7 / 6. Graphic 10, mobile 8. No pill (980/999).
class XkRadius {
  XkRadius._();

  static const double panel = 11.0;
  static const double card = 11.0;
  static const double inset = 8.0;
  static const double ctl = 7.0;
  static const double tag = 6.0;
  static const double graphic = 10.0;
  static const double graphicMobile = 8.0;

  static const BorderRadius panelBorderRadius = BorderRadius.all(
    Radius.circular(panel),
  );
  static const BorderRadius cardBorderRadius = BorderRadius.all(
    Radius.circular(card),
  );
  static const BorderRadius insetBorderRadius = BorderRadius.all(
    Radius.circular(inset),
  );
  static const BorderRadius ctlBorderRadius = BorderRadius.all(
    Radius.circular(ctl),
  );
  static const BorderRadius tagBorderRadius = BorderRadius.all(
    Radius.circular(tag),
  );
  static const BorderRadius graphicBorderRadius = BorderRadius.all(
    Radius.circular(graphic),
  );

  /// v3 aliases — apps that still say `sm`/`md`/`lg`/`pill` keep compiling.
  @Deprecated('Use XkRadius.inset')
  static const double sm = inset;
  @Deprecated('Use XkRadius.panel')
  static const double md = panel;
  @Deprecated('Use XkRadius.panel')
  static const double lg = panel;
  @Deprecated('Use XkRadius.ctl — pills are gone in v4')
  static const double pill = ctl;
  @Deprecated('Use XkRadius.inset')
  static const double xs = inset;
}

/// Shape tokens. Prefer [XkRadius] for new code.
class XkShape {
  XkShape._();

  static const double radiusXs = XkRadius.inset;
  static const double radiusSm = XkRadius.inset;
  static const double radiusCtl = XkRadius.ctl;
  static const double radiusMd = XkRadius.panel;
  static const double radiusCard = XkRadius.card;
  static const double radiusLg = XkRadius.panel;
  static const double radiusXl = XkRadius.panel;
  @Deprecated('Use XkRadius.ctl — pills are gone in v4')
  static const double radiusFull = XkRadius.ctl;
  static const double radiusTag = XkRadius.tag;

  static const BorderRadius xsBorderRadius = XkRadius.insetBorderRadius;
  static const BorderRadius smBorderRadius = XkRadius.insetBorderRadius;
  static const BorderRadius ctlBorderRadius = XkRadius.ctlBorderRadius;
  static const BorderRadius mdBorderRadius = XkRadius.panelBorderRadius;
  static const BorderRadius lgBorderRadius = XkRadius.panelBorderRadius;
  static const BorderRadius xlBorderRadius = XkRadius.panelBorderRadius;
  @Deprecated('Use XkRadius.ctlBorderRadius')
  static const BorderRadius fullBorderRadius = XkRadius.ctlBorderRadius;
  static const BorderRadius tagBorderRadius = XkRadius.tagBorderRadius;
  static const BorderRadius cardBorderRadius = XkRadius.cardBorderRadius;

  static const double radiusSmall = radiusSm;
  static const double radiusMedium = radiusMd;
  static const double radiusLarge = radiusLg;

  static const BorderRadius defaultBorderRadius = smBorderRadius;
  static const BorderRadius smallBorderRadius = xsBorderRadius;
  static const BorderRadius largeBorderRadius = mdBorderRadius;
}

/// Layout tokens from tokens.css (`--sp-*`, `--fs-*` widths).
class XkLayout {
  XkLayout._();

  static const double gridMax = 1160.0;
  static const double sidebarWidth = 220.0;

  static const double spacingXxs = 4.0; // --sp-1
  static const double spacingXs = 8.0; // --sp-2
  static const double spacingSm = 12.0; // --sp-3
  static const double spacingMd = 16.0; // --sp-4
  static const double spacingLg = 24.0; // --sp-5
  static const double spacingXl = 24.0; // --sp-5
  static const double spacing2xl = 32.0; // --sp-6
  static const double spacing3xl = 48.0; // --sp-7
  static const double spacing4xl = 48.0; // --sp-7

  static const double sectionLo = 40.0;
  static const double sectionHi = 72.0;

  static const double contentWidth = 1160.0;
  static const double readingWidth = 760.0;
  static const double sectionSpace = 72.0;
  static const double sectionSpaceMobile = 40.0;
  static const double gutter = 24.0;
  static const double gutterMobile = 20.0;
  static const double controlHeight = 48.0;

  static const double leadingBody = 1.6;
  static const double leadingHeading = 1.2;

  static const double spacingExtraLarge = spacing2xl;
  static const double spacingLarge = spacingXl;
  static const double spacingMedium = spacingMd;
  static const double spacingSmall = spacingSm;
  static const double spacingExtraSmall = spacingXs;

  static const double lineHeightTight = 1.2;
  static const double lineHeightNormal = 1.6;
  static const double lineHeightRelaxed = 1.65;
  static const double lineHeightLoose = 2.0;

  static const double letterSpacingTight = -0.03;
  static const double letterSpacingNormal = 0.0;
  static const double letterSpacingWide = 0.12;
  static const double letterSpacingWider = 0.12;
}

enum XkShadowLevel { sm, md, lg }

/// Glass / gem shadows from tokens.css `--glass-shadow` and gem-ctl recipe.
class XkShadow {
  XkShadow._();

  static const Color lightLowlight = XkColor.glassShadowNear;
  static const Color lightHighlight = XkColor.glassEdge;
  static const Color darkLowlight = XkColor.darkGlassShadowNear;
  static const Color darkHighlight = XkColor.none;

  /// `--glass-shadow` light: `0 8px 32px rgba(0,0,0,.05)`.
  static const List<BoxShadow> glassLight = <BoxShadow>[
    BoxShadow(
      color: XkColor.glassShadowNear,
      offset: Offset(0, 8),
      blurRadius: 32,
      spreadRadius: 0,
    ),
  ];

  /// `--glass-shadow` dark: `0 8px 32px rgba(0,0,0,.4)`.
  static const List<BoxShadow> glassDark = <BoxShadow>[
    BoxShadow(
      color: XkColor.darkGlassShadowNear,
      offset: Offset(0, 8),
      blurRadius: 32,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> glass(Brightness brightness) =>
      brightness == Brightness.dark ? glassDark : glassLight;

  /// `.gem-ctl` outer glow: `0 8px 24px var(--aqua-glow)` /
  /// hover `0 12px 28px`. Inset rim is painted on the fill, not here.
  static List<BoxShadow> gem(Brightness brightness, {bool hover = false}) {
    return <BoxShadow>[
      BoxShadow(
        color: XkColor.aquaGlowOf(brightness),
        offset: Offset(0, hover ? 12 : 8),
        blurRadius: hover ? 28 : 24,
        spreadRadius: 0,
      ),
    ];
  }

  /// `--ctl-shadow`: `0 2px 8px rgba(0,0,0,.06)` / dark `0 2px 10px .35`.
  static List<BoxShadow> ctl(Brightness brightness) {
    final bool dark = brightness == Brightness.dark;
    return <BoxShadow>[
      BoxShadow(
        color: dark ? const Color(0x59000000) : const Color(0x0F000000),
        offset: const Offset(0, 2),
        blurRadius: dark ? 10 : 8,
        spreadRadius: 0,
      ),
    ];
  }

  /// `--graphic-shadow`: `0 10px 28px rgba(0,0,0,.08)` / dark `.4`.
  static List<BoxShadow> graphic(Brightness brightness) {
    final bool dark = brightness == Brightness.dark;
    return <BoxShadow>[
      BoxShadow(
        color: dark ? XkColor.darkGlassShadowNear : const Color(0x14000000),
        offset: const Offset(0, 10),
        blurRadius: 28,
        spreadRadius: 0,
      ),
    ];
  }

  /// v3 names kept so apps compile. Geometry is now glass, xy ≥ 0.
  static const List<BoxShadow> raisedLight = glassLight;
  static const List<BoxShadow> raisedDark = glassDark;
  static const List<BoxShadow> liftedLight = glassLight;
  static const List<BoxShadow> liftedDark = glassDark;
  static const List<BoxShadow> elevatedLight = glassLight;
  static const List<BoxShadow> elevatedDark = glassDark;
  static const List<BoxShadow> raisedSoftLight = <BoxShadow>[
    BoxShadow(
      color: XkColor.glassShadowFar,
      offset: Offset(0, 10),
      blurRadius: 28,
      spreadRadius: 0,
    ),
  ];
  static const List<BoxShadow> raisedSoftDark = <BoxShadow>[
    BoxShadow(
      color: XkColor.darkGlassShadowFar,
      offset: Offset(0, 10),
      blurRadius: 28,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> raisedSoft(Brightness brightness) =>
      brightness == Brightness.dark ? raisedSoftDark : raisedSoftLight;

  static const List<BoxShadow> lightSm = glassLight;
  static const List<BoxShadow> lightMd = glassLight;
  static const List<BoxShadow> lightLg = glassLight;
  static const List<BoxShadow> darkSm = glassDark;
  static const List<BoxShadow> darkMd = glassDark;
  static const List<BoxShadow> darkLg = glassDark;

  static List<BoxShadow> raised(Brightness brightness) => glass(brightness);

  static List<BoxShadow> lifted(Brightness brightness) => glass(brightness);

  static List<BoxShadow> resolve(
    Brightness brightness, [
    XkShadowLevel level = XkShadowLevel.sm,
  ]) {
    switch (level) {
      case XkShadowLevel.sm:
      case XkShadowLevel.md:
      case XkShadowLevel.lg:
        return glass(brightness);
    }
  }
}
