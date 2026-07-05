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
    this.selected,
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

  /// When non-null, the chip becomes a two-state selectable/filter chip
  /// (covers the product `CosentioChip`): selected chips use an accent tint,
  /// unselected chips use a neutral surface. Leave null (default) for the
  /// original static/variant behavior.
  final bool? selected;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors =
        selected != null ? _selectableColors(isDark, selected!) : _resolveColors(isDark);
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
          ] else if (showDot && selected == null) ...[
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

  _ChipPalette _selectableColors(bool isDark, bool isSelected) {
    final Color accent = isDark ? XkColor.darkAccent : XkColor.accent;
    final Color accentText = isDark ? XkColor.darkAccentDeep : XkColor.accentDeep;
    if (isSelected) {
      return _ChipPalette(
        background: accent.withValues(alpha: 0.14),
        border: accent,
        text: accentText,
        dot: accent,
      );
    }
    return _ChipPalette(
      background: isDark ? XkColor.darkSurface2 : XkColor.surface2,
      border: isDark ? XkColor.darkBorder : XkColor.border,
      text: isDark ? XkColor.darkTextBody : XkColor.textBody,
      dot: isDark ? XkColor.darkTextMuted : XkColor.textMuted,
    );
  }

  _ChipPalette _resolveColors(bool isDark) {
    switch (variant) {
      case XkChipVariant.neutral:
        return _ChipPalette(
          background: isDark ? XkColor.darkSurface2 : XkColor.surface,
          border: isDark ? XkColor.darkBorder : XkColor.border,
          text: isDark ? XkColor.darkTextBody : XkColor.textBody,
          dot: isDark ? XkColor.darkTextMuted : XkColor.textMuted,
        );
      case XkChipVariant.brand:
        return _ChipPalette(
          background: isDark ? XkColor.darkAccentSoft : XkColor.accentSoft,
          border: (isDark ? XkColor.darkAccent : XkColor.accent).withValues(
            alpha: 0.44,
          ),
          text: isDark ? XkColor.darkAccentDeep : XkColor.accentDeep,
          dot: isDark ? XkColor.darkAccent : XkColor.accent,
        );
      case XkChipVariant.support:
        return _ChipPalette(
          background: isDark ? XkColor.darkSuccessSoft : XkColor.successSoft,
          border: (isDark ? XkColor.darkSuccess : XkColor.success).withValues(
            alpha: 0.44,
          ),
          text: isDark ? XkColor.darkSuccess : XkColor.success,
          dot: isDark ? XkColor.darkSuccess : XkColor.success,
        );
      case XkChipVariant.accent:
        return _ChipPalette(
          background: isDark ? XkColor.darkAccentSoft : XkColor.accentSoft,
          border: (isDark ? XkColor.darkAccent : XkColor.accent).withValues(
            alpha: 0.44,
          ),
          text: isDark ? XkColor.darkAccentDeep : XkColor.accentDeep,
          dot: isDark ? XkColor.darkAccent : XkColor.accent,
        );
      case XkChipVariant.signal:
        return _ChipPalette(
          background: isDark ? XkColor.darkErrorSoft : XkColor.errorSoft,
          border: (isDark ? XkColor.darkError : XkColor.error).withValues(
            alpha: 0.44,
          ),
          text: isDark ? XkColor.darkError : XkColor.error,
          dot: isDark ? XkColor.darkError : XkColor.error,
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
