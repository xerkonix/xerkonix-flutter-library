import 'package:flutter/material.dart';

import '../palette/color.dart';

/// A small, uppercased, tracked-out status badge (e.g. "OPEN BETA", "NEW").
///
/// The [color] tints both the fill (12% alpha), the border (40% alpha) and the
/// text. Defaults to the accent token for the current brightness.
class XkBadge extends StatelessWidget {
  const XkBadge({
    super.key,
    required this.label,
    this.color,
  });

  final String label;

  /// Base tint. Defaults to the accent token for the current brightness.
  final Color? color;

  /// Preset covering the product "OPEN BETA" badge.
  factory XkBadge.beta({Key? key, String label = 'OPEN BETA', Color? color}) {
    return XkBadge(key: key, label: label, color: color);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color base =
        color ?? (isDark ? XkColor.darkAccent : XkColor.accent);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: base.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: base.withValues(alpha: 0.4)),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: base,
          fontSize: 9.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
