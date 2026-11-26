import 'package:flutter/material.dart';

import 'tactile_plate.dart';

/// Values from DS `tactile/tokens.css` v4.5.0.
/// Do not invent hex here. Light `:root` and dark `[data-theme=dark]`.
///
/// Product screen v4 roles (`currentLabel` … `humanReviewBorder`) come
/// from DS `tactile/app-surface.css` through `flutter/APP_SURFACE_MAPPING.md`.
/// Light is the product theme; the dark block is the emphasis-dark band
/// token set (`[data-theme="dark"]` scoped to an element, two places only).
/// `color-mix(in srgb, …)` values are computed by
/// `tools/build_tactile_theme_roles.py` into `tools/tactile_theme_roles.json`
/// and checked against the constants below — edit the CSS, not these.
class XkTactileTokens {
  const XkTactileTokens._({
    required this.canvas,
    required this.surface,
    required this.surfaceRaised,
    required this.panelFill,
    required this.panelGradient,
    required this.panelHaze,
    required this.panelBorder,
    required this.panelShadow,
    required this.glassFloatShadow,
    required this.ink,
    required this.muted,
    required this.ice,
    required this.accent,
    required this.accentDeep,
    required this.line,
    required this.glassFill,
    required this.glassRim,
    required this.glassRing,
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

  /// Flat Material Card fallback (`--surface`). Information surfaces paint
  /// [panelGradient] over [panelHaze], preserving CSS `--panel-fill` layers.
  final Color panelFill;
  final LinearGradient panelGradient;
  final RadialGradient panelHaze;

  /// Card outer edge (`--panel-border`), transparent in the current CSS.
  /// Inner dividers keep [line].
  final Color panelBorder;

  /// Card depth (`--panel-shadow`). Paint it as an outer shadow only
  /// (`XkOuterShadow`) so the translucent [panelFill] does not show it.
  final List<BoxShadow> panelShadow;

  /// Floating glass depth (`--glass-float-shadow`, `.glass` / `.glass-2`).
  /// Values follow the current CSS depth token.
  final List<BoxShadow> glassFloatShadow;
  final Color ink;
  final Color muted;
  final Color ice;
  final Color accent;
  final Color accentDeep;
  final Color line;
  final Color glassFill;
  final Color glassRim;

  /// Even 1px inner ring of a card or glass face
  /// (`inset 0 0 0 1px var(--glass-ring)`).
  final Color glassRing;
  final Color glassInset;
  final Color glassFallback;
  final double glassBlur;
  final Color overlayFill;
  final Color overlayBorder;
  final Color overlayBackdrop;
  final Color inputFill;

  /// Borderless text field edge (`--input-border`). Native checkbox,
  /// radio and switch outlines use [ink] to remain visible while off.
  /// Chips and choices use [secondaryBorder].
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
    canvas: Color(0xFFFAFBFB),
    surface: Color(0xFFFBFBFC),
    surfaceRaised: Color(0xFFFFFFFF),
    panelFill: Color(0xFFFBFBFC),
    panelGradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[Color(0x9EFFFFFF), Color(0xEBFFFFFF), Color(0xFAFFFFFF)],
      stops: <double>[0, 0.62, 1],
    ),
    panelHaze: RadialGradient(
      center: Alignment(-0.8, -1),
      radius: 1,
      colors: <Color>[Color(0x59CDD6D6), Color(0x00CDD6D6)],
      stops: <double>[0, 0.7],
      transform: XkTactileEllipse(1.2, 0.7, 0.1, 0),
    ),
    panelBorder: Color(0x00000000),
    panelShadow: <BoxShadow>[
      BoxShadow(
        color: Color(0x0D111111),
        offset: Offset(0, 1),
        blurRadius: 2,
        spreadRadius: 0,
      ),
      BoxShadow(
        color: Color(0x0F111111),
        offset: Offset(0, 4),
        blurRadius: 12,
        spreadRadius: 0,
      ),
    ],
    glassFloatShadow: <BoxShadow>[
      BoxShadow(
        color: Color(0x0F111111),
        offset: Offset(0, 2),
        blurRadius: 6,
        spreadRadius: 0,
      ),
      BoxShadow(
        color: Color(0x1A111111),
        offset: Offset(0, 12),
        blurRadius: 32,
        spreadRadius: 0,
      ),
    ],
    ink: Color(0xFF111111),
    muted: Color(0xFF636365),
    ice: Color(0xFFE9E9E9),
    accent: Color(0xFF65C9D9),
    accentDeep: Color(0xFF111111),
    line: Color(0x1A111111),
    glassFill: Color(0x8FFFFFFF),
    glassRim: Color(0xE6FFFFFF),
    glassRing: Color(0x00000000),
    glassInset: Color(0x00000000),
    glassFallback: Color(0xFFFBFBFC),
    glassBlur: 20,
    overlayFill: Color(0xFFFFFFFF),
    overlayBorder: Color(0x00000000),
    overlayBackdrop: Color(0x40111111),
    inputFill: Color(0xB3E8E9E9),
    inputBorder: Color(0x00000000),
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
    secondaryFill: Color(0xD1FFFFFF),
    secondaryHover: Color(0xFFFFFFFF),
    secondaryBorder: Color(0x00000000),
    secondaryShadow: <BoxShadow>[
      BoxShadow(
        color: Color(0x14111111),
        offset: Offset(0, 1),
        blurRadius: 2,
        spreadRadius: 0,
      ),
      BoxShadow(
        color: Color(0x1A111111),
        offset: Offset(0, 6),
        blurRadius: 16,
        spreadRadius: 0,
      ),
    ],
    controlHover: Color(0x0F111111),
    faint: Color(0xFF767678),
    headerFill: Color(0xDEFAFBFB),
    controlOn: Color(0xFF111111),
    controlTrack: Color(0xFFCFD3DA),
    controlMark: Color(0xFFFFFFFF),
    selectedFill: Color(0x14111111),
    currentLabel: Color(0xFF111111),
    keyMetric: Color(0xFF111111),
    humanReviewLabel: Color(0xFF111111),
    selectedCue: Color(0xFF111111),
    humanReviewSurface: Color(0x14111111),
    humanReviewBorder: Color(0x00000000),
  );

  static const XkTactileTokens dark = XkTactileTokens._(
    canvas: Color(0xFF101111),
    surface: Color(0xFF1B1C1C),
    surfaceRaised: Color(0xFF252727),
    panelFill: Color(0xFF1B1C1C),
    panelGradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[Color(0x662D3030), Color(0xC72D3030), Color(0xE62D3030)],
      stops: <double>[0, 0.62, 1],
    ),
    panelHaze: RadialGradient(
      center: Alignment(-0.8, -1),
      radius: 1,
      colors: <Color>[Color(0x1ACFD5D5), Color(0x00CFD5D5)],
      stops: <double>[0, 0.7],
      transform: XkTactileEllipse(1.2, 0.7, 0.1, 0),
    ),
    panelBorder: Color(0x00000000),
    panelShadow: <BoxShadow>[
      BoxShadow(
        color: Color(0x80111111),
        offset: Offset(0, 1),
        blurRadius: 2,
        spreadRadius: 0,
      ),
      BoxShadow(
        color: Color(0x73111111),
        offset: Offset(0, 4),
        blurRadius: 12,
        spreadRadius: 0,
      ),
    ],
    glassFloatShadow: <BoxShadow>[
      BoxShadow(
        color: Color(0x80111111),
        offset: Offset(0, 2),
        blurRadius: 6,
        spreadRadius: 0,
      ),
      BoxShadow(
        color: Color(0x99111111),
        offset: Offset(0, 12),
        blurRadius: 32,
        spreadRadius: 0,
      ),
    ],
    ink: Color(0xFFF5F5F5),
    muted: Color(0xFFAEB4BD),
    ice: Color(0xFF303030),
    accent: Color(0xFF65C9D9),
    accentDeep: Color(0xFFF5F5F5),
    line: Color(0x21CFD3DA),
    glassFill: Color(0xA32C3030),
    glassRim: Color(0x30CFD3DA),
    glassRing: Color(0x00000000),
    glassInset: Color(0x00000000),
    glassFallback: Color(0xFF252727),
    glassBlur: 20,
    overlayFill: Color(0xFF252727),
    overlayBorder: Color(0x00000000),
    overlayBackdrop: Color(0x94111111),
    inputFill: Color(0xFF1B1C1C),
    inputBorder: Color(0x00000000),
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
    secondaryFill: Color(0xA33D3F3F),
    secondaryHover: Color(0xFF3A3A3C),
    secondaryBorder: Color(0x00000000),
    secondaryShadow: <BoxShadow>[
      BoxShadow(
        color: Color(0x66111111),
        offset: Offset(0, 1),
        blurRadius: 2,
        spreadRadius: 0,
      ),
      BoxShadow(
        color: Color(0x59111111),
        offset: Offset(0, 6),
        blurRadius: 16,
        spreadRadius: 0,
      ),
    ],
    controlHover: Color(0x1ACFD3DA),
    faint: Color(0xFF9199A5),
    headerFill: Color(0xDE101111),
    controlOn: Color(0xFFF5F5F5),
    controlTrack: Color(0xFF3A3A3C),
    controlMark: Color(0xFF111111),
    selectedFill: Color(0x1AF5F5F5),
    currentLabel: Color(0xFFF5F5F5),
    keyMetric: Color(0xFFF5F5F5),
    humanReviewLabel: Color(0xFFF5F5F5),
    selectedCue: Color(0xFFF5F5F5),
    humanReviewSurface: Color(0x1AF5F5F5),
    humanReviewBorder: Color(0x00000000),
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

  /// Card face blur (`--panel-blur` / `--panel-blur-mobile`, max-width 700).
  static const double panelBlur = 20;
  static const double panelBlurMobile = 16;
  static const double panelBlurMobileMaxWidth = 700;

  /// `saturate(var(--glass-saturate))` behind a card or glass face.
  static const double glassSaturate = 1;
  static const double overlayBlur = 24;
  static const double focusOutlineWidth = 3;
  static const double focusOutlineOffset = 4;

  /// Input control focus ring (`outline:2px solid var(--focus-ring);
  /// outline-offset:2px`): drawn outside the edge, apart from it.
  static const double inputFocusRingWidth = 2;
  static const double inputFocusRingOffset = 2;

  /// Button-like control focus ring offset (`button:focus-visible`,
  /// `outline-offset:3px`), e.g. a chip. Width is [inputFocusRingWidth].
  static const double controlFocusRingOffset = 3;
  static const Duration motion = Duration(milliseconds: 220);
  static const Cubic ease = Cubic(0.22, 1, 0.36, 1);
  static const double disabledOpacity = 0.4;
}
