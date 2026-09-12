import 'package:flutter/material.dart';

import '../palette/color.dart';
import '../shape/xerkonix_shape.dart';

/// Initials on an inset surface. No multi-color gradients.
class XkAvatar extends StatelessWidget {
  const XkAvatar({super.key, required this.name, this.size = 44});

  final String name;
  final double size;

  String get _initial {
    final String trimmed = name.trim();
    if (trimmed.isEmpty) {
      return '?';
    }
    return trimmed.characters.first.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final Brightness b = Theme.of(context).brightness;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: XkColor.insetBgOf(b),
        borderRadius: XkRadius.insetBorderRadius,
        border: Border.all(color: XkColor.ruleOf(b)),
      ),
      child: Text(
        _initial,
        style: TextStyle(
          color: XkColor.ink2Of(b),
          fontWeight: FontWeight.w600,
          fontSize: size * 0.38,
        ),
      ),
    );
  }
}
