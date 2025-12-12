import 'package:flutter/material.dart';

/// Light Color Scheme based on Visual Identity System
/// Canvas: #F5F5F5, Structure: #2D2D2D, Identity: #C0A062, Pulse: #FF6B6B
const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  // Identity (Muted Gold) - Primary
  primary: Color(0xFFC0A062), // Identity
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFE8D9B8), // Lighter version of Identity
  onPrimaryContainer: Color(0xFF2D2D2D), // Structure
  
  // Structure (Deep Charcoal) - Secondary
  secondary: Color(0xFF2D2D2D), // Structure
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFF4A4A4A), // Lighter version of Structure
  onSecondaryContainer: Color(0xFFF5F5F5), // Canvas
  
  // Canvas (Warm Off-white) - Tertiary
  tertiary: Color(0xFFF5F5F5), // Canvas
  onTertiary: Color(0xFF2D2D2D), // Structure
  tertiaryContainer: Color(0xFFFFFFFF),
  onTertiaryContainer: Color(0xFF2D2D2D), // Structure
  
  // Pulse (Human Coral) - Error/Alert
  error: Color(0xFFFF6B6B), // Pulse
  errorContainer: Color(0xFFFFE5E5), // Light coral
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF2D2D2D), // Structure
  
  // Background and Surface
  background: Color(0xFFF5F5F5), // Canvas
  onBackground: Color(0xFF2D2D2D), // Structure
  surface: Color(0xFFF5F5F5), // Canvas
  onSurface: Color(0xFF2D2D2D), // Structure
  surfaceVariant: Color(0xFFE8E8E8), // Slightly darker than Canvas
  onSurfaceVariant: Color(0xFF4A4A4A), // Lighter Structure
  
  // Outline and Inverse
  outline: Color(0xFF8A8A8A), // Medium gray
  onInverseSurface: Color(0xFF2D2D2D), // Structure
  inverseSurface: Color(0xFFF5F5F5), // Canvas
  inversePrimary: Color(0xFFD4B87A), // Lighter Identity
  
  // Shadow and Tint
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFFC0A062), // Identity
);

