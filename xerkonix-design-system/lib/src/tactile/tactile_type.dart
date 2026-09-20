import 'package:flutter/painting.dart';

import 'tactile_fonts.dart';

/// Type scale from tactile `components.css` / `service.css`.
///
/// Family is the stack's loadable fallback [XkTactileFonts.family]
/// (`Noto Sans CJK KR`). Inter / `.SF NS` / Apple SD Gothic Neo names
/// do not paint in CanvasKit. Pretendard is not in the current stack.
///
/// CSS `font-weight: 550` (button, label, eyebrow) and hero `450` are
/// not [FontWeight] enum values. Paint uses [FontVariation.weight] on
/// the official Noto CJK variable face. [FontWeight] is the nearest
/// Material enum only (500 for 550, 400 for 450). Apps must call
/// [XkTactileFonts.ensureLoaded] — a family string without bytes is
/// the engine default.
class XkTactileType {
  XkTactileType._();

  static TextStyle ui({
    required double size,
    FontWeight weight = FontWeight.w400,
    double? wght,
    double height = 1.65,
    double letterSpacing = 0,
    Color? color,
  }) {
    final double axis = wght ?? weight.value.toDouble();
    return TextStyle(
      fontFamily: XkTactileFonts.family,
      fontSize: size,
      fontWeight: weight,
      fontVariations: XkTactileFonts.variations(axis),
      height: height,
      letterSpacing: letterSpacing == 0 ? null : letterSpacing,
      color: color,
    );
  }

  static TextStyle body({Color? color}) =>
      ui(size: 15, wght: 400, height: 1.65, color: color);

  static TextStyle button({Color? color}) => ui(
        size: 13,
        weight: FontWeight.w500,
        wght: 550,
        height: 1.5,
        color: color,
      );

  static TextStyle field({Color? color}) =>
      ui(size: 13, wght: 400, height: 1.55, color: color);

  static TextStyle label({Color? color}) => ui(
        size: 12,
        weight: FontWeight.w500,
        wght: 550,
        height: 1.5,
        color: color,
      );

  static TextStyle display({Color? color}) => ui(
        size: 28,
        weight: FontWeight.w400,
        wght: 450,
        height: 1.35,
        letterSpacing: -0.03,
        color: color,
      );

  static TextStyle eyebrow({Color? color}) => ui(
        size: 10,
        weight: FontWeight.w500,
        wght: 550,
        height: 1.6,
        letterSpacing: 0.18,
        color: color,
      );
}
