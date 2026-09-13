import 'dart:ui';

/// XERKONIX TACTILE color tokens. Hex comes from `tokens.css` (sibling file or
/// `test/fixtures/tokens.css` copy). Package version is pubspec; contract
/// version is the tokens.css header. Do not paste draft hex into this file.
///
/// Names strip `--` and camelCase. Dark overrides are `dark*`.
/// v3 names remain as deprecated aliases so existing apps still compile.
class XkColor {
  XkColor._();

  // --- Light (tokens.css :root, TACTILE v4.2.0) ---
  static const Color canvas = Color(0xFFF7F7F7);
  static const Color groundHi = Color(0xFFFFFFFF);
  static const Color solid = Color(0xFFFFFFFF);
  static const Color ink = Color(0xFF111111);
  static const Color ink2 = Color(0xFF555555);
  static const Color ink3 = Color(0xFF888888);
  static const Color rule = Color(0x1F000000); // rgba(0,0,0,.12)

  static const Color aqua100 = Color(0xFFE3F3F7);
  static const Color aquaTint = Color(0xFFC0E3EC);
  static const Color aquaHi = Color(0xFF92CCDC);
  static const Color aqua = Color(0xFF6EB4C4);
  static const Color aquaMid = Color(0xFF59A1B0);
  static const Color aquaShade = Color(0xFF33778D);
  static const Color aquaDeep = Color(0xFF2E6B79);
  static const Color aquaInk = Color(0xFF1B4650);

  static const Color accent = Color(0xFFB1DAE1);
  static const Color accentInk = Color(0xFF1C4C58);

  static const Color glass = Color(0xBFFFFFFF); // rgba(255,255,255,.75)
  static const Color glassStrong = Color(0xBFFFFFFF);
  static const Color glassNavigation = Color(0x73FFFFFF); // .45
  static const Color glassAction = Color(0x38FFFFFF); // .22
  static const Color glassAccent = Color(0x38B1DAE1);
  static const Color planeEdge = Color(0x1F000000); // rgba(0,0,0,.12)
  static const Color planeRim = Color(0xD1FFFFFF); // rgba(255,255,255,.82)
  static const Color planeShadow = Color(0x1F000000);
  static const Color glassEdge = Color(0xD1FFFFFF);
  static const Color glassEdge2 = Color(0x1F000000);
  static const Color spec = Color(0xD1FFFFFF);
  static const Color insetBg = Color(0x09000000); // rgba(0,0,0,.035)
  static const Color headGlass = Color(0xD1FFFFFF); // rgba(255,255,255,.82)
  static const Color glossSheen = Color(0xA6FFFFFF);
  static const Color glossRim = Color(0xF5FFFFFF);
  static const Color glossLow = Color(0x1F000000);
  static const Color glossContact = Color(0x1A000000);
  /// Inverse-surface sheen. Theme-invariant (`:root` only).
  static const Color glossInverse = Color(0x1FFFFFFF); // rgba(255,255,255,.12)

  /// Inverse surface — theme-invariant. Primary CTA fill.
  static const Color surfaceInverse = Color(0xFF000000);
  static const Color inkInverse = Color(0xFFFFFFFF);
  static const Color inkInverse2 = Color(0xFFC4C4C4);
  static const Color surfaceInverseCard = Color(0xFF151515);
  static const Color ruleInverse = Color(0xFF333333);

  static const Color ok = Color(0xFF4F7868);
  static const Color warn = Color(0xFFA95C11);
  static const Color bad = Color(0xFFC13030);
  static const Color warm = Color(0xFFB8503A);
  static const Color cool = Color(0xFF3E6B8F);

  /// Recipe white used in `color-mix(..., white)` gem borders / inset highlight.
  static const Color mixWhite = Color(0xFFFFFFFF);

  /// Fully transparent — token-file home for overlays that need no fill.
  static const Color none = Color(0x00000000);

  static const Color glassShadowNear = Color(0x1F000000);
  static const Color glassShadowFar = Color(0x1F000000);

  // --- Dark (tokens.css :root[data-theme="dark"]) ---
  static const Color darkCanvas = Color(0xFF141414);
  static const Color darkGroundHi = Color(0xFF202020);
  static const Color darkSolid = Color(0xFF202020);
  static const Color darkInk = Color(0xFFF5F5F5);
  static const Color darkInk2 = Color(0xFFBBBBBB);
  static const Color darkInk3 = Color(0xFF777777);
  static const Color darkRule = Color(0x1FFFFFFF); // rgba(255,255,255,.12)

  static const Color darkAqua100 = Color(0xFF12333C);
  static const Color darkAquaTint = Color(0xFF1F4C58);
  static const Color darkAquaHi = Color(0xFFA6D8E5);
  static const Color darkAqua = Color(0xFF6EB4C4);
  static const Color darkAquaMid = Color(0xFF4F97A8);
  static const Color darkAquaShade = Color(0xFF2E6774);
  static const Color darkAquaDeep = Color(0xFFA7DCE6);
  static const Color darkAquaInk = Color(0xFF10303A);

  static const Color darkAccent = Color(0xFF89C0CD);
  static const Color darkAccentInk = Color(0xFF0B2B35);

  static const Color darkGlass = Color(0xBF202020); // rgba(32,32,32,.75)
  static const Color darkGlassStrong = Color(0xBF202020);
  static const Color darkGlassNavigation = Color(0x73202020);
  static const Color darkGlassAction = Color(0x38202020);
  static const Color darkGlassAccent = Color(0x3889C0CD);
  static const Color darkPlaneEdge = Color(0x2EFFFFFF);
  static const Color darkPlaneRim = Color(0x61FFFFFF);
  static const Color darkPlaneShadow = Color(0x3D000000);
  static const Color darkGlassEdge = Color(0x61FFFFFF);
  static const Color darkGlassEdge2 = Color(0x2EFFFFFF);
  static const Color darkSpec = Color(0x61FFFFFF);
  static const Color darkInsetBg = Color(0x0DFFFFFF);
  static const Color darkHeadGlass = Color(0xD1202020); // rgba(32,32,32,.82)
  static const Color darkGlossSheen = Color(0x38FFFFFF);
  static const Color darkGlossRim = Color(0x9EFFFFFF);
  static const Color darkGlossLow = Color(0x24FFFFFF);
  static const Color darkGlossContact = Color(0x45000000);

  static const Color darkOk = Color(0xFF7FB59E);
  static const Color darkWarn = Color(0xFFEC9A50);
  static const Color darkBad = Color(0xFFE67274);
  static const Color darkWarm = Color(0xFFDE9074);
  static const Color darkCool = Color(0xFF8AA8C2);

  static const Color darkGlassShadowNear = Color(0x3D000000);
  static const Color darkGlassShadowFar = Color(0x3D000000);

  // --- v3 aliases (compile compatibility) ---
  @Deprecated('Use XkColor.canvas')
  static const Color bg = canvas;
  @Deprecated('Use XkColor.groundHi')
  static const Color panel = groundHi;
  @Deprecated('Use XkColor.ink')
  static const Color black = ink;
  @Deprecated('Use XkColor.ink2')
  static const Color muted = ink2;
  @Deprecated('Use XkColor.rule')
  static const Color hair = rule;
  @Deprecated('Use XkColor.rule')
  static const Color hairSoft = rule;
  @Deprecated('Use XkColor.insetBg')
  static const Color well = insetBg;
  @Deprecated('Use XkColor.aquaDeep')
  static const Color tintText = aquaDeep;
  @Deprecated('Use XkColor.ink — links are ink in v4')
  static const Color tintTextHover = ink;
  @Deprecated('Use XkColor.aquaMid')
  static const Color tintFill = aquaMid;
  @Deprecated('Use XkColor.aquaInk')
  static const Color tintOnFill = aquaInk;
  @Deprecated('Use XkColor.aqua')
  static const Color tint = aqua;
  @Deprecated('Use XkColor.aquaHi')
  static const Color tintLight = aquaHi;
  @Deprecated('Use XkColor.aquaHi')
  static const Color tintGem = aquaHi;
  @Deprecated('Use XkColor.aqua100')
  static const Color tintSoft = aqua100;
  @Deprecated('Use XkColor.aquaDeep')
  static const Color tintDark = aquaDeep;
  @Deprecated('Use XkColor.ok')
  static const Color okOn = ok;
  @Deprecated('Use XkColor.warn')
  static const Color warnOn = warn;
  @Deprecated('Use XkColor.bad')
  static const Color badOn = bad;
  @Deprecated('Use XkColor.groundHi')
  static const Color wash = groundHi;
  @Deprecated('Use XkColor.canvas')
  static const Color far = canvas;
  @Deprecated('Use XkColor.canvas')
  static const Color farP = canvas;
  @Deprecated('Removed in v4 — was glow. Use glass materials.')
  static const Color glow = Color(0x00000000);
  @Deprecated('Removed in v4 — was glow. Use glass materials.')
  static const Color glowP = Color(0x00000000);
  @Deprecated('Use XkColor.glassEdge')
  static const Color hi = glassEdge;
  @Deprecated('Use XkColor.glassShadowNear')
  static const Color sh = glassShadowNear;
  @Deprecated('Use XkColor.glassShadowFar')
  static const Color shFar = glassShadowFar;
  @Deprecated('Use XkColor.headGlass')
  static const Color nav = headGlass;

  @Deprecated('Use XkColor.darkCanvas')
  static const Color darkBg = darkCanvas;
  @Deprecated('Use XkColor.darkGroundHi')
  static const Color darkPanel = darkGroundHi;
  @Deprecated('Use XkColor.darkInk2')
  static const Color darkMuted = darkInk2;
  @Deprecated('Use XkColor.darkRule')
  static const Color darkHair = darkRule;
  @Deprecated('Use XkColor.darkRule')
  static const Color darkHairSoft = darkRule;
  @Deprecated('Use XkColor.darkInsetBg')
  static const Color darkWell = darkInsetBg;
  @Deprecated('Use XkColor.darkAquaDeep')
  static const Color darkTintText = darkAquaDeep;
  @Deprecated('Use XkColor.darkInk — links are ink in v4')
  static const Color darkTintTextHover = darkInk;
  @Deprecated('Use XkColor.darkAquaMid')
  static const Color darkTintFill = darkAquaMid;
  @Deprecated('Use XkColor.darkAquaInk')
  static const Color darkTintOnFill = darkAquaInk;
  @Deprecated('Use XkColor.darkAqua')
  static const Color darkTint = darkAqua;
  @Deprecated('Use XkColor.darkAquaHi')
  static const Color darkTintLight = darkAquaHi;
  @Deprecated('Use XkColor.darkAquaHi')
  static const Color darkTintGem = darkAquaHi;
  @Deprecated('Use XkColor.darkAqua100')
  static const Color darkTintSoft = darkAqua100;
  @Deprecated('Use XkColor.darkAquaDeep')
  static const Color darkTintDark = darkAquaDeep;
  @Deprecated('Use XkColor.darkOk')
  static const Color darkOkOn = darkOk;
  @Deprecated('Use XkColor.darkWarn')
  static const Color darkWarnOn = darkWarn;
  @Deprecated('Use XkColor.darkBad')
  static const Color darkBadOn = darkBad;
  @Deprecated('Use XkColor.darkGroundHi')
  static const Color darkWash = darkGroundHi;
  @Deprecated('Use XkColor.darkCanvas')
  static const Color darkFar = darkCanvas;
  @Deprecated('Use XkColor.darkCanvas')
  static const Color darkFarP = darkCanvas;
  @Deprecated('Removed in v4')
  static const Color darkGlow = Color(0x00000000);
  @Deprecated('Removed in v4')
  static const Color darkGlowP = Color(0x00000000);
  @Deprecated('Use XkColor.darkGlassEdge')
  static const Color darkHi = darkGlassEdge;
  @Deprecated('Use XkColor.darkGlassShadowNear')
  static const Color darkSh = darkGlassShadowNear;
  @Deprecated('Use XkColor.darkGlassShadowFar')
  static const Color darkShFar = darkGlassShadowFar;
  @Deprecated('Use XkColor.darkHeadGlass')
  static const Color darkNav = darkHeadGlass;

  /// Light-canon color → dark remap. Identity in light.
  ///
  /// Neutralization made several roles share a Color value (`groundHi` /
  /// `inkInverse` are both #FFF). This method must not infer inverse identity
  /// from that value — inverse UI uses [inkInverseOf] / [surfaceInverseOf].
  /// Overlapping gloss/edge neutrals also share values; callers that need a
  /// specific role in dark should use the `*Of` getter, not [themed].
  static Color themed(Color color, Brightness brightness) {
    if (brightness != Brightness.dark) return color;
    // Already-dark tokens first (aqua-hi light == aqua-deep dark, etc.).
    if (color == darkCanvas ||
        color == darkGroundHi ||
        color == darkInk ||
        color == darkInk2 ||
        color == darkInk3 ||
        color == darkRule ||
        color == darkAqua100 ||
        color == darkAquaTint ||
        color == darkAquaHi ||
        color == darkAqua ||
        color == darkAquaMid ||
        color == darkAquaShade ||
        color == darkAquaDeep ||
        color == darkAquaInk ||
        color == darkGlass ||
        color == darkGlassStrong ||
        color == darkGlassEdge ||
        color == darkGlassEdge2 ||
        color == darkSpec ||
        color == darkInsetBg ||
        color == darkHeadGlass ||
        color == darkOk ||
        color == darkWarn ||
        color == darkBad ||
        color == darkWarm ||
        color == darkCool) {
      return color;
    }
    if (color == canvas) return darkCanvas;
    if (color == groundHi) return darkGroundHi;
    if (color == ink) return darkInk;
    if (color == ink2) return darkInk2;
    if (color == ink3) return darkInk3;
    if (color == rule) return darkRule;
    if (color == aqua100) return darkAqua100;
    if (color == aquaTint) return darkAquaTint;
    if (color == aquaHi) return darkAquaHi;
    if (color == aqua) return darkAqua;
    if (color == aquaMid) return darkAquaMid;
    if (color == aquaShade) return darkAquaShade;
    if (color == aquaDeep) return darkAquaDeep;
    if (color == aquaInk) return darkAquaInk;
    if (color == glass) return darkGlass;
    if (color == glassStrong) return darkGlassStrong;
    if (color == glassEdge) return darkGlassEdge;
    if (color == glassEdge2) return darkGlassEdge2;
    if (color == spec) return darkSpec;
    if (color == insetBg) return darkInsetBg;
    if (color == headGlass) return darkHeadGlass;
    if (color == ok) return darkOk;
    if (color == warn) return darkWarn;
    if (color == bad) return darkBad;
    if (color == warm) return darkWarm;
    if (color == cool) return darkCool;
    if (color == glassShadowNear) return darkGlassShadowNear;
    if (color == glassShadowFar) return darkGlassShadowFar;
    return color;
  }

  static Color canvasOf(Brightness b) =>
      b == Brightness.dark ? darkCanvas : canvas;
  static Color solidOf(Brightness b) =>
      b == Brightness.dark ? darkSolid : solid;
  static Color groundHiOf(Brightness b) =>
      b == Brightness.dark ? darkGroundHi : groundHi;
  static Color inkOf(Brightness b) => b == Brightness.dark ? darkInk : ink;
  static Color ink2Of(Brightness b) => b == Brightness.dark ? darkInk2 : ink2;
  static Color ink3Of(Brightness b) => b == Brightness.dark ? darkInk3 : ink3;
  static Color ruleOf(Brightness b) => b == Brightness.dark ? darkRule : rule;
  static Color aquaOf(Brightness b) => b == Brightness.dark ? darkAqua : aqua;
  static Color aquaHiOf(Brightness b) =>
      b == Brightness.dark ? darkAquaHi : aquaHi;
  static Color aquaMidOf(Brightness b) =>
      b == Brightness.dark ? darkAquaMid : aquaMid;
  static Color aquaTintOf(Brightness b) =>
      b == Brightness.dark ? darkAquaTint : aquaTint;
  static Color aquaDeepOf(Brightness b) =>
      b == Brightness.dark ? darkAquaDeep : aquaDeep;
  static Color aquaInkOf(Brightness b) =>
      b == Brightness.dark ? darkAquaInk : aquaInk;
  static Color aqua100Of(Brightness b) =>
      b == Brightness.dark ? darkAqua100 : aqua100;
  static Color accentOf(Brightness b) =>
      b == Brightness.dark ? darkAccent : accent;
  static Color accentInkOf(Brightness b) =>
      b == Brightness.dark ? darkAccentInk : accentInk;
  static Color glassOf(Brightness b) =>
      b == Brightness.dark ? darkGlass : glass;
  static Color glassStrongOf(Brightness b) =>
      b == Brightness.dark ? darkGlassStrong : glassStrong;
  static Color glassNavigationOf(Brightness b) =>
      b == Brightness.dark ? darkGlassNavigation : glassNavigation;
  static Color glassActionOf(Brightness b) =>
      b == Brightness.dark ? darkGlassAction : glassAction;
  static Color glassAccentOf(Brightness b) =>
      b == Brightness.dark ? darkGlassAccent : glassAccent;
  static Color planeEdgeOf(Brightness b) =>
      b == Brightness.dark ? darkPlaneEdge : planeEdge;
  static Color planeRimOf(Brightness b) =>
      b == Brightness.dark ? darkPlaneRim : planeRim;
  static Color planeShadowOf(Brightness b) =>
      b == Brightness.dark ? darkPlaneShadow : planeShadow;
  static Color glossSheenOf(Brightness b) =>
      b == Brightness.dark ? darkGlossSheen : glossSheen;
  static Color glossRimOf(Brightness b) =>
      b == Brightness.dark ? darkGlossRim : glossRim;
  static Color glossLowOf(Brightness b) =>
      b == Brightness.dark ? darkGlossLow : glossLow;
  static Color glassEdgeOf(Brightness b) =>
      b == Brightness.dark ? darkGlassEdge : glassEdge;
  static Color glassEdge2Of(Brightness b) =>
      b == Brightness.dark ? darkGlassEdge2 : glassEdge2;
  static Color specOf(Brightness b) => b == Brightness.dark ? darkSpec : spec;
  static Color insetBgOf(Brightness b) =>
      b == Brightness.dark ? darkInsetBg : insetBg;
  static Color headGlassOf(Brightness b) =>
      b == Brightness.dark ? darkHeadGlass : headGlass;
  static Color okOf(Brightness b) => b == Brightness.dark ? darkOk : ok;
  static Color warnOf(Brightness b) => b == Brightness.dark ? darkWarn : warn;
  static Color badOf(Brightness b) => b == Brightness.dark ? darkBad : bad;
  static Color warmOf(Brightness b) => b == Brightness.dark ? darkWarm : warm;
  static Color coolOf(Brightness b) => b == Brightness.dark ? darkCool : cool;

  /// Inverse roles are theme-invariant (tokens.css `:root` only).
  static Color surfaceInverseOf(Brightness b) => surfaceInverse;
  static Color inkInverseOf(Brightness b) => inkInverse;
  static Color inkInverse2Of(Brightness b) => inkInverse2;
  static Color surfaceInverseCardOf(Brightness b) => surfaceInverseCard;
  static Color ruleInverseOf(Brightness b) => ruleInverse;
  static Color glossInverseOf(Brightness b) => glossInverse;

  /// `.selected` fill: `--aqua-tint` at 30%.
  static Color selectedFill(Brightness b) =>
      aquaTintOf(b).withValues(alpha: 0.30);
}
