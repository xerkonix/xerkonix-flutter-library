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
    required this.child,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final ButtonType buttonType;
  final Color? semanticColor;

  factory XkButton.primary({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.primary,
      child: child,
    );
  }

  factory XkButton.action({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.action,
      child: child,
    );
  }

  factory XkButton.cta({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    return XkButton.action(key: key, onPressed: onPressed, child: child);
  }

  factory XkButton.brand({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.brand,
      child: child,
    );
  }

  factory XkButton.support({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.support,
      child: child,
    );
  }

  factory XkButton.accent({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.accent,
      child: child,
    );
  }

  factory XkButton.tonal({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.tonal,
      child: child,
    );
  }

  factory XkButton.outline({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.outline,
      child: child,
    );
  }

  // Backward-compatible alias
  factory XkButton.outlined({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    return XkButton.outline(key: key, onPressed: onPressed, child: child);
  }

  factory XkButton.success({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.semantic,
      semanticColor: XkColor.success,
      child: child,
    );
  }

  factory XkButton.warning({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.semantic,
      semanticColor: XkColor.warning,
      child: child,
    );
  }

  factory XkButton.error({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.semantic,
      semanticColor: XkColor.error,
      child: child,
    );
  }

  factory XkButton.info({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.semantic,
      semanticColor: XkColor.gray600,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
