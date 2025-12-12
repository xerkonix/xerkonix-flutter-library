import 'package:flutter/painting.dart';

import 'typo_constants.dart';

/// XkTypo - Main Typography System
/// Warm Intelligence: 시집을 읽는 듯한 넉넉한 행간과 자간
/// "여백이 곧 콘텐츠"
class XkTypo {
  XkTypo._();

  // Typography Rules: IBM Plex Sans
  // 자간(Tracking): -0.01em ~ -0.02em로 좁게 설정하여 단단한 인상을 줄 것
  // 행간(Line Height): 150% 이상으로 설정하여 여유로운 호흡을 줄 것
  static const double _lineHeight = 1.5; // 150% 이상 (여유로운 호흡)
  static const double _letterSpacing = -0.015; // -0.01em ~ -0.02em (단단한 인상)

  // 색상은 ThemeData의 textTheme에서 설정되므로 여기서는 null로 설정
  // Light theme: Structure (#2D2D2D) / Body Text (#4A4A4A)
  // Dark theme: Canvas (#F5F5F5)로 자동 반전
  static final TextStyle largeTitle = TextStyle(
      fontFamily: IBMPlexSans.fontFamily,
      fontFamilyFallback: const [NotoSansKR.fontFamily],
      fontSize: TypoConst.fontSize.largeTitle,
      fontWeight: TypoConst.fontWeight.regular,
      height: _lineHeight,
      letterSpacing: _letterSpacing);

  static final TextStyle title1 = TextStyle(
      fontFamily: IBMPlexSans.fontFamily,
      fontFamilyFallback: const [NotoSansKR.fontFamily],
      fontSize: TypoConst.fontSize.title1,
      fontWeight: TypoConst.fontWeight.regular,
      height: _lineHeight,
      letterSpacing: _letterSpacing);

  static final TextStyle title2 = TextStyle(
      fontFamily: IBMPlexSans.fontFamily,
      fontFamilyFallback: const [NotoSansKR.fontFamily],
      fontSize: TypoConst.fontSize.title2,
      fontWeight: TypoConst.fontWeight.regular,
      height: _lineHeight,
      letterSpacing: _letterSpacing);

  static final TextStyle title3 = TextStyle(
      fontFamily: IBMPlexSans.fontFamily,
      fontFamilyFallback: const [NotoSansKR.fontFamily],
      fontSize: TypoConst.fontSize.title3,
      fontWeight: TypoConst.fontWeight.regular,
      height: _lineHeight,
      letterSpacing: _letterSpacing);

  static final TextStyle headline = TextStyle(
      fontFamily: IBMPlexSans.fontFamily,
      fontFamilyFallback: const [NotoSansKR.fontFamily],
      fontSize: TypoConst.fontSize.headline,
      fontWeight: TypoConst.fontWeight.semiBold,
      height: _lineHeight,
      letterSpacing: _letterSpacing);

  static final TextStyle body = TextStyle(
      fontFamily: IBMPlexSans.fontFamily,
      fontFamilyFallback: const [NotoSansKR.fontFamily],
      fontSize: TypoConst.fontSize.body,
      fontWeight: TypoConst.fontWeight.regular,
      height: _lineHeight,
      letterSpacing: _letterSpacing);

  static final TextStyle callout = TextStyle(
      fontFamily: IBMPlexSans.fontFamily,
      fontFamilyFallback: const [NotoSansKR.fontFamily],
      fontSize: TypoConst.fontSize.callout,
      fontWeight: TypoConst.fontWeight.regular,
      height: _lineHeight,
      letterSpacing: _letterSpacing);

  static final TextStyle subhead = TextStyle(
      fontFamily: IBMPlexSans.fontFamily,
      fontFamilyFallback: const [NotoSansKR.fontFamily],
      fontSize: TypoConst.fontSize.subhead,
      fontWeight: TypoConst.fontWeight.regular,
      height: _lineHeight,
      letterSpacing: _letterSpacing);

  static final TextStyle footnote = TextStyle(
      fontFamily: IBMPlexSans.fontFamily,
      fontFamilyFallback: const [NotoSansKR.fontFamily],
      fontSize: TypoConst.fontSize.footnote,
      fontWeight: TypoConst.fontWeight.regular,
      height: _lineHeight,
      letterSpacing: _letterSpacing);

  static final TextStyle caption1 = TextStyle(
      fontFamily: IBMPlexSans.fontFamily,
      fontFamilyFallback: const [NotoSansKR.fontFamily],
      fontSize: TypoConst.fontSize.caption1,
      fontWeight: TypoConst.fontWeight.regular,
      height: _lineHeight,
      letterSpacing: _letterSpacing);

  static final TextStyle caption2 = TextStyle(
      fontFamily: IBMPlexSans.fontFamily,
      fontFamilyFallback: const [NotoSansKR.fontFamily],
      fontSize: TypoConst.fontSize.caption2,
      fontWeight: TypoConst.fontWeight.regular,
      height: _lineHeight,
      letterSpacing: _letterSpacing);
}

class HIGTypo {
  HIGTypo._();

  static final TextStyle largeTitle = TextStyle(
      fontFamily: IBMPlexSans.fontFamily,
      fontFamilyFallback: const [NotoSansKR.fontFamily],
      fontSize: TypoConst.fontSize.largeTitle,
      fontWeight: TypoConst.fontWeight.regular);
  static final TextStyle title1 = TextStyle(
      fontFamily: IBMPlexSans.fontFamily,
      fontFamilyFallback: const [NotoSansKR.fontFamily],
      fontSize: TypoConst.fontSize.title1,
      fontWeight: TypoConst.fontWeight.regular);
  static final TextStyle title2 = TextStyle(
      fontFamily: IBMPlexSans.fontFamily,
      fontFamilyFallback: const [NotoSansKR.fontFamily],
      fontSize: TypoConst.fontSize.title2,
      fontWeight: TypoConst.fontWeight.regular);
  static final TextStyle title3 = TextStyle(
      fontFamily: IBMPlexSans.fontFamily,
      fontFamilyFallback: const [NotoSansKR.fontFamily],
      fontSize: TypoConst.fontSize.title3,
      fontWeight: TypoConst.fontWeight.regular);
  static final TextStyle headline = TextStyle(
      fontFamily: IBMPlexSans.fontFamily,
      fontFamilyFallback: const [NotoSansKR.fontFamily],
      fontSize: TypoConst.fontSize.headline,
      fontWeight: TypoConst.fontWeight.semiBold);
  static final TextStyle body = TextStyle(
      fontFamily: IBMPlexSans.fontFamily,
      fontFamilyFallback: const [NotoSansKR.fontFamily],
      fontSize: TypoConst.fontSize.body,
      fontWeight: TypoConst.fontWeight.regular);
  static final TextStyle callout = TextStyle(
      fontFamily: IBMPlexSans.fontFamily,
      fontFamilyFallback: const [NotoSansKR.fontFamily],
      fontSize: TypoConst.fontSize.callout,
      fontWeight: TypoConst.fontWeight.regular);
  static final TextStyle subhead = TextStyle(
      fontFamily: IBMPlexSans.fontFamily,
      fontFamilyFallback: const [NotoSansKR.fontFamily],
      fontSize: TypoConst.fontSize.subhead,
      fontWeight: TypoConst.fontWeight.regular);
  static final TextStyle footnote = TextStyle(
      fontFamily: IBMPlexSans.fontFamily,
      fontFamilyFallback: const [NotoSansKR.fontFamily],
      fontSize: TypoConst.fontSize.footnote,
      fontWeight: TypoConst.fontWeight.regular);
  static final TextStyle caption1 = TextStyle(
      fontFamily: IBMPlexSans.fontFamily,
      fontFamilyFallback: const [NotoSansKR.fontFamily],
      fontSize: TypoConst.fontSize.caption1,
      fontWeight: TypoConst.fontWeight.regular);
  static final TextStyle caption2 = TextStyle(
      fontFamily: IBMPlexSans.fontFamily,
      fontFamilyFallback: const [NotoSansKR.fontFamily],
      fontSize: TypoConst.fontSize.caption2,
      fontWeight: TypoConst.fontWeight.regular);
}

class M3Typo {
  M3Typo._();

  static final TextStyle displayLarge = TextStyle(
      fontFamily: IBMPlexSans.fontFamily,
      fontFamilyFallback: const [NotoSansKR.fontFamily],
      fontSize: TypoConst.fontSize.displayLarge,
      fontWeight: TypoConst.fontWeight.regular);
  static final TextStyle displayMedium = TextStyle(
      fontFamily: IBMPlexSans.fontFamily,
      fontFamilyFallback: const [NotoSansKR.fontFamily],
      fontSize: TypoConst.fontSize.displayMedium,
      fontWeight: TypoConst.fontWeight.regular);
  static final TextStyle displaySmall = TextStyle(
      fontFamily: IBMPlexSans.fontFamily,
      fontFamilyFallback: const [NotoSansKR.fontFamily],
      fontSize: TypoConst.fontSize.displaySmall,
      fontWeight: TypoConst.fontWeight.regular);
  static final TextStyle headlineLarge = TextStyle(
      fontFamily: IBMPlexSans.fontFamily,
      fontFamilyFallback: const [NotoSansKR.fontFamily],
      fontSize: TypoConst.fontSize.headlineLarge,
      fontWeight: TypoConst.fontWeight.regular);
  static final TextStyle headlineMedium = TextStyle(
      fontFamily: IBMPlexSans.fontFamily,
      fontFamilyFallback: const [NotoSansKR.fontFamily],
      fontSize: TypoConst.fontSize.headlineMedium,
      fontWeight: TypoConst.fontWeight.regular);
  static final TextStyle headlineSmall = TextStyle(
      fontFamily: IBMPlexSans.fontFamily,
      fontFamilyFallback: const [NotoSansKR.fontFamily],
      fontSize: TypoConst.fontSize.headlineSmall,
      fontWeight: TypoConst.fontWeight.regular);
  static final TextStyle titleLarge = TextStyle(
      fontFamily: IBMPlexSans.fontFamily,
      fontFamilyFallback: const [NotoSansKR.fontFamily],
      fontSize: TypoConst.fontSize.titleLarge,
      fontWeight: TypoConst.fontWeight.regular);
  static final TextStyle titleMedium = TextStyle(
      fontFamily: IBMPlexSans.fontFamily,
      fontFamilyFallback: const [NotoSansKR.fontFamily],
      fontSize: TypoConst.fontSize.titleMedium,
      fontWeight: TypoConst.fontWeight.medium);
  static final TextStyle titleSmall = TextStyle(
      fontFamily: IBMPlexSans.fontFamily,
      fontFamilyFallback: const [NotoSansKR.fontFamily],
      fontSize: TypoConst.fontSize.titleSmall,
      fontWeight: TypoConst.fontWeight.medium);
  static final TextStyle labelLarge = TextStyle(
      fontFamily: IBMPlexSans.fontFamily,
      fontFamilyFallback: const [NotoSansKR.fontFamily],
      fontSize: TypoConst.fontSize.labelLarge,
      fontWeight: TypoConst.fontWeight.medium);
  static final TextStyle labelMedium = TextStyle(
      fontFamily: IBMPlexSans.fontFamily,
      fontFamilyFallback: const [NotoSansKR.fontFamily],
      fontSize: TypoConst.fontSize.labelMedium,
      fontWeight: TypoConst.fontWeight.medium);
  static final TextStyle labelSmall = TextStyle(
      fontFamily: IBMPlexSans.fontFamily,
      fontFamilyFallback: const [NotoSansKR.fontFamily],
      fontSize: TypoConst.fontSize.labelSmall,
      fontWeight: TypoConst.fontWeight.medium);
  static final TextStyle bodyLarge = TextStyle(
      fontFamily: IBMPlexSans.fontFamily,
      fontFamilyFallback: const [NotoSansKR.fontFamily],
      fontSize: TypoConst.fontSize.bodyLarge,
      fontWeight: TypoConst.fontWeight.regular);
  static final TextStyle bodyMedium = TextStyle(
      fontFamily: IBMPlexSans.fontFamily,
      fontFamilyFallback: const [NotoSansKR.fontFamily],
      fontSize: TypoConst.fontSize.bodyMedium,
      fontWeight: TypoConst.fontWeight.medium);
  static final TextStyle bodySmall = TextStyle(
      fontFamily: IBMPlexSans.fontFamily,
      fontFamilyFallback: const [NotoSansKR.fontFamily],
      fontSize: TypoConst.fontSize.bodySmall,
      fontWeight: TypoConst.fontWeight.regular);
}

class SFPro {
  SFPro._();

  static const String fontFamily = "SFPro";

  static TextStyle thin({required double fontSize}) {
    return TextStyle(fontFamily: fontFamily, fontSize: fontSize, fontWeight: FontWeight.w100, package: "xerkonix_palette");
  }

  static TextStyle extraLight({required double fontSize}) {
    return TextStyle(fontFamily: fontFamily, fontSize: fontSize, fontWeight: FontWeight.w200, package: "xerkonix_palette");
  }

  static TextStyle light({required double fontSize}) {
    return TextStyle(fontFamily: fontFamily, fontSize: fontSize, fontWeight: FontWeight.w300, package: "xerkonix_palette");
  }

  static TextStyle regular({required double fontSize}) {
    return TextStyle(fontFamily: fontFamily, fontSize: fontSize, fontWeight: FontWeight.w400, package: "xerkonix_palette");
  }

  static TextStyle medium({required double fontSize}) {
    return TextStyle(fontFamily: fontFamily, fontSize: fontSize, fontWeight: FontWeight.w500, package: "xerkonix_palette");
  }

  static TextStyle semiBold({required double fontSize}) {
    return TextStyle(fontFamily: fontFamily, fontSize: fontSize, fontWeight: FontWeight.w600, package: "xerkonix_palette");
  }

  static TextStyle bold({required double fontSize}) {
    return TextStyle(fontFamily: fontFamily, fontSize: fontSize, fontWeight: FontWeight.w700, package: "xerkonix_palette");
  }

  static TextStyle extraBold({required double fontSize}) {
    return TextStyle(fontFamily: fontFamily, fontSize: fontSize, fontWeight: FontWeight.w800, package: "xerkonix_palette");
  }

  static TextStyle black({required double fontSize}) {
    return TextStyle(fontFamily: fontFamily, fontSize: fontSize, fontWeight: FontWeight.w900, package: "xerkonix_palette");
  }
}

class AppleSDGothicNeo {
  AppleSDGothicNeo._();

  static const String fontFamily = "AppleSDGothicNeo";

  static TextStyle thin({required double fontSize}) {
    return TextStyle(fontFamily: fontFamily, fontSize: fontSize, fontWeight: FontWeight.w100, package: "xerkonix_palette");
  }

  static TextStyle extraLight({required double fontSize}) {
    return TextStyle(fontFamily: fontFamily, fontSize: fontSize, fontWeight: FontWeight.w200, package: "xerkonix_palette");
  }

  static TextStyle light({required double fontSize}) {
    return TextStyle(fontFamily: fontFamily, fontSize: fontSize, fontWeight: FontWeight.w300, package: "xerkonix_palette");
  }

  static TextStyle regular({required double fontSize}) {
    return TextStyle(fontFamily: fontFamily, fontSize: fontSize, fontWeight: FontWeight.w400, package: "xerkonix_palette");
  }

  static TextStyle medium({required double fontSize}) {
    return TextStyle(fontFamily: fontFamily, fontSize: fontSize, fontWeight: FontWeight.w500, package: "xerkonix_palette");
  }

  static TextStyle semiBold({required double fontSize}) {
    return TextStyle(fontFamily: fontFamily, fontSize: fontSize, fontWeight: FontWeight.w600, package: "xerkonix_palette");
  }

  static TextStyle bold({required double fontSize}) {
    return TextStyle(fontFamily: fontFamily, fontSize: fontSize, fontWeight: FontWeight.w700, package: "xerkonix_palette");
  }

  static TextStyle extraBold({required double fontSize}) {
    return TextStyle(fontFamily: fontFamily, fontSize: fontSize, fontWeight: FontWeight.w800, package: "xerkonix_palette");
  }

  static TextStyle black({required double fontSize}) {
    return TextStyle(fontFamily: fontFamily, fontSize: fontSize, fontWeight: FontWeight.w900, package: "xerkonix_palette");
  }
}

class Roboto {
  Roboto._();

  static const String fontFamily = "Roboto";

  static TextStyle thin({required double fontSize}) {
    return TextStyle(fontFamily: fontFamily, fontSize: fontSize, fontWeight: FontWeight.w100, package: "xerkonix_palette");
  }

  static TextStyle light({required double fontSize}) {
    return TextStyle(fontFamily: fontFamily, fontSize: fontSize, fontWeight: FontWeight.w300, package: "xerkonix_palette");
  }

  static TextStyle regular({required double fontSize}) {
    return TextStyle(fontFamily: fontFamily, fontSize: fontSize, fontWeight: FontWeight.w400, package: "xerkonix_palette");
  }

  static TextStyle medium({required double fontSize}) {
    return TextStyle(fontFamily: fontFamily, fontSize: fontSize, fontWeight: FontWeight.w500, package: "xerkonix_palette");
  }

  static TextStyle bold({required double fontSize}) {
    return TextStyle(fontFamily: fontFamily, fontSize: fontSize, fontWeight: FontWeight.w700, package: "xerkonix_palette");
  }

  static TextStyle black({required double fontSize}) {
    return TextStyle(fontFamily: fontFamily, fontSize: fontSize, fontWeight: FontWeight.w900, package: "xerkonix_palette");
  }
}

class NotoSansKR {
  NotoSansKR._();

  static const String fontFamily = "NotoSansKR";

  static TextStyle thin({required double fontSize}) {
    return TextStyle(fontFamily: fontFamily, fontSize: fontSize, fontWeight: FontWeight.w100, package: "xerkonix_palette");
  }

  static TextStyle light({required double fontSize}) {
    return TextStyle(fontFamily: fontFamily, fontSize: fontSize, fontWeight: FontWeight.w300, package: "xerkonix_palette");
  }

  static TextStyle regular({required double fontSize}) {
    return TextStyle(fontFamily: fontFamily, fontSize: fontSize, fontWeight: FontWeight.w400, package: "xerkonix_palette");
  }

  static TextStyle medium({required double fontSize}) {
    return TextStyle(fontFamily: fontFamily, fontSize: fontSize, fontWeight: FontWeight.w500, package: "xerkonix_palette");
  }

  static TextStyle bold({required double fontSize}) {
    return TextStyle(fontFamily: fontFamily, fontSize: fontSize, fontWeight: FontWeight.w700, package: "xerkonix_palette");
  }

  static TextStyle black({required double fontSize}) {
    return TextStyle(fontFamily: fontFamily, fontSize: fontSize, fontWeight: FontWeight.w900, package: "xerkonix_palette");
  }
}

class Pretendard {
  Pretendard._();

  static const String fontFamily = "Pretendard";

  static TextStyle thin({required double fontSize}) {
    return TextStyle(fontFamily: fontFamily, fontSize: fontSize, fontWeight: FontWeight.w100, package: "xerkonix_design_system");
  }

  static TextStyle extraLight({required double fontSize}) {
    return TextStyle(fontFamily: fontFamily, fontSize: fontSize, fontWeight: FontWeight.w200, package: "xerkonix_design_system");
  }

  static TextStyle light({required double fontSize}) {
    return TextStyle(fontFamily: fontFamily, fontSize: fontSize, fontWeight: FontWeight.w300, package: "xerkonix_design_system");
  }

  static TextStyle regular({required double fontSize}) {
    return TextStyle(fontFamily: fontFamily, fontSize: fontSize, fontWeight: FontWeight.w400, package: "xerkonix_design_system");
  }

  static TextStyle medium({required double fontSize}) {
    return TextStyle(fontFamily: fontFamily, fontSize: fontSize, fontWeight: FontWeight.w500, package: "xerkonix_design_system");
  }

  static TextStyle semiBold({required double fontSize}) {
    return TextStyle(fontFamily: fontFamily, fontSize: fontSize, fontWeight: FontWeight.w600, package: "xerkonix_design_system");
  }

  static TextStyle bold({required double fontSize}) {
    return TextStyle(fontFamily: fontFamily, fontSize: fontSize, fontWeight: FontWeight.w700, package: "xerkonix_design_system");
  }

  static TextStyle extraBold({required double fontSize}) {
    return TextStyle(fontFamily: fontFamily, fontSize: fontSize, fontWeight: FontWeight.w800, package: "xerkonix_design_system");
  }

  static TextStyle black({required double fontSize}) {
    return TextStyle(fontFamily: fontFamily, fontSize: fontSize, fontWeight: FontWeight.w900, package: "xerkonix_design_system");
  }
}

class IBMPlexSans {
  IBMPlexSans._();

  static const String fontFamily = "IBMPlexSans";

  static TextStyle thin({required double fontSize}) {
    return TextStyle(fontFamily: fontFamily, fontSize: fontSize, fontWeight: FontWeight.w100, package: "xerkonix_design_system");
  }

  static TextStyle extraLight({required double fontSize}) {
    return TextStyle(fontFamily: fontFamily, fontSize: fontSize, fontWeight: FontWeight.w200, package: "xerkonix_design_system");
  }

  static TextStyle light({required double fontSize}) {
    return TextStyle(fontFamily: fontFamily, fontSize: fontSize, fontWeight: FontWeight.w300, package: "xerkonix_design_system");
  }

  static TextStyle regular({required double fontSize}) {
    return TextStyle(fontFamily: fontFamily, fontSize: fontSize, fontWeight: FontWeight.w400, package: "xerkonix_design_system");
  }

  static TextStyle medium({required double fontSize}) {
    return TextStyle(fontFamily: fontFamily, fontSize: fontSize, fontWeight: FontWeight.w500, package: "xerkonix_design_system");
  }

  static TextStyle semiBold({required double fontSize}) {
    return TextStyle(fontFamily: fontFamily, fontSize: fontSize, fontWeight: FontWeight.w600, package: "xerkonix_design_system");
  }

  static TextStyle bold({required double fontSize}) {
    return TextStyle(fontFamily: fontFamily, fontSize: fontSize, fontWeight: FontWeight.w700, package: "xerkonix_design_system");
  }

  static TextStyle extraBold({required double fontSize}) {
    return TextStyle(fontFamily: fontFamily, fontSize: fontSize, fontWeight: FontWeight.w800, package: "xerkonix_design_system");
  }

  static TextStyle black({required double fontSize}) {
    return TextStyle(fontFamily: fontFamily, fontSize: fontSize, fontWeight: FontWeight.w900, package: "xerkonix_design_system");
  }
}
