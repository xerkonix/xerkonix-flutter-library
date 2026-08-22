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
  // [v2.3] 면 분리 — 캔버스 하강 + 순백 카드(1.09:1). gray 단 별칭에서 독립값으로.
  static const Color bg = Color(0xFFF5F5F7);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surface2 = Color(0xFFEFF0F3);
  static const Color border = Color(0xFFE3E5EA);
  /// [v2.3] --well — 입력·트랙 전용 우물 면 (캔버스 대비 1.13:1).
  static const Color well = Color(0xFFE6E8EC);
  static const Color borderSoft = Color(0x47ACADB7); // rgba(172,173,183,.28)

  static const Color textStrong = Color(0xFF232430);
  static const Color textBody = Color(0xFF4A4B57);
  // [v2.3] muted 상향 — 옛 #686975 는 AA 턱걸이(4.94:1) → 6.44:1.
  static const Color textMuted = Color(0xFF575866);

  /// v2.2 ink hierarchy — display ink for large headings (d1/d2) and hero
  /// figures, anchor for section hooks/labels (mono + tracking). The point is
  /// to stop hanging hierarchy on size alone.
  static const Color inkDisplay = gray950; // --ink-display
  // [v2.3] anchor: gray-500 은 2.88:1 로 텍스트 AA 위반이었다 → 4.99:1.
  static const Color anchor = Color(0xFF686975); // --anchor

  static const Color brand = gray400;

  /// [v2.3] 포인트(아쿠아마린) — [v2.5] 인라인 링크·인디케이터 전용.
  /// 켜짐 상태(토글/체크/라디오)는 근흑([accent])으로 환원됐다 — 컨트롤의 켜짐은
  /// 강조가 아니라 상태다. CTA·배지·제목 금지, 액션은 화면당 1개.
  /// [point] 는 문구 가능(캔버스 4.60:1) · [pointInd] 는 면 요소 전용(문구 금지).
  static const Color point = Color(0xFF007A91);
  static const Color pointDeep = Color(0xFF006B7F);
  static const Color pointInd = Color(0xFF0090AE);

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

  // v2.2 vivid — icons, status glyphs and gauges only. The base colors are
  // darkened to clear text AA (4.5:1), which turns the orange brown; non-text
  // signals only need 3:1, so this step keeps the chroma (same hue).
  // Measured against --bg: success 3.61 · warning 3.45 · error 4.18.
  // **Never use on text** — below AA.
  static const Color successVivid = Color(0xFF2F9066);
  static const Color warningVivid = Color(0xFFC96A05);
  static const Color errorVivid = Color(0xFFD63C3C);

  // v2.2 border — the edge of a soft-tinted plane (callouts, badge frames).
  // Base hue at low alpha; keeps a translucent soft plane from dissolving
  // into the background in dark mode.
  static const Color successBorder = Color(0x4D4F7868); // rgba(79,120,104,.30)
  static const Color warningBorder = Color(0x4DA95C11); // rgba(169,92,17,.30)
  static const Color errorBorder = Color(0x47C13030); // rgba(193,48,48,.28)

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
  /// [v2.3] --well (dark) — 값 한계(1.13:1)라 위젯이 1px 링을 병기한다.
  static const Color darkWell = Color(0xFF0C0D11);

  static const Color darkTextStrong = Color(0xFFF1F1F4);
  static const Color darkTextBody = Color(0xFFB4B5BE);
  // [v2.3] 다크 muted 상향 — 5.69 → 6.60:1.
  static const Color darkTextMuted = Color(0xFF9FA0A9);

  static const Color darkInkDisplay = gray000; // --ink-display (dark)
  static const Color darkAnchor = gray400; // --anchor (dark)

  static const Color darkBrand = gray400;

  /// [v2.3] 다크 포인트 — 원석 단일(#62CBDB, 캔버스 9.06:1). ind 는 별칭.
  static const Color darkPoint = Color(0xFF62CBDB);
  static const Color darkPointDeep = Color(0xFF78D5E3);
  static const Color darkPointInd = darkPoint;

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

  // v2.2 vivid(다크) — 다크 base 는 이미 밝아 비텍스트 3:1 을 여유롭게 넘는다.
  // 정본도 별칭(--*-vivid:var(--*))이므로 본색 재사용.
  static const Color darkSuccessVivid = darkSuccess;
  static const Color darkWarningVivid = darkWarning;
  static const Color darkErrorVivid = darkError;

  // v2.2 border(다크) — 알파만 상향. error 는 soft 와 같은 옛 색 기반 rgb 를
  // 정본이 유지하므로 여기서도 동일하게 둔다.
  static const Color darkSuccessBorder = Color(0x527FB59E); // rgba(127,181,158,.32)
  static const Color darkWarningBorder = Color(0x52EC9A50); // rgba(236,154,80,.32)
  static const Color darkErrorBorder = Color(0x4DE4696B); // rgba(228,105,107,.30)

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
