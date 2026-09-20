import 'package:flutter/painting.dart';

/// Type scale from tactile `components.css` / `service.css`.
///
/// Live CSS declares Inter first and loads **no** `@font-face`. Mac Chrome
/// paints `.SF NS` + `Apple SD Gothic Neo` (`isCustomFont: false`). Flutter
/// CanvasKit and the test embedder do **not** register those faces — measured
/// 2026-09-20: rasters for `''`, `.SF NS`, `Inter`, and FontManifest-only
/// `Pretendard` were byte-identical tofu; only `FontLoader` bytes painted
/// "Aa가". Naming a face here is not paint.
///
/// Supported strategy: omit `fontFamily` in this shared API (scale / weight /
/// leading only). Controls merge onto the ambient Theme face. Apps apply a
/// family they actually load (existing Pretendard bundle + FontLoader) at
/// Theme, on every platform they ship — not a Mac-only `.SF NS` string, and
/// not a new Inter CDN.
class XkTactileType {
  XkTactileType._();

  static TextStyle ui({
    required double size,
    FontWeight weight = FontWeight.w400,
    double height = 1.65,
    double letterSpacing = 0,
    Color? color,
  }) {
    return TextStyle(
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: letterSpacing == 0 ? null : letterSpacing,
      color: color,
    );
  }

  static TextStyle body({Color? color}) =>
      ui(size: 15, height: 1.65, color: color);

  static TextStyle button({Color? color}) => ui(
        size: 13,
        weight: FontWeight.w500,
        height: 1.5,
        color: color,
      );

  static TextStyle field({Color? color}) =>
      ui(size: 13, height: 1.55, color: color);

  static TextStyle label({Color? color}) => ui(
        size: 12,
        weight: FontWeight.w500,
        height: 1.5,
        color: color,
      );
}
