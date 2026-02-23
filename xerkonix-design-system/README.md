# xerkonix_design_system

Flutter design system package for XERKONIX products.

This package provides a reusable token and component layer aligned with Weave design references, including colors, typography, themes, shape/layout tokens, iconography, components, pattern widgets, and motion primitives.

## Version

Current version: **1.1.0**

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  xerkonix_design_system: ^1.1.0
```

Requirements:

- Dart SDK: `>=3.5.0 <4.0.0`
- Flutter: `>=3.24.0`

## Quick Start

```dart
import 'package:flutter/material.dart';
import 'package:xerkonix_design_system/xerkonix_design_system.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: XkLightTheme.themeData,
      darkTheme: XkDarkTheme.themeData,
      home: const Scaffold(),
    );
  }
}
```

## Color Tokens

```dart
Container(
  color: XkColor.canvas,
  child: Text(
    'Weave',
    style: TextStyle(color: XkColor.text),
  ),
);

final brand = XkColor.identity;
final accent = XkColor.action;
final signal = XkColor.signal;
```

Main token groups:

- Surface: `canvas`, `surface`, `surfaceSoft`, `surfaceDeep`
- Text: `text`, `textBody`, `textSoft`, `textFaint`
- Brand/Accent: `identity`, `action`, `signal`
- Semantic: `success`, `warning`, `error`, `info`
- Dark overrides: `dark*` token set

Legacy names from `1.0.x` are still available as aliases for compatibility.

## Typography

```dart
Text('Display', style: XkTypo.display);
Text('Heading', style: XkTypo.h2);
Text('Body', style: XkTypo.body);
Text('Label', style: XkTypo.label);
Text('Meta', style: XkTypo.metaMono);
```

`XkTypo.title1`, `XkTypo.body`, `HIGTypo`, and `M3Typo` remain available.

Font baseline:

- Base / UI text: `IBM Plex Sans KR`
- Meta / code-like text: `IBM Plex Mono`

## Button Variants

```dart
Wrap(
  spacing: 8,
  children: [
    XkButton.primary(onPressed: () {}, child: const Text('Primary')),
    XkButton.brand(onPressed: () {}, child: const Text('Brand')),
    XkButton.accent(onPressed: () {}, child: const Text('Accent')),
    XkButton.tonal(onPressed: () {}, child: const Text('Tonal')),
    XkButton.outline(onPressed: () {}, child: const Text('Outline')),
  ],
);
```

Backward-compatible constructors (`outlined`, `success`, `warning`, `error`, `info`) are still supported.

## Components

```dart
const XkChip(label: 'trusted', variant: XkChipVariant.brand);

const XkInfoCard(
  metric: 'Metric Card',
  title: 'Primary Value',
  description: '핵심 수치 카드',
);

const XkAlert(
  title: '분석 완료',
  message: '핵심 지표와 권장 액션이 생성되었습니다.',
  variant: XkAlertVariant.success,
);
```

Form and table widgets:

- `XkTextInputField`
- `XkSelectField`
- `XkTextAreaField`
- `XkTable`

All widgets use company defaults by default, while exposing radius/padding/color overrides.

## Iconography

```dart
const XkIcon(XkIconName.chevRight);
const XkIcon(XkIconName.alert, size: XkIconSize.large);
```

- `XkIconName` includes all 48 icons from the HTML reference.
- `XkIconSize`: `inline`, `small`, `regular`, `large`, `display`, `hero`.

## Pattern Widgets

```dart
const XkKpiCard(label: '신뢰도', value: '92', suffix: '%');
const XkSignalOverviewMonitor();
const XkDomainPatternTabs();
```

Available pattern widgets:

- `XkKpiCard`
- `XkConfidenceMeter`
- `XkSignalTimeline`
- `XkSignalOverviewMonitor`
- `XkHexagonRadar`
- `XkClusterMatrix`
- `XkFlowCompression`
- `XkDomainPatternTabs`

## Motion

```dart
const XkStatusBreath();
const XkSignalSweep();
const XkWaveDrift();
const XkFocusRipple();
const XkCardSettle();
const XkAlertBeat();
```

Legacy wrappers are still available:

- `XkMotion.breathingLight(...)`
- `XkMotion.pulse(...)`

Motion defaults follow Weave timing tokens, and reduced-motion settings are respected.

## License

Apache License 2.0. See `LICENSE`.
