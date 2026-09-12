import 'package:flutter/material.dart';

import '../palette/color.dart';
import '../shape/xerkonix_shape.dart';
import '../typography/xerkonix_typography.dart';
import 'color_schemes/dark_color_scheme.dart';
import 'xerkonix_theme.dart';

/// Dark Theme (XERKONIX DS · TACTILE v4)
class XkDarkTheme extends XkTheme {
  XkDarkTheme._();

  static ThemeData themeData = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: darkColorScheme,
    scaffoldBackgroundColor: XkColor.darkCanvas,
    fontFamily: Pretendard.fontFamily,
    textTheme: TextTheme(
      displayLarge: XkTypo.display.copyWith(color: XkColor.darkInk),
      displayMedium: XkTypo.h1.copyWith(color: XkColor.darkInk),
      displaySmall: XkTypo.h2.copyWith(color: XkColor.darkInk),
      headlineLarge: XkTypo.h1.copyWith(color: XkColor.darkInk),
      headlineMedium: XkTypo.h2.copyWith(color: XkColor.darkInk),
      headlineSmall: XkTypo.h3.copyWith(color: XkColor.darkInk),
      titleLarge: XkTypo.h3.copyWith(color: XkColor.darkInk),
      titleMedium: XkTypo.label.copyWith(color: XkColor.darkInk),
      titleSmall: XkTypo.eyebrow.copyWith(color: XkColor.darkInk2),
      bodyLarge: XkTypo.bodyLarge.copyWith(color: XkColor.darkInk),
      bodyMedium: XkTypo.body.copyWith(color: XkColor.darkInk),
      bodySmall: XkTypo.label.copyWith(color: XkColor.darkInk2),
      labelLarge: _buttonLabel.copyWith(color: XkColor.darkInk),
      labelMedium: XkTypo.eyebrow.copyWith(color: XkColor.darkInk2),
      labelSmall: XkTypo.eyebrow.copyWith(color: XkColor.darkInk2),
    ),
    cardTheme: CardThemeData(
      color: XkColor.darkGlass,
      elevation: 0,
      shadowColor: XkColor.darkGlassShadowNear,
      surfaceTintColor: XkColor.none,
      shape: RoundedRectangleBorder(
        borderRadius: XkRadius.panelBorderRadius,
        side: const BorderSide(color: XkColor.darkGlassEdge2),
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
        color: XkColor.darkInk,
      ),
      iconTheme: IconThemeData(color: XkColor.darkInk),
      shape: Border(bottom: BorderSide(color: XkColor.darkRule, width: 1)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: _ctlStyle(
        foreground: XkColor.darkAquaInk,
        background: XkColor.darkAquaMid,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: _ctlStyle(
        foreground: XkColor.darkInk,
        background: XkColor.none,
        border: XkColor.darkGlassEdge2,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: _ctlStyle(
        foreground: XkColor.darkInk,
        background: XkColor.none,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: XkColor.darkGlass,
      hintStyle: XkTypo.hint.copyWith(color: XkColor.darkInk3),
      border: OutlineInputBorder(
        borderRadius: XkRadius.ctlBorderRadius,
        borderSide: const BorderSide(color: XkColor.darkRule),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: XkRadius.ctlBorderRadius,
        borderSide: const BorderSide(color: XkColor.darkRule),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: XkRadius.ctlBorderRadius,
        borderSide: BorderSide(color: XkColor.darkAqua, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    switchTheme: _switchTheme(),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return XkColor.darkAquaMid;
        }
        return XkColor.none;
      }),
      checkColor: WidgetStateProperty.all(XkColor.darkAquaInk),
      side: const BorderSide(color: XkColor.darkRule),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return XkColor.darkAquaMid;
        }
        return XkColor.darkRule;
      }),
    ),
    dividerTheme: const DividerThemeData(
      color: XkColor.darkRule,
      space: 1,
      thickness: 1,
    ),
    dividerColor: XkColor.darkRule,
    focusColor: XkColor.darkAqua.withValues(alpha: 0.2),
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
          return XkColor.darkInsetBg;
        }
        return background;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((Set<WidgetState> s) {
        if (s.contains(WidgetState.disabled)) {
          return XkColor.darkInk3;
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
          return XkColor.darkInk3;
        }
        return XkColor.darkGroundHi;
      }),
      trackColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return XkColor.darkInsetBg;
        }
        return states.contains(WidgetState.selected)
            ? XkColor.darkAquaMid
            : XkColor.darkInsetBg;
      }),
      trackOutlineColor: WidgetStateProperty.resolveWith(
        (Set<WidgetState> states) {
          return states.contains(WidgetState.selected)
              ? XkColor.darkAquaMid
              : XkColor.darkRule;
        },
      ),
    );
  }
}
