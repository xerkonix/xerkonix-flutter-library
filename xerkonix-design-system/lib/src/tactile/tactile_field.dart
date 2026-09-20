import 'package:flutter/material.dart';

import 'tactile_tokens.dart';
import 'tactile_type.dart';

/// TACTILE `.field` / `.input` — 46h, 10r, input fill/border, accent focus.
class XkTactileField extends StatelessWidget {
  const XkTactileField({
    super.key,
    required this.child,
    this.label,
  });

  final Widget child;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final XkTactileTokens t = XkTactileTokens.of(Theme.of(context).brightness);
    final Widget input = _TactileInputChrome(tokens: t, child: child);
    if (label == null) {
      return input;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(label!, style: XkTactileType.label(color: t.ink)),
        const SizedBox(height: 8),
        input,
      ],
    );
  }
}

class _TactileInputChrome extends StatefulWidget {
  const _TactileInputChrome({required this.tokens, required this.child});

  final XkTactileTokens tokens;
  final Widget child;

  @override
  State<_TactileInputChrome> createState() => _TactileInputChromeState();
}

class _TactileInputChromeState extends State<_TactileInputChrome> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final XkTactileTokens t = widget.tokens;
    return Focus(
      canRequestFocus: false,
      skipTraversal: true,
      includeSemantics: false,
      onFocusChange: (bool focused) {
        if (focused != _focused) {
          setState(() => _focused = focused);
        }
      },
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: XkTactileTokens.controlHeight),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: t.inputFill,
            borderRadius: BorderRadius.circular(XkTactileTokens.fieldRadius),
            border: Border.all(color: _focused ? t.accent : t.inputBorder),
            boxShadow: _focused
                ? <BoxShadow>[
                    BoxShadow(
                      color: t.selectedBorder.withValues(alpha: 0.22),
                      spreadRadius: 3,
                    ),
                  ]
                : null,
          ),
          child: DefaultTextStyle.merge(
            style: XkTactileType.field(color: t.ink),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
