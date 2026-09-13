import 'package:flutter/material.dart';

import '../palette/color.dart';
import '../shape/xerkonix_shape.dart';
import '../typography/xerkonix_typography.dart';
import 'color_schemes/light_color_scheme.dart';
import 'xerkonix_theme.dart';

/// Light Theme (XERKONIX DS · TACTILE v4)
class XkLightTheme extends XkTheme {
  XkLightTheme._();

  static ThemeData themeData = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: lightColorScheme,
    scaffoldBackgroundColor: XkColor.canvas,
    fontFamily: Pretendard.fontFamily,
    textTheme: TextTheme(
      displayLarge: XkTypo.display.copyWith(color: XkColor.ink),
      displayMedium: XkTypo.h1.copyWith(color: XkColor.ink),
      displaySmall: XkTypo.h2.copyWith(color: XkColor.ink),
      headlineLarge: XkTypo.h1.copyWith(color: XkColor.ink),
      headlineMedium: XkTypo.h2.copyWith(color: XkColor.ink),
      headlineSmall: XkTypo.h3.copyWith(color: XkColor.ink),
      titleLarge: XkTypo.h3.copyWith(color: XkColor.ink),
      titleMedium: XkTypo.label.copyWith(color: XkColor.ink),
      titleSmall: XkTypo.eyebrow.copyWith(color: XkColor.ink2),
      bodyLarge: XkTypo.bodyLarge.copyWith(color: XkColor.ink),
      bodyMedium: XkTypo.body.copyWith(color: XkColor.ink),
      bodySmall: XkTypo.label.copyWith(color: XkColor.ink2),
      labelLarge: _buttonLabel.copyWith(color: XkColor.ink),
      labelMedium: XkTypo.eyebrow.copyWith(color: XkColor.ink2),
      labelSmall: XkTypo.eyebrow.copyWith(color: XkColor.ink2),
    ),
    cardTheme: CardThemeData(
      color: XkColor.glass,
      elevation: 0,
      shadowColor: XkColor.glassShadowNear,
      surfaceTintColor: XkColor.none,
      shape: RoundedRectangleBorder(
        borderRadius: XkRadius.panelBorderRadius,
        side: const BorderSide(color: XkColor.glassEdge2),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: XkLayout.spacingSm,
        vertical: XkLayout.spacingXs,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: XkColor.none,
      surfaceTintColor: XkColor.none,
      scrolledUnderElevation: 0,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: Pretendard.fontFamily,
        package: Pretendard.package,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: XkColor.ink,
      ),
      iconTheme: IconThemeData(color: XkColor.ink),
      shape: Border(bottom: BorderSide(color: XkColor.rule, width: 1)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: _ctlStyle(
        foreground: XkColor.inkInverse,
        background: XkColor.surfaceInverse,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: _ctlStyle(
        foreground: XkColor.ink,
        background: XkColor.none,
        border: XkColor.glassEdge2,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: _ctlStyle(
        foreground: XkColor.ink,
        background: XkColor.none,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: XkColor.glass,
      hintStyle: XkTypo.hint.copyWith(color: XkColor.ink3),
      border: OutlineInputBorder(
        borderRadius: XkRadius.ctlBorderRadius,
        borderSide: const BorderSide(color: XkColor.rule),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: XkRadius.ctlBorderRadius,
        borderSide: const BorderSide(color: XkColor.rule),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: XkRadius.ctlBorderRadius,
        borderSide: BorderSide(color: XkColor.aquaDeep, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    switchTheme: _switchTheme(),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return XkColor.aquaMid;
        }
        return XkColor.none;
      }),
      checkColor: WidgetStateProperty.all(XkColor.aquaInk),
      side: const BorderSide(color: XkColor.rule),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return XkColor.aquaMid;
        }
        return XkColor.rule;
      }),
    ),
    dividerTheme: const DividerThemeData(
      color: XkColor.rule,
      space: 1,
      thickness: 1,
    ),
    dividerColor: XkColor.rule,
    focusColor: XkColor.aquaDeep.withValues(alpha: 0.2),
  );

  static final TextStyle _buttonLabel = XkTypo.buttonLabel.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.15,
  );

  static ButtonStyle _ctlStyle({
    required Color foreground,
    required Color background,
    Color? border,
  }) {
    return ButtonStyle(
      textStyle: WidgetStateProperty.all(_buttonLabel),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      minimumSize: WidgetStateProperty.all(
        const Size(48, XkLayout.controlHeight),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: XkRadius.ctlBorderRadius),
      ),
      side: WidgetStateProperty.all(
        border == null ? BorderSide.none : BorderSide(color: border),
      ),
      backgroundColor: WidgetStateProperty.resolveWith((Set<WidgetState> s) {
        if (s.contains(WidgetState.disabled)) {
          return XkColor.insetBg;
        }
        return background;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((Set<WidgetState> s) {
        if (s.contains(WidgetState.disabled)) {
          return XkColor.ink3;
        }
        return foreground;
      }),
      overlayColor: WidgetStateProperty.all(XkColor.none),
      elevation: WidgetStateProperty.all(0),
      shadowColor: WidgetStateProperty.all(XkColor.none),
      surfaceTintColor: WidgetStateProperty.all(XkColor.none),
    );
  }

  static SwitchThemeData _switchTheme() {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return XkColor.ink3;
        }
        return XkColor.groundHi;
      }),
      trackColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return XkColor.insetBg;
        }
        return states.contains(WidgetState.selected)
            ? XkColor.aquaMid
            : XkColor.insetBg;
      }),
      trackOutlineColor: WidgetStateProperty.resolveWith(
        (Set<WidgetState> states) {
          return states.contains(WidgetState.selected)
              ? XkColor.aquaMid
              : XkColor.rule;
        },
      ),
    );
  }
}
