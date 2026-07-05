import 'package:flutter/material.dart';

import '../../palette/color.dart';

/// Dark color scheme based on XERKONIX DS v1.5 tokens.
const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: XkColor.darkAccent,
  onPrimary: XkColor.darkBg,
  primaryContainer: XkColor.darkAccentSoft,
  onPrimaryContainer: XkColor.darkBg,
  secondary: XkColor.darkAccentDeep,
  onSecondary: XkColor.darkBg,
  secondaryContainer: XkColor.darkAccentSoft,
  onSecondaryContainer: XkColor.darkTextStrong,
  tertiary: XkColor.darkError,
  onTertiary: XkColor.darkBg,
  tertiaryContainer: XkColor.darkErrorSoft,
  onTertiaryContainer: XkColor.darkTextStrong,
  error: XkColor.error,
  onError: Colors.white,
  errorContainer: Color(0xFF6E3D33),
  onErrorContainer: XkColor.darkTextStrong,
  surface: XkColor.darkSurface,
  onSurface: XkColor.darkTextStrong,
  surfaceContainerHighest: XkColor.darkSurface2,
  onSurfaceVariant: XkColor.darkTextBody,
  outline: XkColor.darkBorder,
  outlineVariant: XkColor.darkBorderSoft,
  shadow: Color(0x66000000),
  scrim: Color(0x99000000),
  inverseSurface: XkColor.darkTextStrong,
  onInverseSurface: XkColor.darkBg,
  inversePrimary: XkColor.accent,
  surfaceTint: XkColor.darkAccent,
);
