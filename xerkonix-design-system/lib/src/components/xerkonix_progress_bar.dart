import 'package:flutter/material.dart';

import '../palette/color.dart';

/// Determinate bar: `--rule` track, `--aqua-mid` fill.
class XkProgressBar extends StatelessWidget {
  const XkProgressBar({
    super.key,
    required this.value,
    this.minHeight = 4,
    this.color,
  });

  final double value;
  final double minHeight;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final Brightness b = Theme.of(context).brightness;
    final double t = value.clamp(0.0, 1.0);
    return ClipRRect(
      borderRadius: BorderRadius.circular(minHeight / 2),
      child: SizedBox(
        height: minHeight,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: ColoredBox(color: XkColor.ruleOf(b)),
            ),
            FractionallySizedBox(
              widthFactor: t,
              child: ColoredBox(color: color ?? XkColor.aquaMidOf(b)),
            ),
          ],
        ),
      ),
    );
  }
}
