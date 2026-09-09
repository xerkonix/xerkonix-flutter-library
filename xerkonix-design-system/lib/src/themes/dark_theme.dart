import 'package:flutter/material.dart';

import '../palette/color.dart';
import '../shape/xerkonix_shape.dart';
import '../typography/xerkonix_typography.dart';
import 'color_schemes/dark_color_scheme.dart';
import 'xerkonix_theme.dart';

/// Dark Theme (XERKONIX DS · TACTILE)
class XkDarkTheme extends XkTheme {
  XkDarkTheme._();

  static ThemeData themeData = ThemeData(
    useMaterial3: true,
    colorScheme: darkColorScheme,
    scaffoldBackgroundColor: XkColor.darkBg,
    textTheme: TextTheme(
      displayLarge: XkTypo.display.copyWith(color: XkColor.darkInk),
      displayMedium: XkTypo.h1.copyWith(color: XkColor.darkInk),
      displaySmall: XkTypo.h2.copyWith(color: XkColor.darkInk),
      headlineLarge: XkTypo.h1.copyWith(color: XkColor.darkInk),
      headlineMedium: XkTypo.h2.copyWith(color: XkColor.darkInk),
      headlineSmall: XkTypo.h3.copyWith(color: XkColor.darkInk),
      titleLarge: XkTypo.h3.copyWith(color: XkColor.darkInk),
      titleMedium: XkTypo.label.copyWith(color: XkColor.darkInk),
      titleSmall: XkTypo.label.copyWith(color: XkColor.darkMuted),
      bodyLarge: XkTypo.bodyLarge.copyWith(color: XkColor.darkInk),
      bodyMedium: XkTypo.body.copyWith(color: XkColor.darkInk),
      bodySmall: XkTypo.label.copyWith(color: XkColor.darkMuted),
      labelLarge: _buttonLabel.copyWith(color: XkColor.darkInk),
      labelMedium: XkTypo.label.copyWith(color: XkColor.darkMuted),
      labelSmall: XkTypo.metaMono.copyWith(color: XkColor.darkMuted),
    ),
    cardTheme: CardThemeData(
      color: XkColor.darkPanel,
      elevation: 0,
      shadowColor: XkColor.darkSh,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: XkShape.lgBorderRadius,
        side: BorderSide(color: XkColor.darkHairSoft),
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
      centerTitle: false,
      titleTextStyle: XkTypo.h3.copyWith(color: XkColor.darkInk),
      iconTheme: const IconThemeData(color: XkColor.darkInk),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: _elevatedStyle(
        baseColor: XkColor.darkInk,
        hoverColor: XkColor.darkInk,
        textColor: XkColor.darkBg,
        disabledColor: XkColor.darkWell,
        disabledTextColor: XkColor.darkMuted,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: _outlinedStyle(
        borderColor: XkColor.darkHair,
        textColor: XkColor.darkInk,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: _tonalStyle(
        backgroundColor: XkColor.darkHairSoft,
        textColor: XkColor.darkInk,
        borderColor: XkColor.darkHair,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: XkColor.darkBg,
      hintStyle: XkTypo.hint.copyWith(color: XkColor.darkMuted),
      border: OutlineInputBorder(
        borderRadius: XkShape.smBorderRadius,
        borderSide: BorderSide(color: XkColor.darkHairSoft),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: XkShape.smBorderRadius,
        borderSide: BorderSide(color: XkColor.darkHairSoft),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: XkShape.smBorderRadius,
        borderSide: BorderSide(color: XkColor.darkTintFill, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    switchTheme: _switchTheme(
      accent: XkColor.darkInk,
      onAccent: XkColor.darkBg,
      thumbOff: XkColor.darkMuted,
      trackOff: XkColor.darkHairSoft,
      border: XkColor.darkHair,
      disabled: XkColor.muted,
    ),
    dividerTheme: const DividerThemeData(
      color: XkColor.darkHairSoft,
      space: 1,
      thickness: 1,
    ),
    dividerColor: XkColor.darkHairSoft,
  );

  static final TextStyle _buttonLabel = XkTypo.label.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1.15,
  );

  static ButtonStyle _elevatedStyle({
    required Color baseColor,
    required Color hoverColor,
    required Color textColor,
    required Color disabledColor,
    required Color disabledTextColor,
  }) {
    return ButtonStyle(
      textStyle: WidgetStateProperty.all(_buttonLabel),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
      ),
      minimumSize: WidgetStateProperty.all(const Size(48, 48)),
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
          return hoverColor;
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
      elevation: WidgetStateProperty.all(0),
      shadowColor: WidgetStateProperty.all(Colors.transparent),
      surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
    );
  }

  static ButtonStyle _outlinedStyle({
    required Color borderColor,
    required Color textColor,
  }) {
    return ButtonStyle(
      textStyle: WidgetStateProperty.all(_buttonLabel),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
      ),
      minimumSize: WidgetStateProperty.all(const Size(48, 48)),
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
          return XkColor.darkHairSoft;
        }
        if (states.contains(WidgetState.hovered)) {
          return XkColor.darkPanel.withValues(alpha: 0.85);
        }
        return Colors.transparent;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return textColor.withValues(alpha: 0.5);
        }
        return textColor;
      }),
      elevation: WidgetStateProperty.all(0),
      shadowColor: WidgetStateProperty.all(Colors.transparent),
      surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
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
        const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
      ),
      minimumSize: WidgetStateProperty.all(const Size(48, 48)),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: XkShape.smBorderRadius),
      ),
      side: WidgetStateProperty.all(BorderSide(color: borderColor)),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return backgroundColor.withValues(alpha: 0.5);
        }
        if (states.contains(WidgetState.pressed)) {
          return XkColor.darkHairSoft;
        }
        if (states.contains(WidgetState.hovered)) {
          return XkColor.darkHairSoft.withValues(alpha: 0.9);
        }
        return backgroundColor;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return textColor.withValues(alpha: 0.45);
        }
        return textColor;
      }),
      elevation: WidgetStateProperty.all(0),
      shadowColor: WidgetStateProperty.all(Colors.transparent),
      surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
    );
  }

  static SwitchThemeData _switchTheme({
    required Color accent,
    required Color onAccent,
    required Color thumbOff,
    required Color trackOff,
    required Color border,
    required Color disabled,
  }) {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return disabled;
        }
        return states.contains(WidgetState.selected) ? onAccent : thumbOff;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return trackOff.withValues(alpha: 0.5);
        }
        return states.contains(WidgetState.selected) ? accent : trackOff;
      }),
      trackOutlineColor: WidgetStateProperty.resolveWith((states) {
        return states.contains(WidgetState.selected) ? accent : border;
      }),
    );
  }
}
