import 'package:flutter/material.dart';

import 'tactile_tokens.dart';

/// Public-page company chrome. One approved wordmark, home is XERKONIX.
///
/// Consumes DS `assets/brand/wordmark-ink.png` / `wordmark-paper.png`
/// (no new art). Product names stay on the product surface.
///
/// Focus role matches tactile buttons: `FocusableActionDetector` +
/// focus-visible outline 3 / offset 4 (no layout growth). Not a Material
/// `TextButton` overlay — that does not paint a visible ring on the PNG.
class XkCompanyWordmark extends StatefulWidget {
  const XkCompanyWordmark({
    super.key,
    required this.onOpenHome,
    this.height = 14,
  });

  static const String homeUrl = 'https://xerkonix.com/';
  static const String assetInk = 'assets/brand/wordmark-ink.png';
  static const String assetPaper = 'assets/brand/wordmark-paper.png';

  /// Gap so a fixed footer hairline does not sit on the last scroll line.
  static const double foldClearance = 12;

  static const String semanticsLabel = 'XERKONIX 홈';

  static const ValueKey<String> focusRingKey = ValueKey<String>(
    'xk-company-wordmark-focus-ring',
  );

  final VoidCallback onOpenHome;
  final double height;

  @override
  State<XkCompanyWordmark> createState() => _XkCompanyWordmarkState();
}

class _XkCompanyWordmarkState extends State<XkCompanyWordmark> {
  bool _focus = false;

  Widget _mark(bool dark) {
    return Image.asset(
      dark ? XkCompanyWordmark.assetPaper : XkCompanyWordmark.assetInk,
      height: widget.height,
      filterQuality: FilterQuality.medium,
      errorBuilder: (BuildContext context, Object error, StackTrace? st) {
        return Image.asset(
          dark ? XkCompanyWordmark.assetPaper : XkCompanyWordmark.assetInk,
          package: 'xerkonix_design_system',
          height: widget.height,
          filterQuality: FilterQuality.medium,
          errorBuilder: (BuildContext context, Object error, StackTrace? st) {
            return Text(
              'XERKONIX',
              style: TextStyle(
                fontSize: widget.height,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.35,
                height: 1,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final XkTactileTokens t = XkTactileTokens.of(Theme.of(context).brightness);
    Widget face = _mark(dark);
    if (_focus) {
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
                key: XkCompanyWordmark.focusRingKey,
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
    return Semantics(
      button: true,
      label: XkCompanyWordmark.semanticsLabel,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: FocusableActionDetector(
          onFocusChange: (bool has) => setState(() => _focus = has),
          actions: <Type, Action<Intent>>{
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (ActivateIntent intent) {
                widget.onOpenHome();
                return null;
              },
            ),
            ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
              onInvoke: (ButtonActivateIntent intent) {
                widget.onOpenHome();
                return null;
              },
            ),
          },
          child: GestureDetector(
            onTap: widget.onOpenHome,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 88,
                  minHeight: widget.height + 8,
                ),
                child: face,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
