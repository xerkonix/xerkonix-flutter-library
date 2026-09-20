import 'package:flutter/material.dart';

import '../icons/xerkonix_icon.dart';
import '../tactile/tactile_field.dart';
import '../tactile/tactile_tokens.dart';
import '../tactile/tactile_type.dart';

class XkSelectOption<T> {
  const XkSelectOption({required this.value, required this.label});

  final T value;
  final String label;
}

/// Public text field. Delegates to [XkTactileField] (external label, input
/// fill, r10) — not `_InsetWell` / [XkGlass] action.
class XkTextInputField extends StatelessWidget {
  const XkTextInputField({
    super.key,
    required this.label,
    this.hintText,
    this.helperText,
    this.controller,
    this.onChanged,
    this.borderRadius,
    this.contentPadding,
    this.keyboardType,
    this.enabled = true,
    this.errorText,
  });

  final String label;
  final String? hintText;
  final String? helperText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final TextInputType? keyboardType;
  final bool enabled;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return _DelegatedField(
      label: label,
      helperText: helperText,
      errorText: errorText,
      enabled: enabled,
      child: TextField(
        controller: controller,
        enabled: enabled,
        keyboardType: keyboardType,
        onChanged: onChanged,
        decoration: XkTactileField.inputDecoration(hintText: hintText).copyWith(
          contentPadding: contentPadding,
        ),
      ),
    );
  }
}

/// Public textarea. Same current field chrome as [XkTextInputField].
class XkTextAreaField extends StatelessWidget {
  const XkTextAreaField({
    super.key,
    required this.label,
    this.hintText,
    this.helperText,
    this.controller,
    this.onChanged,
    this.borderRadius,
    this.contentPadding,
    this.maxLines = 4,
    this.enabled = true,
    this.errorText,
  });

  final String label;
  final String? hintText;
  final String? helperText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final int maxLines;
  final bool enabled;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return _DelegatedField(
      label: label,
      helperText: helperText,
      errorText: errorText,
      enabled: enabled,
      child: TextField(
        controller: controller,
        enabled: enabled,
        onChanged: onChanged,
        maxLines: maxLines,
        decoration: XkTactileField.inputDecoration(hintText: hintText).copyWith(
          contentPadding: contentPadding,
        ),
      ),
    );
  }
}

/// Public select. Same current field chrome as [XkTextInputField].
class XkSelectField<T> extends StatelessWidget {
  const XkSelectField({
    super.key,
    required this.label,
    required this.options,
    this.value,
    this.onChanged,
    this.helperText,
    this.borderRadius,
    this.contentPadding,
    this.enabled = true,
    this.errorText,
  });

  final String label;
  final List<XkSelectOption<T>> options;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final String? helperText;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final bool enabled;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final XkTactileTokens t = XkTactileTokens.of(Theme.of(context).brightness);
    return _DelegatedField(
      label: label,
      helperText: helperText,
      errorText: errorText,
      enabled: enabled,
      child: DropdownButtonFormField<T>(
        key: ValueKey<T?>(value),
        initialValue: value,
        isExpanded: true,
        icon: XkIcon(
          XkIconName.chevDown,
          size: 16,
          color: t.muted,
        ),
        iconSize: 16,
        items: options
            .map(
              (XkSelectOption<T> option) => DropdownMenuItem<T>(
                value: option.value,
                child: Text(option.label),
              ),
            )
            .toList(),
        onChanged: enabled ? onChanged : null,
        decoration: XkTactileField.inputDecoration().copyWith(
          contentPadding: contentPadding,
        ),
      ),
    );
  }
}

class _DelegatedField extends StatelessWidget {
  const _DelegatedField({
    required this.label,
    required this.child,
    this.helperText,
    this.errorText,
    this.enabled = true,
  });

  final String label;
  final Widget child;
  final String? helperText;
  final String? errorText;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final XkTactileTokens t = XkTactileTokens.of(Theme.of(context).brightness);
    final String? error = errorText?.trim();
    final bool invalid = error != null && error.isNotEmpty;
    final String? helper = helperText?.trim();
    final Widget field = XkTactileField(
      label: label.trim().isEmpty ? null : label,
      enabled: enabled,
      error: invalid,
      child: child,
    );
    final String? below = invalid ? error : (helper == null || helper.isEmpty ? null : helper);
    if (below == null) {
      return field;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        field,
        const SizedBox(height: 8),
        Text(
          below,
          style: XkTactileType.label(color: invalid ? t.accentDeep : t.muted),
        ),
      ],
    );
  }
}
