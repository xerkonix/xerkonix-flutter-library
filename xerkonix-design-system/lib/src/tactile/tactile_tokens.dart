import 'package:flutter/material.dart';

/// Values from DS `tactile/tokens.css` (SHA `00f39c4b05ec0b2f422b26e0da760cbabc99b2ab`, DS#43).
/// Do not invent hex here. Light `:root` and dark `[data-theme=dark]`.
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

  /// Unpainted. Widgets use this instead of `Color(0x00000000)`.
  static const Color clear = Color(0x00000000);

  static const XkTactileTokens light = XkTactileTokens._(
    canvas: Color(0xFFF5F5F5),
    surface: Color(0xFFFBFBFC),
    surfaceRaised: Color(0xFFFFFFFF),
    panelFill: Color(0x3DFFFFFF),
    ink: Color(0xFF111111),
    muted: Color(0xFF636365),
    ice: Color(0xFFCFE3F5),
    accent: Color(0xFF1E70B8),
    accentDeep: Color(0xFF175C99),
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
    primaryText: Color(0xFF175C99),
    primaryBase: Color(0xFFCFE3F5),
    primaryBorder: Color(0xF2FFFFFF),
    primaryOverlayTop: Color(0x7DFFFFFF),
    primaryOverlayBottom: Color(0x14FFFFFF),
    primaryHoverTop: Color(0xA8FFFFFF),
    primaryHoverBottom: Color(0x1FFFFFFF),
    primaryRing: Color(0x1F1E70B8),
    primaryDrop: Color(0x1A1E70B8),
    primaryInset: Color(0xFFFFFFFF),
    primaryDropOffset: Offset(0, 5),
    primaryDropBlur: 14,
    selectedBorder: Color(0x661E70B8),
    focusRing: Color(0x8C1E70B8),
    shadowFloat: <BoxShadow>[
      BoxShadow(
        color: Color(0x13111111),
        offset: Offset(0, 20),
        blurRadius: 48,
      ),
      BoxShadow(
        color: Color(0x09111111),
        offset: Offset(0, 3),
        blurRadius: 8,
      ),
    ],
    secondaryFill: Color(0xB3FFFFFF),
    secondaryHover: Color(0xFFFFFFFF),
    secondaryBorder: Color(0xF2FFFFFF),
    secondaryShadow: <BoxShadow>[
      BoxShadow(
        color: Color(0x0D111111),
        offset: Offset(0, 8),
        blurRadius: 24,
      ),
      BoxShadow(
        color: Color(0x0A111111),
        offset: Offset(0, 1),
        blurRadius: 3,
      ),
    ],
    controlHover: Color(0xBFFFFFFF),
    faint: Color(0xFF767678),
    headerFill: Color(0xDEF5F5F5),
    controlOn: Color(0xFF1E70B8),
    controlTrack: Color(0xFFCFD3DA),
    controlMark: Color(0xFFFFFFFF),
    selectedFill: Color(0x73CFE3F5),
  );

  static const XkTactileTokens dark = XkTactileTokens._(
    canvas: Color(0xFF111111),
    surface: Color(0xFF191B1F),
    surfaceRaised: Color(0xFF22262C),
    panelFill: Color(0x06CFD3DA),
    ink: Color(0xFFF5F5F5),
    muted: Color(0xFFAEB4BD),
    ice: Color(0xFF1A3045),
    accent: Color(0xFF93BFE5),
    accentDeep: Color(0xFFCFE3F5),
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
    primaryText: Color(0xFFCFE3F5),
    primaryBase: Color(0xFF1A3045),
    primaryBorder: Color(0x4793BFE5),
    primaryOverlayTop: Color(0x12CFE3F5),
    primaryOverlayBottom: Color(0x00CFE3F5),
    primaryHoverTop: Color(0x1FCFE3F5),
    primaryHoverBottom: Color(0x06CFE3F5),
    primaryRing: Color(0x00000000),
    primaryDrop: Color(0x29000000),
    primaryInset: Color(0x17CFE3F5),
    primaryDropOffset: Offset(0, 4),
    primaryDropBlur: 12,
    selectedBorder: Color(0x5993BFE5),
    focusRing: Color(0xA693BFE5),
    shadowFloat: <BoxShadow>[
      BoxShadow(
        color: Color(0x4D000000),
        offset: Offset(0, 20),
        blurRadius: 48,
      ),
      BoxShadow(
        color: Color(0x29000000),
        offset: Offset(0, 3),
        blurRadius: 8,
      ),
    ],
    secondaryFill: Color(0x0ECFD3DA),
    secondaryHover: Color(0x1ACFD3DA),
    secondaryBorder: Color(0x29CFD3DA),
    secondaryShadow: <BoxShadow>[
      BoxShadow(
        color: Color(0x1F000000),
        offset: Offset(0, 3),
        blurRadius: 10,
      ),
      BoxShadow(
        color: Color(0x0BFFFFFF),
        offset: Offset(0, 1),
        blurStyle: BlurStyle.inner,
      ),
    ],
    controlHover: Color(0x14CFD3DA),
    faint: Color(0xFF9199A5),
    headerFill: Color(0xE0111111),
    controlOn: Color(0xFF1E70B8),
    controlTrack: Color(0xFF383D45),
    controlMark: Color(0xFFFFFFFF),
    selectedFill: Color(0x2E1E70B8),
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
