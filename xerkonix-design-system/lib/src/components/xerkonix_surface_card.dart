import 'package:flutter/material.dart';

import '../tactile/tactile_surface.dart';

/// A flat rounded group. [onTap] adds keyboard and pointer interaction.
///
/// This is the generic sibling of [XkInfoCard] (which composes fixed
/// metric/title/description content). Use [XkCard] when you need an arbitrary
/// child on the standard surface. Built on [XkNeumorphic].
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
    return XkTactileSurface(
      role: XkTactileSurfaceRole.information,
      padding: padding ?? const EdgeInsets.all(16),
      width: double.infinity,
      onTap: onTap,
      child: child,
    );
  }
}
