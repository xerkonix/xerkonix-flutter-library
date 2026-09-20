import 'package:flutter/material.dart';

import 'tactile_tokens.dart';
import 'tactile_type.dart';

/// TACTILE `.field` / `.input` — external label, 46h, 10r, input fill/border.
///
/// Material `InputDecorationTheme` (aqua / floating label / filled glass)
/// must not paint on [child]. Use [inputThemeOf] / [inputDecoration].
class XkTactileField extends StatelessWidget {
  const XkTactileField({
    super.key,
    required this.child,
    this.label,
  });

  final Widget child;
  final String? label;

  static InputDecorationTheme inputThemeOf(Brightness brightness) {
    final XkTactileTokens t = XkTactileTokens.of(brightness);
    return InputDecorationTheme(
      filled: false,
      fillColor: const Color(0x00000000),
      isDense: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      hintStyle: XkTactileType.field(color: t.muted),
      labelStyle: XkTactileType.field(color: t.muted),
      helperStyle: XkTactileType.label(color: t.muted),
      errorStyle: XkTactileType.label(color: t.accentDeep),
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      focusedErrorBorder: InputBorder.none,
    );
  }

  static InputDecoration inputDecoration({
    String? hintText,
    String? helperText,
    String? errorText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      helperText: helperText,
      errorText: errorText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: false,
      isDense: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      focusedErrorBorder: InputBorder.none,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    final XkTactileTokens t = XkTactileTokens.of(brightness);
    final Widget stripped = Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: inputThemeOf(brightness),
      ),
      child: child,
    );
    final Widget input = _TactileInputChrome(tokens: t, child: stripped);
    final String? name = label?.trim();
    if (name == null || name.isEmpty) {
      return input;
    }
    // Visible label stays outside the chrome. Merge it onto the child text
    // field so VoiceOver / semantics tree keep the accessible name when
    // InputDecoration.labelText / hintText are stripped (login email/password).
    return MergeSemantics(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(name, style: XkTactileType.label(color: t.ink)),
          const SizedBox(height: 8),
          Semantics(
            label: name,
            container: true,
            child: input,
          ),
        ],
      ),
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
