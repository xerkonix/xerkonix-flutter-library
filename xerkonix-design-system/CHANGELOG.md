# Changelog

All notable changes to this project will be documented in this file.

## 1.1.1

### Fixed
- Improved `XkHexagonRadar` dark-theme contrast so radar lines remain visible

### Changed
- Reorganized package documentation to English-first and Korean-second structure
- Clarified typography policy to explicitly use `IBM Plex Sans KR` and `IBM Plex Mono`
- Updated package/documentation version references for the `1.1.1` release

## 1.1.0

### Added
- Added XERKONIX DS v1.1 button variants: `brand`, `accent`, `tonal`, and `outline`
- Added v1.1 token families for light/dark colors, borders, and motion timings
- Added reduced-motion handling for motion widgets

### Changed
- Updated `XkColor` palette to align with `weave` design system v1.1 references
- Updated light/dark color schemes to v1.1 token mapping
- Updated `XkLightTheme` and `XkDarkTheme` defaults (typography, form, and button styling)
- Updated typography scale (`display/h1/h2/h3/body/label/meta`) to v1.1
- Fixed package font style declarations to use correct package names
- Kept backward-compatible aliases for legacy color and typography APIs

## 1.0.1

### Changes
- Fixed Pub Points: Reduced description length to meet pub.dev requirements
- Fixed static analysis: Moved `child` parameter to last position in widget constructors
- Updated all code comments to English
- Removed product-specific references from code comments

## 1.0.0

### Initial Release

- Complete Visual Identity System color palette implementation
- IBM Plex Sans typography system with NotoSansKR fallback
- Material Design 3 (M3Typo) and Human Interface Guidelines (HIGTypo) typography support
- Light and dark theme support with automatic text color inversion
- Shape and layout system (corner radius, spacing)
- Motion components (Breathing Light animation)
- Full Flutter 3.24+ and Dart 3.5+ compatibility
