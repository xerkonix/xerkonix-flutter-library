import 'package:flutter/material.dart';

import '../../palette/color.dart';

/// Dark color scheme based on XERKONIX TACTILE tokens.
///
/// The action accent inverts to a near-white ink; the tertiary role hosts the
/// cool temperature accent.
const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: XkColor.darkInk,
  onPrimary: XkColor.darkBg,
  primaryContainer: XkColor.darkTintSoft,
  onPrimaryContainer: XkColor.darkInk,
  secondary: XkColor.darkTintLight,
  onSecondary: XkColor.darkTintOnFill,
  secondaryContainer: XkColor.darkHairSoft,
  onSecondaryContainer: XkColor.darkInk,
  tertiary: XkColor.darkCool,
  onTertiary: XkColor.darkBg,
  tertiaryContainer: XkColor.darkCool,
  onTertiaryContainer: XkColor.darkInk,
  error: XkColor.darkBad,
  onError: XkColor.darkBg,
  errorContainer: XkColor.darkBad,
  onErrorContainer: XkColor.darkInk,
  surface: XkColor.darkPanel,
  onSurface: XkColor.darkInk,
  surfaceContainerHighest: XkColor.darkHairSoft,
  onSurfaceVariant: XkColor.darkInk,
  outline: XkColor.darkHair,
  outlineVariant: XkColor.darkHairSoft,
  shadow: Color(0x9E000000),
  // 다크 --bg 가 거의 검정이라 배경색 계열 스크림은 암전이 0 — 정본은
  // 순검정 기반 rgba(0,0,0,.66) 으로 더 강하게 덮는다.
  scrim: Color(0xA8000000), // 정본 다크 --scrim rgba(0,0,0,.66)
  inverseSurface: XkColor.darkInk,
  onInverseSurface: XkColor.darkBg,
  inversePrimary: XkColor.tintFill,
  surfaceTint: Colors.transparent,
);
