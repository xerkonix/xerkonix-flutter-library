import 'package:flutter/material.dart';

import '../palette/color.dart';
import '../shape/xerkonix_shape.dart';
import '../typography/xerkonix_typography.dart';
import 'color_schemes/light_color_scheme.dart';
import 'xerkonix_theme.dart';

/// Light Theme
/// Provides a light theme with matte paper-like appearance
class XkLightTheme extends XkTheme {
  XkLightTheme._();

  static ThemeData themeData = ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    
    // Materiality: High-end Matte Paper
    // No Glassmorphism - 눈을 찌르는 빛 반사나 유광 질감을 절대적으로 지양
    scaffoldBackgroundColor: XkColor.canvas, // Warm Off-white
    
    // Typography - IBM Plex Sans with generous spacing
    // Light theme: Structure (#2D2D2D) for headings, Body Text (#4A4A4A) for body
    textTheme: TextTheme(
      displayLarge: XkTypo.largeTitle.copyWith(color: XkColor.textPrimary),
      displayMedium: XkTypo.title1.copyWith(color: XkColor.textPrimary),
      displaySmall: XkTypo.title2.copyWith(color: XkColor.textPrimary),
      headlineLarge: XkTypo.headline.copyWith(color: XkColor.textPrimary),
      headlineMedium: XkTypo.title3.copyWith(color: XkColor.textPrimary),
      titleLarge: XkTypo.title1.copyWith(color: XkColor.textPrimary),
      titleMedium: XkTypo.title2.copyWith(color: XkColor.textPrimary),
      titleSmall: XkTypo.title3.copyWith(color: XkColor.textPrimary),
      bodyLarge: XkTypo.body.copyWith(color: XkColor.bodyText),
      bodyMedium: XkTypo.body.copyWith(color: XkColor.bodyText),
      bodySmall: XkTypo.caption1.copyWith(color: XkColor.bodyText),
      labelLarge: XkTypo.callout.copyWith(color: XkColor.bodyText),
      labelMedium: XkTypo.footnote.copyWith(color: XkColor.bodyText),
      labelSmall: XkTypo.caption2.copyWith(color: XkColor.bodyText),
    ),
    
    // Card Theme - Sophisticated Round (R8-R12)
    cardTheme: const CardThemeData(
      color: Colors.white,
      elevation: 0, // No shadow for matte paper feel
      shape: RoundedRectangleBorder(
        borderRadius: XkShape.defaultBorderRadius,
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: XkLayout.spacingMedium,
        vertical: XkLayout.spacingSmall,
      ),
    ),
    
    // AppBar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: XkColor.canvas,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: XkTypo.title2.copyWith(color: XkColor.structure),
    ),
    
    // Button Theme - Sophisticated Round + States (hover, pressed, disabled)
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return XkColor.textDisabled;
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
            return XkColor.textTertiary; // Disabled button text uses darker color
          }
          return XkColor.structure; // Deep Charcoal text
        }),
        overlayColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            return XkColor.pulse.withValues(alpha: 0.18);
          }
          if (states.contains(MaterialState.hovered)) {
            return XkColor.identity.withValues(alpha: 0.12);
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
    
    // OutlinedButton Theme - Outlined Style
    // Secondary Button: Transparent background with Identity border and text
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
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
          return Colors.transparent; // Transparent background
        }),
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return XkColor.textDisabled;
          }
          return XkColor.identity; // Identity text
        }),
        side: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return BorderSide(color: XkColor.textDisabled, width: 1);
          }
          if (states.contains(MaterialState.pressed)) {
            return BorderSide(color: XkColor.identity.withValues(alpha: 0.7), width: 1.5);
          }
          return BorderSide(color: XkColor.identity, width: 1.5); // Identity border
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
    
    // TextButton Theme - CTA Style (Light Theme)
    // CTA: Deep Charcoal (#2D2D2D) background with Muted Gold (#C0A062) text
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return XkColor.textDisabled.withValues(alpha: 0.2);
          }
          if (states.contains(MaterialState.pressed)) {
            return XkColor.structure.withValues(alpha: 0.9);
          }
          if (states.contains(MaterialState.hovered) ||
              states.contains(MaterialState.focused)) {
            return XkColor.structure.withValues(alpha: 0.95);
          }
          return XkColor.structure; // Deep Charcoal background
        }),
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return XkColor.textDisabled;
          }
          return XkColor.identity; // Muted Gold text
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
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: XkShape.defaultBorderRadius,
        borderSide: BorderSide(color: XkColor.structure.withValues(alpha: 0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: XkShape.defaultBorderRadius,
        borderSide: BorderSide(color: XkColor.structure.withValues(alpha: 0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: XkShape.defaultBorderRadius,
        borderSide: BorderSide(color: XkColor.identity, width: 2),
      ),
      contentPadding: const EdgeInsets.all(XkLayout.spacingMedium),
    ),
  );
}