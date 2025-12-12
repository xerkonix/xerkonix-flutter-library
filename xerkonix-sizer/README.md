# xerkonix_sizer

A responsive sizing utility package for Flutter applications that provides adaptive layout calculations based on screen dimensions. Supports both fixed and responsive sizing with logical pixel (lp) calculations for consistent UI scaling across different device sizes.

## Features

- 📐 Responsive sizing based on logical pixels (lp)
- 📱 Support for both static and context-based sizing
- 🎯 Safe area padding calculations
- ⚙️ Standard width/height configuration
- 🔄 Automatic scaling based on device dimensions

## Version

**Current version: v1.0.0**

## Getting Started

### Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  xerkonix_sizer: ^1.0.0
```

### Requirements

- Dart SDK: `>=3.5.0 <4.0.0`
- Flutter: `>=3.24.0`

## Usage

### Initialize Sizer

```dart
import 'package:xerkonix_sizer/xerkonix_sizer.dart';

// Initialize Sizer with standard dimensions
Sizer.init(standardLogicalWidth: 420, standardLogicalHeight: 920);
```

### Static Sizer Usage

```dart
// Use static Sizer for fixed sizing
double width = Sizer.unitWidth.lp16;
double height = Sizer.unitHeight.lp24;

// Available logical pixel values: lp1, lp2, lp4, lp8, lp12, lp16, lp20, lp24, lp32, lp40, lp48, lp56, lp64, lp80, lp96, lp128, lp160, lp192, lp224, lp256, lp320, lp384, lp448, lp512
Container(
  width: Sizer.unitWidth.lp16,
  height: Sizer.unitHeight.lp24,
  child: Text('Responsive Container'),
);
```

### ResponsiveSizer Usage

```dart
// Use ResponsiveSizer in widgets for context-based sizing
ResponsiveSizer responsiveSizer = ResponsiveSizer(context: context);
double responsiveWidth = responsiveSizer.unitWidth.lp16;
double responsiveHeight = responsiveSizer.unitHeight.lp24;

// In a widget
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sizer = ResponsiveSizer(context: context);
    return Container(
      width: sizer.unitWidth.lp16,
      height: sizer.unitHeight.lp24,
      child: Text('Responsive Widget'),
    );
  }
}
```

### Safe Area Support

```dart
// ResponsiveSizer automatically handles safe area padding
ResponsiveSizer responsiveSizer = ResponsiveSizer(context: context);
// Safe area padding is automatically calculated
```

## Logical Pixel Values

The package provides predefined logical pixel values for consistent sizing:

- Small: lp1, lp2, lp4, lp8, lp12
- Medium: lp16, lp20, lp24, lp32, lp40, lp48, lp56, lp64
- Large: lp80, lp96, lp128, lp160, lp192, lp224, lp256, lp320, lp384, lp448, lp512

## Additional Information

- Version: v1.0.0
- License: Apache License, Version 2.0 (see [LICENSE](LICENSE) file)
