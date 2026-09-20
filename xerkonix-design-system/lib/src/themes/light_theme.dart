import 'package:flutter/material.dart';

import '../palette/color.dart';
import '../tactile/tactile_theme.dart';
import '../typography/xerkonix_typography.dart';
import 'xerkonix_theme.dart';

/// Public light [ThemeData]. Delegates to [XkTactileTheme] so existing
/// `XkLightTheme.themeData` callers (example included) get current roles —
/// ice primary, panel cards, tactile inputs — not aqua gem / glass cards.
///
/// Brand state / temperature (`bad`, `cool`) stay as allowed differences.
class XkLightTheme extends XkTheme {
  XkLightTheme._();

  static ThemeData get themeData => XkTactileTheme.themeData(
        Brightness.light,
        fontFamily: Pretendard.fontFamily,
        error: XkColor.bad,
        onError: XkColor.inkInverse,
        tertiary: XkColor.cool,
        onTertiary: XkColor.groundHi,
      );
}
