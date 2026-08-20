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
    // [v2.3] 트랙=우물(--well) · 채움=포인트 인디케이터(--point-ind).
    final Color track = isDark ? XkColor.darkWell : XkColor.well;
    final Color fill =
        color ?? (isDark ? XkColor.darkPointInd : XkColor.pointInd);
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
