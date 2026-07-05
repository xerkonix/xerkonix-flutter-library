import 'package:flutter/material.dart';

import '../../palette/color.dart';

/// Light color scheme based on XERKONIX DS v1.5 tokens.
const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: XkColor.accent,
  onPrimary: Colors.white,
  primaryContainer: XkColor.accentSoft,
  onPrimaryContainer: XkColor.textStrong,
  secondary: XkColor.accentDeep,
  onSecondary: Colors.white,
  secondaryContainer: XkColor.accentSoft,
  onSecondaryContainer: XkColor.accentDeep,
  tertiary: XkColor.error,
  onTertiary: Colors.white,
  tertiaryContainer: XkColor.errorSoft,
  onTertiaryContainer: XkColor.textStrong,
  error: XkColor.error,
  onError: Colors.white,
  errorContainer: Color(0xFFF4DDD7),
  onErrorContainer: XkColor.textStrong,
  surface: XkColor.surface,
  onSurface: XkColor.textStrong,
  surfaceContainerHighest: XkColor.surface2,
  onSurfaceVariant: XkColor.textBody,
  outline: XkColor.border,
  outlineVariant: XkColor.borderSoft,
  shadow: Color(0x1A000000),
  scrim: Color(0x66000000),
  inverseSurface: XkColor.textStrong,
  onInverseSurface: XkColor.bg,
  inversePrimary: XkColor.accentSoft,
  surfaceTint: XkColor.accent,
);
