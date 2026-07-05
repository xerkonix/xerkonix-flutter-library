import 'package:flutter/material.dart';

import '../palette/color.dart';
import '../shape/xerkonix_shape.dart';

/// A base tappable surface: a bordered, rounded container that becomes an
/// [InkWell] when [onTap] is provided. Covers the product `CosentioCard`.
///
/// This is the generic sibling of [XkInfoCard] (which composes fixed
/// metric/title/description content). Use [XkCard] when you need an arbitrary
/// child on the standard surface.
class XkCard extends StatelessWidget {
  const XkCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bg = isDark ? XkColor.darkSurface : XkColor.surface;
    final Color border = isDark ? XkColor.darkBorder : XkColor.border;
    final Widget content = Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: XkShape.lgBorderRadius,
        border: Border.all(color: border),
      ),
      child: child,
    );
    if (onTap == null) {
      return content;
    }
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: XkShape.lgBorderRadius,
        child: content,
      ),
    );
  }
}
