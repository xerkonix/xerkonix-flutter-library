import 'package:flutter/material.dart';

import '../palette/color.dart';

/// An uppercased, tracked-out section header with an optional [trailing] widget.
/// Covers the product `SectionLabel`.
class XkSectionLabel extends StatelessWidget {
  const XkSectionLabel({
    super.key,
    required this.title,
    this.trailing,
  });

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color color = isDark ? XkColor.darkTextMuted : XkColor.textMuted;
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 22, 2, 11),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              title.toUpperCase(),
              style: (Theme.of(context).textTheme.bodySmall ?? const TextStyle())
                  .copyWith(
                letterSpacing: 1.6,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
