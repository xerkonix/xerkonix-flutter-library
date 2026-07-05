import 'package:flutter/material.dart';

import '../palette/color.dart';

/// A generic, parameterized brand-mark primitive: an open arc (ring segment)
/// paired with a filled circle, in the geometry of a "linked" glyph.
///
/// This is intentionally NOT tied to any single product's brand colors — by
/// default the arc paints with the accent token and the dot with the brand
/// token, so it respects light/dark automatically. Pass [primary] / [secondary]
/// to recolor (e.g. to reproduce a product-specific mark).
class XkBrandMark extends StatelessWidget {
  const XkBrandMark({
    super.key,
    required this.size,
    this.primary,
    this.secondary,
  });

  final double size;

  /// Arc / ring color. Defaults to the accent token for the current brightness.
  final Color? primary;

  /// Dot / circle color. Defaults to the brand token for the current brightness.
  final Color? secondary;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color arc = primary ?? (isDark ? XkColor.darkAccent : XkColor.accent);
    final Color dot = secondary ?? (isDark ? XkColor.darkBrand : XkColor.brand);
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _BrandMarkPainter(arc, dot)),
    );
  }
}

class _BrandMarkPainter extends CustomPainter {
  _BrandMarkPainter(this.arcColor, this.dotColor);

  final Color arcColor;
  final Color dotColor;

  static const double _deg = 3.141592653589793 / 180.0;

  @override
  void paint(Canvas canvas, Size size) {
    // Clean geometry on a 96x96 reference grid, stroke 7 (matches the product
    // CosentioMark geometry but generic).
    final double s = size.width / 96.0;
    final double stroke = 7 * s;
    final Paint arc = Paint()
      ..color = arcColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    final Paint dot = Paint()
      ..color = dotColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    // Arc at (30,48) r18, opening on the right toward the dot.
    canvas.drawArc(
      Rect.fromCircle(center: Offset(30 * s, 48 * s), radius: 18 * s),
      34 * _deg,
      292 * _deg,
      false,
      arc,
    );
    // Ring at (66,48) r18.
    canvas.drawCircle(Offset(66 * s, 48 * s), 18 * s, dot);
  }

  @override
  bool shouldRepaint(covariant _BrandMarkPainter old) =>
      old.arcColor != arcColor || old.dotColor != dotColor;
}
