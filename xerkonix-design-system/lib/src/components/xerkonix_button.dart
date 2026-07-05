import 'package:flutter/material.dart';

import '../palette/color.dart';
import '../shape/xerkonix_shape.dart';
import '../typography/xerkonix_typography.dart';

/// XERKONIX Design System button component.
///
/// Variants:
/// - primary   (text-on-canvas)
/// - action    (default CTA, `#3B434F` / white · `cta` alias)
/// - brand     (brand gold, for brand-identity contexts only)
/// - support   (recommended / stable context)
/// - accent    (editorial emphasis)
/// - tonal
/// - outline
///
/// v1.3 policy: the default CTA should be `action` (WCAG AAA contrast).
/// `brand` remains available but is reserved for brand-identity moments,
/// not generic primary actions. See design system/v1.3/tokens.css.
class XkButton extends StatelessWidget {
  const XkButton._({
    super.key,
    required this.onPressed,
    required this.buttonType,
    this.semanticColor,
    this.expanded = false,
    this.gradient = false,
    required this.child,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final ButtonType buttonType;
  final Color? semanticColor;

  /// When true, the button stretches to fill the available width.
  final bool expanded;

  /// When true, a gradient accent fill is used (see [XkButton.primaryGradient]).
  final bool gradient;

  factory XkButton.primary({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    bool expanded = false,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.primary,
      expanded: expanded,
      child: child,
    );
  }

  /// Gradient-filled accent CTA (covers the product `CosentioPrimaryButton`).
  /// Full-width by default.
  factory XkButton.primaryGradient({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    bool expanded = true,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.action,
      gradient: true,
      expanded: expanded,
      child: child,
    );
  }

  factory XkButton.action({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    bool expanded = false,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.action,
      expanded: expanded,
      child: child,
    );
  }

  factory XkButton.cta({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    bool expanded = false,
  }) {
    return XkButton.action(
      key: key,
      onPressed: onPressed,
      expanded: expanded,
      child: child,
    );
  }

  factory XkButton.brand({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    bool expanded = false,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.brand,
      expanded: expanded,
      child: child,
    );
  }

  factory XkButton.support({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    bool expanded = false,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.support,
      expanded: expanded,
      child: child,
    );
  }

  factory XkButton.accent({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    bool expanded = false,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.accent,
      expanded: expanded,
      child: child,
    );
  }

  factory XkButton.tonal({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    bool expanded = false,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.tonal,
      expanded: expanded,
      child: child,
    );
  }

  factory XkButton.outline({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    bool expanded = false,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.outline,
      expanded: expanded,
      child: child,
    );
  }

  // Backward-compatible alias
  factory XkButton.outlined({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    bool expanded = false,
  }) {
    return XkButton.outline(
      key: key,
      onPressed: onPressed,
      expanded: expanded,
      child: child,
    );
  }

  factory XkButton.success({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    bool expanded = false,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.semantic,
      semanticColor: XkColor.success,
      expanded: expanded,
      child: child,
    );
  }

  factory XkButton.warning({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    bool expanded = false,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.semantic,
      semanticColor: XkColor.warning,
      expanded: expanded,
      child: child,
    );
  }

  factory XkButton.error({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    bool expanded = false,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.semantic,
      semanticColor: XkColor.error,
      expanded: expanded,
      child: child,
    );
  }

  factory XkButton.info({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    bool expanded = false,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.semantic,
      semanticColor: XkColor.gray600,
      expanded: expanded,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget button = gradient
        ? _buildGradient(context, isDark)
        : _buildCore(context, isDark);
    if (expanded) {
      button = SizedBox(width: double.infinity, child: button);
    }
    return button;
  }

  Widget _buildGradient(BuildContext context, bool isDark) {
    final Color start = isDark ? XkColor.darkAccent : XkColor.accent;
    final Color end = isDark ? XkColor.darkAccentDeep : XkColor.accentDeep;
    final Color onColor = isDark ? XkColor.darkAccentText : XkColor.accentText;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: <Color>[start, end]),
        borderRadius: XkShape.smBorderRadius,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: XkShape.smBorderRadius,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 15),
            child: DefaultTextStyle.merge(
              textAlign: TextAlign.center,
              style: XkTypo.buttonLabel.copyWith(
                color: onColor,
                fontWeight: FontWeight.w600,
              ),
              child: IconTheme.merge(
                data: IconThemeData(color: onColor),
                child: Center(widthFactor: 1, child: child),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCore(BuildContext context, bool isDark) {
    switch (buttonType) {
      case ButtonType.primary:
        return ElevatedButton(
          onPressed: onPressed,
          style: _filledStyle(
            isDark: isDark,
            baseColor: isDark ? XkColor.darkTextStrong : XkColor.textStrong,
            hoverColor: isDark ? XkColor.darkTextBody : XkColor.textBody,
            textColor: isDark ? XkColor.darkBg : XkColor.bg,
          ),
          child: child,
        );
      case ButtonType.action:
        return ElevatedButton(
          onPressed: onPressed,
          style: _filledStyle(
            isDark: isDark,
            baseColor: isDark ? XkColor.darkAccent : XkColor.accent,
            hoverColor: isDark ? XkColor.darkAccentDeep : XkColor.accentDeep,
            textColor: isDark ? XkColor.darkAccentText : XkColor.accentText,
          ),
          child: child,
        );
      case ButtonType.brand:
        return ElevatedButton(
          onPressed: onPressed,
          style: _filledStyle(
            isDark: isDark,
            baseColor: isDark ? XkColor.darkAccent : XkColor.accent,
            hoverColor: isDark
                ? XkColor.darkAccentDeep
                : XkColor.accentDeep,
            textColor: const Color(0xFF1A0E00),
          ),
          child: child,
        );
      case ButtonType.support:
        return ElevatedButton(
          onPressed: onPressed,
          style: _filledStyle(
            isDark: isDark,
            baseColor: isDark ? XkColor.darkSuccess : XkColor.success,
            hoverColor: isDark ? XkColor.darkSuccess : XkColor.success,
            textColor: const Color(0xFF1A0E00),
          ),
          child: child,
        );
      case ButtonType.accent:
        return ElevatedButton(
          onPressed: onPressed,
          style: _filledStyle(
            isDark: isDark,
            baseColor: isDark ? XkColor.darkAccent : XkColor.accent,
            hoverColor: isDark ? XkColor.darkAccentDeep : XkColor.accentDeep,
            textColor: isDark ? XkColor.darkAccentText : Colors.white,
          ),
          child: child,
        );
      case ButtonType.tonal:
        return OutlinedButton(
          onPressed: onPressed,
          style: _tonalStyle(isDark: isDark),
          child: child,
        );
      case ButtonType.outline:
        return OutlinedButton(
          onPressed: onPressed,
          style: _outlineStyle(isDark: isDark),
          child: child,
        );
      case ButtonType.semantic:
        return ElevatedButton(
          onPressed: onPressed,
          style: _filledStyle(
            isDark: isDark,
            baseColor: semanticColor!,
            hoverColor: _emphasize(semanticColor!, isDark),
            textColor: _onColor(semanticColor!, isDark),
          ),
          child: child,
        );
    }
  }

  static ButtonStyle _filledStyle({
    required bool isDark,
    required Color baseColor,
    required Color hoverColor,
    required Color textColor,
  }) {
    return ButtonStyle(
      textStyle: WidgetStateProperty.all(XkTypo.buttonLabel),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      ),
      minimumSize: WidgetStateProperty.all(const Size(0, 36)),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: XkShape.smBorderRadius),
      ),
      side: WidgetStateProperty.all(BorderSide.none),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return isDark ? XkColor.gray400 : XkColor.gray400;
        }
        if (states.contains(WidgetState.pressed) ||
            states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.focused)) {
          return hoverColor;
        }
        return baseColor;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return isDark ? XkColor.darkSurface : XkColor.textMuted;
        }
        return textColor;
      }),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return textColor.withValues(alpha: 0.10);
        }
        if (states.contains(WidgetState.hovered)) {
          return textColor.withValues(alpha: 0.06);
        }
        return null;
      }),
      elevation: WidgetStateProperty.resolveWith((states) {
        return states.contains(WidgetState.hovered) ? 2 : 0;
      }),
      shadowColor: WidgetStateProperty.all(
        isDark ? const Color(0x61000000) : const Color(0x14141414),
      ),
      surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
    );
  }

  static ButtonStyle _outlineStyle({required bool isDark}) {
    final borderColor = isDark ? XkColor.darkBorder : XkColor.border;
    final textColor = isDark ? XkColor.darkTextBody : XkColor.textBody;

    return ButtonStyle(
      textStyle: WidgetStateProperty.all(XkTypo.buttonLabel),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      ),
      minimumSize: WidgetStateProperty.all(const Size(0, 36)),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: XkShape.smBorderRadius),
      ),
      side: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return BorderSide(color: borderColor.withValues(alpha: 0.45));
        }
        if (states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.focused)) {
          return BorderSide(color: borderColor.withValues(alpha: 0.95));
        }
        return BorderSide(color: borderColor);
      }),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return isDark ? XkColor.darkSurface2 : XkColor.surface2;
        }
        if (states.contains(WidgetState.hovered)) {
          return (isDark ? XkColor.darkSurface : XkColor.surface).withValues(
            alpha: 0.92,
          );
        }
        return Colors.transparent;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return textColor.withValues(alpha: 0.45);
        }
        return textColor;
      }),
      elevation: WidgetStateProperty.resolveWith((states) {
        return states.contains(WidgetState.hovered) ? 2 : 0;
      }),
      shadowColor: WidgetStateProperty.all(
        isDark ? const Color(0x61000000) : const Color(0x14141414),
      ),
      surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
    );
  }

  static ButtonStyle _tonalStyle({required bool isDark}) {
    final backgroundColor = isDark
        ? XkColor.darkSurface2
        : XkColor.surface2;
    final textColor = isDark ? XkColor.darkTextStrong : XkColor.textStrong;
    final borderColor = isDark ? XkColor.darkBorder : XkColor.border;

    return ButtonStyle(
      textStyle: WidgetStateProperty.all(XkTypo.buttonLabel),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      ),
      minimumSize: WidgetStateProperty.all(const Size(0, 36)),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: XkShape.smBorderRadius),
      ),
      side: WidgetStateProperty.all(BorderSide(color: borderColor)),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return backgroundColor.withValues(alpha: 0.5);
        }
        if (states.contains(WidgetState.pressed)) {
          return isDark ? XkColor.darkSurface2 : XkColor.surface2;
        }
        if (states.contains(WidgetState.hovered)) {
          return backgroundColor.withValues(alpha: 0.94);
        }
        return backgroundColor;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return textColor.withValues(alpha: 0.45);
        }
        return textColor;
      }),
      elevation: WidgetStateProperty.resolveWith((states) {
        return states.contains(WidgetState.hovered) ? 2 : 0;
      }),
      shadowColor: WidgetStateProperty.all(
        isDark ? const Color(0x61000000) : const Color(0x14141414),
      ),
      surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
    );
  }

  static Color _emphasize(Color color, bool isDark) {
    return Color.lerp(color, isDark ? Colors.white : Colors.black, 0.14) ??
        color;
  }

  static Color _onColor(Color color, bool isDark) {
    return ThemeData.estimateBrightnessForColor(color) == Brightness.dark
        ? Colors.white
        : (isDark ? XkColor.darkAccentText : const Color(0xFF1A0E00));
  }
}

enum ButtonType {
  primary,
  action,
  brand,
  support,
  accent,
  tonal,
  outline,
  semantic,
}
