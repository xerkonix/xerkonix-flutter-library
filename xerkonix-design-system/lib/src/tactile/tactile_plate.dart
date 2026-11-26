import 'package:flutter/material.dart';

/// CSS radial-gradient percentage radii are relative to width and height.
/// Flutter's radial radius is relative to the shortest side; scale its shader
/// about the CSS centre to preserve the ellipse at every aspect ratio.
class XkTactileEllipse extends GradientTransform {
  const XkTactileEllipse(
    this.radiusX,
    this.radiusY,
    this.centerX,
    this.centerY,
  );

  final double radiusX;
  final double radiusY;
  final double centerX;
  final double centerY;

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    final double shortest = bounds.shortestSide;
    if (shortest == 0) return Matrix4.identity();
    final double x = bounds.left + bounds.width * centerX;
    final double y = bounds.top + bounds.height * centerY;
    return Matrix4.identity()
      ..translateByDouble(x, y, 0, 1)
      ..scaleByDouble(
        bounds.width * radiusX / shortest,
        bounds.height * radiusY / shortest,
        1,
        1,
      )
      ..translateByDouble(-x, -y, 0, 1);
  }
}
