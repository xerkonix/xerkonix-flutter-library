import 'package:flutter/material.dart';

import '../palette/color.dart';

/// A chevron-left text button used to navigate back. Covers the product
/// `CosentioBackButton`.
class XkBackButton extends StatelessWidget {
  const XkBackButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color color = isDark ? XkColor.darkTextBody : XkColor.textBody;
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: color),
      label: Text(label, style: TextStyle(color: color)),
      style: TextButton.styleFrom(padding: const EdgeInsets.only(bottom: 8)),
    );
  }
}
