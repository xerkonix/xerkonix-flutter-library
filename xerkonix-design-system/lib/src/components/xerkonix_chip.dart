import 'package:flutter/material.dart';

import '../palette/color.dart';
import '../shape/xerkonix_shape.dart';
import '../tactile/tactile_surface.dart';
import '../tactile/tactile_tokens.dart';
import '../typography/xerkonix_typography.dart';
import 'xerkonix_glass.dart';

enum XkChipVariant { neutral, brand, support, accent, signal }

/// Tag-shaped chip: 6px, 11px `--ink-2`. Tappable: `--secondary-border`
/// edge; [selected] chosen: `--control-on` edge (DS #119, 3:1).
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
      // Choice (DS `.choice span`): edge `--secondary-border`, chosen edge
      // `--control-on` on the neutral selected face (DS #119, 3:1).
      final XkTactileTokens t = XkTactileTokens.of(
        Theme.of(context).brightness,
      );
      final bool on = selected!;
      return GestureDetector(
        onTap: onTap,
        child: DecoratedBox(
          key: const ValueKey<String>('xk-chip-choice'),
          decoration: BoxDecoration(
            color: on ? t.selectedFill : null,
            borderRadius: XkRadius.tagBorderRadius,
            border: XkTactileEdge(color: on ? t.controlOn : t.secondaryBorder),
          ),
          child: Padding(
            padding: padding,
            child: Text(
              label,
              style: XkTypo.eyebrow.copyWith(
                color:
                    textColor ?? XkColor.ink2Of(Theme.of(context).brightness),
              ),
            ),
          ),
        ),
      );
    }
    return XkTag(label: label, flag: variant == XkChipVariant.accent, onTap: onTap);
  }
}
