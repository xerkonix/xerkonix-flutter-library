import 'package:flutter/material.dart';

import '../../palette/color.dart';

/// Light color scheme based on XERKONIX TACTILE tokens.
///
/// The action accent is a monochrome ink (near-black); the tertiary role hosts
/// the cool temperature accent so the warm/cool pair has a place in the scheme.
const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: XkColor.accent,
  onPrimary: XkColor.accentText,
  primaryContainer: XkColor.accentSoft,
  onPrimaryContainer: XkColor.textStrong,
  secondary: XkColor.accentDeep,
  onSecondary: XkColor.accentText,
  secondaryContainer: XkColor.surface2,
  onSecondaryContainer: XkColor.textStrong,
  tertiary: XkColor.tempCool,
  onTertiary: Colors.white,
  tertiaryContainer: XkColor.tempCoolSoft,
  onTertiaryContainer: XkColor.textStrong,
  error: XkColor.error,
  onError: Colors.white,
  errorContainer: XkColor.errorSoft,
  onErrorContainer: XkColor.textStrong,
  surface: XkColor.surface,
  onSurface: XkColor.textStrong,
  surfaceContainerHighest: XkColor.surface2,
  onSurfaceVariant: XkColor.textBody,
  outline: XkColor.border,
  outlineVariant: XkColor.borderSoft,
  shadow: XkColor.shadow,
  scrim: Color(0x66000000),
  inverseSurface: XkColor.textStrong,
  onInverseSurface: XkColor.bg,
  inversePrimary: XkColor.darkAccent,
  surfaceTint: Colors.transparent,
);
