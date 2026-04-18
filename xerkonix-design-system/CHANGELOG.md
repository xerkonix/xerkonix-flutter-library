# Changelog

All notable changes to this project will be documented in this file.

## 1.3.0 (BREAKING)

Aligned with Weave Design System v1.3 (`design system/v1.3/`). This release
drops v1.2 backward-compat shims; v1.3 canonical names are the only API.

### Changed
- `XkAlert` redesigned: replaced the v1.2 3px left border + tinted background
  with an 8px left solid block (rendered via `Stack`+`Positioned`) and an
  asymmetric border radius (square on the left, rounded on the right).
  Default background is now neutral `surface`; only `danger` keeps a tinted
  signal wash. Added optional mono 3-letter prefix (`SUC/INF/WRN/ERR`) on the
  trailing side.
- Rounded motion durations to remove fake precision:
  `statusPulse 2500ms` (was 2600), `rhythmLine 3500ms` (was 3800),
  `signalSweep 2500ms` (was 2600).
- Updated Weave interpretation-stage timings to v1.3 values:
  `observe 160→180ms`, `interpret 230→250ms`.
- `XkDomainPatternTabs` default labels changed from
  `Input/Pattern/State/Action Layer` to `수집 · 분석 · 상태 · 실행`.
- Documentation comments across color/shape/typography/button files updated
  to reference v1.3.

### Renamed (v1.2 → v1.3)
Motion widgets and tokens:
- `XkStatusBreath` → `XkStatusPulse`
- `XkWaveDrift` → `XkRhythmLine`
- `XkAlertBeat` → `XkAlertPulse`
- `XkMotion.statusBreath()` → `XkMotion.statusPulse()`
- `XkMotion.waveDrift()` → `XkMotion.rhythmLine()`
- `XkMotion.alertBeat()` → `XkMotion.alertPulse()`
- `XkMotionToken.statusBreath` → `XkMotionToken.statusPulse`
- `XkMotionToken.waveDrift` → `XkMotionToken.rhythmLine`
- `XkMotionToken.alertBeat` → `XkMotionToken.alertPulse`

Pattern widgets:
- `XkSignalOverviewMonitor` → `XkMetricTimeline`
- `XkClusterMatrix` → `XkDistributionHeatmap`
- `XkFlowCompression` → `XkPriorityFunnel`

### Added
- Alert mono meta prefix (`SUC/INF/WRN/ERR`) rendered by default; can be
  disabled with `showMetaPrefix: false` or overridden with custom `trailing`.

### Kept
- All color hex values (palette unchanged from v1.2).
- All 7 button variants (primary / action / brand / support / accent / tonal /
  outline). Default CTA policy clarified via dartdoc comments.
- Typography scale, shape/radius tokens, shadow tiers, spacing tokens.

### Migration
Replace v1.2 legacy names with the v1.3 canonical ones listed under **Renamed**
above. No behavioural change beyond the Alert redesign and the rounded motion
durations.

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
