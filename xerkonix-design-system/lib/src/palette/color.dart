import 'dart:ui';

/// XERKONIX Design Token Colors — TACTILE.
///
/// The accent is a **monochrome ink** (near-black in light, near-white in dark),
/// so elevation is carried by paired highlight/lowlight shadows (see [XkShadow])
/// rather than color. A **warm/cool temperature accent pair** ([tempWarm] /
/// [tempCool]) reads on a hot↔cold axis.
///
/// Token names are legacy aliases, kept so existing call sites keep resolving.
class XkColor {
  XkColor._();

  // --- Neutral gray scale (TACTILE) ---
  static const Color gray000 = Color(0xFFFBFBFC);
  static const Color gray050 = Color(0xFFF4F4F6);
  static const Color gray100 = Color(0xFFEAEAEE);
  static const Color gray200 = Color(0xFFDBDBE0);
  static const Color gray300 = Color(0xFFC4C5CC);
  static const Color gray400 = Color(0xFFACADB7);
  static const Color gray500 = Color(0xFF8F909C);
  static const Color gray600 = Color(0xFF71727F);
  static const Color gray700 = Color(0xFF575866);
  static const Color gray800 = Color(0xFF3F404C);
  static const Color gray900 = Color(0xFF2A2B35);
  static const Color gray950 = Color(0xFF1A1B22);

  // --- Semantic · Light ---
  static const Color bg = gray050; // #F4F4F6
  static const Color surface = gray000; // #FBFBFC
  static const Color surface2 = gray100; // #EAEAEE
  static const Color border = gray200; // #DBDBE0
  static const Color borderSoft = Color(0x66C4C5CC); // rgba(196,197,204,.40)

  static const Color textStrong = Color(0xFF232430);
  static const Color textBody = Color(0xFF4A4B57);
  static const Color textMuted = gray600; // #71727F

  static const Color brand = gray400;

  /// Monochrome ink action. In TACTILE the accent is near-black; elevation
  /// (not hue) differentiates interactive surfaces.
  static const Color accent = Color(0xFF232430); // action / accent
  static const Color accentDeep = Color(0xFF3F404C); // accent-hover (gray800)
  static const Color accentSoft = Color(0xFFE4E4E9); // soft neutral tint
  static const Color accentText = Color(0xFFFBFBFC); // on-accent (surface)

  static const Color success = Color(0xFF5E8F7B);
  static const Color successSoft = Color(0xFFE4EDE9);
  static const Color warning = Color(0xFFC96E14);
  static const Color warningSoft = Color(0xFFF6E7D5);
  static const Color error = Color(0xFFC13030);
  static const Color errorSoft = Color(0xFFF6DEDE);

  /// Temperature accent pair (hot ↔ cold axis).
  static const Color tempWarm = Color(0xFFC65F45);
  static const Color tempWarmSoft = Color(0xFFF6E1DA);
  static const Color tempCool = Color(0xFF7B84C4);
  static const Color tempCoolSoft = Color(0xFFE4E6F3);

  static const Color shadow = Color(0x1A1A1B22); // rgba(26,27,34,.10)
  static const Color shadowLg = Color(0x241A1B22); // rgba(26,27,34,.14)

  // --- Semantic · Dark ---
  static const Color darkBg = gray950; // #1A1B22
  static const Color darkSurface = Color(0xFF23242C);
  static const Color darkSurface2 = Color(0xFF2C2D37);
  static const Color darkBorder = Color(0xFF373844);
  static const Color darkBorderSoft = Color(0x66373844); // rgba(55,56,68,.40)

  static const Color darkTextStrong = Color(0xFFF1F1F4);
  static const Color darkTextBody = Color(0xFFB4B5BE);
  static const Color darkTextMuted = Color(0xFF7E7F8A);

  static const Color darkBrand = gray400;

  static const Color darkAccent = Color(0xFFF1F1F4); // near-white ink action
  static const Color darkAccentDeep = Color(0xFFD9DAE0); // accent-hover
  static const Color darkAccentSoft = Color(
    0x24F1F1F4,
  ); // rgba(241,241,244,.14)
  static const Color darkAccentText = Color(0xFF1A1B22); // on-accent (bg)

  static const Color darkSuccess = Color(0xFF7FB59E);
  static const Color darkSuccessSoft = Color(0x247FB59E);
  static const Color darkWarning = Color(0xFFE0A45C);
  static const Color darkWarningSoft = Color(0x24E0A45C);
  static const Color darkError = Color(0xFFE08080);
  static const Color darkErrorSoft = Color(0x24E08080);

  static const Color darkTempWarm = Color(0xFFDE9074);
  static const Color darkTempWarmSoft = Color(0x24DE9074);
  static const Color darkTempCool = Color(0xFF939CD6);
  static const Color darkTempCoolSoft = Color(0x24939CD6);

  static const Color darkShadow = Color(0x9E000000); // rgba(0,0,0,.62)
  static const Color darkShadowLg = Color(0xB3000000); // rgba(0,0,0,.70)

  // --- Generic role mapping ---
  static const Color primary = accent;
  static const Color secondary = brand;
  static const Color tertiary = tempCool;
}
