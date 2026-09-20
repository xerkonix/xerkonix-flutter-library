import 'package:flutter/material.dart';

import '../palette/color.dart';
import '../tactile/tactile_fonts.dart';
import '../tactile/tactile_theme.dart';
import 'xerkonix_theme.dart';

/// Public dark [ThemeData]. Delegates to [XkTactileTheme] so existing
/// `XkDarkTheme.themeData` callers get current roles (canvas #111111, ice
/// primary, panel / overlay chrome) — not product #141414 or aqua gem.
class XkDarkTheme extends XkTheme {
  XkDarkTheme._();

  static ThemeData get themeData => XkTactileTheme.themeData(
        Brightness.dark,
        fontFamily: XkTactileFonts.family,
        error: XkColor.darkBad,
        onError: XkColor.darkInk,
        tertiary: XkColor.darkCool,
        onTertiary: XkColor.darkGroundHi,
      );
}
