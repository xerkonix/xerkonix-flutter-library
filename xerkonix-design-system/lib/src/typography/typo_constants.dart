import 'dart:ui';

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
  final FontWeight bold = FontWeight.w700;
  final FontWeight extraBold = FontWeight.w800;
  final FontWeight black = FontWeight.w900;
}

class _FontSize {
  // XERKONIX TACTILE v3.1 role scale
  final double displayMin = 34;
  final double displayMax = 58;
  final double h1Min = 30;
  final double h1Max = 44;
  final double h2 = 32;
  final double h3 = 22;
  final double bodyLarge = 17;
  final double body = 16;
  final double label = 15;
  final double meta = 13;

  // 업무 페이지 제목은 왼쪽 정렬로 내용과 행동을 연결한다.
  final double pageTitle = 32;

  // Apple alias mapping (backward compatibility)
  final double largeTitle = 58;
  final double title1 = 44;
  final double title2 = 32;
  final double title3 = 22;
  final double headline = 22;
  final double callout = 16;
  final double subhead = 15;
  final double footnote = 13;
  final double caption1 = 13;
  final double caption2 = 13;

  // Material aliases
  final double displayLarge = 58;
  final double displayMedium = 44;
  final double displaySmall = 34;
  final double headlineLarge = 32;
  final double headlineMedium = 28;
  final double headlineSmall = 22;
  final double titleLarge = 22;
  final double titleMedium = 17;
  final double titleSmall = 15;
  final double labelLarge = 15;
  final double labelMedium = 13;
  final double labelSmall = 13;
  final double bodyMedium = 16;
  final double bodySmall = 15;
}
