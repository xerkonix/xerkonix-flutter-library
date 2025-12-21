# xerkonix_design_system

A comprehensive design system package for Flutter applications, providing consistent colors, typography, themes, shapes, and motion components based on the Visual Identity System with warm intelligence and minimal design philosophy.

## Features

- 🎨 **Color Palette**: Visual Identity System colors with warm intelligence (Canvas, Structure, Identity, Pulse, and semantic colors)
- 📝 **Typography**: IBM Plex Sans as main font with NotoSansKR fallback, supporting Material Design 3 (M3Typo) and Human Interface Guidelines (HIGTypo) typography systems
- 🌓 **Theme Support**: Light and dark theme compatibility with automatic text color inversion
- 📐 **Shape & Layout**: Consistent corner radius (8px ~ 12px) and spacing system
- ✨ **Motion**: Breathing Light animation for loading states
- 📱 **Platform Support**: Full support for all Flutter platforms

## Version

Current version: **1.0.1**

## Getting Started

### Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  xerkonix_design_system: ^1.0.1
```

### Requirements

- Dart SDK: `>=3.5.0 <4.0.0`
- Flutter: `>=3.24.0`

## Usage

### Colors

```dart
import 'package:xerkonix_design_system/xerkonix_design_system.dart';

// Use Visual Identity System colors
Container(
  color: XkColor.canvas,  // Warm Off-white background
  child: Text(
    'Deep Charcoal Text',
    style: TextStyle(color: XkColor.structure),  // Deep Charcoal
  ),
);

// Brand colors
Container(
  color: XkColor.identity,  // Muted Gold
  child: Text('Trust', style: TextStyle(color: XkColor.canvas)),
);

// Semantic colors
Text('Success', style: TextStyle(color: XkColor.success));
Text('Warning', style: TextStyle(color: XkColor.warning));
Text('Error', style: TextStyle(color: XkColor.error));
Text('Info', style: TextStyle(color: XkColor.info));
```

### Typography

```dart
import 'package:xerkonix_design_system/xerkonix_design_system.dart';

// XkTypo - Main typography system (IBM Plex Sans)
Text('Large Title', style: XkTypo.largeTitle);
Text('Title 1', style: XkTypo.title1);
Text('Body Text', style: XkTypo.body);

// Material Design 3 Typography
Text('Title Large', style: M3Typo.titleLarge);
Text('Body Medium', style: M3Typo.bodyMedium);

// Human Interface Guidelines Typography
Text('Title 1', style: HIGTypo.title1);
Text('Body', style: HIGTypo.body);
```

### Themes

```dart
import 'package:xerkonix_design_system/xerkonix_design_system.dart';

// Light theme
MaterialApp(
  theme: lightTheme,
  home: MyHomePage(),
);

// Dark theme (automatic text color inversion)
MaterialApp(
  theme: darkTheme,
  darkTheme: darkTheme,
  home: MyHomePage(),
);
```

### Shape & Layout

```dart
import 'package:xerkonix_design_system/xerkonix_design_system.dart';

// Corner radius
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(XkShape.cornerRadius),
    color: XkColor.surface,
  ),
);

// Spacing
Padding(
  padding: EdgeInsets.all(XkLayout.spacing),
  child: Text('Content'),
);
```

### Motion

```dart
import 'package:xerkonix_design_system/xerkonix_design_system.dart';

// Breathing Light animation for loading states
AnimatedBuilder(
  animation: XkMotion.breathingLight,
  builder: (context, child) {
    return Container(
      color: XkColor.identity.withOpacity(
        XkMotion.breathingLight.value,
      ),
    );
  },
);
```

## Design Philosophy

- **Warm Intelligence**: 차가운 디지털 화면이 아닌, '따뜻한 미색 종이 위에 깊은 먹색 잉크로 쓴 기록' 같은 느낌
- **Minimal & Deep**: 불필요한 장식을 배제하고, 여백을 통해 지적인 깊이감 표현
- **No Generic Tech Look**: 파란색 계열 사용 금지, 순백색 배경 지양

## Additional Information

- Version: v1.0.1
- License: Apache License 2.0 (see [LICENSE](LICENSE) file)
