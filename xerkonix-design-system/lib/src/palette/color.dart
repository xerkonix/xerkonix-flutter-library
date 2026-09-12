import 'dart:ui';

/// XERKONIX TACTILE v4.0.0 color tokens. Source: tokens.css.
///
/// Names strip `--` and camelCase. Dark overrides are `dark*`.
/// v3 names remain as deprecated aliases so existing apps still compile.
class XkColor {
  XkColor._();

  // --- Light (tokens.css :root) ---
  static const Color canvas = Color(0xFFF5F5F5);
  static const Color groundHi = Color(0xFFFFFFFF);
  static const Color ink = Color(0xFF0C1114);
  static const Color ink2 = Color(0xFF5E6A6E);
  static const Color ink3 = Color(0xFF9AA5A8);
  static const Color rule = Color(0x1A0C1114); // rgba(12,17,20,.10)

  static const Color aqua100 = Color(0xFFE3F3F7);
  static const Color aquaTint = Color(0xFFC0E3EC);
  static const Color aquaHi = Color(0xFF92CCDC);
  static const Color aqua = Color(0xFF6EB4C4);
  static const Color aquaMid = Color(0xFF59A1B0);
  static const Color aquaShade = Color(0xFF33778D);
  static const Color aquaDeep = Color(0xFF2E6774);
  static const Color aquaInk = Color(0xFF1B4650);

  static const Color glass = Color(0x8CFFFFFF); // rgba(255,255,255,.55)
  static const Color glassStrong = Color(0xC7FFFFFF); // rgba(255,255,255,.78)
  static const Color glassEdge = Color(0xE6FFFFFF); // rgba(255,255,255,.90)
  static const Color glassEdge2 = Color(0x66FFFFFF); // rgba(255,255,255,.40)
  static const Color spec = Color(0xF2FFFFFF); // rgba(255,255,255,.95)
  static const Color insetBg = Color(0x090C1114); // rgba(12,17,20,.035)
  static const Color headGlass = Color(0xD6F5F5F5); // rgba(245,245,245,.84)

  static const Color ok = Color(0xFF4F7868);
  static const Color warn = Color(0xFFA95C11);
  static const Color bad = Color(0xFFC13030);
  static const Color warm = Color(0xFFB8503A);
  static const Color cool = Color(0xFF3E6B8F);

  /// Recipe white used in `color-mix(..., white)` gem borders / inset highlight.
  static const Color mixWhite = Color(0xFFFFFFFF);

  /// Fully transparent — token-file home for overlays that need no fill.
  static const Color none = Color(0x00000000);

  static const Color glassShadowNear = Color(0x4D0C1114); // rgba(12,17,20,.30)
  static const Color glassShadowFar = Color(0x140C1114); // rgba(12,17,20,.08)

  // --- Dark (tokens.css :root[data-theme="dark"]) ---
  static const Color darkCanvas = Color(0xFF0B0F11);
  static const Color darkGroundHi = Color(0xFF1A2023);
  static const Color darkInk = Color(0xFFF2F5F5);
  static const Color darkInk2 = Color(0xFF98A4A7);
  static const Color darkInk3 = Color(0xFF5E6A6E);
  static const Color darkRule = Color(0x1AF2F5F5); // rgba(242,245,245,.10)

  static const Color darkAqua100 = Color(0xFF12333C);
  static const Color darkAquaTint = Color(0xFF1F4C58);
  static const Color darkAquaHi = Color(0xFFA6D8E5);
  static const Color darkAqua = Color(0xFF6EB4C4);
  static const Color darkAquaMid = Color(0xFF4F97A8);
  static const Color darkAquaShade = Color(0xFF2E6774);
  static const Color darkAquaDeep = Color(0xFF92CCDC);
  static const Color darkAquaInk = Color(0xFF10303A);

  static const Color darkGlass = Color(0x0FFFFFFF); // rgba(255,255,255,.06)
  static const Color darkGlassStrong = Color(0x1AFFFFFF); // rgba(255,255,255,.10)
  static const Color darkGlassEdge = Color(0x38FFFFFF); // rgba(255,255,255,.22)
  static const Color darkGlassEdge2 = Color(0x12FFFFFF); // rgba(255,255,255,.07)
  static const Color darkSpec = Color(0x73FFFFFF); // rgba(255,255,255,.45)
  static const Color darkInsetBg = Color(0x0DFFFFFF); // rgba(255,255,255,.05)
  static const Color darkHeadGlass = Color(0xC70B0F11); // rgba(11,15,17,.78)

  static const Color darkOk = Color(0xFF7FB59E);
  static const Color darkWarn = Color(0xFFEC9A50);
  static const Color darkBad = Color(0xFFE67274);
  static const Color darkWarm = Color(0xFFDE9074);
  static const Color darkCool = Color(0xFF8AA8C2);

  static const Color darkGlassShadowNear = Color(0xCC000000); // rgba(0,0,0,.8)
  static const Color darkGlassShadowFar = Color(0x80000000); // rgba(0,0,0,.5)

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
  static Color themed(Color color, Brightness brightness) {
    if (brightness != Brightness.dark) return color;
    // Dark tokens first — some light/dark hexes collide (e.g. aqua-hi light
    // equals aqua-deep dark).
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
  static Color glassOf(Brightness b) =>
      b == Brightness.dark ? darkGlass : glass;
  static Color glassStrongOf(Brightness b) =>
      b == Brightness.dark ? darkGlassStrong : glassStrong;
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

  /// `.selected` fill: `--aqua-tint` at 30%.
  static Color selectedFill(Brightness b) =>
      aquaTintOf(b).withValues(alpha: 0.30);
}
