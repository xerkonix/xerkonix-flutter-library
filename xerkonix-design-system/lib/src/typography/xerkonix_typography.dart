import 'package:flutter/painting.dart';

import 'typo_constants.dart';

/// XERKONIX Weave typography
///
/// Canonical v1.3 styles (unchanged from v1.2):
/// - display 52 / 700
/// - h1 38 / 700
/// - h2 28 / 700
/// - h3 22 / 600
/// - bodyLarge 17 / 400
/// - body 14 / 400
/// - bodySmall 13 / 400
/// - label 12 / 600
/// - buttonLabel 13 / 500
/// - metaMono 11 / 500
/// - metricMono 10 / 500
class XkTypo {
  XkTypo._();

  static const List<String> _sansFallback = [
    'Apple SD Gothic Neo',
    IBMPlexSansKR.fontFamily,
  ];
  static const List<String> _serifFallback = [
    'Noto Serif KR',
    IBMPlexSansKR.fontFamily,
  ];
  static const List<String> _monoFallback = [
    IBMPlexMono.fontFamily,
    Pretendard.fontFamily,
  ];

  static TextStyle _sans({
    required double size,
    required FontWeight weight,
    required double height,
    double letterSpacing = 0,
  }) {
    return TextStyle(
      fontFamily: Pretendard.fontFamily,
      package: Pretendard.package,
      fontFamilyFallback: _sansFallback,
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  /// v1.5 display serif — MaruBuri. Reserved for 28px+ display styles.
  static TextStyle _serif({
    required double size,
    required FontWeight weight,
    required double height,
    double letterSpacing = 0,
  }) {
    return TextStyle(
      fontFamily: MaruBuri.fontFamily,
      package: MaruBuri.package,
      fontFamilyFallback: _serifFallback,
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle _mono({
    required double size,
    required FontWeight weight,
    required double height,
    double letterSpacing = 0,
  }) {
    return TextStyle(
      fontFamily: IBMPlexMono.fontFamily,
      package: IBMPlexMono.package,
      fontFamilyFallback: _monoFallback,
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  // Display styles (28px+) use the MaruBuri serif per v1.5.
  static final TextStyle display = _serif(
    size: TypoConst.fontSize.displayMax,
    weight: TypoConst.fontWeight.bold,
    height: 1.15,
    letterSpacing: -0.4,
  );

  static final TextStyle h1 = _serif(
    size: TypoConst.fontSize.h1Max,
    weight: TypoConst.fontWeight.bold,
    height: 1.18,
    letterSpacing: -0.2,
  );

  static final TextStyle h2 = _serif(
    size: TypoConst.fontSize.h2,
    weight: TypoConst.fontWeight.bold,
    height: 1.24,
    letterSpacing: -0.1,
  );

  static final TextStyle h3 = _sans(
    size: TypoConst.fontSize.h3,
    weight: TypoConst.fontWeight.semiBold,
    height: 1.3,
  );

  static final TextStyle bodyLarge = _sans(
    size: TypoConst.fontSize.bodyLarge,
    weight: TypoConst.fontWeight.regular,
    height: 1.6,
  );

  static final TextStyle body = _sans(
    size: TypoConst.fontSize.body,
    weight: TypoConst.fontWeight.regular,
    height: 1.6,
  );

  static final TextStyle bodySmall = _sans(
    size: 13,
    weight: TypoConst.fontWeight.regular,
    height: 1.55,
  );

  static final TextStyle label = _sans(
    size: TypoConst.fontSize.label,
    weight: TypoConst.fontWeight.semiBold,
    height: 1.32,
  );

  static final TextStyle fieldLabel = _sans(
    size: 12,
    weight: TypoConst.fontWeight.medium,
    height: 1.28,
  );

  static final TextStyle buttonLabel = _sans(
    size: 13,
    weight: TypoConst.fontWeight.medium,
    height: 1.15,
  );

  static final TextStyle chipLabel = _sans(
    size: 11,
    weight: TypoConst.fontWeight.medium,
    height: 1.18,
  );

  static final TextStyle hint = _sans(
    size: 11,
    weight: TypoConst.fontWeight.regular,
    height: 1.35,
  );

  static final TextStyle cardTitle = _sans(
    size: 16,
    weight: TypoConst.fontWeight.semiBold,
    height: 1.28,
    letterSpacing: -0.1,
  );

  static final TextStyle cardBody = _sans(
    size: 13,
    weight: TypoConst.fontWeight.regular,
    height: 1.55,
  );

  static final TextStyle metaMono = _mono(
    size: TypoConst.fontSize.meta,
    weight: TypoConst.fontWeight.medium,
    height: 1.3,
    letterSpacing: 0.2,
  );

  static final TextStyle metricMono = _mono(
    size: 10,
    weight: TypoConst.fontWeight.medium,
    height: 1.2,
    letterSpacing: 0.9,
  );

  static final TextStyle tableHeader = _mono(
    size: 10,
    weight: TypoConst.fontWeight.medium,
    height: 1.2,
    letterSpacing: 0.9,
  );

  static final TextStyle tableCode = _mono(
    size: 11,
    weight: TypoConst.fontWeight.medium,
    height: 1.3,
    letterSpacing: 0.2,
  );

  // Backward-compatible aliases
  static TextStyle get largeTitle => display;
  static TextStyle get title1 => h1;
  static TextStyle get title2 => h2;
  static TextStyle get title3 => h3;
  static TextStyle get headline => h3;
  static TextStyle get callout => body;
  static TextStyle get subhead => body;
  static TextStyle get footnote => label;
  static TextStyle get caption1 => label;
  static TextStyle get caption2 => metaMono;
}

class HIGTypo {
  HIGTypo._();

  static TextStyle get largeTitle => XkTypo.largeTitle;
  static TextStyle get title1 => XkTypo.title1;
  static TextStyle get title2 => XkTypo.title2;
  static TextStyle get title3 => XkTypo.title3;
  static TextStyle get headline => XkTypo.headline;
  static TextStyle get body => XkTypo.body;
  static TextStyle get callout => XkTypo.callout;
  static TextStyle get subhead => XkTypo.subhead;
  static TextStyle get footnote => XkTypo.footnote;
  static TextStyle get caption1 => XkTypo.caption1;
  static TextStyle get caption2 => XkTypo.caption2;
}

class M3Typo {
  M3Typo._();

  static TextStyle _m3(double size, FontWeight weight) {
    return TextStyle(
      fontFamily: Pretendard.fontFamily,
      package: Pretendard.package,
      fontFamilyFallback: const [
        'Apple SD Gothic Neo',
        IBMPlexSansKR.fontFamily,
      ],
      fontSize: size,
      fontWeight: weight,
      height: 1.5,
    );
  }

  static TextStyle get displayLarge =>
      _m3(TypoConst.fontSize.displayLarge, TypoConst.fontWeight.regular);
  static TextStyle get displayMedium =>
      _m3(TypoConst.fontSize.displayMedium, TypoConst.fontWeight.regular);
  static TextStyle get displaySmall =>
      _m3(TypoConst.fontSize.displaySmall, TypoConst.fontWeight.regular);
  static TextStyle get headlineLarge =>
      _m3(TypoConst.fontSize.headlineLarge, TypoConst.fontWeight.regular);
  static TextStyle get headlineMedium =>
      _m3(TypoConst.fontSize.headlineMedium, TypoConst.fontWeight.regular);
  static TextStyle get headlineSmall =>
      _m3(TypoConst.fontSize.headlineSmall, TypoConst.fontWeight.regular);
  static TextStyle get titleLarge =>
      _m3(TypoConst.fontSize.titleLarge, TypoConst.fontWeight.regular);
  static TextStyle get titleMedium =>
      _m3(TypoConst.fontSize.titleMedium, TypoConst.fontWeight.medium);
  static TextStyle get titleSmall =>
      _m3(TypoConst.fontSize.titleSmall, TypoConst.fontWeight.medium);
  static TextStyle get labelLarge =>
      _m3(TypoConst.fontSize.labelLarge, TypoConst.fontWeight.medium);
  static TextStyle get labelMedium =>
      _m3(TypoConst.fontSize.labelMedium, TypoConst.fontWeight.medium);
  static TextStyle get labelSmall =>
      _m3(TypoConst.fontSize.labelSmall, TypoConst.fontWeight.medium);
  static TextStyle get bodyLarge =>
      _m3(TypoConst.fontSize.bodyLarge, TypoConst.fontWeight.regular);
  static TextStyle get bodyMedium =>
      _m3(TypoConst.fontSize.bodyMedium, TypoConst.fontWeight.regular);
  static TextStyle get bodySmall =>
      _m3(TypoConst.fontSize.bodySmall, TypoConst.fontWeight.regular);
}

TextStyle _familyStyle({
  required String fontFamily,
  required String package,
  required double fontSize,
  required FontWeight weight,
}) {
  return TextStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    fontWeight: weight,
  );
}

class SFPro {
  SFPro._();

  static const String fontFamily = IBMPlexSans.fontFamily;
  static const String package = IBMPlexSans.package;

  static TextStyle thin({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w100,
  );
  static TextStyle extraLight({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w200,
  );
  static TextStyle light({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w300,
  );
  static TextStyle regular({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w400,
  );
  static TextStyle medium({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w500,
  );
  static TextStyle semiBold({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w600,
  );
  static TextStyle bold({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w700,
  );
  static TextStyle extraBold({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w800,
  );
  static TextStyle black({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w900,
  );
}

class AppleSDGothicNeo {
  AppleSDGothicNeo._();

  static const String fontFamily = IBMPlexSans.fontFamily;
  static const String package = IBMPlexSans.package;

  static TextStyle thin({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w100,
  );
  static TextStyle extraLight({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w200,
  );
  static TextStyle light({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w300,
  );
  static TextStyle regular({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w400,
  );
  static TextStyle medium({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w500,
  );
  static TextStyle semiBold({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w600,
  );
  static TextStyle bold({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w700,
  );
  static TextStyle extraBold({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w800,
  );
  static TextStyle black({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w900,
  );
}

class Roboto {
  Roboto._();

  static const String fontFamily = IBMPlexSans.fontFamily;
  static const String package = IBMPlexSans.package;

  static TextStyle thin({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w100,
  );
  static TextStyle light({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w300,
  );
  static TextStyle regular({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w400,
  );
  static TextStyle medium({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w500,
  );
  static TextStyle bold({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w700,
  );
  static TextStyle black({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w900,
  );
}

class NotoSansKR {
  NotoSansKR._();

  static const String fontFamily = IBMPlexSans.fontFamily;
  static const String package = IBMPlexSans.package;

  static TextStyle thin({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w100,
  );
  static TextStyle light({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w300,
  );
  static TextStyle regular({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w400,
  );
  static TextStyle medium({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w500,
  );
  static TextStyle bold({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w700,
  );
  static TextStyle black({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w900,
  );
}

class Pretendard {
  Pretendard._();

  static const String fontFamily = 'Pretendard';
  static const String package = 'xerkonix_design_system';

  static TextStyle thin({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w100,
  );
  static TextStyle extraLight({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w200,
  );
  static TextStyle light({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w300,
  );
  static TextStyle regular({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w400,
  );
  static TextStyle medium({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w500,
  );
  static TextStyle semiBold({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w600,
  );
  static TextStyle bold({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w700,
  );
  static TextStyle extraBold({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w800,
  );
  static TextStyle black({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w900,
  );
}

/// MaruBuri serif — v1.5 display family (28px+ headings only).
class MaruBuri {
  MaruBuri._();

  static const String fontFamily = 'MaruBuri';
  static const String package = 'xerkonix_design_system';

  static TextStyle light({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w300,
  );
  static TextStyle regular({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w400,
  );
  static TextStyle semiBold({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w600,
  );
  static TextStyle bold({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w700,
  );
}

class IBMPlexSansKR {
  IBMPlexSansKR._();

  static const String fontFamily = 'IBMPlexSansKR';
  static const String package = 'xerkonix_design_system';

  static TextStyle thin({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w100,
  );
  static TextStyle extraLight({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w200,
  );
  static TextStyle light({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w300,
  );
  static TextStyle regular({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w400,
  );
  static TextStyle medium({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w500,
  );
  static TextStyle semiBold({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w600,
  );
  static TextStyle bold({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w700,
  );
  static TextStyle extraBold({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w800,
  );
  static TextStyle black({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w900,
  );
}

class IBMPlexMono {
  IBMPlexMono._();

  static const String fontFamily = 'IBMPlexMono';
  static const String package = 'xerkonix_design_system';

  static TextStyle thin({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w100,
  );
  static TextStyle extraLight({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w200,
  );
  static TextStyle light({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w300,
  );
  static TextStyle regular({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w400,
  );
  static TextStyle medium({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w500,
  );
  static TextStyle semiBold({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w600,
  );
  static TextStyle bold({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w700,
  );
  static TextStyle extraBold({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w800,
  );
  static TextStyle black({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w900,
  );
}

/// Backward-compatible alias: legacy API name now maps to Pretendard (v1.5 sans).
class IBMPlexSans {
  IBMPlexSans._();

  static const String fontFamily = Pretendard.fontFamily;
  static const String package = Pretendard.package;

  static TextStyle thin({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w100,
  );
  static TextStyle extraLight({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w200,
  );
  static TextStyle light({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w300,
  );
  static TextStyle regular({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w400,
  );
  static TextStyle medium({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w500,
  );
  static TextStyle semiBold({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w600,
  );
  static TextStyle bold({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w700,
  );
  static TextStyle extraBold({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w800,
  );
  static TextStyle black({required double fontSize}) => _familyStyle(
    fontFamily: fontFamily,
    package: package,
    fontSize: fontSize,
    weight: FontWeight.w900,
  );
}
