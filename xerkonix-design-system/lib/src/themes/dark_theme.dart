import 'package:flutter/material.dart';

import '../palette/color.dart';
import '../shape/xerkonix_shape.dart';
import '../typography/xerkonix_typography.dart';
import 'color_schemes/dark_color_scheme.dart';
import 'xerkonix_theme.dart';

/// Dark Theme - Warm Intelligence (따뜻한 지성)
/// Materiality: High-end Matte Paper (물성)
/// Background와 Structure를 반전하여 사용
class XkDarkTheme extends XkTheme {
  XkDarkTheme._();

  static ThemeData themeData = ThemeData(
    useMaterial3: true,
    colorScheme: darkColorScheme,

    // Materiality: High-end Matte Paper
    scaffoldBackgroundColor: XkColor.structure, // Structure (swapped)

    // Typography - IBM Plex Sans with generous spacing
    textTheme: TextTheme(
      displayLarge: XkTypo.largeTitle.copyWith(color: XkColor.canvas),
      displayMedium: XkTypo.title1.copyWith(color: XkColor.canvas),
      displaySmall: XkTypo.title2.copyWith(color: XkColor.canvas),
      headlineLarge: XkTypo.headline.copyWith(color: XkColor.canvas),
      headlineMedium: XkTypo.title3.copyWith(color: XkColor.canvas),
      titleLarge: XkTypo.title1.copyWith(color: XkColor.canvas),
      titleMedium: XkTypo.title2.copyWith(color: XkColor.canvas),
      titleSmall: XkTypo.title3.copyWith(color: XkColor.canvas),
      bodyLarge: XkTypo.body.copyWith(color: XkColor.canvas),
      bodyMedium: XkTypo.body.copyWith(color: XkColor.canvas),
      bodySmall: XkTypo.caption1.copyWith(color: XkColor.canvas),
      labelLarge: XkTypo.callout.copyWith(color: XkColor.canvas),
      labelMedium: XkTypo.footnote.copyWith(color: XkColor.canvas),
      labelSmall: XkTypo.caption2.copyWith(color: XkColor.canvas),
    ),

    // Card Theme - Sophisticated Round (R8-R12)
    // 다크테마: 배경(Structure)보다 약간 밝은 색으로 구분
    cardTheme: const CardThemeData(
      color: XkColor.darkSurface, // #3A3A3A - 배경과 구분되는 약간 밝은 색
      elevation: 0, // No shadow for matte paper feel
      shape: RoundedRectangleBorder(
        borderRadius: XkShape.defaultBorderRadius,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: XkLayout.spacingMedium,
        vertical: XkLayout.spacingSmall,
      ),
    ),

    // AppBar Theme
    // 스크롤 시: Structure (#2D2D2D) → 약간 밝은 색으로 변경
    appBarTheme: AppBarTheme(
      backgroundColor: XkColor.structure,
      surfaceTintColor: XkColor.structure.withValues(alpha: 0.95), // 스크롤 시 약간 밝은 색
      scrolledUnderElevation: 0.5, // 스크롤 시 elevation
      elevation: 0,
      centerTitle: true,
      titleTextStyle: XkTypo.title2.copyWith(color: XkColor.canvas),
    ),

    // Button Theme - Sophisticated Round + States (hover, pressed, disabled)
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return XkColor.textDisabled.withValues(alpha: 0.4);
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
            return XkColor.textDisabled;
          }
          return XkColor.canvas; // Canvas 텍스트 (다크테마에서는 밝은 텍스트)
        }),
        overlayColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            return XkColor.pulse.withValues(alpha: 0.25);
          }
          if (states.contains(MaterialState.hovered)) {
            return XkColor.identity.withValues(alpha: 0.18);
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
      ),
    ),
    
    // OutlinedButton Theme - Outlined Style (다크테마)
    // Secondary Button: 투명 배경 + Identity 테두리 + Identity 텍스트
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return XkColor.textDisabled.withValues(alpha: 0.1);
          }
          if (states.contains(MaterialState.pressed)) {
            return XkColor.identity.withValues(alpha: 0.15);
          }
          if (states.contains(MaterialState.hovered) ||
              states.contains(MaterialState.focused)) {
            return XkColor.identity.withValues(alpha: 0.08);
          }
          return Colors.transparent; // 투명 배경
        }),
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return XkColor.textDisabled;
          }
          return XkColor.identity; // Identity 텍스트
        }),
        side: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return BorderSide(color: XkColor.textDisabled, width: 1);
          }
          if (states.contains(MaterialState.pressed)) {
            return BorderSide(color: XkColor.identity.withValues(alpha: 0.7), width: 1.5);
          }
          return BorderSide(color: XkColor.identity, width: 1.5); // Identity 테두리
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
      ),
    ),

    // TextButton Theme - CTA Style (다크테마)
    // CTA: Canvas (#F5F5F5) 배경 + Identity (#C0A062) 텍스트
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return XkColor.textDisabled.withValues(alpha: 0.2);
          }
          if (states.contains(MaterialState.pressed)) {
            return XkColor.canvas.withValues(alpha: 0.9);
          }
          if (states.contains(MaterialState.hovered) ||
              states.contains(MaterialState.focused)) {
            return XkColor.canvas.withValues(alpha: 0.95);
          }
          return XkColor.canvas; // Canvas 배경 (다크테마에서는 밝은 배경)
        }),
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return XkColor.textDisabled;
          }
          return XkColor.identity; // Muted Gold 텍스트
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
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: XkColor.structure,
      border: OutlineInputBorder(
        borderRadius: XkShape.defaultBorderRadius,
        borderSide: BorderSide(color: XkColor.canvas.withValues(alpha: 0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: XkShape.defaultBorderRadius,
        borderSide: BorderSide(color: XkColor.canvas.withValues(alpha: 0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: XkShape.defaultBorderRadius,
        borderSide: BorderSide(color: XkColor.identity, width: 2),
      ),
      contentPadding: const EdgeInsets.all(XkLayout.spacingMedium),
    ),
  );
}

