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
    testWidgets('XkLoader: no running animation when reduced motion on', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          disableAnimations: true,
          child: const SizedBox(width: 200, child: XkLoader()),
        ),
      );
      await tester.pump();
      expect(tester.hasRunningAnimations, isFalse);
    });

    testWidgets('XkLoader: animates when reduced motion off', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          disableAnimations: false,
          child: const SizedBox(width: 200, child: XkLoader()),
        ),
      );
      await tester.pump();
      expect(tester.hasRunningAnimations, isTrue);
    });

    testWidgets('XkGemSweep: ticker stops when reduced motion on', (
      WidgetTester tester,
    ) async {
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

    testWidgets('breathingLight/pulse are static (no ticker)', (
      WidgetTester tester,
    ) async {
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

  group('product screen 6-B motion', () {
    // One ThemeData instance: a fresh one per pump would start AnimatedTheme.
    final ThemeData theme = XkTactileTheme.themeData(Brightness.light);
    Widget host({required bool reduce, required Widget child}) {
      return MaterialApp(
        theme: theme,
        home: MediaQuery(
          data: MediaQueryData(disableAnimations: reduce),
          child: Scaffold(body: Center(child: child)),
        ),
      );
    }

    double opacityOf(WidgetTester tester) => tester
        .widget<FadeTransition>(
          find
              .ancestor(
                of: find.text('view'),
                matching: find.byType(FadeTransition),
              )
              .first,
        )
        .opacity
        .value;

    testWidgets('XkTactileRouteFade: 180 ms opacity once', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        host(
          reduce: false,
          child: const XkTactileRouteFade(child: Text('view')),
        ),
      );
      expect(tester.hasRunningAnimations, isTrue);
      expect(opacityOf(tester), 0);
      await tester.pump(const Duration(milliseconds: 90));
      expect(opacityOf(tester), inExclusiveRange(0, 1));
      await tester.pump(const Duration(milliseconds: 91));
      expect(opacityOf(tester), 1);
      expect(tester.hasRunningAnimations, isFalse);
      expect(XkTactileRouteFade.routeFadeCurve, const Cubic(0.2, 0, 0, 1));
    });

    testWidgets('XkTactileRouteFade: reduced motion shows at once', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        host(
          reduce: true,
          child: const XkTactileRouteFade(child: Text('view')),
        ),
      );
      expect(tester.hasRunningAnimations, isFalse);
      expect(opacityOf(tester), 1);
    });

    testWidgets('completion light plays once, then stops (no loop)', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        host(
          reduce: false,
          child: const XkTactileAppIntro(completion: true, child: Text('완료')),
        ),
      );
      await tester.pump(const Duration(milliseconds: 700));
      expect(
        find.byKey(const ValueKey<String>('xk-tactile-completion-sheen')),
        findsOneWidget,
      );
      expect(tester.hasRunningAnimations, isTrue);
      await tester.pump(const Duration(milliseconds: 701));
      expect(tester.hasRunningAnimations, isFalse);
      expect(
        find.byKey(const ValueKey<String>('xk-tactile-completion-sheen')),
        findsNothing,
      );
      // Rebuilding with completion still true does not replay it.
      await tester.pumpWidget(
        host(
          reduce: false,
          child: const XkTactileAppIntro(completion: true, child: Text('완료!')),
        ),
      );
      expect(tester.hasRunningAnimations, isFalse);
    });

    testWidgets('turning completion on keeps the child state', (
      WidgetTester tester,
    ) async {
      Widget intro(bool done) => host(
        reduce: false,
        child: XkTactileAppIntro(completion: done, child: const _StateProbe()),
      );
      await tester.pumpWidget(intro(false));
      final State<_StateProbe> before = tester.state(find.byType(_StateProbe));
      await tester.pumpWidget(intro(true));
      expect(tester.state(find.byType(_StateProbe)), same(before));
      expect(
        find.byKey(const ValueKey<String>('xk-tactile-completion-sheen')),
        findsNothing,
        reason: 'first frame is v=0 — nothing painted yet',
      );
      await tester.pump(const Duration(milliseconds: 700));
      expect(
        find.byKey(const ValueKey<String>('xk-tactile-completion-sheen')),
        findsOneWidget,
      );
      await tester.pumpAndSettle();
      expect(tester.state(find.byType(_StateProbe)), same(before));
    });

    testWidgets('completion light: reduced motion paints nothing', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        host(
          reduce: true,
          child: const XkTactileAppIntro(completion: true, child: Text('완료')),
        ),
      );
      await tester.pump(const Duration(milliseconds: 700));
      expect(tester.hasRunningAnimations, isFalse);
      expect(
        find.byKey(const ValueKey<String>('xk-tactile-completion-sheen')),
        findsNothing,
      );
    });
  });
}

class _StateProbe extends StatefulWidget {
  const _StateProbe();

  @override
  State<_StateProbe> createState() => _StateProbeState();
}

class _StateProbeState extends State<_StateProbe> {
  @override
  Widget build(BuildContext context) => const Text('완료');
}
