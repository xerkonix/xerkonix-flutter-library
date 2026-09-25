import 'package:flutter/material.dart';

import 'tactile_app_surface.dart';
import 'tactile_theme.dart';
import 'tactile_tokens.dart';
import 'tactile_type.dart';

/// TACTILE `.btn.btn-primary` role + states.
///
/// Light/dark values come from `tactile/tokens.css` `--primary-*`.
/// Hover `translateY(-2px)`, `:active` `translateY(0)` (hover chrome stays),
/// focus-visible outline 3 / offset 4 (no layout growth), disabled 40%,
/// flat monochrome fill. `min-height` 46, not a fixed
/// height — text scale / wrap can grow. Not CosentioRaise.sm.
///
/// Inside [XkTactileAppIntro] the face inverts to the ink-plane roles
/// (`appIntroPrimaryFill` / `appIntroPrimaryText` / `appIntroPrimaryHover`,
/// focus `appIntroFocusRing`) — web `.app-intro .btn-primary`.
class XkTactilePrimaryButton extends StatefulWidget {
  const XkTactilePrimaryButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.expanded = false,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final bool expanded;

  @override
  State<XkTactilePrimaryButton> createState() => _XkTactilePrimaryButtonState();
}

class _XkTactilePrimaryButtonState extends State<XkTactilePrimaryButton> {
  bool _hover = false;
  bool _focus = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final XkTactileTokens t = XkTactileTokens.of(Theme.of(context).brightness);
    final XkTactileAppSurface? ink = XkTactileAppIntro.maybeOf(context);
    final bool enabled = widget.onPressed != null;
    final bool hover = _hover && enabled;
    final bool pressed = _pressed && enabled;
    final bool lifted = hover && !pressed;
    final Color base = ink?.appIntroPrimaryFill ?? t.primaryBase;
    final Color hoverFill = ink?.appIntroPrimaryHover ?? t.primaryHoverTop;
    final Color label = ink?.appIntroPrimaryText ?? t.primaryText;
    final Color ring = ink?.appIntroFocusRing ?? t.focusRing;
    final Color fill = hover ? hoverFill : base;

    Widget face = ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: XkTactileTokens.controlHeight,
      ),
      child: DecoratedBox(
        key: const ValueKey<String>('xk-tactile-primary-fill'),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(XkTactileTokens.controlRadius),
          border: Border.all(color: fill),
          color: fill,
          boxShadow: const <BoxShadow>[],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
          child: DefaultTextStyle.merge(
            style: XkTactileType.button(color: label),
            child: IconTheme(
              data: IconThemeData(color: label, size: 16),
              child: Center(
                widthFactor: widget.expanded ? null : 1,
                heightFactor: 1,
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );

    if (widget.expanded) {
      face = SizedBox(width: double.infinity, child: face);
    }

    // CSS outline: 3px / offset 4px. Paints outside; does not grow layout.
    if (_focus && enabled) {
      const double outset =
          XkTactileTokens.focusOutlineOffset +
          XkTactileTokens.focusOutlineWidth;
      face = Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          face,
          Positioned(
            left: -outset,
            top: -outset,
            right: -outset,
            bottom: -outset,
            child: IgnorePointer(
              child: DecoratedBox(
                key: const ValueKey<String>('xk-tactile-primary-focus-ring'),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    XkTactileTokens.controlRadius + outset,
                  ),
                  border: Border.all(
                    color: ring,
                    width: XkTactileTokens.focusOutlineWidth,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    Widget button = Semantics(
      button: true,
      enabled: enabled,
      child: MouseRegion(
        onEnter: enabled ? (_) => setState(() => _hover = true) : null,
        onExit: enabled
            ? (_) => setState(() {
                _hover = false;
                _pressed = false;
              })
            : null,
        cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: FocusableActionDetector(
          enabled: enabled,
          onFocusChange: (bool has) => setState(() => _focus = has),
          actions: <Type, Action<Intent>>{
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (ActivateIntent intent) {
                widget.onPressed?.call();
                return null;
              },
            ),
            ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
              onInvoke: (ButtonActivateIntent intent) {
                widget.onPressed?.call();
                return null;
              },
            ),
          },
          child: GestureDetector(
            onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
            onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
            onTapCancel: enabled
                ? () => setState(() => _pressed = false)
                : null,
            onTap: widget.onPressed,
            child: AnimatedSlide(
              key: ValueKey<String>(
                pressed
                    ? 'xk-tactile-primary-lift-active'
                    : lifted
                    ? 'xk-tactile-primary-lift-hover'
                    : 'xk-tactile-primary-lift-rest',
              ),
              duration: XkTactileTokens.motion,
              curve: XkTactileTokens.ease,
              offset: lifted
                  ? const Offset(0, -2 / XkTactileTokens.controlHeight)
                  : Offset.zero,
              child: Opacity(
                key: const ValueKey<String>('xk-tactile-primary-opacity'),
                opacity: enabled ? 1 : XkTactileTokens.disabledOpacity,
                child: face,
              ),
            ),
          ),
        ),
      ),
    );

    if (widget.expanded) {
      button = SizedBox(width: double.infinity, child: button);
    }
    return Align(
      alignment: Alignment.center,
      heightFactor: 1,
      widthFactor: widget.expanded ? null : 1,
      child: button,
    );
  }
}
