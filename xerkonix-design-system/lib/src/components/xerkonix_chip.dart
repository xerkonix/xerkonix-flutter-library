import 'package:flutter/material.dart';

import '../palette/color.dart';
import '../shape/xerkonix_shape.dart';
import '../typography/xerkonix_typography.dart';
import 'xerkonix_glass.dart';

enum XkChipVariant { neutral, brand, support, accent, signal }

/// Tag-shaped chip: 6px, `--rule` outline, 11px `--ink-2`.
class XkChip extends StatelessWidget {
  const XkChip({
    super.key,
    required this.label,
    this.variant = XkChipVariant.neutral,
    this.onTap,
    this.showDot = true,
    this.leading,
    this.trailing,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
  final bool? selected;

  @override
  Widget build(BuildContext context) {
    if (selected != null) {
      return GestureDetector(
        onTap: onTap,
        child: XkSelected(
          selected: selected!,
          borderRadius: XkRadius.tagBorderRadius,
          padding: padding,
          child: Text(
            label,
            style: XkTypo.eyebrow.copyWith(
              color: textColor ??
                  XkColor.ink2Of(Theme.of(context).brightness),
            ),
          ),
        ),
      );
    }
    return XkTag(label: label, flag: variant == XkChipVariant.accent, onTap: onTap);
  }
}
