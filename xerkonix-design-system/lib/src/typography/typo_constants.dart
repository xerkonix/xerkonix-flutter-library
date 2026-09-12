import 'dart:ui';

/// Font size tokens from tokens.css `--fs-*`.
class XkFontSize {
  XkFontSize._();

  static const double display = 58;
  static const double displayMobile = 34;
  static const double section = 44;
  static const double sectionMobile = 30;
  static const double page = 32;
  static const double pageMobile = 28;
  static const double title = 22;
  static const double titleMobile = 20;
  static const double body = 17;
  static const double bodyMobile = 16;
  static const double small = 15;
  static const double caption = 13;
  static const double label = 11;
}

class TypoConst {
  TypoConst._();

  // ignore: library_private_types_in_public_api
  static _FontWeight fontWeight = _FontWeight();

  // ignore: library_private_types_in_public_api
  static _FontSize fontSize = _FontSize();
}

class _FontWeight {
  final FontWeight thin = FontWeight.w100;
  final FontWeight extraLight = FontWeight.w200;
  final FontWeight light = FontWeight.w300;
  final FontWeight regular = FontWeight.w400;
  final FontWeight medium = FontWeight.w500;
  final FontWeight semiBold = FontWeight.w600;
  /// v4 cap: 700+ is forbidden. Alias keeps compile; value is 600.
  final FontWeight bold = FontWeight.w600;
  final FontWeight extraBold = FontWeight.w600;
  final FontWeight black = FontWeight.w600;
}

class _FontSize {
  final double displayMin = XkFontSize.displayMobile;
  final double displayMax = XkFontSize.display;
  final double h1Min = XkFontSize.sectionMobile;
  final double h1Max = XkFontSize.section;
  final double h2 = XkFontSize.page;
  final double h3 = XkFontSize.title;
  final double bodyLarge = XkFontSize.body;
  final double body = XkFontSize.bodyMobile;
  final double label = XkFontSize.small;
  final double meta = XkFontSize.caption;
  final double eyebrow = XkFontSize.label;
  final double pageTitle = XkFontSize.page;

  final double largeTitle = XkFontSize.display;
  final double title1 = XkFontSize.section;
  final double title2 = XkFontSize.page;
  final double title3 = XkFontSize.title;
  final double headline = XkFontSize.title;
  final double callout = XkFontSize.bodyMobile;
  final double subhead = XkFontSize.small;
  final double footnote = XkFontSize.caption;
  final double caption1 = XkFontSize.caption;
  final double caption2 = XkFontSize.caption;

  final double displayLarge = XkFontSize.display;
  final double displayMedium = XkFontSize.section;
  final double displaySmall = XkFontSize.displayMobile;
  final double headlineLarge = XkFontSize.page;
  final double headlineMedium = XkFontSize.pageMobile;
  final double headlineSmall = XkFontSize.title;
  final double titleLarge = XkFontSize.title;
  final double titleMedium = XkFontSize.body;
  final double titleSmall = XkFontSize.small;
  final double labelLarge = XkFontSize.small;
  final double labelMedium = XkFontSize.caption;
  final double labelSmall = XkFontSize.label;
  final double bodyMedium = XkFontSize.bodyMobile;
  final double bodySmall = XkFontSize.small;
}
