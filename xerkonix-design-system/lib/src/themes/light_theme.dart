import 'package:flutter/material.dart';

import '../palette/color.dart';
import '../shape/xerkonix_shape.dart';
import '../typography/xerkonix_typography.dart';
import 'color_schemes/light_color_scheme.dart';
import 'xerkonix_theme.dart';

/// Light Theme (XERKONIX DS · TACTILE)
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
    // Cards read as extruded from the canvas. Material's CardTheme can only
    // express a single drop shadow, so the raised surface uses a matched fill
    // and hairline; use `XkCard` / `XkNeumorphic` for the full paired shadow.
    cardTheme: CardThemeData(
      color: XkColor.surface,
      elevation: 0,
      shadowColor: XkColor.shadow,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: XkShape.lgBorderRadius,
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
        textColor: XkColor.accentText,
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
        backgroundColor: XkColor.surface,
        textColor: XkColor.textStrong,
        borderColor: XkColor.border,
      ),
    ),
    // Inputs are sunken wells: a recessed fill + hairline, focus ring in ink.
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: XkColor.surface2,
      hintStyle: XkTypo.hint.copyWith(color: XkColor.textMuted),
      border: OutlineInputBorder(
        borderRadius: XkShape.smBorderRadius,
        borderSide: BorderSide(color: XkColor.borderSoft),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: XkShape.smBorderRadius,
        borderSide: BorderSide(color: XkColor.borderSoft),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: XkShape.smBorderRadius,
        borderSide: BorderSide(color: XkColor.accent, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    switchTheme: _switchTheme(
      accent: XkColor.accent,
      onAccent: XkColor.accentText,
      thumbOff: XkColor.surface,
      trackOff: XkColor.surface2,
      border: XkColor.border,
      disabled: XkColor.gray400,
    ),
    dividerTheme: const DividerThemeData(
      color: XkColor.borderSoft,
      space: 1,
      thickness: 1,
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
        const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
      ),
      minimumSize: WidgetStateProperty.all(const Size(0, 40)),
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
          return XkColor.accentDeep;
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
      minimumSize: WidgetStateProperty.all(const Size(0, 40)),
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
      minimumSize: WidgetStateProperty.all(const Size(0, 40)),
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
