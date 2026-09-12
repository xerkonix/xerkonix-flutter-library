import 'package:flutter/material.dart';

import '../../palette/color.dart';

/// Light color scheme based on TACTILE v4 tokens.
const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: XkColor.aquaMid,
  onPrimary: XkColor.aquaInk,
  primaryContainer: XkColor.aqua100,
  onPrimaryContainer: XkColor.ink,
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
  inverseSurface: XkColor.ink,
  onInverseSurface: XkColor.canvas,
  inversePrimary: XkColor.darkAquaMid,
  surfaceTint: XkColor.none,
);
