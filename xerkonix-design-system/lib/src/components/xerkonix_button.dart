import 'package:flutter/material.dart';

import '../palette/color.dart';
import '../shape/xerkonix_shape.dart';
import '../typography/xerkonix_typography.dart';

/// XERKONIX Design System button component.
///
/// v1.1 variants:
/// - primary
/// - brand
/// - accent
/// - tonal
/// - outline
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
    return XkButton.outline(
      key: key,
      onPressed: onPressed,
      child: child,
    );
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
      semanticColor: XkColor.info,
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
          style: _elevatedStyle(
            isDark: isDark,
            baseColor: isDark ? XkColor.darkText : XkColor.text,
            textColor: isDark ? XkColor.darkCanvas : XkColor.canvas,
          ),
          child: child,
        );
      case ButtonType.brand:
        return ElevatedButton(
          onPressed: onPressed,
          style: _elevatedStyle(
            isDark: isDark,
            baseColor: isDark ? XkColor.darkIdentity : XkColor.identity,
            textColor: isDark ? XkColor.darkCanvas : Colors.white,
          ),
          child: child,
        );
      case ButtonType.accent:
        return ElevatedButton(
          onPressed: onPressed,
          style: _elevatedStyle(
            isDark: isDark,
            baseColor: isDark ? XkColor.darkAction : XkColor.action,
            textColor: isDark ? XkColor.darkCanvas : Colors.white,
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
          style: _semanticStyle(semanticColor!, isDark: isDark),
          child: child,
        );
    }
  }

  static final TextStyle _labelStyle = XkTypo.label.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.15,
  );

  static ButtonStyle _elevatedStyle({
    required bool isDark,
    required Color baseColor,
    required Color textColor,
  }) {
    final disabledBg = isDark ? XkColor.darkTextFaint : XkColor.textFaint;
    final disabledFg = isDark ? XkColor.darkSurface : XkColor.textSoft;

    return ButtonStyle(
      textStyle: WidgetStateProperty.all(_labelStyle),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      ),
      minimumSize: WidgetStateProperty.all(const Size(0, 36)),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: XkShape.smBorderRadius),
      ),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return disabledBg;
        }
        if (states.contains(WidgetState.pressed)) {
          return baseColor.withValues(alpha: 0.9);
        }
        if (states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.focused)) {
          return baseColor.withValues(alpha: 0.96);
        }
        return baseColor;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return disabledFg;
        }
        return textColor;
      }),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return Colors.white.withValues(alpha: 0.14);
        }
        if (states.contains(WidgetState.hovered)) {
          return Colors.white.withValues(alpha: 0.08);
        }
        return null;
      }),
      elevation: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered)) {
          return 3;
        }
        return 0;
      }),
      shadowColor: WidgetStateProperty.all(
        isDark ? const Color(0x73000000) : const Color(0x29000000),
      ),
    );
  }

  static ButtonStyle _outlineStyle({required bool isDark}) {
    final borderColor = isDark ? XkColor.darkBorderMid : XkColor.borderMid;
    final textColor = isDark ? XkColor.darkTextBody : XkColor.textBody;

    return ButtonStyle(
      textStyle: WidgetStateProperty.all(_labelStyle),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      ),
      minimumSize: WidgetStateProperty.all(const Size(0, 36)),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: XkShape.smBorderRadius),
      ),
      side: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return BorderSide(color: borderColor.withValues(alpha: 0.5));
        }
        if (states.contains(WidgetState.pressed)) {
          return BorderSide(color: borderColor.withValues(alpha: 0.9));
        }
        return BorderSide(color: borderColor);
      }),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return isDark ? XkColor.darkSurfaceDeep : XkColor.surfaceSoft;
        }
        if (states.contains(WidgetState.hovered)) {
          return (isDark ? XkColor.darkSurface : XkColor.surface)
              .withValues(alpha: 0.85);
        }
        return Colors.transparent;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return textColor.withValues(alpha: 0.5);
        }
        return textColor;
      }),
      elevation: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered)) {
          return 3;
        }
        return 0;
      }),
      shadowColor: WidgetStateProperty.all(
        isDark ? const Color(0x66000000) : const Color(0x24000000),
      ),
    );
  }

  static ButtonStyle _tonalStyle({required bool isDark}) {
    final backgroundColor =
        isDark ? XkColor.darkSurfaceSoft : XkColor.surfaceSoft;
    final textColor = isDark ? XkColor.darkText : XkColor.text;
    final borderColor = isDark ? XkColor.darkBorderMid : XkColor.borderMid;

    return ButtonStyle(
      textStyle: WidgetStateProperty.all(_labelStyle),
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
          return isDark ? XkColor.darkSurfaceDeep : XkColor.surfaceDeep;
        }
        if (states.contains(WidgetState.hovered)) {
          return backgroundColor.withValues(alpha: 0.9);
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
        if (states.contains(WidgetState.hovered)) {
          return 3;
        }
        return 0;
      }),
      shadowColor: WidgetStateProperty.all(
        isDark ? const Color(0x66000000) : const Color(0x24000000),
      ),
    );
  }

  static ButtonStyle _semanticStyle(Color color, {required bool isDark}) {
    final disabledBg = isDark ? XkColor.darkTextFaint : XkColor.textFaint;
    final disabledFg = isDark ? XkColor.darkSurface : XkColor.textSoft;

    return ButtonStyle(
      textStyle: WidgetStateProperty.all(_labelStyle),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      ),
      minimumSize: WidgetStateProperty.all(const Size(0, 36)),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: XkShape.smBorderRadius),
      ),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return disabledBg;
        }
        if (states.contains(WidgetState.pressed)) {
          return color.withValues(alpha: 0.9);
        }
        if (states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.focused)) {
          return color.withValues(alpha: 0.96);
        }
        return color;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return disabledFg;
        }
        return Colors.white;
      }),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return Colors.white.withValues(alpha: 0.14);
        }
        if (states.contains(WidgetState.hovered)) {
          return Colors.white.withValues(alpha: 0.08);
        }
        return null;
      }),
      elevation: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered)) {
          return 3;
        }
        return 0;
      }),
      shadowColor: WidgetStateProperty.all(
        isDark ? const Color(0x73000000) : const Color(0x29000000),
      ),
    );
  }
}

enum ButtonType {
  primary,
  brand,
  accent,
  tonal,
  outline,
  semantic,
}
