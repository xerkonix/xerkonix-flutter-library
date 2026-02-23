import 'package:flutter/material.dart';

import '../palette/color.dart';
import '../shape/xerkonix_shape.dart';
import '../typography/xerkonix_typography.dart';

/// Weave card style used for Metric/Status/Summary blocks.
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg =
        backgroundColor ?? (isDark ? XkColor.darkSurface : XkColor.surface);
    final cardBorder =
        borderColor ?? (isDark ? XkColor.darkBorderSoft : XkColor.borderSoft);
    final metricColor = isDark ? XkColor.darkTextSoft : XkColor.textSoft;
    final titleColor = isDark ? XkColor.darkText : XkColor.text;
    final bodyColor = isDark ? XkColor.darkTextBody : XkColor.textBody;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: borderRadius ?? XkShape.mdBorderRadius,
        border: Border.all(color: cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (leading != null || trailing != null) ...[
            Row(
              children: [
                if (leading != null) leading!,
                const Spacer(),
                if (trailing != null) trailing!,
              ],
            ),
            const SizedBox(height: XkLayout.spacingXs),
          ],
          Text(
            metric,
            style: XkTypo.metaMono.copyWith(
              fontSize: 11,
              color: metricColor,
            ),
          ),
          const SizedBox(height: XkLayout.spacingXs),
          Text(
            title,
            style: XkTypo.h3.copyWith(
              fontSize: 18,
              color: titleColor,
            ),
          ),
          const SizedBox(height: XkLayout.spacingXs),
          Text(
            description,
            style: XkTypo.body.copyWith(color: bodyColor),
          ),
        ],
      ),
    );
  }
}
