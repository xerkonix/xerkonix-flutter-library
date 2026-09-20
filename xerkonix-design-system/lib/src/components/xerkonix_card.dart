import 'package:flutter/material.dart';

import '../palette/color.dart';
import '../shape/xerkonix_shape.dart';
import '../tactile/tactile_surface.dart';
import '../typography/xerkonix_typography.dart';

/// Metric/Status/Summary card on the information surface, not `.glass`.
/// [borderRadius] / [backgroundColor] / [borderColor] still paint; they do
/// not switch the role to glass.
class XkInfoCard extends StatelessWidget {
  const XkInfoCard({
    super.key,
    required this.metric,
    required this.title,
    required this.description,
    this.leading,
    this.trailing,
    this.padding = const EdgeInsets.all(XkLayout.spacingMd),
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
  });

  final String metric;
  final String title;
  final String description;
  final Widget? leading;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry? borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final metricColor = isDark ? XkColor.darkInk2 : XkColor.ink2;
    final titleColor = isDark ? XkColor.darkInk : XkColor.ink;
    final bodyColor = isDark ? XkColor.darkInk : XkColor.ink;

    return XkTactileSurface(
      role: XkTactileSurfaceRole.information,
      padding: padding,
      fill: backgroundColor,
      borderColor: borderColor,
      radius: borderRadius,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (leading != null || trailing != null) ...[
            Row(children: [?leading, const Spacer(), ?trailing]),
            const SizedBox(height: XkLayout.spacingXs),
          ],
          Text(
            metric,
            style: XkTypo.metaMono.copyWith(fontSize: 13, color: metricColor),
          ),
          const SizedBox(height: XkLayout.spacingXs),
          Text(
            title,
            style: XkTypo.h3.copyWith(fontSize: 18, color: titleColor),
          ),
          const SizedBox(height: XkLayout.spacingXs),
          Text(description, style: XkTypo.body.copyWith(color: bodyColor)),
        ],
      ),
    );
  }
}
