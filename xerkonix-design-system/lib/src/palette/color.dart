import 'dart:ui';

/// XERKONIX Design Token Colors (v1.5)
///
/// Reference:
/// - design system/v1.5/tokens.css  (single source of truth)
/// - design system/v1.5/MIGRATION-MAP.md
///
/// v1.5 direction:
/// - Neutral system rebuilt on a cool gray-blue 12-step scale
///   (`gray000`..`gray950`, H ~231 deg).
/// - Multi-hue accents (gold / navy / orange / olive) collapse to a single
///   indigo `accent` plus an achromatic `brand` baseline.
/// - No backward-compatible aliases: the v1.4 vocabulary
///   (canvas / identity / action / support / signal ...) is removed.
class XkColor {
  XkColor._();

  // --- Gray-blue neutral scale (H ~231 deg) ---
  static const Color gray000 = Color(0xFFFAFBFD);
  static const Color gray050 = Color(0xFFF2F3F8);
  static const Color gray100 = Color(0xFFE7E9F2);
  static const Color gray200 = Color(0xFFD5D8E8);
  static const Color gray300 = Color(0xFFC0C4DC);
  static const Color gray400 = Color(0xFFA9AFCF); // brand reference value
  static const Color gray500 = Color(0xFF8C93B8);
  static const Color gray600 = Color(0xFF6F779D);
  static const Color gray700 = Color(0xFF565D80);
  static const Color gray800 = Color(0xFF3E4462);
  static const Color gray900 = Color(0xFF292E45);
  static const Color gray950 = Color(0xFF1B1E30);

  // --- Semantic · Light ---
  static const Color bg = gray050;
  static const Color surface = gray000;
  static const Color surface2 = gray100;
  static const Color border = gray200;
  static const Color borderSoft = Color(0x47A9AFCF); // rgba(169,175,207,.28)

  static const Color textStrong = Color(0xFF23263A);
  static const Color textBody = Color(0xFF494F6E);
  static const Color textMuted = gray600;

  static const Color brand = gray400;
  static const Color accent = Color(0xFF4B5DC3);
  static const Color accentDeep = Color(0xFF3D46A8);
  static const Color accentSoft = Color(0xFFE4E6FA);
  static const Color accentText = Color(0xFFFFFFFF);

  static const Color success = Color(0xFF5E8F7B);
  static const Color successSoft = Color(0xFFE2EEE9);
  static const Color warning = Color(0xFFB08954);
  static const Color warningSoft = Color(0xFFF3EADC);
  static const Color error = Color(0xFFB84E5E);
  static const Color errorSoft = Color(0xFFF5E2E5);

  static const Color shadow = Color(0x1A292E45); // rgba(41,46,69,.10)
  static const Color shadowLg = Color(0x24292E45); // rgba(41,46,69,.14)

  // --- Semantic · Dark ---
  static const Color darkBg = gray950;
  static const Color darkSurface = gray900;
  static const Color darkSurface2 = Color(0xFF323A58);
  static const Color darkBorder = Color(0xFF3A4160);
  static const Color darkBorderSoft = Color(0x29A9AFCF); // rgba(169,175,207,.16)

  static const Color darkTextStrong = Color(0xFFEFF1F8);
  static const Color darkTextBody = Color(0xFFB9BED6);
  static const Color darkTextMuted = gray500;

  static const Color darkBrand = gray400;
  static const Color darkAccent = Color(0xFF8E9BE6);
  static const Color darkAccentDeep = Color(0xFFA5B0F0);
  static const Color darkAccentSoft = Color(0x298E9BE6); // rgba(143,151,232,.16)
  static const Color darkAccentText = Color(0xFF14162B);

  static const Color darkSuccess = Color(0xFF7FB59E);
  static const Color darkSuccessSoft = Color(0x247FB59E);
  static const Color darkWarning = Color(0xFFD3A96E);
  static const Color darkWarningSoft = Color(0x24D3A96E);
  static const Color darkError = Color(0xFFE08694);
  static const Color darkErrorSoft = Color(0x24E08694);

  static const Color darkShadow = Color(0x52000000); // rgba(0,0,0,.32)
  static const Color darkShadowLg = Color(0x6B000000); // rgba(0,0,0,.42)

  // --- Generic role mapping ---
  static const Color primary = accent;
  static const Color secondary = brand;
  static const Color tertiary = accent;
}
