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
      return _XkChoice(
        label: label,
        selected: selected!,
        onTap: onTap,
        padding: padding,
        textColor: textColor,
      );
    }
    return XkTag(label: label, flag: variant == XkChipVariant.accent, onTap: onTap);
  }
}

/// Choice (DS `.choice span`): edge `--secondary-border`, chosen edge
/// `--control-on` on the neutral selected face (DS #119, 3:1). Focusable
/// button with a selected state; keyboard focus keeps the edge and draws a
/// separate 2px `--focus-ring` ring 3px outside it.
class _XkChoice extends StatefulWidget {
  const _XkChoice({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.padding,
    required this.textColor,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final Color? textColor;

  @override
  State<_XkChoice> createState() => _XkChoiceState();
}

class _XkChoiceState extends State<_XkChoice> {
  bool _focus = false;

  void _activate() => widget.onTap?.call();

  @override
  Widget build(BuildContext context) {
    final Brightness b = Theme.of(context).brightness;
    final XkTactileTokens t = XkTactileTokens.of(b);
    final bool on = widget.selected;
    final bool enabled = widget.onTap != null;
    final Widget face = DecoratedBox(
      key: const ValueKey<String>('xk-chip-choice'),
      decoration: BoxDecoration(
        color: on ? t.selectedFill : null,
        borderRadius: XkRadius.tagBorderRadius,
        border: XkTactileEdge(color: on ? t.controlOn : t.secondaryBorder),
      ),
      child: Padding(
        padding: widget.padding,
        child: Text(
          widget.label,
          style: XkTypo.eyebrow.copyWith(
            color: widget.textColor ?? XkColor.ink2Of(b),
          ),
        ),
      ),
    );
    return Semantics(
      button: true,
      selected: on,
      enabled: enabled,
      child: FocusableActionDetector(
        enabled: enabled,
        mouseCursor: enabled ? SystemMouseCursors.click : MouseCursor.defer,
        onFocusChange: (bool has) => setState(() => _focus = has),
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (ActivateIntent intent) {
              _activate();
              return null;
            },
          ),
          ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
            onInvoke: (ButtonActivateIntent intent) {
              _activate();
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: XkTactileFocusRing(
            show: _focus && enabled,
            color: t.focusRing,
            borderRadius: XkRadius.tagBorderRadius,
            offset: XkTactileTokens.controlFocusRingOffset,
            ringKey: const ValueKey<String>('xk-chip-choice-focus-ring'),
            child: face,
          ),
        ),
      ),
    );
  }
}
