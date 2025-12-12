import 'package:flutter/material.dart';

/// Shape & Layout System
/// Sophisticated Round - 유치하지 않은 부드러움을 유지합니다.
class XkShape {
  XkShape._();

  /// Corner Radius: R8 ~ R12
  /// 유치하지 않은 부드러움을 유지합니다.
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 10.0;
  static const double radiusLarge = 12.0;

  /// 기본 Border Radius (R10)
  static const BorderRadius defaultBorderRadius = BorderRadius.all(Radius.circular(10.0));
  
  /// 작은 Border Radius (R8)
  static const BorderRadius smallBorderRadius = BorderRadius.all(Radius.circular(8.0));
  
  /// 큰 Border Radius (R12)
  static const BorderRadius largeBorderRadius = BorderRadius.all(Radius.circular(12.0));
}

/// Layout System
/// "여백이 곧 콘텐츠" - 시집을 읽는 듯한 넉넉한 행간과 자간
class XkLayout {
  XkLayout._();

  /// 넉넉한 여백 (시집을 읽는 듯한 느낌)
  static const double spacingExtraLarge = 32.0;
  static const double spacingLarge = 24.0;
  static const double spacingMedium = 16.0;
  static const double spacingSmall = 12.0;
  static const double spacingExtraSmall = 8.0;

  /// 행간 (Line Height) - 넉넉한 간격
  static const double lineHeightTight = 1.2;
  static const double lineHeightNormal = 1.5;
  static const double lineHeightRelaxed = 1.75;
  static const double lineHeightLoose = 2.0;

  /// 자간 (Letter Spacing) - 시집을 읽는 듯한 느낌
  static const double letterSpacingTight = -0.5;
  static const double letterSpacingNormal = 0.0;
  static const double letterSpacingWide = 0.5;
  static const double letterSpacingWider = 1.0;
}

