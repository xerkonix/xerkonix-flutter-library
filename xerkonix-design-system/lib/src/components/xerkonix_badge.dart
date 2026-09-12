import 'package:flutter/material.dart';

import 'xerkonix_glass.dart';

/// Outline tag. [color] is ignored (aqua is not a semantic fill).
class XkBadge extends StatelessWidget {
  const XkBadge({super.key, required this.label, this.color});

  final String label;
  final Color? color;

  factory XkBadge.beta({Key? key, String label = 'OPEN BETA', Color? color}) {
    return XkBadge(key: key, label: label, color: color);
  }

  @override
  Widget build(BuildContext context) {
    return XkTag(label: label.toUpperCase());
  }
}
