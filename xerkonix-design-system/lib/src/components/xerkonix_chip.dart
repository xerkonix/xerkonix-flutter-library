import 'package:flutter/material.dart';

import '../palette/color.dart';
import '../shape/xerkonix_shape.dart';
import '../typography/xerkonix_typography.dart';

enum XkChipVariant { neutral, brand, support, accent, signal }

/// Weave chip component from the HTML design reference.
class XkChip extends StatelessWidget {
  const XkChip({
    super.key,
    required this.label,
    this.variant = XkChipVariant.neutral,
    this.onTap,
    this.showDot = true,
    this.leading,
    this.trailing,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
    final resolvedRadius = borderRadius ?? XkShape.fullBorderRadius;
    final inkBorderRadius = borderRadius is BorderRadius
        ? borderRadius as BorderRadius
        : XkShape.fullBorderRadius;

    final body = Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? colors.background,
        borderRadius: resolvedRadius,
        border: Border.all(color: borderColor ?? colors.border),
      ),
      padding: padding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: 6),
          ] else if (showDot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: dotColor ?? colors.dot,
              ),
            ),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: textStyle ??
                XkTypo.chipLabel.copyWith(color: textColor ?? colors.text),
          ),
          if (trailing != null) ...[const SizedBox(width: 6), trailing!],
        ],
      ),
    );

    if (onTap == null) {
      return body;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: inkBorderRadius,
        onTap: onTap,
        child: body,
      ),
    );
  }

  _ChipPalette _resolveColors(bool isDark) {
    switch (variant) {
      case XkChipVariant.neutral:
        return _ChipPalette(
          background: isDark ? XkColor.darkSurfaceSoft : XkColor.surface,
          border: isDark ? XkColor.darkBorderMid : XkColor.borderMid,
          text: isDark ? XkColor.darkTextBody : XkColor.textBody,
          dot: isDark ? XkColor.darkTextSoft : XkColor.textSoft,
        );
      case XkChipVariant.brand:
        return _ChipPalette(
          background: isDark ? XkColor.darkIdentityWash : XkColor.identityWash,
          border: (isDark ? XkColor.darkIdentity : XkColor.identity).withValues(
            alpha: 0.44,
          ),
          text: isDark ? XkColor.darkIdentityDeep : XkColor.identityDeep,
          dot: isDark ? XkColor.darkIdentity : XkColor.identity,
        );
      case XkChipVariant.support:
        return _ChipPalette(
          background: isDark ? XkColor.darkSupportWash : XkColor.supportWash,
          border: (isDark ? XkColor.darkSupport : XkColor.support).withValues(
            alpha: 0.44,
          ),
          text: isDark ? XkColor.darkSupportDeep : XkColor.supportDeep,
          dot: isDark ? XkColor.darkSupport : XkColor.support,
        );
      case XkChipVariant.accent:
        return _ChipPalette(
          background: isDark ? XkColor.darkAccentWash : XkColor.accentWash,
          border: (isDark ? XkColor.darkAccent : XkColor.accent).withValues(
            alpha: 0.44,
          ),
          text: isDark ? XkColor.darkAccentDeep : XkColor.accentDeep,
          dot: isDark ? XkColor.darkAccent : XkColor.accent,
        );
      case XkChipVariant.signal:
        return _ChipPalette(
          background: isDark ? XkColor.darkSignalWash : XkColor.signalWash,
          border: (isDark ? XkColor.darkSignal : XkColor.signal).withValues(
            alpha: 0.44,
          ),
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
