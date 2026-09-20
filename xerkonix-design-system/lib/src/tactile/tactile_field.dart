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
    this.enabled = true,
    this.error = false,
    this.borderRadius,
  });

  final Widget child;
  final String? label;
  final bool enabled;
  final bool error;

  /// Override for the input chrome. Null uses [XkTactileTokens.fieldRadius].
  final BorderRadius? borderRadius;

  static InputDecorationTheme inputThemeOf(Brightness brightness) {
    final XkTactileTokens t = XkTactileTokens.of(brightness);
    return InputDecorationTheme(
      filled: false,
      fillColor: XkTactileTokens.clear,
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
    final Widget input = _TactileInputChrome(
      tokens: t,
      enabled: enabled,
      error: error,
      borderRadius: borderRadius,
      child: stripped,
    );
    final String? name = label?.trim();
    if (name == null || name.isEmpty) {
      return input;
    }
    // Measured 2026-09-20 (field-semantics-dump.json): MergeSemantics +
    // visible Text + Semantics(label, container:true) made
    // getSemantics(TextField) a 74px parent with the name but
    // isTextField=false / isObscured=false. The editable child kept the
    // flags and a second copy of the name (labelHits=2).
    // Visual Text is excluded; the name is attached on the input so the
    // text-field node itself has the exact label and flags.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ExcludeSemantics(
          child: Text(name, style: XkTactileType.label(color: t.ink)),
        ),
        const SizedBox(height: 8),
        Semantics(
          label: name,
          child: input,
        ),
      ],
    );
  }
}

class _TactileInputChrome extends StatefulWidget {
  const _TactileInputChrome({
    required this.tokens,
    required this.child,
    required this.enabled,
    required this.error,
    this.borderRadius,
  });

  final XkTactileTokens tokens;
  final Widget child;
  final bool enabled;
  final bool error;
  final BorderRadius? borderRadius;

  @override
  State<_TactileInputChrome> createState() => _TactileInputChromeState();
}

class _TactileInputChromeState extends State<_TactileInputChrome> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final XkTactileTokens t = widget.tokens;
    final bool focused = _focused && widget.enabled;
    final Color border = !widget.enabled
        ? t.inputBorder
        : widget.error
            ? t.accentDeep
            : focused
                ? t.accent
                : t.inputBorder;
    return Focus(
      canRequestFocus: false,
      skipTraversal: true,
      includeSemantics: false,
      onFocusChange: (bool next) {
        if (next != _focused) {
          setState(() => _focused = next);
        }
      },
      child: Opacity(
        opacity: widget.enabled ? 1 : XkTactileTokens.disabledOpacity,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: XkTactileTokens.controlHeight,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: t.inputFill,
              borderRadius: widget.borderRadius ??
                  BorderRadius.circular(XkTactileTokens.fieldRadius),
              border: Border.all(color: border),
              boxShadow: focused
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
      ),
    );
  }
}
