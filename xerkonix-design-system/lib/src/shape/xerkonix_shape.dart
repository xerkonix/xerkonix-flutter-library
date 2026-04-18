import 'package:flutter/material.dart';

/// Shape tokens from XERKONIX Design System v1.3
class XkShape {
  XkShape._();

  static const double radiusXs = 6.0;
  static const double radiusSm = 10.0;
  static const double radiusMd = 14.0;
  static const double radiusLg = 20.0;
  static const double radiusXl = 26.0;
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

/// Shadow tokens from the v1.3 HTML reference.
class XkShadow {
  XkShadow._();

  static const List<BoxShadow> lightSm = [
    BoxShadow(color: Color(0x0D141414), blurRadius: 3, offset: Offset(0, 1)),
    BoxShadow(color: Color(0x0A141414), blurRadius: 0, spreadRadius: 1),
  ];

  static const List<BoxShadow> lightMd = [
    BoxShadow(color: Color(0x14141414), blurRadius: 26, offset: Offset(0, 10)),
    BoxShadow(color: Color(0x0D141414), blurRadius: 0, spreadRadius: 1),
  ];

  static const List<BoxShadow> lightLg = [
    BoxShadow(color: Color(0x24141414), blurRadius: 48, offset: Offset(0, 18)),
    BoxShadow(color: Color(0x14141414), blurRadius: 0, spreadRadius: 1),
  ];

  static const List<BoxShadow> darkSm = [
    BoxShadow(color: Color(0x52000000), blurRadius: 3, offset: Offset(0, 1)),
    BoxShadow(color: Color(0x0AFFFFFF), blurRadius: 0, spreadRadius: 1),
  ];

  static const List<BoxShadow> darkMd = [
    BoxShadow(color: Color(0x61000000), blurRadius: 26, offset: Offset(0, 10)),
    BoxShadow(color: Color(0x0FFFFFFF), blurRadius: 0, spreadRadius: 1),
  ];

  static const List<BoxShadow> darkLg = [
    BoxShadow(color: Color(0x8F000000), blurRadius: 48, offset: Offset(0, 18)),
    BoxShadow(color: Color(0x17FFFFFF), blurRadius: 0, spreadRadius: 1),
  ];

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
