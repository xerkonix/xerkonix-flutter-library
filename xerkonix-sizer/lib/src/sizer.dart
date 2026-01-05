import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'unit.dart';

class Sizer {
  Sizer._();

  static UnitWidth unitWidth = UnitWidth();
  static UnitHeight unitHeight = UnitHeight();
  static UnitPadding unitPadding = UnitPadding();
  static double? _standardLogicalWidth;
  static double? _standardLogicalHeight;

  static void init({double? standardLogicalWidth, double? standardLogicalHeight}) {
    _standardLogicalWidth = standardLogicalWidth;
    _standardLogicalHeight = standardLogicalHeight;

    unitPadding.topSafeArea =
        MediaQueryData.fromView(PlatformDispatcher.instance.views.single)
            .padding
            .top;
    unitPadding.bottomSafeArea =
        MediaQueryData.fromView(PlatformDispatcher.instance.views.single)
            .padding
            .bottom;

    unitPadding.safeAreaPadding =
        unitPadding.topSafeArea + unitPadding.bottomSafeArea;

    unitWidth.max =
        MediaQueryData.fromView(PlatformDispatcher.instance.views.single)
            .size
            .width;

    unitHeight.max =
        MediaQueryData.fromView(PlatformDispatcher.instance.views.single)
            .size
            .height;

    unitWidth.standard = _standardLogicalWidth ?? unitWidth.max;
    unitHeight.standard = _standardLogicalHeight ?? unitHeight.max;

    // Ensure standard is at least 4 to avoid division issues
    if (unitWidth.standard < 4) {
      unitWidth.standard = 4;
    }
    if (unitHeight.standard < 4) {
      unitHeight.standard = 4;
    }

    unitWidth.lp4 = unitWidth.max / (unitWidth.standard / 4);
    unitHeight.lp4 = unitHeight.max / (unitHeight.standard / 4);

    // Calculate LP values using loop (lp4부터 lp500까지, 4씩 증가)
    _calculateLpValues(unitWidth, unitWidth.lp4);
    _calculateLpValues(unitHeight, unitHeight.lp4);
  }
}

class ResponsiveSizer {
  UnitWidth unitWidth = UnitWidth();
  UnitHeight unitHeight = UnitHeight();
  UnitPadding unitPadding = UnitPadding();
  late BuildContext context;

  ResponsiveSizer({required this.context}) {
    measure();
  }

  void measure() {
    unitPadding.topSafeArea =
        MediaQueryData.fromView(View.of(context)).padding.top;
    unitPadding.bottomSafeArea =
        MediaQueryData.fromView(View.of(context)).padding.bottom;

    unitPadding.safeAreaPadding =
        unitPadding.topSafeArea + unitPadding.bottomSafeArea;

    unitWidth.window = MediaQuery.of(context).size.width;

    unitHeight.window = MediaQuery.of(context).size.height;

    unitWidth.max = unitWidth.window;
    unitHeight.max = unitHeight.window;

    final standardWidth = Sizer._standardLogicalWidth ?? unitWidth.max;
    final standardHeight = Sizer._standardLogicalHeight ?? unitHeight.max;

    // Ensure standard is at least 4 to avoid division issues
    final safeStandardWidth = standardWidth < 4 ? 4.0 : standardWidth;
    final safeStandardHeight = standardHeight < 4 ? 4.0 : standardHeight;

    unitWidth.lp4 = unitWidth.max / (safeStandardWidth / 4);
    unitHeight.lp4 = unitHeight.max / (safeStandardHeight / 4);

    // Calculate LP values using loop
    _calculateLpValues(unitWidth, unitWidth.lp4);
    _calculateLpValues(unitHeight, unitHeight.lp4);
  }
}

/// Helper function to calculate LP values
void _calculateLpValues(UnitSize unit, double lp4) {
  unit.lp8 = lp4 * 2;
  unit.lp12 = lp4 * 3;
  unit.lp16 = lp4 * 4;
  unit.lp20 = lp4 * 5;
  unit.lp24 = lp4 * 6;
  unit.lp28 = lp4 * 7;
  unit.lp32 = lp4 * 8;
  unit.lp36 = lp4 * 9;
  unit.lp40 = lp4 * 10;
  unit.lp44 = lp4 * 11;
  unit.lp48 = lp4 * 12;
  unit.lp52 = lp4 * 13;
  unit.lp56 = lp4 * 14;
  unit.lp60 = lp4 * 15;
  unit.lp64 = lp4 * 16;
  unit.lp68 = lp4 * 17;
  unit.lp72 = lp4 * 18;
  unit.lp76 = lp4 * 19;
  unit.lp80 = lp4 * 20;
  unit.lp84 = lp4 * 21;
  unit.lp88 = lp4 * 22;
  unit.lp92 = lp4 * 23;
  unit.lp96 = lp4 * 24;
  unit.lp100 = lp4 * 25;
  unit.lp104 = lp4 * 26;
  unit.lp108 = lp4 * 27;
  unit.lp112 = lp4 * 28;
  unit.lp116 = lp4 * 29;
  unit.lp120 = lp4 * 30;
  unit.lp124 = lp4 * 31;
  unit.lp128 = lp4 * 32;
  unit.lp132 = lp4 * 33;
  unit.lp136 = lp4 * 34;
  unit.lp140 = lp4 * 35;
  unit.lp144 = lp4 * 36;
  unit.lp148 = lp4 * 37;
  unit.lp152 = lp4 * 38;
  unit.lp156 = lp4 * 39;
  unit.lp160 = lp4 * 40;
  unit.lp164 = lp4 * 41;
  unit.lp168 = lp4 * 42;
  unit.lp172 = lp4 * 43;
  unit.lp176 = lp4 * 44;
  unit.lp180 = lp4 * 45;
  unit.lp184 = lp4 * 46;
  unit.lp188 = lp4 * 47;
  unit.lp192 = lp4 * 48;
  unit.lp196 = lp4 * 49;
  unit.lp200 = lp4 * 50;
  unit.lp204 = lp4 * 51;
  unit.lp208 = lp4 * 52;
  unit.lp212 = lp4 * 53;
  unit.lp216 = lp4 * 54;
  unit.lp220 = lp4 * 55;
  unit.lp224 = lp4 * 56;
  unit.lp228 = lp4 * 57;
  unit.lp232 = lp4 * 58;
  unit.lp236 = lp4 * 59;
  unit.lp240 = lp4 * 60;
  unit.lp244 = lp4 * 61;
  unit.lp248 = lp4 * 62;
  unit.lp252 = lp4 * 63;
  unit.lp256 = lp4 * 64;
  unit.lp260 = lp4 * 65;
  unit.lp264 = lp4 * 66;
  unit.lp268 = lp4 * 67;
  unit.lp272 = lp4 * 68;
  unit.lp276 = lp4 * 69;
  unit.lp280 = lp4 * 70;
  unit.lp284 = lp4 * 71;
  unit.lp288 = lp4 * 72;
  unit.lp292 = lp4 * 73;
  unit.lp296 = lp4 * 74;
  unit.lp300 = lp4 * 75;
  unit.lp304 = lp4 * 76;
  unit.lp308 = lp4 * 77;
  unit.lp312 = lp4 * 78;
  unit.lp316 = lp4 * 79;
  unit.lp320 = lp4 * 80;
  unit.lp324 = lp4 * 81;
  unit.lp328 = lp4 * 82;
  unit.lp332 = lp4 * 83;
  unit.lp336 = lp4 * 84;
  unit.lp340 = lp4 * 85;
  unit.lp344 = lp4 * 86;
  unit.lp348 = lp4 * 87;
  unit.lp352 = lp4 * 88;
  unit.lp356 = lp4 * 89;
  unit.lp360 = lp4 * 90;
  unit.lp364 = lp4 * 91;
  unit.lp368 = lp4 * 92;
  unit.lp372 = lp4 * 93;
  unit.lp376 = lp4 * 94;
  unit.lp380 = lp4 * 95;
  unit.lp384 = lp4 * 96;
  unit.lp388 = lp4 * 97;
  unit.lp392 = lp4 * 98;
  unit.lp396 = lp4 * 99;
  unit.lp400 = lp4 * 100;
  unit.lp404 = lp4 * 101;
  unit.lp408 = lp4 * 102;
  unit.lp412 = lp4 * 103;
  unit.lp416 = lp4 * 104;
  unit.lp420 = lp4 * 105;
  unit.lp424 = lp4 * 106;
  unit.lp428 = lp4 * 107;
  unit.lp432 = lp4 * 108;
  unit.lp436 = lp4 * 109;
  unit.lp440 = lp4 * 110;
  unit.lp444 = lp4 * 111;
  unit.lp448 = lp4 * 112;
  unit.lp452 = lp4 * 113;
  unit.lp456 = lp4 * 114;
  unit.lp460 = lp4 * 115;
  unit.lp464 = lp4 * 116;
  unit.lp468 = lp4 * 117;
  unit.lp472 = lp4 * 118;
  unit.lp476 = lp4 * 119;
  unit.lp480 = lp4 * 120;
  unit.lp484 = lp4 * 121;
  unit.lp488 = lp4 * 122;
  unit.lp492 = lp4 * 123;
  unit.lp496 = lp4 * 124;
  unit.lp500 = lp4 * 125;
}
