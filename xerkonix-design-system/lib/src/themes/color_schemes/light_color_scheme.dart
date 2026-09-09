import 'package:flutter/material.dart';

import '../../palette/color.dart';

/// Light color scheme based on XERKONIX TACTILE tokens.
///
/// The action accent is a monochrome ink (near-black); the tertiary role hosts
/// the cool temperature accent so the warm/cool pair has a place in the scheme.
const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: XkColor.ink,
  onPrimary: XkColor.bg,
  primaryContainer: XkColor.tintSoft,
  onPrimaryContainer: XkColor.ink,
  secondary: XkColor.tintTextHover,
  onSecondary: XkColor.tintOnFill,
  secondaryContainer: XkColor.hairSoft,
  onSecondaryContainer: XkColor.ink,
  tertiary: XkColor.cool,
  onTertiary: Colors.white,
  tertiaryContainer: XkColor.cool,
  onTertiaryContainer: XkColor.ink,
  error: XkColor.bad,
  onError: Colors.white,
  errorContainer: XkColor.bad,
  onErrorContainer: XkColor.ink,
  surface: XkColor.panel,
  onSurface: XkColor.ink,
  surfaceContainerHighest: XkColor.hairSoft,
  onSurfaceVariant: XkColor.ink,
  outline: XkColor.hair,
  outlineVariant: XkColor.hairSoft,
  shadow: XkColor.sh,
  scrim: Color(0x731A1B22), // 정본 --scrim rgba(26,27,34,.45)
  inverseSurface: XkColor.ink,
  onInverseSurface: XkColor.bg,
  inversePrimary: XkColor.darkTintFill,
  surfaceTint: Colors.transparent,
);
