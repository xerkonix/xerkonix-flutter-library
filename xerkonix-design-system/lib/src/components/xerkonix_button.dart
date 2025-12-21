import 'package:flutter/material.dart';

import '../palette/color.dart';
import '../shape/xerkonix_shape.dart';

/// Xerkonix Design System Button Component
/// 
/// A button component that automatically adjusts colors based on the theme.
/// 
/// Example usage:
/// ```dart
/// XkButton.primary(
///   onPressed: () {},
///   child: Text('Primary Button'),
/// )
/// ```
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
  final Color? semanticColor; // For Success, Warning, Error, Info buttons

  /// Primary Button
  /// Light theme: Identity background with Structure text
  /// Dark theme: Identity background with Canvas text
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

  /// Outlined Button
  /// Transparent background with Identity border and text
  factory XkButton.outlined({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      buttonType: ButtonType.outlined,
      child: child,
    );
  }

  /// Success Button
  /// Success color background with white text
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

  /// Warning Button
  /// Warning color background with white text
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

  /// Error Button
  /// Error color background with white text
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

  /// Info Button
  /// Info color background with white text
  /// Uses Deep Slate (#526875) for neutral information display
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    switch (buttonType) {
      case ButtonType.primary:
        return ElevatedButton(
          onPressed: onPressed,
          style: _buildPrimaryStyle(isDark),
          child: child,
        );
      case ButtonType.outlined:
        return OutlinedButton(
          onPressed: onPressed,
          style: _buildOutlinedStyle(),
          child: child,
        );
      case ButtonType.semantic:
        return ElevatedButton(
          onPressed: onPressed,
          style: _buildSemanticStyle(semanticColor!),
          child: child,
        );
    }
  }

  ButtonStyle _buildPrimaryStyle(bool isDark) {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return isDark
              ? XkColor.textDisabled.withValues(alpha: 0.4)
              : XkColor.textDisabled;
        }
        if (states.contains(MaterialState.pressed)) {
          return XkColor.identity.withValues(alpha: 0.75);
        }
        if (states.contains(MaterialState.hovered) ||
            states.contains(MaterialState.focused)) {
          return XkColor.identity.withValues(alpha: 0.9);
        }
        return XkColor.identity;
      }),
      foregroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return isDark
              ? XkColor.textDisabled
              : XkColor.textTertiary;
        }
        return isDark ? XkColor.canvas : XkColor.structure;
      }),
      overlayColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.pressed)) {
          return XkColor.pulse.withValues(alpha: isDark ? 0.25 : 0.18);
        }
        if (states.contains(MaterialState.hovered)) {
          return XkColor.identity.withValues(alpha: isDark ? 0.18 : 0.12);
        }
        return null;
      }),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: XkShape.defaultBorderRadius,
        ),
      ),
      padding: MaterialStateProperty.all<EdgeInsets>(
        const EdgeInsets.symmetric(
          horizontal: XkLayout.spacingLarge,
          vertical: XkLayout.spacingMedium,
        ),
      ),
      elevation: MaterialStateProperty.all<double>(0),
    );
  }

  ButtonStyle _buildOutlinedStyle() {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return XkColor.textDisabled.withValues(alpha: 0.1);
        }
        if (states.contains(MaterialState.pressed)) {
          return XkColor.identity.withValues(alpha: 0.1);
        }
        if (states.contains(MaterialState.hovered) ||
            states.contains(MaterialState.focused)) {
          return XkColor.identity.withValues(alpha: 0.05);
        }
        return Colors.transparent;
      }),
      foregroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return XkColor.textDisabled;
        }
        return XkColor.identity;
      }),
      side: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return BorderSide(color: XkColor.textDisabled, width: 1);
        }
        if (states.contains(MaterialState.pressed)) {
          return BorderSide(color: XkColor.identity.withValues(alpha: 0.7), width: 1.5);
        }
        return BorderSide(color: XkColor.identity, width: 1.5);
      }),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: XkShape.defaultBorderRadius,
        ),
      ),
      padding: MaterialStateProperty.all<EdgeInsets>(
        const EdgeInsets.symmetric(
          horizontal: XkLayout.spacingLarge,
          vertical: XkLayout.spacingMedium,
        ),
      ),
    );
  }

  ButtonStyle _buildSemanticStyle(Color color) {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return XkColor.textDisabled;
        }
        if (states.contains(MaterialState.pressed)) {
          return color.withValues(alpha: 0.8);
        }
        if (states.contains(MaterialState.hovered) ||
            states.contains(MaterialState.focused)) {
          return color.withValues(alpha: 0.9);
        }
        return color;
      }),
      foregroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return XkColor.textTertiary;
        }
        return Colors.white;
      }),
      overlayColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.pressed)) {
          return Colors.white.withValues(alpha: 0.1);
        }
        if (states.contains(MaterialState.hovered)) {
          return Colors.white.withValues(alpha: 0.05);
        }
        return null;
      }),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: XkShape.defaultBorderRadius,
        ),
      ),
      padding: MaterialStateProperty.all<EdgeInsets>(
        const EdgeInsets.symmetric(
          horizontal: XkLayout.spacingLarge,
          vertical: XkLayout.spacingMedium,
        ),
      ),
      elevation: MaterialStateProperty.all<double>(0),
    );
  }
}

enum ButtonType {
  primary,
  outlined,
  semantic,
}
