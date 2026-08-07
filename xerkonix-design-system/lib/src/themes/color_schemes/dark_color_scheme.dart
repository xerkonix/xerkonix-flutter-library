import 'package:flutter/material.dart';

import '../../palette/color.dart';

/// Dark color scheme based on XERKONIX TACTILE tokens.
///
/// The action accent inverts to a near-white ink; the tertiary role hosts the
/// cool temperature accent.
const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: XkColor.darkAccent,
  onPrimary: XkColor.darkAccentText,
  primaryContainer: XkColor.darkAccentSoft,
  onPrimaryContainer: XkColor.darkTextStrong,
  secondary: XkColor.darkAccentDeep,
  onSecondary: XkColor.darkAccentText,
  secondaryContainer: XkColor.darkSurface2,
  onSecondaryContainer: XkColor.darkTextStrong,
  tertiary: XkColor.darkTempCool,
  onTertiary: XkColor.darkBg,
  tertiaryContainer: XkColor.darkTempCoolSoft,
  onTertiaryContainer: XkColor.darkTextStrong,
  error: XkColor.darkError,
  onError: XkColor.darkBg,
  errorContainer: XkColor.darkErrorSoft,
  onErrorContainer: XkColor.darkTextStrong,
  surface: XkColor.darkSurface,
  onSurface: XkColor.darkTextStrong,
  surfaceContainerHighest: XkColor.darkSurface2,
  onSurfaceVariant: XkColor.darkTextBody,
  outline: XkColor.darkBorder,
  outlineVariant: XkColor.darkBorderSoft,
  shadow: Color(0x9E000000),
  // 다크 --bg 가 거의 검정이라 배경색 계열 스크림은 암전이 0 — 정본은
  // 순검정 기반 rgba(0,0,0,.66) 으로 더 강하게 덮는다.
  scrim: Color(0xA8000000), // 정본 다크 --scrim rgba(0,0,0,.66)
  inverseSurface: XkColor.darkTextStrong,
  onInverseSurface: XkColor.darkBg,
  inversePrimary: XkColor.accent,
  surfaceTint: Colors.transparent,
);
