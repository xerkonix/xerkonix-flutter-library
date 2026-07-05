import 'package:flutter/material.dart';

import '../palette/color.dart';
import '../shape/xerkonix_shape.dart';
import '../typography/xerkonix_typography.dart';
import 'color_schemes/dark_color_scheme.dart';
import 'xerkonix_theme.dart';

/// Dark Theme (XERKONIX DS v1.5)
class XkDarkTheme extends XkTheme {
  XkDarkTheme._();

  static ThemeData themeData = ThemeData(
    useMaterial3: true,
    colorScheme: darkColorScheme,
    scaffoldBackgroundColor: XkColor.darkBg,
    textTheme: TextTheme(
      displayLarge: XkTypo.display.copyWith(color: XkColor.darkTextStrong),
      displayMedium: XkTypo.h1.copyWith(color: XkColor.darkTextStrong),
      displaySmall: XkTypo.h2.copyWith(color: XkColor.darkTextStrong),
      headlineLarge: XkTypo.h1.copyWith(color: XkColor.darkTextStrong),
      headlineMedium: XkTypo.h2.copyWith(color: XkColor.darkTextStrong),
      headlineSmall: XkTypo.h3.copyWith(color: XkColor.darkTextStrong),
      titleLarge: XkTypo.h3.copyWith(color: XkColor.darkTextStrong),
      titleMedium: XkTypo.label.copyWith(color: XkColor.darkTextBody),
      titleSmall: XkTypo.label.copyWith(color: XkColor.darkTextMuted),
      bodyLarge: XkTypo.bodyLarge.copyWith(color: XkColor.darkTextBody),
      bodyMedium: XkTypo.body.copyWith(color: XkColor.darkTextBody),
      bodySmall: XkTypo.label.copyWith(color: XkColor.darkTextMuted),
      labelLarge: _buttonLabel.copyWith(color: XkColor.darkTextStrong),
      labelMedium: XkTypo.label.copyWith(color: XkColor.darkTextMuted),
      labelSmall: XkTypo.metaMono.copyWith(color: XkColor.darkTextMuted),
    ),
    cardTheme: CardThemeData(
      color: XkColor.darkSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: XkShape.xlBorderRadius,
        side: BorderSide(color: XkColor.darkBorderSoft),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: XkLayout.spacingSm,
        vertical: XkLayout.spacingXs,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: XkColor.darkBg,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: XkTypo.h3.copyWith(color: XkColor.darkTextStrong),
      iconTheme: const IconThemeData(color: XkColor.darkTextStrong),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: _elevatedStyle(
        baseColor: XkColor.darkAccent,
        textColor: XkColor.darkBg,
        disabledColor: XkColor.gray400,
        disabledTextColor: XkColor.darkSurface,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: _outlinedStyle(
        borderColor: XkColor.darkBorder,
        textColor: XkColor.darkTextBody,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: _tonalStyle(
        backgroundColor: XkColor.darkSurface2,
        textColor: XkColor.darkTextStrong,
        borderColor: XkColor.darkBorder,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: XkColor.darkSurface,
      hintStyle: XkTypo.metaMono.copyWith(color: XkColor.darkTextMuted),
      border: OutlineInputBorder(
        borderRadius: XkShape.smBorderRadius,
        borderSide: BorderSide(color: XkColor.darkBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: XkShape.smBorderRadius,
        borderSide: BorderSide(color: XkColor.darkBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: XkShape.smBorderRadius,
        borderSide: const BorderSide(color: XkColor.darkAccent, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    ),
    dividerColor: XkColor.darkBorderSoft,
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
          return disabledTextColor;
        }
        return textColor;
      }),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return XkColor.darkBg.withValues(alpha: 0.16);
        }
        if (states.contains(WidgetState.hovered)) {
          return XkColor.darkBg.withValues(alpha: 0.1);
        }
        return null;
      }),
      elevation: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered)) {
          return 3;
        }
        return 0;
      }),
      shadowColor: WidgetStateProperty.all(const Color(0x73000000)),
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
          return XkColor.darkSurface2;
        }
        if (states.contains(WidgetState.hovered)) {
          return XkColor.darkSurface.withValues(alpha: 0.85);
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
      shadowColor: WidgetStateProperty.all(const Color(0x66000000)),
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
          return XkColor.darkSurface2;
        }
        if (states.contains(WidgetState.hovered)) {
          return XkColor.darkSurface2.withValues(alpha: 0.9);
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
      shadowColor: WidgetStateProperty.all(const Color(0x66000000)),
    );
  }
}
