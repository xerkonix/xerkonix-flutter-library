import 'package:flutter/material.dart';

import '../../palette/color.dart';

/// Dark color scheme based on TACTILE v4.2 tokens.
/// Primary CTA stays inverse (black + white ink). Aqua is a small point only.
const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: XkColor.surfaceInverse,
  onPrimary: XkColor.inkInverse,
  primaryContainer: XkColor.surfaceInverseCard,
  onPrimaryContainer: XkColor.inkInverse,
  secondary: XkColor.darkInk,
  onSecondary: XkColor.darkGroundHi,
  secondaryContainer: XkColor.darkInsetBg,
  onSecondaryContainer: XkColor.darkInk,
  tertiary: XkColor.darkCool,
  onTertiary: XkColor.darkGroundHi,
  tertiaryContainer: XkColor.darkInsetBg,
  onTertiaryContainer: XkColor.darkInk,
  error: XkColor.darkBad,
  onError: XkColor.darkCanvas,
  errorContainer: XkColor.darkInsetBg,
  onErrorContainer: XkColor.darkBad,
  surface: XkColor.darkCanvas,
  onSurface: XkColor.darkInk,
  surfaceContainerHighest: XkColor.darkGroundHi,
  onSurfaceVariant: XkColor.darkInk2,
  outline: XkColor.darkRule,
  outlineVariant: XkColor.darkRule,
  shadow: XkColor.darkGlassShadowNear,
  scrim: XkColor.darkCanvas,
  inverseSurface: XkColor.surfaceInverse,
  onInverseSurface: XkColor.inkInverse,
  inversePrimary: XkColor.darkAquaMid,
  surfaceTint: XkColor.none,
);
