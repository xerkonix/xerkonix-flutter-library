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
  scrim: Color(0x99000000),
  inverseSurface: XkColor.darkTextStrong,
  onInverseSurface: XkColor.darkBg,
  inversePrimary: XkColor.accent,
  surfaceTint: Colors.transparent,
);
