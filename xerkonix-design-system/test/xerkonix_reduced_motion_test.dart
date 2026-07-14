import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xerkonix_design_system/xerkonix_design_system.dart';

Widget _wrap({required bool disableAnimations, required Widget child}) {
  return MediaQuery(
    data: MediaQueryData(disableAnimations: disableAnimations),
    child: Directionality(textDirection: TextDirection.ltr, child: child),
  );
}

void main() {
  group('L9 — reduced motion halts repeating tickers', () {
    testWidgets('breathingLight: no running animation when reduced motion on',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        _wrap(
          disableAnimations: true,
          child: XkMotion.breathingLight(
            child: const SizedBox(width: 10, height: 10),
          ),
        ),
      );
      await tester.pump();
      // Regression: previously the controller kept `repeat()`ing behind a
      // static frame, so a ticker stayed scheduled forever.
      expect(tester.hasRunningAnimations, isFalse);
    });

    testWidgets('breathingLight: animates when reduced motion off',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        _wrap(
          disableAnimations: false,
          child: XkMotion.breathingLight(
            child: const SizedBox(width: 10, height: 10),
          ),
        ),
      );
      await tester.pump();
      expect(tester.hasRunningAnimations, isTrue);
    });

    testWidgets('pulse: ticker stops when reduced motion toggles on',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        _wrap(
          disableAnimations: false,
          child: XkMotion.pulse(child: const SizedBox(width: 10, height: 10)),
        ),
      );
      await tester.pump();
      expect(tester.hasRunningAnimations, isTrue);

      await tester.pumpWidget(
        _wrap(
          disableAnimations: true,
          child: XkMotion.pulse(child: const SizedBox(width: 10, height: 10)),
        ),
      );
      await tester.pump();
      expect(tester.hasRunningAnimations, isFalse);
    });
  });
}
