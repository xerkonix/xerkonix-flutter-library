import 'package:flutter/material.dart';

import '../palette/color.dart';
import '../shape/xerkonix_shape.dart';
import '../typography/xerkonix_typography.dart';
import 'color_schemes/light_color_scheme.dart';
import 'xerkonix_theme.dart';

/// Light Theme (XERKONIX DS v1.5)
class XkLightTheme extends XkTheme {
  XkLightTheme._();

  static ThemeData themeData = ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    scaffoldBackgroundColor: XkColor.bg,
    textTheme: TextTheme(
      displayLarge: XkTypo.display.copyWith(color: XkColor.textStrong),
      displayMedium: XkTypo.h1.copyWith(color: XkColor.textStrong),
      displaySmall: XkTypo.h2.copyWith(color: XkColor.textStrong),
      headlineLarge: XkTypo.h1.copyWith(color: XkColor.textStrong),
      headlineMedium: XkTypo.h2.copyWith(color: XkColor.textStrong),
      headlineSmall: XkTypo.h3.copyWith(color: XkColor.textStrong),
      titleLarge: XkTypo.h3.copyWith(color: XkColor.textStrong),
      titleMedium: XkTypo.label.copyWith(color: XkColor.textBody),
      titleSmall: XkTypo.label.copyWith(color: XkColor.textMuted),
      bodyLarge: XkTypo.bodyLarge.copyWith(color: XkColor.textBody),
      bodyMedium: XkTypo.body.copyWith(color: XkColor.textBody),
      bodySmall: XkTypo.label.copyWith(color: XkColor.textMuted),
      labelLarge: _buttonLabel.copyWith(color: XkColor.textStrong),
      labelMedium: XkTypo.label.copyWith(color: XkColor.textMuted),
      labelSmall: XkTypo.metaMono.copyWith(color: XkColor.textMuted),
    ),
    cardTheme: CardThemeData(
      color: XkColor.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: XkShape.xlBorderRadius,
        side: BorderSide(color: XkColor.borderSoft),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: XkLayout.spacingSm,
        vertical: XkLayout.spacingXs,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: XkColor.bg,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: XkTypo.h3.copyWith(color: XkColor.textStrong),
      iconTheme: const IconThemeData(color: XkColor.textStrong),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: _elevatedStyle(
        baseColor: XkColor.accent,
        textColor: Colors.white,
        disabledColor: XkColor.gray400,
        disabledTextColor: XkColor.textMuted,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: _outlinedStyle(
        borderColor: XkColor.border,
        textColor: XkColor.textBody,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: _tonalStyle(
        backgroundColor: XkColor.surface2,
        textColor: XkColor.textStrong,
        borderColor: XkColor.border,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: XkColor.surface,
      hintStyle: XkTypo.metaMono.copyWith(color: XkColor.textMuted),
      border: OutlineInputBorder(
        borderRadius: XkShape.smBorderRadius,
        borderSide: BorderSide(color: XkColor.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: XkShape.smBorderRadius,
        borderSide: BorderSide(color: XkColor.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: XkShape.smBorderRadius,
        borderSide: const BorderSide(color: XkColor.accent, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    ),
    dividerColor: XkColor.borderSoft,
  );

  static final TextStyle _buttonLabel = XkTypo.label.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.15,
  );

  static ButtonStyle _elevatedStyle({
    required Color baseColor,
    required Color textColor,
    required Color disabledColor,
    required Color disabledTextColor,
  }) {
    return ButtonStyle(
      textStyle: WidgetStateProperty.all(_buttonLabel),
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
          return disabledColor;
        }
        if (states.contains(WidgetState.pressed)) {
          return baseColor.withValues(alpha: 0.92);
        }
        if (states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.focused)) {
          return baseColor.withValues(alpha: 0.96);
        }
        return baseColor;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return disabledTextColor;
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
      shadowColor: WidgetStateProperty.all(const Color(0x33000000)),
    );
  }

  static ButtonStyle _outlinedStyle({
    required Color borderColor,
    required Color textColor,
  }) {
    return ButtonStyle(
      textStyle: WidgetStateProperty.all(_buttonLabel),
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
          return XkColor.surface2;
        }
        if (states.contains(WidgetState.hovered)) {
          return XkColor.surface.withValues(alpha: 0.8);
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
      shadowColor: WidgetStateProperty.all(const Color(0x24000000)),
    );
  }

  static ButtonStyle _tonalStyle({
    required Color backgroundColor,
    required Color textColor,
    required Color borderColor,
  }) {
    return ButtonStyle(
      textStyle: WidgetStateProperty.all(_buttonLabel),
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
          return XkColor.surface2;
        }
        if (states.contains(WidgetState.hovered)) {
          return XkColor.surface2.withValues(alpha: 0.92);
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
      shadowColor: WidgetStateProperty.all(const Color(0x24000000)),
    );
  }
}
