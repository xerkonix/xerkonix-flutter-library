import 'package:flutter_test/flutter_test.dart';
import 'package:xerkonix_sizer/xerkonix_sizer.dart';
import 'package:flutter/widgets.dart';

void main() {
  group('Sizer Tests', () {
    test('Sizer.init should initialize with standard dimensions', () {
      Sizer.init(
        standardLogicalWidth: 400,
        standardLogicalHeight: 800,
      );
      
      expect(Sizer.unitWidth.standard, 400);
      expect(Sizer.unitHeight.standard, 800);
    });

    test('Sizer should calculate lp4 correctly', () {
      Sizer.init(
        standardLogicalWidth: 400,
        standardLogicalHeight: 800,
      );
      
      // lp4 = max / (standard / 4)
      // If max = 400, standard = 400, then lp4 = 400 / (400/4) = 4
      expect(Sizer.unitWidth.lp4, greaterThan(0));
      expect(Sizer.unitHeight.lp4, greaterThan(0));
    });

    test('Sizer should calculate lp values as multiples of lp4', () {
      Sizer.init(
        standardLogicalWidth: 400,
        standardLogicalHeight: 800,
      );
      
      expect(Sizer.unitWidth.lp8, Sizer.unitWidth.lp4 * 2);
      expect(Sizer.unitWidth.lp12, Sizer.unitWidth.lp4 * 3);
      expect(Sizer.unitWidth.lp16, Sizer.unitWidth.lp4 * 4);
      expect(Sizer.unitWidth.lp20, Sizer.unitWidth.lp4 * 5);
      
      expect(Sizer.unitHeight.lp8, Sizer.unitHeight.lp4 * 2);
      expect(Sizer.unitHeight.lp12, Sizer.unitHeight.lp4 * 3);
      expect(Sizer.unitHeight.lp16, Sizer.unitHeight.lp4 * 4);
      expect(Sizer.unitHeight.lp20, Sizer.unitHeight.lp4 * 5);
    });

    test('Sizer should initialize safe area padding', () {
      Sizer.init();
      
      expect(Sizer.unitPadding.topSafeArea, greaterThanOrEqualTo(0));
      expect(Sizer.unitPadding.bottomSafeArea, greaterThanOrEqualTo(0));
      expect(
        Sizer.unitPadding.safeAreaPadding,
        Sizer.unitPadding.topSafeArea + Sizer.unitPadding.bottomSafeArea,
      );
    });

    test('Sizer should set max dimensions', () {
      Sizer.init();
      
      expect(Sizer.unitWidth.max, greaterThan(0));
      expect(Sizer.unitHeight.max, greaterThan(0));
    });
  });

  group('UnitSize Tests', () {
    test('UnitWidth should have all lp values', () {
      Sizer.init(standardLogicalWidth: 400, standardLogicalHeight: 800);
      
      expect(Sizer.unitWidth.lp4, isNotNull);
      expect(Sizer.unitWidth.lp8, isNotNull);
      expect(Sizer.unitWidth.lp12, isNotNull);
      expect(Sizer.unitWidth.lp16, isNotNull);
      expect(Sizer.unitWidth.lp100, isNotNull);
      expect(Sizer.unitWidth.lp200, isNotNull);
      expect(Sizer.unitWidth.lp500, isNotNull);
    });

    test('UnitHeight should have all lp values', () {
      Sizer.init(standardLogicalWidth: 400, standardLogicalHeight: 800);
      
      expect(Sizer.unitHeight.lp4, isNotNull);
      expect(Sizer.unitHeight.lp8, isNotNull);
      expect(Sizer.unitHeight.lp12, isNotNull);
      expect(Sizer.unitHeight.lp16, isNotNull);
      expect(Sizer.unitHeight.lp100, isNotNull);
      expect(Sizer.unitHeight.lp200, isNotNull);
      expect(Sizer.unitHeight.lp500, isNotNull);
    });
  });
}

