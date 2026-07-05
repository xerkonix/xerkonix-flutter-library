# Changelog

All notable changes to this project will be documented in this file.

## 1.1.0

### Added — width-class breakpoint system

An additive, opt-in breakpoint system that sits alongside the existing logical
pixel (`lp`) scaling API. The `Sizer.init`, `unitWidth.lpXXX` and
`ResponsiveSizer` APIs are unchanged and remain fully supported.

- `XkWidthClass` enum (`mobile`, `tablet`, `desktop`).
- `XkBreakpoints` configuration with sensible, overridable defaults
  (`mobile = 760`, `desktop = 1080`) and a `classify(width)` helper.
- `xkWidthClass(width)` top-level helper.
- `BoxConstraints` extension (`widthClass`, `isMobile`, `isTablet`,
  `isDesktop`) for use inside a `LayoutBuilder`.
- `BuildContext` extension (`widthClass`, `isMobile`, `isTablet`,
  `isDesktop`) reading `MediaQuery.sizeOf`.
- `XkResponsiveLayout` widget (default builder + `.slots` constructor) that
  switches its child by width class via `LayoutBuilder`.

### Changed

- Bumped minimum requirements to Dart `>=3.9.0` and Flutter `>=3.35.0`.

## 1.0.0

### Initial Release

- Responsive sizing utility package for Flutter applications
- Adaptive layout calculations based on screen dimensions
- Support for both static and context-based sizing
- Logical pixel (lp) based sizing system
- Safe area padding calculations
- Standard width/height configuration
- Predefined logical pixel values for consistent sizing
- Full Flutter 3.24+ and Dart 3.5+ compatibility
