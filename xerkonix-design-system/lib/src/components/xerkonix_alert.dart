import 'package:flutter/material.dart';

import '../palette/color.dart';
import '../shape/xerkonix_shape.dart';
import '../typography/xerkonix_typography.dart';

enum XkAlertVariant { success, info, warning, danger }

/// Alert item from the design-system component section.
///
/// v1.3:
/// - Left 8px solid block (replaces v1.2's 3px left-border)
/// - Asymmetric radius (left edge square, right edge rounded)
/// - Neutral surface background by default; `danger` keeps a tinted wash
/// - Optional mono prefix shown on the trailing side (`SUC/INF/WRN/ERR`)
class XkAlert extends StatelessWidget {
  const XkAlert({
    super.key,
    required this.title,
    required this.message,
    this.variant = XkAlertVariant.info,
    this.leading,
    this.trailing,
    this.showMetaPrefix = true,
    this.padding = const EdgeInsets.fromLTRB(24, 14, 16, 14),
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
    this.accentColor,
    this.textColor,
  });

  final String title;
  final String message;
  final XkAlertVariant variant;
  final Widget? leading;
  final Widget? trailing;

  /// Whether to display the mono 3-letter state prefix (`SUC/INF/WRN/ERR`)
  /// on the trailing side when [trailing] is not provided.
  final bool showMetaPrefix;

  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry? borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? accentColor;
  final Color? textColor;

  static const double _accentWidth = 8;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final palette = _resolvePalette(isDark);
    final foreground = textColor ?? palette.foreground;
    final accent = accentColor ?? palette.accent;
    final bg = backgroundColor ?? palette.background;
    final resolvedRadius =
        borderRadius ??
        const BorderRadius.only(
          topLeft: Radius.zero,
          bottomLeft: Radius.zero,
          topRight: Radius.circular(XkShape.radiusMd),
          bottomRight: Radius.circular(XkShape.radiusMd),
        );

    final trailingWidget =
        trailing ??
        (showMetaPrefix
            ? Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  _metaLabel(variant),
                  style: XkTypo.metricMono.copyWith(
                    color: accent,
                    letterSpacing: 1.4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            : null);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: resolvedRadius,
        boxShadow: XkShadow.raised(isDark ? Brightness.dark : Brightness.light),
      ),
      child: ClipRRect(
        borderRadius: resolvedRadius,
        child: Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: resolvedRadius,
            border: Border.all(color: borderColor ?? palette.border),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                width: _accentWidth,
                child: Container(color: accent),
              ),
              Padding(
                padding: padding,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (leading != null) ...[
                      leading!,
                      const SizedBox(width: XkLayout.spacingSm),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: XkTypo.fieldLabel.copyWith(
                              color: foreground,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.05,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            message,
                            style: XkTypo.bodySmall.copyWith(
                              color: isDark
                                  ? XkColor.darkTextBody
                                  : XkColor.textBody,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (trailingWidget != null) ...[
                      const SizedBox(width: XkLayout.spacingSm),
                      trailingWidget,
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _metaLabel(XkAlertVariant variant) {
    switch (variant) {
      case XkAlertVariant.success:
        return 'SUC';
      case XkAlertVariant.info:
        return 'INF';
      case XkAlertVariant.warning:
        return 'WRN';
      case XkAlertVariant.danger:
        return 'ERR';
    }
  }

  _AlertPalette _resolvePalette(bool isDark) {
    final neutralBg = isDark ? XkColor.darkSurface : XkColor.surface;
    final neutralBorder = isDark ? XkColor.darkBorderSoft : XkColor.borderSoft;
    final foreground = isDark ? XkColor.darkTextStrong : XkColor.textStrong;

    switch (variant) {
      case XkAlertVariant.success:
        return _AlertPalette(
          background: neutralBg,
          border: neutralBorder,
          foreground: foreground,
          accent: isDark ? XkColor.darkSuccess : XkColor.success,
        );
      case XkAlertVariant.info:
        return _AlertPalette(
          background: neutralBg,
          border: neutralBorder,
          foreground: foreground,
          accent: isDark ? XkColor.gray500 : XkColor.gray600,
        );
      case XkAlertVariant.warning:
        return _AlertPalette(
          background: neutralBg,
          border: neutralBorder,
          foreground: foreground,
          accent: isDark ? XkColor.darkWarning : XkColor.warning,
        );
      case XkAlertVariant.danger:
        final signal = isDark ? XkColor.darkError : XkColor.error;
        final wash = isDark ? XkColor.darkErrorSoft : XkColor.errorSoft;
        return _AlertPalette(
          background: Color.alphaBlend(wash, neutralBg),
          border: neutralBorder,
          foreground: signal,
          accent: signal,
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
