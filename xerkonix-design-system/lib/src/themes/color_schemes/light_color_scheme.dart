import 'package:flutter/material.dart';

import '../../palette/color.dart';

/// Light color scheme based on XERKONIX DS v1.1 tokens.
const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: XkColor.identity,
  onPrimary: Colors.white,
  primaryContainer: XkColor.identitySoft,
  onPrimaryContainer: XkColor.text,
  secondary: XkColor.action,
  onSecondary: Colors.white,
  secondaryContainer: XkColor.actionSoft,
  onSecondaryContainer: XkColor.actionDeep,
  tertiary: XkColor.signal,
  onTertiary: Colors.white,
  tertiaryContainer: XkColor.signalWash,
  onTertiaryContainer: XkColor.text,
  error: XkColor.error,
  onError: Colors.white,
  errorContainer: Color(0xFFF4DDD7),
  onErrorContainer: XkColor.text,
  surface: XkColor.surface,
  onSurface: XkColor.text,
  surfaceContainerHighest: XkColor.surfaceSoft,
  onSurfaceVariant: XkColor.textBody,
  outline: XkColor.borderMid,
  outlineVariant: XkColor.borderSoft,
  shadow: Color(0x1A000000),
  scrim: Color(0x66000000),
  inverseSurface: XkColor.text,
  onInverseSurface: XkColor.canvas,
  inversePrimary: XkColor.identitySoft,
  surfaceTint: XkColor.identity,
);
