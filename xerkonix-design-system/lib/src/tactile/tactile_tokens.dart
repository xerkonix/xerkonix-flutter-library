import 'package:flutter/material.dart';

/// Values from DS `tactile/tokens.css` v3.1.0.
/// Do not invent hex here. Light `:root` and dark `[data-theme=dark]`.
///
/// Product screen 6-B roles (`appIntroSurface` … `humanReviewBorder`) come
/// from DS `tactile/app-surface.css` through `flutter/APP_SURFACE_MAPPING.md`.
/// `color-mix(in srgb, …)` values are computed by
/// `tools/build_tactile_theme_roles.py` into `tools/tactile_theme_roles.json`
/// and checked against the constants below — edit the CSS, not these.
class XkTactileTokens {
  const XkTactileTokens._({
    required this.canvas,
    required this.surface,
    required this.surfaceRaised,
    required this.panelFill,
    required this.ink,
    required this.muted,
    required this.ice,
    required this.accent,
    required this.accentDeep,
    required this.line,
    required this.glassFill,
    required this.glassRim,
    required this.glassInset,
    required this.glassFallback,
    required this.glassBlur,
    required this.overlayFill,
    required this.overlayBorder,
    required this.overlayBackdrop,
    required this.inputFill,
    required this.inputBorder,
    required this.primaryText,
    required this.primaryBase,
    required this.primaryBorder,
    required this.primaryOverlayTop,
    required this.primaryOverlayBottom,
    required this.primaryHoverTop,
    required this.primaryHoverBottom,
    required this.primaryRing,
    required this.primaryDrop,
    required this.primaryInset,
    required this.primaryDropOffset,
    required this.primaryDropBlur,
    required this.selectedBorder,
    required this.focusRing,
    required this.shadowFloat,
    required this.secondaryFill,
    required this.secondaryHover,
    required this.secondaryBorder,
    required this.secondaryShadow,
    required this.controlHover,
    required this.faint,
    required this.headerFill,
    required this.controlOn,
    required this.controlTrack,
    required this.controlMark,
    required this.selectedFill,
    required this.appIntroSurface,
    required this.onAppIntro,
    required this.appIntroBody,
    required this.appIntroPrimaryFill,
    required this.appIntroPrimaryText,
    required this.appIntroPrimaryHover,
    required this.appIntroFocusRing,
    required this.onAppIntroAccent,
    required this.appIntroLink,
    required this.appIntroBrandWord,
    required this.completionSheen,
    required this.currentLabel,
    required this.keyMetric,
    required this.humanReviewLabel,
    required this.selectedCue,
    required this.humanReviewSurface,
    required this.humanReviewBorder,
  });

  final Color canvas;
  final Color surface;
  final Color surfaceRaised;
  final Color panelFill;
  final Color ink;
  final Color muted;
  final Color ice;
  final Color accent;
  final Color accentDeep;
  final Color line;
  final Color glassFill;
  final Color glassRim;
  final Color glassInset;
  final Color glassFallback;
  final double glassBlur;
  final Color overlayFill;
  final Color overlayBorder;
  final Color overlayBackdrop;
  final Color inputFill;
  final Color inputBorder;
  final Color primaryText;
  final Color primaryBase;
  final Color primaryBorder;
  final Color primaryOverlayTop;
  final Color primaryOverlayBottom;
  final Color primaryHoverTop;
  final Color primaryHoverBottom;
  final Color primaryRing;
  final Color primaryDrop;
  final Color primaryInset;
  final Offset primaryDropOffset;
  final double primaryDropBlur;
  final Color selectedBorder;
  final Color focusRing;
  final List<BoxShadow> shadowFloat;
  final Color secondaryFill;
  final Color secondaryHover;
  final Color secondaryBorder;
  final List<BoxShadow> secondaryShadow;
  final Color controlHover;
  final Color faint;
  final Color headerFill;
  final Color controlOn;
  final Color controlTrack;
  final Color controlMark;
  final Color selectedFill;

  /// Ink first-impression plane (`.app-intro` background, `--app-ink`).
  final Color appIntroSurface;

  /// Heading and body text on [appIntroSurface] (`--app-ink-text`).
  final Color onAppIntro;

  /// Secondary copy on [appIntroSurface] (`.app-intro-copy`).
  final Color appIntroBody;

  /// Primary button fill inside [appIntroSurface] only.
  final Color appIntroPrimaryFill;

  /// Primary button label inside [appIntroSurface] only.
  final Color appIntroPrimaryText;

  /// Primary button hover fill and border inside [appIntroSurface].
  final Color appIntroPrimaryHover;

  /// Keyboard focus outline on [appIntroSurface] (3px, offset 4px).
  final Color appIntroFocusRing;

  /// Aquamarine label on [appIntroSurface] (`.app-intro-label`).
  final Color onAppIntroAccent;

  /// Link on [appIntroSurface] (`.app-ink-link`, underline offset 3px).
  final Color appIntroLink;

  /// Single-hue brand word gradient stops on [appIntroSurface].
  final List<Color> appIntroBrandWord;

  /// One-pass completion light tint (`.app-completion`).
  final Color completionSheen;

  /// Current place / active state text (`.app-current`).
  final Color currentLabel;

  /// Key number text (`.app-metric-value`).
  final Color keyMetric;

  /// Human review label text (`.app-review-label`).
  final Color humanReviewLabel;

  /// Aquamarine cue beside a neutral selected label (`.app-selected-cue`).
  final Color selectedCue;

  /// Human review plane (`.app-review` background).
  final Color humanReviewSurface;

  /// Human review edge (`.app-review` border).
  final Color humanReviewBorder;

  /// Unpainted. Widgets use this instead of `Color(0x00000000)`.
  static const Color clear = Color(0x00000000);

  static const XkTactileTokens light = XkTactileTokens._(
    canvas: Color(0xFFF5F5F5),
    surface: Color(0xFFFBFBFC),
    surfaceRaised: Color(0xFFFFFFFF),
    panelFill: Color(0x3DFFFFFF),
    ink: Color(0xFF111111),
    muted: Color(0xFF636365),
    ice: Color(0xFFE9E9E9),
    accent: Color(0xFF269DB0),
    accentDeep: Color(0xFF111111),
    line: Color(0x1A111111),
    glassFill: Color(0x8FFFFFFF),
    glassRim: Color(0xE6FFFFFF),
    glassInset: Color(0xCCFFFFFF),
    glassFallback: Color(0xFFFBFBFC),
    glassBlur: 20,
    overlayFill: Color(0xF5FBFBFC),
    overlayBorder: Color(0xF2FFFFFF),
    overlayBackdrop: Color(0x40111111),
    inputFill: Color(0xADFFFFFF),
    inputBorder: Color(0x33111111),
    primaryText: Color(0xFFF5F5F5),
    primaryBase: Color(0xFF111111),
    primaryBorder: Color(0xFF111111),
    primaryOverlayTop: Color(0x00000000),
    primaryOverlayBottom: Color(0x00000000),
    primaryHoverTop: Color(0xFF2A2A2A),
    primaryHoverBottom: Color(0xFF2A2A2A),
    primaryRing: Color(0x00000000),
    primaryDrop: Color(0x00000000),
    primaryInset: Color(0x00000000),
    primaryDropOffset: Offset(0, 0),
    primaryDropBlur: 0,
    selectedBorder: Color(0x59111111),
    focusRing: Color(0xFF111111),
    shadowFloat: <BoxShadow>[
      BoxShadow(
        color: Color(0x13111111),
        offset: Offset(0, 20),
        blurRadius: 48,
      ),
      BoxShadow(color: Color(0x09111111), offset: Offset(0, 3), blurRadius: 8),
    ],
    secondaryFill: Color(0xB3FFFFFF),
    secondaryHover: Color(0xFFFFFFFF),
    secondaryBorder: Color(0xF2FFFFFF),
    secondaryShadow: <BoxShadow>[
      BoxShadow(color: Color(0x0D111111), offset: Offset(0, 8), blurRadius: 24),
      BoxShadow(color: Color(0x0A111111), offset: Offset(0, 1), blurRadius: 3),
    ],
    controlHover: Color(0xBFFFFFFF),
    faint: Color(0xFF767678),
    headerFill: Color(0xDEF5F5F5),
    controlOn: Color(0xFF111111),
    controlTrack: Color(0xFFCFD3DA),
    controlMark: Color(0xFFFFFFFF),
    selectedFill: Color(0x14111111),
    appIntroSurface: Color(0xFF111111),
    onAppIntro: Color(0xFFF5F5F5),
    appIntroBody: Color(0xFFCED4D6),
    appIntroPrimaryFill: Color(0xFFF5F5F5),
    appIntroPrimaryText: Color(0xFF111111),
    appIntroPrimaryHover: Color(0xFFDEDEDE),
    appIntroFocusRing: Color(0xFFF5F5F5),
    onAppIntroAccent: Color(0xFF65C9D9),
    appIntroLink: Color(0xFF65C9D9),
    appIntroBrandWord: <Color>[Color(0xFF65C9D9), Color(0xFF53A1AD)],
    completionSheen: Color(0x4065C9D9),
    currentLabel: Color(0xFF1C5D67),
    keyMetric: Color(0xFF1C5D67),
    humanReviewLabel: Color(0xFF1C5D67),
    selectedCue: Color(0xFF1C5D67),
    humanReviewSurface: Color(0xFFE4F1F4),
    humanReviewBorder: Color(0x7D217D8C),
  );

  static const XkTactileTokens dark = XkTactileTokens._(
    canvas: Color(0xFF111111),
    surface: Color(0xFF191B1F),
    surfaceRaised: Color(0xFF22262C),
    panelFill: Color(0x06CFD3DA),
    ink: Color(0xFFF5F5F5),
    muted: Color(0xFFAEB4BD),
    ice: Color(0xFF303030),
    accent: Color(0xFF65C9D9),
    accentDeep: Color(0xFFF5F5F5),
    line: Color(0x21CFD3DA),
    glassFill: Color(0xA32A2F36),
    glassRim: Color(0x30CFD3DA),
    glassInset: Color(0x17FFFFFF),
    glassFallback: Color(0xFF22262C),
    glassBlur: 20,
    overlayFill: Color(0xF51D2025),
    overlayBorder: Color(0x30CFD3DA),
    overlayBackdrop: Color(0x94000000),
    inputFill: Color(0xFF191B1F),
    inputBorder: Color(0x3DCFD3DA),
    primaryText: Color(0xFF111111),
    primaryBase: Color(0xFFF5F5F5),
    primaryBorder: Color(0xFFF5F5F5),
    primaryOverlayTop: Color(0x00000000),
    primaryOverlayBottom: Color(0x00000000),
    primaryHoverTop: Color(0xFFDEDEDE),
    primaryHoverBottom: Color(0xFFDEDEDE),
    primaryRing: Color(0x00000000),
    primaryDrop: Color(0x00000000),
    primaryInset: Color(0x00000000),
    primaryDropOffset: Offset(0, 0),
    primaryDropBlur: 0,
    selectedBorder: Color(0x66F5F5F5),
    focusRing: Color(0xFFF5F5F5),
    shadowFloat: <BoxShadow>[
      BoxShadow(
        color: Color(0x4D000000),
        offset: Offset(0, 20),
        blurRadius: 48,
      ),
      BoxShadow(color: Color(0x29000000), offset: Offset(0, 3), blurRadius: 8),
    ],
    secondaryFill: Color(0x0ECFD3DA),
    secondaryHover: Color(0x1ACFD3DA),
    secondaryBorder: Color(0x29CFD3DA),
    secondaryShadow: <BoxShadow>[
      BoxShadow(color: Color(0x1F000000), offset: Offset(0, 3), blurRadius: 10),
      BoxShadow(
        color: Color(0x0BFFFFFF),
        offset: Offset(0, 1),
        blurStyle: BlurStyle.inner,
      ),
    ],
    controlHover: Color(0x14CFD3DA),
    faint: Color(0xFF9199A5),
    headerFill: Color(0xE0111111),
    controlOn: Color(0xFFF5F5F5),
    controlTrack: Color(0xFF383D45),
    controlMark: Color(0xFF111111),
    selectedFill: Color(0x1AF5F5F5),
    appIntroSurface: Color(0xFF242C31),
    onAppIntro: Color(0xFFF5F5F5),
    appIntroBody: Color(0xFFCED4D6),
    appIntroPrimaryFill: Color(0xFFF5F5F5),
    appIntroPrimaryText: Color(0xFF242C31),
    appIntroPrimaryHover: Color(0xFFDEDEDE),
    appIntroFocusRing: Color(0xFFF5F5F5),
    onAppIntroAccent: Color(0xFF65C9D9),
    appIntroLink: Color(0xFF65C9D9),
    appIntroBrandWord: <Color>[Color(0xFF65C9D9), Color(0xFF53A1AD)],
    completionSheen: Color(0x4065C9D9),
    currentLabel: Color(0xFF65C9D9),
    keyMetric: Color(0xFF65C9D9),
    humanReviewLabel: Color(0xFF65C9D9),
    selectedCue: Color(0xFF65C9D9),
    humanReviewSurface: Color(0xFF233237),
    humanReviewBorder: Color(0x8D7FCBD9),
  );

  static XkTactileTokens of(Brightness brightness) {
    return brightness == Brightness.dark ? dark : light;
  }

  static const double controlHeight = 46;
  static const double controlRadius = 12;
  static const double fieldRadius = 10;
  static const double surfaceRadius = 16;
  static const double panelRadius = 14;
  static const double overlayRadius = 24;
  static const double controlBlur = 12;
  static const double overlayBlur = 24;
  static const double focusOutlineWidth = 3;
  static const double focusOutlineOffset = 4;
  static const Duration motion = Duration(milliseconds: 220);
  static const Cubic ease = Cubic(0.22, 1, 0.36, 1);
  static const double disabledOpacity = 0.4;
}
