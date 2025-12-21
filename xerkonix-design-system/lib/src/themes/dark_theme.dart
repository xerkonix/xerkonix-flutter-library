import 'package:flutter/material.dart';

import '../palette/color.dart';
import '../shape/xerkonix_shape.dart';
import '../typography/xerkonix_typography.dart';
import 'color_schemes/dark_color_scheme.dart';
import 'xerkonix_theme.dart';

/// Dark Theme
/// Provides a dark theme with inverted background and structure colors
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
    // Dark theme: Slightly brighter color than background (Structure) for distinction
    cardTheme: const CardThemeData(
      color: XkColor.darkSurface, // #3A3A3A - Slightly brighter than background
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
    // On scroll: Structure (#2D2D2D) changes to slightly brighter color
    appBarTheme: AppBarTheme(
      backgroundColor: XkColor.structure,
      surfaceTintColor: XkColor.structure.withValues(alpha: 0.95), // Slightly brighter on scroll
      scrolledUnderElevation: 0.5, // Elevation on scroll
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
          return XkColor.canvas; // Canvas text (bright text in dark theme)
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
    
    // OutlinedButton Theme - Outlined Style (Dark Theme)
    // Secondary Button: Transparent background with Identity border and text
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

    // TextButton Theme - CTA Style (Dark Theme)
    // CTA: Canvas (#F5F5F5) background with Identity (#C0A062) text
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
          return XkColor.canvas; // Canvas background (bright background in dark theme)
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

