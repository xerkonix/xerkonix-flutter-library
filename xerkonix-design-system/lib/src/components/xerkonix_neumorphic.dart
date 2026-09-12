import 'package:flutter/material.dart';

import '../palette/color.dart';
import '../shape/xerkonix_shape.dart';
import 'xerkonix_glass.dart';

/// Surface treatment. v4 maps raised/flat → glass, inset → inset.
enum XkNeumorphicStyle { raised, inset, flat }

/// Compatibility wrapper. New code should use [XkGlass] / [XkInset].
class XkNeumorphic extends StatefulWidget {
  const XkNeumorphic({
    super.key,
    required this.child,
    this.style = XkNeumorphicStyle.raised,
    this.borderRadius,
    this.padding = const EdgeInsets.all(XkLayout.spacingMd),
    this.color,
    this.onTap,
    this.pressable = true,
    this.intensity = 1.0,
    this.width,
    this.height,
    this.semanticLabel,
  });

  final Widget child;
  final XkNeumorphicStyle style;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final VoidCallback? onTap;
  final bool pressable;
  final double intensity;
  final double? width;
  final double? height;
  final String? semanticLabel;

  static BoxDecoration decoration({
    required Brightness brightness,
    BorderRadius? borderRadius,
    Color? color,
    double intensity = 1.0,
  }) {
    return BoxDecoration(
      color: color ?? XkColor.glassOf(brightness),
      borderRadius: borderRadius ?? XkRadius.panelBorderRadius,
      border: Border.all(color: XkColor.glassEdge2Of(brightness)),
      boxShadow: XkShadow.glass(brightness),
    );
  }

  @override
  State<XkNeumorphic> createState() => _XkNeumorphicState();
}

class _XkNeumorphicState extends State<XkNeumorphic> {
  bool _pressed = false;

  bool get _interactive => widget.onTap != null;

  void _setPressed(bool value) {
    if (_pressed != value) {
      setState(() => _pressed = value);
    }
  }

  void _setFocused(bool value) {}

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius =
        widget.borderRadius ?? XkRadius.panelBorderRadius;
    final XkNeumorphicStyle style =
        (_pressed &&
            widget.pressable &&
            _interactive &&
            widget.style == XkNeumorphicStyle.raised)
        ? XkNeumorphicStyle.inset
        : widget.style;

    final Widget surface = style == XkNeumorphicStyle.inset
        ? XkInset(
            borderRadius: radius,
            padding: widget.padding,
            width: widget.width,
            height: widget.height,
            child: widget.child,
          )
        : XkGlass(
            borderRadius: radius,
            padding: widget.padding,
            width: widget.width,
            height: widget.height,
            child: widget.child,
          );

    if (!_interactive) {
      return surface;
    }

    return Semantics(
      button: true,
      label: widget.semanticLabel,
      child: FocusableActionDetector(
        mouseCursor: SystemMouseCursors.click,
        onShowFocusHighlight: _setFocused,
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (ActivateIntent intent) {
              widget.onTap?.call();
              return null;
            },
          ),
          ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
            onInvoke: (ButtonActivateIntent intent) {
              widget.onTap?.call();
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          onTapDown: (_) => _setPressed(true),
          onTapUp: (_) => _setPressed(false),
          onTapCancel: () => _setPressed(false),
          child: surface,
        ),
      ),
    );
  }
}
