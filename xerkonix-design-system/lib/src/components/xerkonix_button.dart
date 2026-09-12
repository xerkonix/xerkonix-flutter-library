import 'package:flutter/material.dart';

import '../motion/xerkonix_motion.dart';
import '../palette/color.dart';
import '../shape/xerkonix_shape.dart';
import '../typography/xerkonix_typography.dart';
import 'xerkonix_glass.dart';

/// TACTILE v4 buttons: gem (primary) or glass-ctl (secondary).
class XkButton extends StatelessWidget {
  const XkButton._({
    super.key,
    required this.onPressed,
    required this.buttonType,
    this.semanticColor,
    this.expanded = false,
    this.gradient = false,
    required this.child,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final ButtonType buttonType;
  final Color? semanticColor;
  final bool expanded;
  final bool gradient;

  factory XkButton.primary({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    bool expanded = false,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.primary,
      expanded: expanded,
      child: child,
    );
  }

  factory XkButton.primaryGradient({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    bool expanded = true,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.action,
      gradient: true,
      expanded: expanded,
      child: child,
    );
  }

  factory XkButton.action({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    bool expanded = false,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.action,
      expanded: expanded,
      child: child,
    );
  }

  factory XkButton.cta({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    bool expanded = false,
  }) {
    return XkButton.action(
      key: key,
      onPressed: onPressed,
      expanded: expanded,
      child: child,
    );
  }

  factory XkButton.brand({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    bool expanded = false,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.brand,
      expanded: expanded,
      child: child,
    );
  }

  factory XkButton.support({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    bool expanded = false,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.support,
      expanded: expanded,
      child: child,
    );
  }

  factory XkButton.accent({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    bool expanded = false,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.accent,
      expanded: expanded,
      child: child,
    );
  }

  factory XkButton.point({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    bool expanded = false,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.point,
      expanded: expanded,
      child: child,
    );
  }

  factory XkButton.pointOutline({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    bool expanded = false,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.pointOutline,
      expanded: expanded,
      child: child,
    );
  }

  factory XkButton.pointText({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    bool expanded = false,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.pointText,
      expanded: expanded,
      child: child,
    );
  }

  factory XkButton.pointElevated({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    bool expanded = false,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.pointElevated,
      expanded: expanded,
      child: child,
    );
  }

  factory XkButton.tonal({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    bool expanded = false,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.tonal,
      expanded: expanded,
      child: child,
    );
  }

  factory XkButton.outline({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    bool expanded = false,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.outline,
      expanded: expanded,
      child: child,
    );
  }

  factory XkButton.outlined({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    bool expanded = false,
  }) {
    return XkButton.outline(
      key: key,
      onPressed: onPressed,
      expanded: expanded,
      child: child,
    );
  }

  factory XkButton.success({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    bool expanded = false,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.semantic,
      semanticColor: XkColor.ok,
      expanded: expanded,
      child: child,
    );
  }

  factory XkButton.warning({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    bool expanded = false,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.semantic,
      semanticColor: XkColor.warn,
      expanded: expanded,
      child: child,
    );
  }

  factory XkButton.error({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    bool expanded = false,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.semantic,
      semanticColor: XkColor.bad,
      expanded: expanded,
      child: child,
    );
  }

  factory XkButton.info({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    bool expanded = false,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.semantic,
      semanticColor: XkColor.ink2,
      expanded: expanded,
      child: child,
    );
  }

  bool get _isGem {
    switch (buttonType) {
      case ButtonType.primary:
      case ButtonType.action:
      case ButtonType.accent:
      case ButtonType.point:
        return true;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget button = _isGem
        ? _GemButton(onPressed: onPressed, child: child)
        : _GlassCtlButton(
            onPressed: onPressed,
            ink: semanticColor,
            child: child,
          );
    if (expanded) {
      button = SizedBox(width: double.infinity, child: button);
    }
    return button;
  }
}

class _GemButton extends StatefulWidget {
  const _GemButton({required this.onPressed, required this.child});

  final VoidCallback? onPressed;
  final Widget child;

  @override
  State<_GemButton> createState() => _GemButtonState();
}

class _GemButtonState extends State<_GemButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final Brightness b = Theme.of(context).brightness;
    final bool enabled = widget.onPressed != null;
    final Color hi = XkColor.aquaHiOf(b);
    final Color mid = XkColor.aquaOf(b);
    final Color lo = XkColor.aquaMidOf(b);
    final Color border = Color.lerp(hi, XkColor.mixWhite, 0.35)!;
    return MouseRegion(
      onEnter: enabled ? (_) => setState(() => _hover = true) : null,
      onExit: enabled ? (_) => setState(() => _hover = false) : null,
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: AnimatedTranslate(
        offset: _hover && enabled ? const Offset(0, -1) : Offset.zero,
        child: FocusableActionDetector(
          enabled: enabled,
          onShowFocusHighlight: (_) {},
          actions: <Type, Action<Intent>>{
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (ActivateIntent intent) {
                widget.onPressed?.call();
                return null;
              },
            ),
          },
          child: GestureDetector(
            onTap: widget.onPressed,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: XkLayout.controlHeight),
              child: ClipRRect(
                borderRadius: XkRadius.ctlBorderRadius,
                child: Stack(
                  children: <Widget>[
                    DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: XkRadius.ctlBorderRadius,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[hi, mid, lo],
                          stops: const <double>[0, 0.55, 1],
                        ),
                        border: Border.all(color: border),
                        boxShadow: XkShadow.gem(b),
                      ),
                      child: CustomPaint(
                        foregroundPainter: XkInsetShadowPainter(
                          borderRadius: XkRadius.ctlBorderRadius,
                          lowlight: XkColor.mixWhite.withValues(alpha: 0.80),
                          highlight: XkColor.mixWhite.withValues(alpha: 0),
                          distance: 1,
                          blur: 0.4,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          child: DefaultTextStyle(
                            style: XkTypo.buttonLabel.copyWith(
                              color: XkColor.aquaInkOf(b),
                              fontWeight: FontWeight.w600,
                            ),
                            child: IconTheme(
                              data: IconThemeData(
                                color: XkColor.aquaInkOf(b),
                                size: 18,
                              ),
                              child: Center(child: widget.child),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: XkGemSweep(enabled: enabled),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassCtlButton extends StatefulWidget {
  const _GlassCtlButton({
    required this.onPressed,
    required this.child,
    this.ink,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final Color? ink;

  @override
  State<_GlassCtlButton> createState() => _GlassCtlButtonState();
}

class _GlassCtlButtonState extends State<_GlassCtlButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final Brightness b = Theme.of(context).brightness;
    final bool enabled = widget.onPressed != null;
    final Color fg = XkColor.themed(
      widget.ink ?? XkColor.inkOf(b),
      b,
    );
    return MouseRegion(
      onEnter: enabled ? (_) => setState(() => _hover = true) : null,
      onExit: enabled ? (_) => setState(() => _hover = false) : null,
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: AnimatedTranslate(
        offset: _hover && enabled ? const Offset(0, -1) : Offset.zero,
        child: GestureDetector(
          onTap: widget.onPressed,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: XkLayout.controlHeight),
            child: XkGlass(
              ctl: true,
              borderRadius: XkRadius.ctlBorderRadius,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: DefaultTextStyle(
                style: XkTypo.buttonLabel.copyWith(
                  color: enabled ? fg : XkColor.ink3Of(b),
                  fontWeight: FontWeight.w600,
                ),
                child: Center(child: widget.child),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedTranslate extends StatelessWidget {
  const AnimatedTranslate({
    super.key,
    required this.offset,
    required this.child,
  });

  final Offset offset;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: XkMotion.hover,
      curve: XkMotionToken.easeOut,
      transform: Matrix4.translationValues(offset.dx, offset.dy, 0),
      child: child,
    );
  }
}

enum ButtonType {
  primary,
  action,
  brand,
  support,
  accent,
  tonal,
  outline,
  semantic,
  point,
  pointOutline,
  pointText,
  pointElevated,
}
