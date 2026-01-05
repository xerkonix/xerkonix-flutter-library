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

// Available logical pixel values: lp4, lp8, lp12, lp16, lp20, lp24, lp28, lp32, lp36, lp40, lp44, lp48, lp52, lp56, lp60, lp64, lp68, lp72, lp76, lp80, lp84, lp88, lp92, lp96, lp100, lp104, lp108, lp112, lp116, lp120, lp124, lp128, lp132, lp136, lp140, lp144, lp148, lp152, lp156, lp160, lp164, lp168, lp172, lp176, lp180, lp184, lp188, lp192, lp196, lp200, lp204, lp208, lp212, lp216, lp220, lp224, lp228, lp232, lp236, lp240, lp244, lp248, lp252, lp256, lp260, lp264, lp268, lp272, lp276, lp280, lp284, lp288, lp292, lp296, lp300, lp304, lp308, lp312, lp316, lp320, lp324, lp328, lp332, lp336, lp340, lp344, lp348, lp352, lp356, lp360, lp364, lp368, lp372, lp376, lp380, lp384, lp388, lp392, lp396, lp400, lp404, lp408, lp412, lp416, lp420, lp424, lp428, lp432, lp436, lp440, lp444, lp448, lp452, lp456, lp460, lp464, lp468, lp472, lp476, lp480, lp484, lp488, lp492, lp496, lp500
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

The package provides predefined logical pixel values from lp4 to lp500 (in increments of 4) for consistent sizing:

- **Range**: lp4, lp8, lp12, lp16, lp20, lp24, lp28, lp32, ... lp496, lp500
- **Total**: 125 predefined values (lp4 to lp500, step 4)
- **Examples**: lp4, lp8, lp16, lp24, lp32, lp64, lp100, lp200, lp300, lp400, lp500

## Additional Information

- Version: v1.0.0
- License: Apache License, Version 2.0 (see [LICENSE](LICENSE) file)
