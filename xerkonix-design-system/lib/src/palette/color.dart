import 'dart:ui';

/// XERKONIX Weave v3 color tokens. Source: tokens.css. No v2 aliases.
class XkColor {
  XkColor._();

  // --- Light ---
  static const Color bg = Color(0xFFF5F5F5);
  static const Color panel = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color ink = Color(0xFF1D1D1F);
  static const Color muted = Color(0xFF6E6E73);
  static const Color hair = Color(0xFFD2D2D7);
  static const Color hairSoft = Color(0xFFE8E8ED);
  static const Color well = Color(0xFFECECEF);

  static const Color tintText = Color(0xFF007A91);
  static const Color tintTextHover = Color(0xFF0089A5);
  static const Color tintFill = Color(0xFF0081A0);
  static const Color tintOnFill = Color(0xFFFFFFFF);
  static const Color tint = Color(0xFF0FA3BD);
  static const Color tintLight = Color(0xFF3FB4C8);
  static const Color tintGem = Color(0xFF62CBDB);
  static const Color tintSoft = Color(0xFFE3F3F6);
  static const Color tintDark = Color(0xFF3FB4C8);

  static const Color warm = Color(0xFFB8503A);
  static const Color cool = Color(0xFF3E6B8F);
  static const Color ok = Color(0xFF4F7868);
  static const Color warn = Color(0xFFA95C11);
  static const Color bad = Color(0xFFC13030);
  static const Color okOn = Color(0xFF4B7263);
  static const Color warnOn = Color(0xFFA05710);
  static const Color badOn = Color(0xFFB92E2E);

  static const Color wash = Color(0xFFFFFFFF);
  static const Color far = Color(0xFFEAEAED);
  static const Color farP = Color(0xFFF1F1F3);
  static const Color glow = Color(0x3862CBDB); // rgba(98,203,219,.22)
  static const Color glowP = Color(0x2662CBDB); // rgba(98,203,219,.15)
  static const Color hi = Color(0xF2FFFFFF); // rgba(255,255,255,.95)
  static const Color sh = Color(0x381A1B22); // rgba(26,27,34,.22)
  static const Color shFar = Color(0x1F1A1B22); // rgba(26,27,34,.12)
  static const Color nav = Color(0xD1F5F5F5); // rgba(245,245,245,.82)

  // --- Dark ---
  static const Color darkBg = Color(0xFF000000);
  static const Color darkPanel = Color(0xFF161617);
  static const Color darkInk = Color(0xFFF5F5F7);
  static const Color darkMuted = Color(0xFF86868B);
  static const Color darkHair = Color(0xFF424245);
  static const Color darkHairSoft = Color(0xFF2C2C2E);
  static const Color darkWell = Color(0xFF0F0F10);

  static const Color darkTintText = Color(0xFF3FB4C8);
  static const Color darkTintTextHover = Color(0xFF62CBDB);
  static const Color darkTintFill = Color(0xFF3FB4C8);
  static const Color darkTintOnFill = Color(0xFF0A0A0A);
  static const Color darkTint = Color(0xFF3FB4C8);
  static const Color darkTintLight = Color(0xFF62CBDB);
  static const Color darkTintGem = Color(0xFF62CBDB);
  static const Color darkTintSoft = Color(0xFF0E2A30);
  static const Color darkTintDark = Color(0xFF62CBDB);

  static const Color darkWarm = Color(0xFFDE9074);
  static const Color darkCool = Color(0xFF8AA8C2);
  static const Color darkOk = Color(0xFF7FB59E);
  static const Color darkWarn = Color(0xFFEC9A50);
  static const Color darkBad = Color(0xFFE67274);
  static const Color darkOkOn = Color(0xFF7FB59E);
  static const Color darkWarnOn = Color(0xFFEC9A50);
  static const Color darkBadOn = Color(0xFFE67274);

  static const Color darkWash = Color(0xFF1C1C1F);
  static const Color darkFar = Color(0xFF000000);
  static const Color darkFarP = Color(0xFF111113);
  static const Color darkGlow = Color(0x333FB4C8); // rgba(63,180,200,.20)
  static const Color darkGlowP = Color(0x243FB4C8); // rgba(63,180,200,.14)
  static const Color darkHi = Color(0x12FFFFFF); // rgba(255,255,255,.07)
  static const Color darkSh = Color(0xBF000000); // rgba(0,0,0,.75)
  static const Color darkShFar = Color(0x80000000); // rgba(0,0,0,.5)
  static const Color darkNav = Color(0xCC000000); // rgba(0,0,0,.8)

  /// Light-canon hex → dark remap. Identity in light.
  static Color themed(Color color, Brightness brightness) {
    if (brightness != Brightness.dark) return color;
    if (color == darkBg ||
        color == darkPanel ||
        color == darkInk ||
        color == darkMuted ||
        color == darkHair ||
        color == darkHairSoft ||
        color == darkWell ||
        color == darkTintText ||
        color == darkTintTextHover ||
        color == darkTintFill ||
        color == darkTintOnFill ||
        color == darkTint ||
        color == darkTintLight ||
        color == darkTintGem ||
        color == darkTintSoft ||
        color == darkWarm ||
        color == darkCool ||
        color == darkOk ||
        color == darkWarn ||
        color == darkBad) {
      return color;
    }
    if (color == bg) return darkBg;
    if (color == panel) return darkPanel;
    if (color == ink) return darkInk;
    if (color == muted) return darkMuted;
    if (color == hair) return darkHair;
    if (color == hairSoft) return darkHairSoft;
    if (color == well) return darkWell;
    if (color == tintText) return darkTintText;
    if (color == tintTextHover) return darkTintTextHover;
    if (color == tintFill) return darkTintFill;
    if (color == tintOnFill) return darkTintOnFill;
    if (color == tint) return darkTint;
    if (color == tintLight) return darkTintLight;
    if (color == tintGem) return darkTintGem;
    if (color == tintSoft) return darkTintSoft;
    if (color == warm) return darkWarm;
    if (color == cool) return darkCool;
    if (color == ok) return darkOk;
    if (color == warn) return darkWarn;
    if (color == bad) return darkBad;
    if (color == okOn) return darkOkOn;
    if (color == warnOn) return darkWarnOn;
    if (color == badOn) return darkBadOn;
    return color;
  }
}
