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
  static const Color borderSoft = Color(0x47ACADB7); // rgba(172,173,183,.28)

  static const Color textStrong = Color(0xFF232430);
  static const Color textBody = Color(0xFF4A4B57);
  // N21: muted lowered in lightness from gray-600 for WCAG AA (≥4.5:1).
  // Canonical tokens.css value; may shift again if N21 lands a new muted.
  static const Color textMuted = Color(0xFF686975);

  static const Color brand = gray400;

  /// Monochrome ink action. In TACTILE the accent is near-black; elevation
  /// (not hue) differentiates interactive surfaces.
  static const Color accent = Color(0xFF232430); // action / accent
  static const Color accentDeep = Color(0xFF3F404C); // accent-hover (gray800)
  static const Color accentSoft = Color(0xFFEAEAEE); // soft neutral tint (gray100)
  static const Color accentText = Color(0xFFFBFBFC); // on-accent (surface)

  // 2026-07-27 TACTILE 정본 WCAG AA 승급 값(bg 대비 4.5:1 이상). 옛 값
  // (#5E8F7B / #C96E14 / #C65F45 / #7B84C4)은 3.3:1 대로 본문 텍스트 기준 미달이었다.
  static const Color success = Color(0xFF4F7868);
  static const Color successSoft = Color(0xFFE2EEE9);
  static const Color warning = Color(0xFFA95C11);
  static const Color warningSoft = Color(0xFFFBE9D3);
  static const Color error = Color(0xFFC13030);
  static const Color errorSoft = Color(0xFFF8DBDB);

  // v2.1 on-soft — soft 틴트 배경 위 텍스트 전용. 본색은 bg 기준으로만 AA 를
  // 통과해서 soft 위(배지·콜아웃)에서는 4.1~4.4 로 미달한다. hue 동일, 명도만
  // 하강해 soft 위에서도 ≥4.5:1.
  static const Color successOnSoft = Color(0xFF4B7263);
  static const Color warningOnSoft = Color(0xFFA05710);
  static const Color errorOnSoft = Color(0xFFB92E2E);

  /// Temperature accent pair (hot ↔ cold axis).
  static const Color tempWarm = Color(0xFFB75138);
  static const Color tempWarmSoft = Color(0xFFF9E8E2);
  static const Color tempCool = Color(0xFF5F6AB8);
  static const Color tempCoolSoft = Color(0xFFEDEEF7);

  // 드롭 섀도우(--shadow/--shadow-lg) — gray-900(#2A2B35) 틴트가 정본.
  static const Color shadow = Color(0x1A2A2B35); // rgba(42,43,53,.10)
  static const Color shadowLg = Color(0x242A2B35); // rgba(42,43,53,.14)

  // --- Semantic · Dark ---
  static const Color darkBg = gray950; // #1A1B22
  static const Color darkSurface = Color(0xFF23242C);
  static const Color darkSurface2 = Color(0xFF2C2D37);
  static const Color darkBorder = Color(0xFF373844);
  static const Color darkBorderSoft = Color(0x26ACADB7); // rgba(172,173,183,.15)

  static const Color darkTextStrong = Color(0xFFF1F1F4);
  static const Color darkTextBody = Color(0xFFB4B5BE);
  // N21: canonical tokens.css value; may shift again if N21 lands a new muted.
  static const Color darkTextMuted = Color(0xFF93949D);

  static const Color darkBrand = gray400;

  static const Color darkAccent = Color(0xFFF1F1F4); // near-white ink action
  static const Color darkAccentDeep = Color(0xFFDBDBE0); // accent-hover
  static const Color darkAccentSoft = Color(
    0x24F1F1F4,
  ); // rgba(241,241,244,.14)
  static const Color darkAccentText = Color(0xFF1A1B22); // on-accent (bg)

  static const Color darkSuccess = Color(0xFF7FB59E);
  static const Color darkSuccessSoft = Color(0x247FB59E);
  static const Color darkWarning = Color(0xFFEC9A50);
  static const Color darkWarningSoft = Color(0x26EC9A50); // rgba(236,154,80,.15)
  // v2.1: #E4696B → #E67274 — --surface-2(#2C2D37) 위 4.25:1 미달 실측 보정.
  static const Color darkError = Color(0xFFE67274);
  // soft 는 정본이 옛 색 기반 rgba(228,105,107,.15) 를 유지한다.
  static const Color darkErrorSoft = Color(0x26E4696B); // rgba(228,105,107,.15)

  // v2.1 on-soft(다크) — 다크 soft 는 반투명이라 본색이 그대로 대비를
  // 통과한다. 정본도 본색 별칭(--*-on-soft:var(--*))이므로 본색 재사용.
  static const Color darkSuccessOnSoft = darkSuccess;
  static const Color darkWarningOnSoft = darkWarning;
  static const Color darkErrorOnSoft = darkError;

  static const Color darkTempWarm = Color(0xFFDE9074);
  static const Color darkTempWarmSoft = Color(0x26DE9074); // rgba(222,144,116,.15)
  static const Color darkTempCool = Color(0xFF939CD6);
  static const Color darkTempCoolSoft = Color(0x24939CD6);

  // 다크 드롭 섀도우(--shadow/--shadow-lg). 뉴모픽 --neu-shadow(.62)와 다르다 —
  // 그쪽은 XkShadow.darkLowlight 소관.
  static const Color darkShadow = Color(0x52000000); // rgba(0,0,0,.32)
  static const Color darkShadowLg = Color(0x6B000000); // rgba(0,0,0,.42)

  // --- Generic role mapping ---
  static const Color primary = accent;
  static const Color secondary = brand;
  static const Color tertiary = tempCool;
}
