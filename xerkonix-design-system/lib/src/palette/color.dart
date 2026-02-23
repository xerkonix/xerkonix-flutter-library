import 'dart:ui';

/// XERKONIX Design Token Colors (v1.1)
///
/// Reference:
/// - /Users/kimdoohyeon/Projects/xerkonix/weave/design system/XERKONIX_Internal_Design_Guide_v1.1.md
class XkColor {
  XkColor._();

  // Light theme foundations
  static const Color canvas = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceSoft = Color(0xFFF2EFE9);
  static const Color surfaceDeep = Color(0xFFEBE6DD);

  // Light theme text
  static const Color text = Color(0xFF2D2D2D);
  static const Color textBody = Color(0xFF6F6B63);
  static const Color textSoft = Color(0xFF9D9990);
  static const Color textFaint = Color(0xFFC8C5BF);

  // Brand and accent
  static const Color identity = Color(0xFFC0A062);
  static const Color identityDeep = Color(0xFFA88844);
  static const Color identitySoft = Color(0xFFD4BC8A);
  static const Color identityWash = Color(0x1FC0A062);

  static const Color action = Color(0xFFD97757);
  static const Color actionDeep = Color(0xFFC0603E);
  static const Color actionSoft = Color(0xFFF6E4DE);
  static const Color actionWash = Color(0x24D97757);

  static const Color signal = Color(0xFFFF6B6B);
  static const Color signalWash = Color(0x1FFF6B6B);

  // Semantic colors
  static const Color success = Color(0xFF5B8C73);
  static const Color warning = Color(0xFFE08E45);
  static const Color error = Color(0xFFC25F4B);
  static const Color info = Color(0xFF6E7FA3);

  // Dark theme overrides
  static const Color darkCanvas = Color(0xFF1D1D1D);
  static const Color darkSurface = Color(0xFF262626);
  static const Color darkSurfaceSoft = Color(0xFF2C2A27);
  static const Color darkSurfaceDeep = Color(0xFF34312D);

  static const Color darkText = Color(0xFFF5F5F5);
  static const Color darkTextBody = Color(0xFFCDC9BE);
  static const Color darkTextSoft = Color(0xFFA8A399);
  static const Color darkTextFaint = Color(0xFF858076);

  static const Color darkIdentity = Color(0xFFD4BC8A);
  static const Color darkIdentityDeep = Color(0xFFC0A062);
  static const Color darkIdentitySoft = Color(0xFFE2CB9E);
  static const Color darkIdentityWash = Color(0x33D4BC8A);

  static const Color darkAction = Color(0xFFFF8D72);
  static const Color darkActionDeep = Color(0xFFF07B59);
  static const Color darkActionSoft = Color(0x33FF8D72);
  static const Color darkActionWash = Color(0x2EFF8D72);

  static const Color darkSignal = Color(0xFFFF8F8F);
  static const Color darkSignalWash = Color(0x33FF8F8F);

  // Border tokens
  static const Color borderSoft = Color(0x142D2D2D);
  static const Color borderMid = Color(0x292D2D2D);
  static const Color borderStrong = Color(0x3D2D2D2D);

  static const Color darkBorderSoft = Color(0x1AF5F5F5);
  static const Color darkBorderMid = Color(0x2EF5F5F5);
  static const Color darkBorderStrong = Color(0x52F5F5F5);

  // Generic role mapping
  static const Color primary = identity;
  static const Color secondary = action;
  static const Color tertiary = signal;

  // Backward-compatible aliases
  static const Color structure = text;
  static const Color overlay = surfaceDeep;
  static const Color divider = borderMid;

  static const Color textPrimary = text;
  static const Color bodyText = textBody;
  static const Color textTertiary = textSoft;
  static const Color textDisabled = textFaint;

  static const Color trust = identity;
  static const Color pulse = signal;
  static const Color life = signal;
  static const Color warmGraphite = textBody;

  @Deprecated('Use XkColor.canvas instead')
  static const Color pinkLavender = Color(0xFFCDB4DB);

  @Deprecated('Use XkColor.canvas instead')
  static const Color lilac = Color(0xFFBE95C4);

  @Deprecated('Use XkColor.canvas instead')
  static const Color bilobaFlower = Color(0xFFAE99DE);

  @Deprecated('Use XkColor.identity instead')
  static const Color xerkonix = Color(0xFF9C75DB);

  @Deprecated('Use XkColor.canvas instead')
  static const Color veryPeri = Color(0xFF6667AB);

  @Deprecated('Use XkColor.text instead')
  static const Color royalPurple = Color(0xFF7851A9);

  @Deprecated('Use XkColor.text instead')
  static const Color deepPurple = Color(0xFF3A243B);

  @Deprecated('Use XkColor.signal instead')
  static const Color tyrianPurple = Color(0xFF66023C);

  @Deprecated('Use XkColor.signal instead')
  static const Color mahoganyRed = Color(0xFF670A0A);

  @Deprecated('Use XkColor.signal instead')
  static const Color carmine = Color(0xFF900020);

  @Deprecated('Use XkColor.text instead')
  static const Color oldLavender = Color(0xFF71697A);

  @Deprecated('Use XkColor.text instead')
  static const Color grey = Color(0xFF939597);
}
