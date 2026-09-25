import 'package:flutter/material.dart';

import 'tactile_app_surface.dart';
import 'tactile_theme.dart';
import 'tactile_tokens.dart';
import 'tactile_type.dart';

/// TACTILE `.btn-secondary` / `.btn-quiet` / `.btn-text`.
///
/// Interaction matches `.btn`: hover `translateY(-2px)` except `.btn-text`,
/// `:active` `translateY(0)`, focus outline 3/4 (no layout growth),
/// disabled 40%. Values from `tactile/tokens.css` — not aqua glass-ctl.
///
/// Inside [XkTactileAppIntro] the faces read the ink-plane roles so they do
/// not sink into it: `text` paints `appIntroLink` (underlined, web
/// `.app-ink-link`), `quiet` paints `onAppIntro` on the plane with the
/// [XkTactileAppIntro.borderOf] edge (that same edge fills the hover), and
/// every kind — `secondary` and semantic faces included — uses
/// `appIntroFocusRing` for keyboard focus.
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
    final XkTactileAppSurface? ink = XkTactileAppIntro.maybeOf(context);
    final bool enabled = widget.onPressed != null;
    final bool hover = _hover && enabled;
    final bool pressed = _pressed && enabled;
    final bool lift =
        widget.kind != XkTactileButtonKind.text && hover && !pressed;
    final Color fill;
    final Color border;
    final List<BoxShadow> shadows;
    final Color label;
    bool underline = false;
    final Color? semantic = widget.semanticFill;
    if (semantic != null) {
      fill = hover ? Color.lerp(semantic, t.controlMark, 0.10)! : semantic;
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
          if (ink != null) {
            final Color edge = XkTactileAppIntro.borderOf(ink);
            fill = hover ? edge : XkTactileTokens.clear;
            border = edge;
            label = ink.onAppIntro;
          } else {
            fill = hover ? t.controlHover : XkTactileTokens.clear;
            border = t.line;
            label = t.ink;
          }
          shadows = const <BoxShadow>[];
        case XkTactileButtonKind.text:
          fill = XkTactileTokens.clear;
          border = XkTactileTokens.clear;
          shadows = const <BoxShadow>[];
          label = ink?.appIntroLink ?? t.ink;
          underline = ink != null;
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
            widget.kind == XkTactileButtonKind.text
                ? 5
                : XkTactileTokens.controlRadius,
          ),
          border: Border.all(color: border),
          boxShadow: shadows,
        ),
        child: Padding(
          padding: widget.kind == XkTactileButtonKind.text
              ? const EdgeInsets.symmetric(horizontal: 2, vertical: 11)
              : const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
          child: DefaultTextStyle.merge(
            style: underline
                ? XkTactileType.button(color: label).copyWith(
                    decoration: TextDecoration.underline,
                    decorationColor: label,
                  )
                : XkTactileType.button(color: label),
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
                key: const ValueKey<String>('xk-tactile-button-focus-ring'),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    XkTactileTokens.controlRadius + outset,
                  ),
                  border: Border.all(
                    color: ink?.appIntroFocusRing ?? t.focusRing,
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
            onTapCancel: enabled
                ? () => setState(() => _pressed = false)
                : null,
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
