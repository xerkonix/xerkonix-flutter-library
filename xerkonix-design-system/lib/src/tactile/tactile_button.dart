import 'package:flutter/material.dart';

import 'tactile_tokens.dart';
import 'tactile_type.dart';

/// TACTILE `.btn-secondary` / `.btn-quiet` / `.btn-text`.
///
/// Interaction matches `.btn`: hover `translateY(-2px)` except `.btn-text`,
/// `:active` `translateY(0)`, focus outline 3/4 (no layout growth),
/// disabled 40%. Values from `tactile/tokens.css` — not aqua glass-ctl.
enum XkTactileButtonKind { secondary, quiet, text }

class XkTactileButton extends StatefulWidget {
  const XkTactileButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.kind = XkTactileButtonKind.secondary,
    this.expanded = false,
    this.semanticFill,
    this.semanticRole,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final XkTactileButtonKind kind;
  final bool expanded;

  /// Allowed brand state / danger fill (`ok` / `warn` / `bad` / info ink).
  /// When set, chrome (height, radius, hover lift, focus) stays tactile
  /// but the face is not secondary.
  final Color? semanticFill;

  /// `success` / `warning` / `error` / `info` — explicit state marker.
  final String? semanticRole;

  @override
  State<XkTactileButton> createState() => _XkTactileButtonState();
}

class _XkTactileButtonState extends State<XkTactileButton> {
  bool _hover = false;
  bool _focus = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final XkTactileTokens t = XkTactileTokens.of(Theme.of(context).brightness);
    final bool enabled = widget.onPressed != null;
    final bool hover = _hover && enabled;
    final bool pressed = _pressed && enabled;
    final bool lift = widget.kind != XkTactileButtonKind.text && hover && !pressed;
    final Color fill;
    final Color border;
    final List<BoxShadow> shadows;
    final Color label;
    final Color? semantic = widget.semanticFill;
    if (semantic != null) {
      fill = hover
          ? Color.lerp(semantic, t.controlMark, 0.10)!
          : semantic;
      border = semantic;
      shadows = enabled ? t.secondaryShadow : const <BoxShadow>[];
      label = semantic.computeLuminance() > 0.45 ? t.ink : t.surfaceRaised;
    } else {
      switch (widget.kind) {
        case XkTactileButtonKind.secondary:
          fill = hover ? t.secondaryHover : t.secondaryFill;
          border = t.secondaryBorder;
          shadows = enabled ? t.secondaryShadow : const <BoxShadow>[];
          label = t.ink;
        case XkTactileButtonKind.quiet:
          fill = hover ? t.controlHover : XkTactileTokens.clear;
          border = t.line;
          shadows = const <BoxShadow>[];
          label = t.ink;
        case XkTactileButtonKind.text:
          fill = XkTactileTokens.clear;
          border = XkTactileTokens.clear;
          shadows = const <BoxShadow>[];
          label = hover ? t.accent : t.ink;
      }
    }

    Widget face = ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: XkTactileTokens.controlHeight,
      ),
      child: DecoratedBox(
        key: ValueKey<String>(
          widget.semanticRole != null
              ? 'xk-tactile-semantic-${widget.semanticRole}-fill'
              : 'xk-tactile-${widget.kind.name}-fill',
        ),
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(
            widget.kind == XkTactileButtonKind.text ? 5 : XkTactileTokens.controlRadius,
          ),
          border: Border.all(color: border),
          boxShadow: shadows,
        ),
        child: Padding(
          padding: widget.kind == XkTactileButtonKind.text
              ? const EdgeInsets.symmetric(horizontal: 2, vertical: 11)
              : const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
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

    if (_focus && enabled) {
      const double outset = XkTactileTokens.focusOutlineOffset +
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
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    XkTactileTokens.controlRadius + outset,
                  ),
                  border: Border.all(
                    color: t.focusRing,
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
      identifier: widget.semanticRole == null
          ? null
          : 'xk-button-${widget.semanticRole}',
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
            onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
            onTap: widget.onPressed,
            child: AnimatedSlide(
              duration: XkTactileTokens.motion,
              curve: XkTactileTokens.ease,
              offset: lift
                  ? const Offset(0, -2 / XkTactileTokens.controlHeight)
                  : Offset.zero,
              child: Opacity(
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
