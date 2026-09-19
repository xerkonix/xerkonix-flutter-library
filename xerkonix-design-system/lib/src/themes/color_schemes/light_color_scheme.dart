import 'package:flutter/material.dart';

import '../../palette/color.dart';

/// Light color scheme. Primary CTA is `--aqua-fill` opaque fallback `--aqua`
/// + `--aqua-on`. Inverse surface stays a section/footer role.
const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: XkColor.aqua,
  onPrimary: XkColor.aquaOn,
  primaryContainer: XkColor.aqua,
  onPrimaryContainer: XkColor.aquaOn,
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
