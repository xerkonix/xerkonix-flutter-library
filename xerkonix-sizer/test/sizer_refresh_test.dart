import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xerkonix_sizer/xerkonix_sizer.dart';

void main() {
  group('N35 — Sizer re-measures instead of freezing on first read', () {
    testWidgets('init measures without throwing (no views.single crash)',
        (WidgetTester tester) async {
      addTearDown(Sizer.dispose);
      Sizer.init(standardLogicalWidth: 400, standardLogicalHeight: 800);
      expect(Sizer.unitWidth.max, greaterThan(0));
      expect(Sizer.unitHeight.max, greaterThan(0));
      expect(Sizer.unitWidth.lp8, Sizer.unitWidth.lp4 * 2);
    });

    testWidgets('refresh() re-reads the view (values are not frozen)',
        (WidgetTester tester) async {
      addTearDown(Sizer.dispose);
      Sizer.init();
      final double measured = Sizer.unitWidth.max;
      expect(measured, greaterThan(0));

      // Simulate a stale global, then re-measure: the old code had no way to
      // update after the first read; refresh() must recompute from the view.
      Sizer.unitWidth.max = -1;
      Sizer.refresh();
      expect(Sizer.unitWidth.max, measured);
    });

    testWidgets('metrics change auto-triggers a re-measure via the observer',
        (WidgetTester tester) async {
      addTearDown(tester.view.reset);
      addTearDown(Sizer.dispose);
      Sizer.init();
      final double measured = Sizer.unitWidth.max;

      Sizer.unitWidth.max = -1; // stale
      // Any metrics change should reach the registered observer.
      tester.view.physicalSize = const Size(1234, 567);
      await tester.pump();
      expect(Sizer.unitWidth.max, measured);
    });
  });
}
