import 'package:flutter/material.dart';

import '../../palette/color.dart';

/// Dark color scheme based on XERKONIX DS v1.1 tokens.
const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: XkColor.darkIdentity,
  onPrimary: XkColor.darkCanvas,
  primaryContainer: XkColor.darkIdentitySoft,
  onPrimaryContainer: XkColor.darkCanvas,
  secondary: XkColor.darkAction,
  onSecondary: XkColor.darkCanvas,
  secondaryContainer: XkColor.darkActionSoft,
  onSecondaryContainer: XkColor.darkText,
  tertiary: XkColor.darkSignal,
  onTertiary: XkColor.darkCanvas,
  tertiaryContainer: XkColor.darkSignalWash,
  onTertiaryContainer: XkColor.darkText,
  error: XkColor.error,
  onError: Colors.white,
  errorContainer: Color(0xFF6E3D33),
  onErrorContainer: XkColor.darkText,
  surface: XkColor.darkSurface,
  onSurface: XkColor.darkText,
  surfaceContainerHighest: XkColor.darkSurfaceSoft,
  onSurfaceVariant: XkColor.darkTextBody,
  outline: XkColor.darkBorderMid,
  outlineVariant: XkColor.darkBorderSoft,
  shadow: Color(0x66000000),
  scrim: Color(0x99000000),
  inverseSurface: XkColor.darkText,
  onInverseSurface: XkColor.darkCanvas,
  inversePrimary: XkColor.identity,
  surfaceTint: XkColor.darkIdentity,
);
