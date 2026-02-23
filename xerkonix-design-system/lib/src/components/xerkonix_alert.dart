import 'package:flutter/material.dart';

import '../palette/color.dart';
import '../shape/xerkonix_shape.dart';
import '../typography/xerkonix_typography.dart';

enum XkAlertVariant {
  success,
  info,
  warning,
  danger,
}

/// Alert item from the design-system component section.
class XkAlert extends StatelessWidget {
  const XkAlert({
    super.key,
    required this.title,
    required this.message,
    this.variant = XkAlertVariant.info,
    this.leading,
    this.trailing,
    this.padding = const EdgeInsets.all(XkLayout.spacingSm),
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
  });

  final String title;
  final String message;
  final XkAlertVariant variant;
  final Widget? leading;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry? borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final palette = _resolvePalette(isDark);
    final foreground = textColor ?? palette.foreground;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? palette.background,
        borderRadius: borderRadius ?? XkShape.smBorderRadius,
        border: Border.all(color: borderColor ?? palette.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          leading ??
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Icon(
                  Icons.circle,
                  size: 10,
                  color: palette.accent,
                ),
              ),
          const SizedBox(width: XkLayout.spacingSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: XkTypo.label.copyWith(
                    fontSize: 12,
                    color: foreground,
                  ),
                ),
                const SizedBox(height: XkLayout.spacingXxs),
                Text(
                  message,
                  style: XkTypo.body.copyWith(
                    fontSize: 12,
                    color: foreground,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: XkLayout.spacingSm),
            trailing!,
          ],
        ],
      ),
    );
  }

  _AlertPalette _resolvePalette(bool isDark) {
    switch (variant) {
      case XkAlertVariant.success:
        return _AlertPalette(
          background: isDark
              ? XkColor.success.withValues(alpha: 0.22)
              : XkColor.success.withValues(alpha: 0.12),
          border: XkColor.success.withValues(alpha: isDark ? 0.6 : 0.35),
          foreground: isDark ? XkColor.darkText : XkColor.text,
          accent: XkColor.success,
        );
      case XkAlertVariant.info:
        return _AlertPalette(
          background: isDark
              ? XkColor.info.withValues(alpha: 0.22)
              : XkColor.info.withValues(alpha: 0.12),
          border: XkColor.info.withValues(alpha: isDark ? 0.6 : 0.35),
          foreground: isDark ? XkColor.darkText : XkColor.text,
          accent: XkColor.info,
        );
      case XkAlertVariant.warning:
        return _AlertPalette(
          background: isDark
              ? XkColor.warning.withValues(alpha: 0.24)
              : XkColor.warning.withValues(alpha: 0.14),
          border: XkColor.warning.withValues(alpha: isDark ? 0.64 : 0.38),
          foreground: isDark ? XkColor.darkText : XkColor.text,
          accent: XkColor.warning,
        );
      case XkAlertVariant.danger:
        return _AlertPalette(
          background: isDark
              ? XkColor.error.withValues(alpha: 0.24)
              : XkColor.error.withValues(alpha: 0.13),
          border: XkColor.error.withValues(alpha: isDark ? 0.64 : 0.38),
          foreground: isDark ? XkColor.darkText : XkColor.text,
          accent: XkColor.error,
        );
    }
  }
}

class _AlertPalette {
  const _AlertPalette({
    required this.background,
    required this.border,
    required this.foreground,
    required this.accent,
  });

  final Color background;
  final Color border;
  final Color foreground;
  final Color accent;
}
