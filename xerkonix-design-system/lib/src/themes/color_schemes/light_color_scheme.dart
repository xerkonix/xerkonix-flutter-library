import 'package:flutter/material.dart';

import '../../palette/color.dart';

/// Light color scheme based on TACTILE v4.2 tokens.
/// Primary CTA is inverse (black) + white ink. Aqua is not the main action.
const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: XkColor.surfaceInverse,
  onPrimary: XkColor.inkInverse,
  primaryContainer: XkColor.surfaceInverseCard,
  onPrimaryContainer: XkColor.inkInverse,
  secondary: XkColor.ink,
  onSecondary: XkColor.groundHi,
  secondaryContainer: XkColor.insetBg,
  onSecondaryContainer: XkColor.ink,
  tertiary: XkColor.cool,
  onTertiary: XkColor.groundHi,
  tertiaryContainer: XkColor.insetBg,
  onTertiaryContainer: XkColor.ink,
  error: XkColor.bad,
  onError: XkColor.canvas,
  errorContainer: XkColor.insetBg,
  onErrorContainer: XkColor.bad,
  surface: XkColor.canvas,
  onSurface: XkColor.ink,
  surfaceContainerHighest: XkColor.groundHi,
  onSurfaceVariant: XkColor.ink2,
  outline: XkColor.rule,
  outlineVariant: XkColor.rule,
  shadow: XkColor.glassShadowNear,
  scrim: XkColor.ink,
  inverseSurface: XkColor.surfaceInverse,
  onInverseSurface: XkColor.inkInverse,
  inversePrimary: XkColor.aquaMid,
  surfaceTint: XkColor.none,
);
