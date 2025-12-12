import 'package:flutter/material.dart';

/// Dark Color Scheme based on Visual Identity System
/// Background: #2D2D2D (Structure), Structure: #F5F5F5 (Canvas - swapped)
/// Identity: #C0A062, Pulse: #FF6B6B
const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  // Identity (Muted Gold) - Primary (same as light)
  primary: Color(0xFFC0A062), // Identity
  onPrimary: Color(0xFF2D2D2D), // Structure (dark background)
  primaryContainer: Color(0xFF9A7D4F), // Darker version of Identity
  onPrimaryContainer: Color(0xFFF5F5F5), // Canvas (light text)
  
  // Canvas (Warm Off-white) - Secondary (swapped from light)
  secondary: Color(0xFFF5F5F5), // Canvas (swapped - now text color)
  onSecondary: Color(0xFF2D2D2D), // Structure (dark background)
  secondaryContainer: Color(0xFFE0E0E0), // Slightly darker Canvas
  onSecondaryContainer: Color(0xFF2D2D2D), // Structure
  
  // Structure (Deep Charcoal) - Tertiary (swapped from light)
  tertiary: Color(0xFF2D2D2D), // Structure (swapped - now background)
  onTertiary: Color(0xFFF5F5F5), // Canvas (light text)
  tertiaryContainer: Color(0xFF1A1A1A), // Darker Structure
  onTertiaryContainer: Color(0xFFF5F5F5), // Canvas
  
  // Pulse (Human Coral) - Error/Alert (same as light)
  error: Color(0xFFFF6B6B), // Pulse
  errorContainer: Color(0xFFCC5555), // Darker coral
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFFFFE5E5), // Light coral
  
  // Background and Surface (swapped from light)
  background: Color(0xFF2D2D2D), // Structure (swapped - now background)
  onBackground: Color(0xFFF5F5F5), // Canvas (swapped - now text)
  surface: Color(0xFF2D2D2D), // Structure
  onSurface: Color(0xFFF5F5F5), // Canvas
  surfaceVariant: Color(0xFF3A3A3A), // Slightly lighter Structure
  onSurfaceVariant: Color(0xFFE0E0E0), // Lighter Canvas
  
  // Outline and Inverse
  outline: Color(0xFF6A6A6A), // Medium gray
  onInverseSurface: Color(0xFFF5F5F5), // Canvas
  inverseSurface: Color(0xFF2D2D2D), // Structure
  inversePrimary: Color(0xFFD4B87A), // Lighter Identity
  
  // Shadow and Tint
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFFC0A062), // Identity
);