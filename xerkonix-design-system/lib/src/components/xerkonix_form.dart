import 'package:flutter/material.dart';

import '../palette/color.dart';
import '../shape/xerkonix_shape.dart';
import '../typography/xerkonix_typography.dart';
import 'xerkonix_neumorphic.dart';

class XkSelectOption<T> {
  const XkSelectOption({required this.value, required this.label});

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
      child: _InsetWell(
        radius: borderRadius ?? XkShape.smBorderRadius,
        enabled: enabled,
        child: TextField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            filled: false,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding:
                contentPadding ??
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
      child: _InsetWell(
        radius: borderRadius ?? XkShape.smBorderRadius,
        enabled: enabled,
        child: TextField(
          controller: controller,
          enabled: enabled,
          onChanged: onChanged,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
            filled: false,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding:
                contentPadding ??
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
      child: _InsetWell(
        radius: borderRadius ?? XkShape.smBorderRadius,
        enabled: enabled,
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
            filled: false,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding:
                contentPadding ??
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ),
    );
  }
}

/// A sunken (inset) field surround: a recessed fill with an inner shadow so the
/// input reads as pressed into the canvas, matching the TACTILE elevation model.
class _InsetWell extends StatelessWidget {
  const _InsetWell({
    required this.child,
    required this.radius,
    this.enabled = true,
  });

  final Widget child;
  final BorderRadius radius;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color fill = isDark ? XkColor.darkBg : XkColor.surface2;
    final Color hairline = isDark ? XkColor.darkBorderSoft : XkColor.borderSoft;
    return Opacity(
      opacity: enabled ? 1.0 : 0.6,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: fill,
          borderRadius: radius,
          border: Border.all(color: hairline),
        ),
        child: CustomPaint(
          foregroundPainter: XkInsetShadowPainter(
            borderRadius: radius,
            lowlight: isDark
                ? XkShadow.darkLowlight
                : XkColor.textStrong.withValues(alpha: 0.16),
            highlight: isDark
                ? XkColor.darkTextStrong.withValues(alpha: 0.05)
                : Colors.white.withValues(alpha: 0.6),
            distance: 3,
            blur: 7,
          ),
          child: ClipRRect(borderRadius: radius, child: child),
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
        Text(label, style: XkTypo.label),
        const SizedBox(height: XkLayout.spacingXs),
        child,
        if (helperText != null && helperText!.trim().isNotEmpty) ...[
          const SizedBox(height: XkLayout.spacingXs),
          Text(helperText!, style: XkTypo.metaMono.copyWith(fontSize: 11)),
        ],
      ],
    );
  }
}
