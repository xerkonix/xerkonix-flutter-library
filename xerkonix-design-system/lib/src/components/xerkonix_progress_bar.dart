import 'package:flutter/material.dart';

import '../palette/color.dart';

/// A thin rounded linear progress bar, [value] in the range 0..1. Covers the
/// product `TemperatureBar`.
class XkProgressBar extends StatelessWidget {
  const XkProgressBar({
    super.key,
    required this.value,
    this.minHeight = 6,
    this.color,
  });

  /// Progress in the range 0..1. Clamped on render.
  final double value;
  final double minHeight;

  /// Fill color. Defaults to the soft accent token for the current brightness.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color track = isDark ? XkColor.darkSurface2 : XkColor.surface2;
    final Color fill =
        color ?? (isDark ? XkColor.darkAccent : XkColor.accent);
    return ClipRRect(
      borderRadius: BorderRadius.circular(minHeight / 2),
      child: LinearProgressIndicator(
        value: value.clamp(0.0, 1.0),
        minHeight: minHeight,
        backgroundColor: track,
        color: fill,
      ),
    );
  }
}
