import 'package:flutter/material.dart';

import '../palette/color.dart';

/// An uppercased, tracked-out section header with an optional [trailing] widget.
/// Covers the product `SectionLabel`.
class XkSectionLabel extends StatelessWidget {
  const XkSectionLabel({super.key, required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color color = isDark ? XkColor.darkInk2 : XkColor.ink2;
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 22, 2, 11),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              title.toUpperCase(),
              style:
                  (Theme.of(context).textTheme.bodySmall ?? const TextStyle())
                      .copyWith(
                        letterSpacing: 0.12,
                        fontSize: 11,
                        color: color,
                        fontWeight: FontWeight.w500,
                      ),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
