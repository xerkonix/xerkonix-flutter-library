import 'package:flutter/material.dart';

import '../shape/xerkonix_shape.dart';
import '../typography/xerkonix_typography.dart';

class XkSelectOption<T> {
  const XkSelectOption({
    required this.value,
    required this.label,
  });

  final T value;
  final String label;
}

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

  @override
  Widget build(BuildContext context) {
    return _LabeledField(
      label: label,
      helperText: helperText,
      child: TextField(
        controller: controller,
        enabled: enabled,
        keyboardType: keyboardType,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: contentPadding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: borderRadius ?? XkShape.smBorderRadius,
          ),
        ),
      ),
    );
  }
}

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

  @override
  Widget build(BuildContext context) {
    return _LabeledField(
      label: label,
      helperText: helperText,
      child: TextField(
        controller: controller,
        enabled: enabled,
        onChanged: onChanged,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: contentPadding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: borderRadius ?? XkShape.smBorderRadius,
          ),
        ),
      ),
    );
  }
}

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
  });

  final String label;
  final List<XkSelectOption<T>> options;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final String? helperText;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return _LabeledField(
      label: label,
      helperText: helperText,
      child: DropdownButtonFormField<T>(
        key: ValueKey<T?>(value),
        initialValue: value,
        items: options
            .map(
              (option) => DropdownMenuItem<T>(
                value: option.value,
                child: Text(option.label),
              ),
            )
            .toList(),
        onChanged: enabled ? onChanged : null,
        decoration: InputDecoration(
          contentPadding: contentPadding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: borderRadius ?? XkShape.smBorderRadius,
          ),
        ),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.child,
    this.helperText,
  });

  final String label;
  final Widget child;
  final String? helperText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: XkTypo.label,
        ),
        const SizedBox(height: XkLayout.spacingXs),
        child,
        if (helperText != null && helperText!.trim().isNotEmpty) ...[
          const SizedBox(height: XkLayout.spacingXs),
          Text(
            helperText!,
            style: XkTypo.metaMono.copyWith(fontSize: 11),
          ),
        ],
      ],
    );
  }
}
