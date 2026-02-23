import 'package:flutter/material.dart';

import '../palette/color.dart';
import '../shape/xerkonix_shape.dart';
import '../typography/xerkonix_typography.dart';

enum XkChipVariant {
  neutral,
  brand,
  accent,
  signal,
}

/// Weave chip component from the HTML design reference.
///
/// - Defaults to company token values.
/// - Exposes radius/padding/color options for flexible reuse.
class XkChip extends StatelessWidget {
  const XkChip({
    super.key,
    required this.label,
    this.variant = XkChipVariant.neutral,
    this.onTap,
    this.showDot = true,
    this.leading,
    this.trailing,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    this.borderRadius,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.dotColor,
    this.textStyle,
  });

  final String label;
  final XkChipVariant variant;
  final VoidCallback? onTap;
  final bool showDot;
  final Widget? leading;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry? borderRadius;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final Color? dotColor;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = _resolveColors(isDark);

    final chip = Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? colors.background,
        borderRadius: borderRadius ?? XkShape.fullBorderRadius,
        border: Border.all(
          color: borderColor ?? colors.border,
        ),
      ),
      padding: padding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: XkLayout.spacingXs),
          ] else if (showDot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: dotColor ?? colors.dot,
              ),
            ),
            const SizedBox(width: XkLayout.spacingXs),
          ],
          Text(
            label,
            style: textStyle ??
                XkTypo.metaMono.copyWith(
                  fontSize: 11,
                  color: textColor ?? colors.text,
                ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: XkLayout.spacingXs),
            trailing!,
          ],
        ],
      ),
    );

    if (onTap == null) {
      return chip;
    }

    final inkBorderRadius = borderRadius is BorderRadius
        ? borderRadius as BorderRadius
        : XkShape.fullBorderRadius;

    return InkWell(
      borderRadius: inkBorderRadius,
      onTap: onTap,
      child: chip,
    );
  }

  _ChipPalette _resolveColors(bool isDark) {
    switch (variant) {
      case XkChipVariant.neutral:
        return _ChipPalette(
          background: isDark ? XkColor.darkSurfaceSoft : XkColor.surfaceSoft,
          border: isDark ? XkColor.darkBorderMid : XkColor.borderMid,
          text: isDark ? XkColor.darkTextBody : XkColor.textBody,
          dot: isDark ? XkColor.darkTextSoft : XkColor.textSoft,
        );
      case XkChipVariant.brand:
        return _ChipPalette(
          background: isDark ? XkColor.darkIdentityWash : XkColor.identityWash,
          border: isDark ? XkColor.darkIdentity : XkColor.identitySoft,
          text: isDark ? XkColor.darkIdentity : XkColor.identityDeep,
          dot: isDark ? XkColor.darkIdentity : XkColor.identity,
        );
      case XkChipVariant.accent:
        return _ChipPalette(
          background: isDark ? XkColor.darkActionWash : XkColor.actionWash,
          border: isDark ? XkColor.darkAction : XkColor.actionSoft,
          text: isDark ? XkColor.darkAction : XkColor.actionDeep,
          dot: isDark ? XkColor.darkAction : XkColor.action,
        );
      case XkChipVariant.signal:
        return _ChipPalette(
          background: isDark ? XkColor.darkSignalWash : XkColor.signalWash,
          border: isDark ? XkColor.darkSignal : XkColor.signal,
          text: isDark ? XkColor.darkSignal : XkColor.signal,
          dot: isDark ? XkColor.darkSignal : XkColor.signal,
        );
    }
  }
}

class _ChipPalette {
  const _ChipPalette({
    required this.background,
    required this.border,
    required this.text,
    required this.dot,
  });

  final Color background;
  final Color border;
  final Color text;
  final Color dot;
}
