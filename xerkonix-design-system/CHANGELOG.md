# Changelog

All notable changes to this project will be documented in this file.

## 3.2.0

TACTILE v2.3.0 대응 — 가독성 개편.

- 면 분리: `bg #F5F5F7` · `surface #FFFFFF` · `surface2 #EFF0F3` · `border #E3E5EA`
  (gray 별칭에서 독립값으로 — 파리티 테스트도 직접 대조로 승격).
- 잉크: `textMuted #575866`(6.44:1) · `anchor #686975`(옛 gray-500 은 AA 위반) ·
  `darkTextMuted #9FA0A9`.
- 신설: `well`/`darkWell`(입력·트랙 우물), `point`/`pointDeep`/`pointInd` +
  다크 원석 단일(`darkPoint #62CBDB`). 계약 — 링크·켜짐·인디케이터 전용,
  `pointInd` 는 문구 금지, CTA 는 여전히 근흑 잉크.
- 배선: `XkProgressBar` 트랙=well · 채움=pointInd. `XkShadow.lightLowlight`
  rgba(144,147,166,.5) 로 톤 보정.
- 파리티: 표면 4종 + 우물·포인트 4종 대조 그룹 추가.

## 3.1.0 — TACTILE v2.2 tokens

Additive only; no existing API or value changes. Mirrors TACTILE v2.2.0, which
itself changed no values — it added a hierarchy layer on top of the existing
scales.

### Added
- **Ink hierarchy** — `XkColor.inkDisplay` / `anchor` (+ `darkInkDisplay` /
  `darkAnchor`). Display ink for large headings and hero figures, anchor for
  section hooks/labels. The point is to stop hanging hierarchy on size alone.
- **Functional color slots** — `successVivid` / `warningVivid` / `errorVivid`
  for icons, status glyphs and gauges (non-text 3:1; the base colors are
  darkened to clear text AA, which turns the orange brown). **Never use vivid
  on text.** `successBorder` / `warningBorder` / `errorBorder` give a soft
  plane its edge so a translucent dark soft does not dissolve into the
  background. Dark vivid aliases the base color, matching canon.
- **Information layer** — `XkShadow.elevatedLight` / `elevatedDark`
  (`--shadow-sm`): a single soft drop for elevated *information* cards,
  deliberately a different vocabulary from the neumorphic `raised*` pair which
  belongs to the touchable layer. At most one or two per section.
- **Section rhythm** — `XkLayout.sectionLo` (72) / `sectionHi` (112). The old
  fixed 88 section padding is retired; the 32–48 group band
  (`spacing2xl`/`spacing3xl`) is the band to reach for.
- **Ops-screen page title** — `XkTypo.pageTitle` (28/36, serif 600), the
  `--fs-page-title` contract for admin/console screens.

### Tests
- `token_canon_parity_test.dart` covers every token above (15 → 22 tests) and
  gains a **coverage net**: it enumerates every declaration in canon's `:root`
  and fails unless each one is either mirrored or listed with a reason for not
  being mirrored. Previously the suite compared only mapped pairs, so a new
  canon token could go missing silently — which is exactly how the v2.2 tokens
  sat unmirrored. Verified by injecting a token into canon and watching the
  test fail with its name.
- Dark-block `var()` references now resolve through `:root` (CSS cascade); the
  dark block only carries overrides, so `var(--gray-000)` had no local answer.

## 3.0.0 (BREAKING) — TACTILE Design System

Full re-skin from Weave v1.5 to **TACTILE**, a neumorphic system. Elevation is
now carried by paired highlight + lowlight shadows (and inset inner shadows)
rather than by a single soft drop, and the indigo accent collapses to a
monochrome ink accent (near-black in light, near-white in dark). Token *names*
are preserved, so most call sites keep resolving; the values and the visual
language change, so this is a breaking release.

### Changed — tokens
- **Palette (`XkColor`)**: retuned the full `gray000..gray950` scale and every
  semantic token (`bg / surface / surface2 / border`, `textStrong/Body/Muted`,
  `accent(+Deep/+Soft/+Text)`, `success/warning/error(+Soft)`, and all `dark*`
  equivalents) to TACTILE values. `accent` is now a monochrome ink
  (`#232430` light / `#F1F1F4` dark); `accentDeep` is the accent-hover step.
- **Added a warm/cool temperature accent pair**: `tempWarm(+Soft)` /
  `tempCool(+Soft)` and `darkTempWarm(+Soft)` / `darkTempCool(+Soft)`, for data
  that reads on a hot↔cold axis. `XkColor.tertiary` and `ColorScheme.tertiary`
  now map to the cool temperature accent.
- **Elevation (`XkShadow`)**: the single-drop shadow is replaced by a
  **neumorphic paired-shadow layer** — `raised` / `lifted` / `raisedSoft`
  `List<BoxShadow>` (each a highlight + lowlight pair) plus the underlying
  `lightLowlight/lightHighlight/darkLowlight/darkHighlight` colors. The legacy
  `resolve(brightness, [level])` API is kept (sm/md → raised, lg → lifted), so
  existing consumers (e.g. `XkPattern`) keep compiling.

### Added — neumorphic primitive
- **`XkNeumorphic`** container widget (`XkNeumorphicStyle.raised | inset | flat`)
  — the core TACTILE surface. `Material` `CardTheme`/`ButtonStyle` cannot
  express dual or inset shadows, so this fills the gap; a tappable `raised`
  surface presses to `inset` while held. `XkNeumorphic.decoration(...)` exposes
  the raised `BoxDecoration` for callers that build their own containers.
- **`XkInsetShadowPainter`** — a reusable `CustomPainter` that emulates an inset
  (inner) shadow, since Flutter's `BoxShadow` only casts outward.

### Changed — components (public APIs preserved)
- `XkButton` (all factories unchanged): every variant now renders as a
  neumorphic surface — raised at rest, pressed *into* the canvas (inner shadow)
  while held, with a subtle press scale. Emphasis is carried by elevation, not
  hue.
- `XkCard` / `XkInfoCard` / `XkTable` / `XkErrorPane` / `XkAlert`: raised
  neumorphic surfaces (paired shadow) instead of a flat 1px border.
- `XkChip`: variant/static chips are softly raised pills; two-state
  `selected` chips press to inset when selected.
- `XkBadge`: subtly raised chiclet.
- Inputs (`XkTextInputField` / `XkTextAreaField` / `XkSelectField`): rendered as
  sunken (inset) wells — a recessed fill with an inner shadow and a borderless
  field. The global `inputDecorationTheme` is retuned to match.
- `XkAvatar`: gradients refreshed to TACTILE tokens + the temperature pair.
- Themes (`XkLightTheme` / `XkDarkTheme`): TACTILE color mapping, flat
  (elevation-0, transparent-tint) Material buttons/cards, sunken inputs, and a
  new `switchTheme` so Material `Switch` toggles adopt the ink accent.

### Breaking / behavior notes
- No public class or member was **removed or renamed**; source that referenced
  token names, widgets, or factories continues to compile.
- Visual output changes across the board (color, elevation, input chrome), and
  interaction affordances shifted: `XkButton` and tappable `XkCard` now use a
  press-to-inset gesture surface rather than a Material `InkWell` ripple, so
  ripple-dependent expectations change.
- `XkInfoCard` / `XkCard` no longer paint a default hairline border; pass
  `borderColor` on `XkInfoCard` to restore one.

### Tooling
- Bumped example constraints for the sibling packages
  (`xerkonix-error-handler` / `-logger` / `-sizer` / `-http` examples) from
  `xerkonix_design_system: ^1.1.1` (which excluded 2.x/3.x) to `^3.0.0` so
  `flutter pub get` resolves.

## 2.1.1

- Fix: dedupe unreachable accent branches in `XkPattern._resolveGradientEnd` (no behavior change).
- Tidy: `ColorScheme.secondary` now uses `accentDeep` (was identical to `primary`) for proper primary/secondary differentiation.

## 2.1.0 — Product-primitive parity (additive)

Additive modernization that makes the package a superset of the product's real
UI primitives. No existing public API is removed or changed in a
backward-incompatible way; all new behavior is opt-in.

### Added
- `XkBrandMark {size, primary?, secondary?}` — generic ring + arc + dot mark
  primitive (defaults to accent/brand tokens; not hardcoded to any brand).
- `XkBadge {label, color?}` + `XkBadge.beta()` preset — uppercased tracked-out
  status badge (covers the "OPEN BETA" badge).
- `XkAvatar {name, size = 44}` — deterministic initials + gradient avatar.
- `XkSkeleton {height, width?, radius}`, `XkSkeletonCard`,
  `XkSkeletonList {count, padding?}` — pulsing loading placeholders.
- `XkLoadingOverlay {message, visible}` — full-screen dual-ring spinner + message.
- `XkToast` + `showXkToast(context, message, {isError})` — top-sliding overlay
  toast with auto/tap dismiss and a `SnackBar` fallback.
- `XkSectionLabel {title, trailing?}` — uppercased tracked-out section header.
- `XkBackButton {label, onPressed}` — chevron-left text button.
- `XkCard {child, onTap?, padding?}` — generic tappable bordered surface
  (base sibling of `XkInfoCard`, which is unchanged).
- `XkProgressBar {value /*0..1*/, minHeight = 6, color?}` — thin rounded bar.
- `XkLoadingPane`, `XkEmptyPane {message}`,
  `XkErrorPane {message, onRetry?, retryLabel}` — state panes.

### Changed (backward-compatible)
- `XkButton`: new optional `expanded` (full-width) on every factory, and a new
  `XkButton.primaryGradient(...)` gradient-fill accent CTA. Existing factories
  and call sites are unaffected (defaults preserve prior behavior).
- `XkChip`: new optional `selected` two-state (selectable/filter) mode. When
  `selected` is null (default), the original static/variant behavior is kept.

### Tooling
- `environment.sdk` `>=3.9.0 <4.0.0`, `flutter` `>=3.35.0`.
- `flutter_svg` `^2.3.0`.

## 2.0.0 (BREAKING) — Weave Design System v1.5

Full re-skin to Weave v1.5: warm beige/gold system replaced by a cool
gray-blue neutral scale with a single indigo accent. Token vocabulary is
replaced with no backward-compat aliases, so this is a breaking release.

### Changed
- Palette: new `gray000..gray950` scale; `bg / surface / surface2 / border`,
  `textStrong / textBody / textMuted`, `brand`, `accent(+Deep/+Soft/+Text)`,
  `success/warning/error(+Soft)` and `dark*` equivalents.
- Token renames (no aliases): `canvas→bg`, `surfaceSoft/Support/Deep/Sunken→surface2`,
  `text→textStrong`, `textSoft→textMuted`, `identity*/action*→accent*`,
  `support→success`, `signal→error`, `info→gray600`, `border*→border`.
- Typography: base font `Pretendard`; display (≥28px) uses `MaruBuri` serif;
  data/meta stays `IBM Plex Mono`. Pretendard + MaruBuri fonts bundled.
- Motion: `interpret→resolve` (260ms), `connect→settle` (320ms); `ease`
  curve is now `Cubic(0.33, 0.02, 0.2, 1)`.

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
