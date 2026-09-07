import 'package:flutter/material.dart';

import '../palette/color.dart';
import '../shape/xerkonix_shape.dart';
import '../typography/xerkonix_typography.dart';
import 'xerkonix_neumorphic.dart';

enum XkChipVariant { neutral, brand, support, accent, signal }

/// TACTILE chip component. Variant/static chips render as softly raised pills;
/// two-state selectable chips press *into* the canvas (inset) when selected.
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
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final colors = selected != null
        ? _selectableColors(isDark, selected!)
        : _resolveColors(isDark);
    final resolvedRadius = borderRadius ?? XkShape.fullBorderRadius;
    final inkBorderRadius = borderRadius is BorderRadius
        ? borderRadius as BorderRadius
        : XkShape.fullBorderRadius;
    final bool isInset = selected == true;

    final Widget row = Row(
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
          style:
              textStyle ??
              XkTypo.chipLabel.copyWith(color: textColor ?? colors.text),
        ),
        if (trailing != null) ...[const SizedBox(width: 6), trailing!],
      ],
    );

    final Widget padded = Padding(padding: padding, child: row);

    final body = DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor ?? colors.background,
        borderRadius: resolvedRadius,
        border: Border.all(color: borderColor ?? colors.border),
        boxShadow: isInset ? null : XkShadow.raisedSoft(brightness),
      ),
      child: isInset
          ? CustomPaint(
              foregroundPainter: XkInsetShadowPainter(
                borderRadius: inkBorderRadius,
                lowlight: isDark
                    ? XkShadow.darkLowlight
                    : XkColor.ink.withValues(alpha: 0.20),
                highlight: isDark
                    ? XkColor.darkInk.withValues(alpha: 0.05)
                    : Colors.white.withValues(alpha: 0.5),
                distance: 2.5,
                blur: 5,
              ),
              child: padded,
            )
          : padded,
    );

    if (onTap == null) {
      return body;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(borderRadius: inkBorderRadius, onTap: onTap, child: body),
    );
  }

  _ChipPalette _selectableColors(bool isDark, bool isSelected) {
    final Color accent = isDark ? XkColor.darkTintFill : XkColor.tintFill;
    final Color accentText = isDark
        ? XkColor.darkTintLight
        : XkColor.tintTextHover;
    if (isSelected) {
      return _ChipPalette(
        background: accent.withValues(alpha: 0.14),
        border: accent,
        text: accentText,
        dot: accent,
      );
    }
    return _ChipPalette(
      background: isDark ? XkColor.darkHairSoft : XkColor.hairSoft,
      border: isDark ? XkColor.darkHair : XkColor.hair,
      text: isDark ? XkColor.darkInk : XkColor.ink,
      dot: isDark ? XkColor.darkMuted : XkColor.muted,
    );
  }

  _ChipPalette _resolveColors(bool isDark) {
    switch (variant) {
      case XkChipVariant.neutral:
        return _ChipPalette(
          background: isDark ? XkColor.darkHairSoft : XkColor.panel,
          border: isDark ? XkColor.darkHair : XkColor.hair,
          text: isDark ? XkColor.darkInk : XkColor.ink,
          dot: isDark ? XkColor.darkMuted : XkColor.muted,
        );
      case XkChipVariant.brand:
        return _ChipPalette(
          background: isDark ? XkColor.darkTintSoft : XkColor.tintSoft,
          border: (isDark ? XkColor.darkTintFill : XkColor.tintFill).withValues(
            alpha: 0.44,
          ),
          text: isDark ? XkColor.darkTintLight : XkColor.tintTextHover,
          dot: isDark ? XkColor.darkTintFill : XkColor.tintFill,
        );
      case XkChipVariant.support:
        return _ChipPalette(
          background: isDark ? XkColor.darkOk : XkColor.ok,
          border: (isDark ? XkColor.darkOk : XkColor.ok).withValues(
            alpha: 0.44,
          ),
          text: isDark ? XkColor.darkOk : XkColor.ok,
          dot: isDark ? XkColor.darkOk : XkColor.ok,
        );
      case XkChipVariant.accent:
        return _ChipPalette(
          background: isDark ? XkColor.darkTintSoft : XkColor.tintSoft,
          border: (isDark ? XkColor.darkTintFill : XkColor.tintFill).withValues(
            alpha: 0.44,
          ),
          text: isDark ? XkColor.darkTintLight : XkColor.tintTextHover,
          dot: isDark ? XkColor.darkTintFill : XkColor.tintFill,
        );
      case XkChipVariant.signal:
        return _ChipPalette(
          background: isDark ? XkColor.darkBad : XkColor.bad,
          border: (isDark ? XkColor.darkBad : XkColor.bad).withValues(
            alpha: 0.44,
          ),
          text: isDark ? XkColor.darkBad : XkColor.bad,
          dot: isDark ? XkColor.darkBad : XkColor.bad,
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
