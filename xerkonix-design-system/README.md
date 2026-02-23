# xerkonix_design_system

Flutter design system package for XERKONIX products.

This package provides a reusable token and component layer aligned with the Weave design references (`v1.1`), including colors, typography, themes, shape/layout tokens, motion presets, and button variants.

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
    'Weave v1.1',
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

## Motion

```dart
XkMotion.breathingLight(
  child: const Icon(Icons.bolt),
);

XkMotion.pulse(
  child: const Icon(Icons.notifications),
);
```

Motion defaults follow v1.1 timing tokens, and reduced-motion settings are respected.

## License

Apache License 2.0. See `LICENSE`.
