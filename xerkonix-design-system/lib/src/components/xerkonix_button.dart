import 'package:flutter/material.dart';

import '../palette/color.dart';
import '../shape/xerkonix_shape.dart';

/// Xerkonix Design System Button Component
/// 
/// 테마에 따라 자동으로 색상이 조정되는 버튼 컴포넌트입니다.
/// 
/// 사용 예시:
/// ```dart
/// XkButton.primary(
///   onPressed: () {},
///   child: Text('Primary Button'),
/// )
/// ```
class XkButton extends StatelessWidget {
  const XkButton._({
    Key? key,
    required this.onPressed,
    required this.child,
    required this.buttonType,
    this.semanticColor,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final Widget child;
  final _ButtonType buttonType;
  final Color? semanticColor; // Success, Warning, Error, Info용

  /// Primary Button
  /// Light: Identity 배경 + Structure 텍스트
  /// Dark: Identity 배경 + Canvas 텍스트
  factory XkButton.primary({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      child: child,
      buttonType: _ButtonType.primary,
    );
  }

  /// Outlined Button
  /// 투명 배경 + Identity 테두리 + Identity 텍스트
  factory XkButton.outlined({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      child: child,
      buttonType: _ButtonType.outlined,
    );
  }

  /// Success Button
  /// Success 색상 배경 + 흰색 텍스트
  factory XkButton.success({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      child: child,
      buttonType: _ButtonType.semantic,
      semanticColor: XkColor.success,
    );
  }

  /// Warning Button
  /// Warning 색상 배경 + 흰색 텍스트
  factory XkButton.warning({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      child: child,
      buttonType: _ButtonType.semantic,
      semanticColor: XkColor.warning,
    );
  }

  /// Error Button
  /// Error 색상 배경 + 흰색 텍스트
  factory XkButton.error({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      child: child,
      buttonType: _ButtonType.semantic,
      semanticColor: XkColor.error,
    );
  }

  /// Info Button
  /// Info 색상 배경 + 흰색 텍스트
  /// Deep Slate (#526875) - 중립적인 정보 안내
  factory XkButton.info({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    return XkButton._(
      key: key,
      onPressed: onPressed,
      child: child,
      buttonType: _ButtonType.semantic,
      semanticColor: XkColor.info,
    );
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    switch (buttonType) {
      case _ButtonType.primary:
        return ElevatedButton(
          onPressed: onPressed,
          style: _buildPrimaryStyle(isDark),
          child: child,
        );
      case _ButtonType.outlined:
        return OutlinedButton(
          onPressed: onPressed,
          style: _buildOutlinedStyle(),
          child: child,
        );
      case _ButtonType.semantic:
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
              ? XkColor.textDisabled.withOpacity(0.4)
              : XkColor.textDisabled;
        }
        if (states.contains(MaterialState.pressed)) {
          return XkColor.identity.withOpacity(0.75);
        }
        if (states.contains(MaterialState.hovered) ||
            states.contains(MaterialState.focused)) {
          return XkColor.identity.withOpacity(0.9);
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
          return XkColor.pulse.withOpacity(isDark ? 0.25 : 0.18);
        }
        if (states.contains(MaterialState.hovered)) {
          return XkColor.identity.withOpacity(isDark ? 0.18 : 0.12);
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
          return XkColor.textDisabled.withOpacity(0.1);
        }
        if (states.contains(MaterialState.pressed)) {
          return XkColor.identity.withOpacity(0.1);
        }
        if (states.contains(MaterialState.hovered) ||
            states.contains(MaterialState.focused)) {
          return XkColor.identity.withOpacity(0.05);
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
          return BorderSide(color: XkColor.identity.withOpacity(0.7), width: 1.5);
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
          return color.withOpacity(0.8);
        }
        if (states.contains(MaterialState.hovered) ||
            states.contains(MaterialState.focused)) {
          return color.withOpacity(0.9);
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
          return Colors.white.withOpacity(0.1);
        }
        if (states.contains(MaterialState.hovered)) {
          return Colors.white.withOpacity(0.05);
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

enum _ButtonType {
  primary,
  outlined,
  semantic,
}
