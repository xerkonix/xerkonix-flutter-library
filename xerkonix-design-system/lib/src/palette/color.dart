import 'dart:ui';

/// XERKONIX Design Token Colors (v1.3)
///
/// Reference:
/// - design system/v1.3/tokens.css
/// - design system/v1.3/XERKONIX_Internal_Design_Guide_v1.3.md
///
/// v1.3 color palette hex values are identical to v1.2; the change is in
/// *usage* policy (gold `identity` is no longer the default CTA — see
/// `XkButton.action` / `--color-action` at `#3B434F`).
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

  // Light semantic palette
  static const Color identity = Color(0xFFC0A062);
  static const Color identityDeep = Color(0xFFA88844);
  static const Color identitySoft = Color(0xFFD4BC8A);
  static const Color identityWash = Color(0x1FC0A062);

  static const Color action = Color(0xFF3B434F);
  static const Color actionDeep = Color(0xFF2F3742);
  static const Color actionSoft = Color(0xFFE7EBF0);
  static const Color actionWash = Color(0x243B434F);
  static const Color actionText = Color(0xFFFFFFFF);

  static const Color accent = Color(0xFFC05A2A);
  static const Color accentDeep = Color(0xFF9F461E);
  static const Color accentSoft = Color(0xFFF3DFD6);
  static const Color accentWash = Color(0x24C05A2A);

  static const Color support = Color(0xFF8A9E3A);
  static const Color supportDeep = Color(0xFF6F8128);
  static const Color supportSoft = Color(0xFFE6EDC9);
  static const Color supportWash = Color(0x298A9E3A);

  static const Color signal = Color(0xFFB84040);
  static const Color signalWash = Color(0x24B84040);

  static const Color success = Color(0xFF5B8C73);
  static const Color warning = Color(0xFFF0A43A);
  static const Color warningDeep = Color(0xFFA56700);
  static const Color warningWash = Color(0x2EF0A43A);
  static const Color error = Color(0xFFB84040);
  static const Color info = Color(0xFF6E7FA3);

  // Dark theme foundations
  static const Color darkCanvas = Color(0xFF1D1D1D);
  static const Color darkSurface = Color(0xFF262626);
  static const Color darkSurfaceSoft = Color(0xFF2C2A27);
  static const Color darkSurfaceDeep = Color(0xFF34312D);

  // Dark theme text
  static const Color darkText = Color(0xFFF5F5F5);
  static const Color darkTextBody = Color(0xFFCDC9BE);
  static const Color darkTextSoft = Color(0xFFA8A399);
  static const Color darkTextFaint = Color(0xFF858076);

  // Dark semantic palette
  static const Color darkIdentity = Color(0xFFD4BC8A);
  static const Color darkIdentityDeep = Color(0xFFC0A062);
  static const Color darkIdentitySoft = Color(0xFFE2CB9E);
  static const Color darkIdentityWash = Color(0x33D4BC8A);

  static const Color darkAction = Color(0xFFC2CAD5);
  static const Color darkActionDeep = Color(0xFFD0D7E1);
  static const Color darkActionSoft = Color(0x2EC2CAD5);
  static const Color darkActionWash = Color(0x2EC2CAD5);
  static const Color darkActionText = Color(0xFF18202A);

  static const Color darkAccent = Color(0xFFD8794D);
  static const Color darkAccentDeep = Color(0xFFEBA07C);
  static const Color darkAccentSoft = Color(0x2ED8794D);
  static const Color darkAccentWash = Color(0x33D8794D);

  static const Color darkSupport = Color(0xFFA3B857);
  static const Color darkSupportDeep = Color(0xFFC0D476);
  static const Color darkSupportSoft = Color(0x2EA3B857);
  static const Color darkSupportWash = Color(0x33A3B857);

  static const Color darkSignal = Color(0xFFD56767);
  static const Color darkSignalWash = Color(0x33D56767);

  static const Color darkSuccess = Color(0xFF7EA48F);
  static const Color darkWarning = Color(0xFFFFC457);
  static const Color darkWarningDeep = Color(0xFFFFD27B);
  static const Color darkWarningWash = Color(0x3DFFC457);
  static const Color darkError = Color(0xFFD56767);
  static const Color darkInfo = Color(0xFF8CA0C8);

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
  static const Color tertiary = accent;

  // Backward-compatible aliases
  static const Color structure = text;
  static const Color overlay = surfaceDeep;
  static const Color divider = borderMid;

  static const Color textPrimary = text;
  static const Color bodyText = textBody;
  static const Color textTertiary = textSoft;
  static const Color textDisabled = textFaint;

  static const Color brand = identity;
  static const Color trust = identity;
  static const Color pulse = signal;
  static const Color life = signal;
  static const Color warmGraphite = textBody;
  static const Color danger = error;

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
