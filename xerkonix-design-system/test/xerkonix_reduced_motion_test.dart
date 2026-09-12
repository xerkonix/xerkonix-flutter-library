import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xerkonix_design_system/xerkonix_design_system.dart';

Widget _wrap({required bool disableAnimations, required Widget child}) {
  return MediaQuery(
    data: MediaQueryData(disableAnimations: disableAnimations),
    child: Theme(
      data: XkLightTheme.themeData,
      child: Directionality(textDirection: TextDirection.ltr, child: child),
    ),
  );
}

void main() {
  group('L9 — reduced motion halts repeating tickers', () {
    testWidgets('XkLoader: no running animation when reduced motion on',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        _wrap(
          disableAnimations: true,
          child: const SizedBox(
            width: 200,
            child: XkLoader(),
          ),
        ),
      );
      await tester.pump();
      expect(tester.hasRunningAnimations, isFalse);
    });

    testWidgets('XkLoader: animates when reduced motion off',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        _wrap(
          disableAnimations: false,
          child: const SizedBox(
            width: 200,
            child: XkLoader(),
          ),
        ),
      );
      await tester.pump();
      expect(tester.hasRunningAnimations, isTrue);
    });

    testWidgets('XkGemSweep: ticker stops when reduced motion on',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        _wrap(
          disableAnimations: false,
          child: const SizedBox(
            width: 80,
            height: 40,
            child: XkGemSweep(enabled: true),
          ),
        ),
      );
      await tester.pump();
      expect(tester.hasRunningAnimations, isTrue);

      await tester.pumpWidget(
        _wrap(
          disableAnimations: true,
          child: const SizedBox(
            width: 80,
            height: 40,
            child: XkGemSweep(enabled: true),
          ),
        ),
      );
      await tester.pump();
      expect(tester.hasRunningAnimations, isFalse);
    });

    testWidgets('breathingLight/pulse are static (no ticker)',
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
      expect(tester.hasRunningAnimations, isFalse);
    });
  });
}
