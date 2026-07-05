import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xerkonix_sizer/xerkonix_sizer.dart';

void main() {
  group('XkBreakpoints defaults', () {
    const XkBreakpoints bp = XkBreakpoints.defaults;

    test('mobile below the mobile breakpoint', () {
      expect(bp.classify(0), XkWidthClass.mobile);
      expect(bp.classify(500), XkWidthClass.mobile);
      expect(bp.classify(759.9), XkWidthClass.mobile);
    });

    test('tablet at and above the mobile boundary (inclusive)', () {
      expect(bp.classify(760), XkWidthClass.tablet);
      expect(bp.classify(900), XkWidthClass.tablet);
      expect(bp.classify(1079.9), XkWidthClass.tablet);
    });

    test('desktop at and above the desktop boundary (inclusive)', () {
      expect(bp.classify(1080), XkWidthClass.desktop);
      expect(bp.classify(1440), XkWidthClass.desktop);
      expect(bp.classify(4000), XkWidthClass.desktop);
    });

    test('boolean helpers agree with classify', () {
      expect(bp.isMobile(500), isTrue);
      expect(bp.isTablet(500), isFalse);
      expect(bp.isTablet(800), isTrue);
      expect(bp.isDesktop(1200), isTrue);
      expect(bp.isMobile(1200), isFalse);
    });

    test('xkWidthClass top-level helper matches defaults', () {
      expect(xkWidthClass(500), XkWidthClass.mobile);
      expect(xkWidthClass(800), XkWidthClass.tablet);
      expect(xkWidthClass(1200), XkWidthClass.desktop);
    });
  });

  group('XkBreakpoints overrides', () {
    test('custom breakpoints shift the boundaries', () {
      const XkBreakpoints bp = XkBreakpoints(mobile: 600, desktop: 1200);
      expect(bp.classify(599), XkWidthClass.mobile);
      expect(bp.classify(600), XkWidthClass.tablet);
      expect(bp.classify(1199), XkWidthClass.tablet);
      expect(bp.classify(1200), XkWidthClass.desktop);
    });

    test('copyWith / equality / hashCode', () {
      const XkBreakpoints a = XkBreakpoints.defaults;
      final XkBreakpoints b = a.copyWith(desktop: 1280);
      expect(b.mobile, 760);
      expect(b.desktop, 1280);
      expect(a == const XkBreakpoints(mobile: 760, desktop: 1080), isTrue);
      expect(a == b, isFalse);
      expect(
        a.hashCode,
        const XkBreakpoints(mobile: 760, desktop: 1080).hashCode,
      );
    });

    test('asserts on invalid configuration', () {
      expect(() => XkBreakpoints(mobile: 0), throwsAssertionError);
      expect(
        () => XkBreakpoints(mobile: 800, desktop: 700),
        throwsAssertionError,
      );
    });
  });

  group('BoxConstraints extension', () {
    test('classifies by maxWidth', () {
      expect(
        const BoxConstraints(maxWidth: 500).widthClass(),
        XkWidthClass.mobile,
      );
      expect(
        const BoxConstraints(maxWidth: 900).widthClass(),
        XkWidthClass.tablet,
      );
      expect(
        const BoxConstraints(maxWidth: 1200).widthClass(),
        XkWidthClass.desktop,
      );
    });

    test('unbounded maxWidth is treated as desktop', () {
      const BoxConstraints c = BoxConstraints();
      expect(c.maxWidth, double.infinity);
      expect(c.widthClass(), XkWidthClass.desktop);
      expect(c.isDesktop(), isTrue);
    });

    test('boolean helpers', () {
      expect(const BoxConstraints(maxWidth: 500).isMobile(), isTrue);
      expect(const BoxConstraints(maxWidth: 900).isTablet(), isTrue);
      expect(const BoxConstraints(maxWidth: 1200).isDesktop(), isTrue);
    });

    test('respects custom breakpoints', () {
      const XkBreakpoints bp = XkBreakpoints(mobile: 600, desktop: 1200);
      expect(
        const BoxConstraints(maxWidth: 800).widthClass(breakpoints: bp),
        XkWidthClass.tablet,
      );
    });
  });

  group('BuildContext extension', () {
    Future<void> pumpAt(WidgetTester tester, Size size) async {
      await tester.pumpWidget(
        MediaQuery(
          data: MediaQueryData(size: size),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: _Probe(),
          ),
        ),
      );
    }

    testWidgets('mobile width', (WidgetTester tester) async {
      await pumpAt(tester, const Size(500, 800));
      expect(_Probe.lastWidthClass, XkWidthClass.mobile);
      expect(_Probe.lastIsMobile, isTrue);
      expect(_Probe.lastIsDesktop, isFalse);
    });

    testWidgets('tablet width', (WidgetTester tester) async {
      await pumpAt(tester, const Size(900, 800));
      expect(_Probe.lastWidthClass, XkWidthClass.tablet);
      expect(_Probe.lastIsTablet, isTrue);
    });

    testWidgets('desktop width', (WidgetTester tester) async {
      await pumpAt(tester, const Size(1300, 800));
      expect(_Probe.lastWidthClass, XkWidthClass.desktop);
      expect(_Probe.lastIsDesktop, isTrue);
      expect(_Probe.lastIsMobile, isFalse);
    });
  });

  group('XkResponsiveLayout', () {
    // Wrap in an OverflowBox so the SizedBox can exceed the test surface size,
    // giving XkResponsiveLayout the intended maxWidth constraint.
    Widget sized(double width, Widget child) => Directionality(
      textDirection: TextDirection.ltr,
      child: Align(
        alignment: Alignment.topLeft,
        child: OverflowBox(
          maxWidth: double.infinity,
          alignment: Alignment.topLeft,
          child: SizedBox(width: width, child: child),
        ),
      ),
    );

    testWidgets('builder receives the width class', (WidgetTester tester) async {
      await tester.pumpWidget(
        sized(
          900,
          XkResponsiveLayout(
            builder: (BuildContext context, XkWidthClass wc) =>
                Text('$wc', textDirection: TextDirection.ltr),
          ),
        ),
      );
      expect(find.text('XkWidthClass.tablet'), findsOneWidget);
    });

    testWidgets('slots fall back to narrower slot', (WidgetTester tester) async {
      Widget layout(double width) => sized(
        width,
        XkResponsiveLayout.slots(
          mobile: (_) => const Text('m', textDirection: TextDirection.ltr),
          desktop: (_) => const Text('d', textDirection: TextDirection.ltr),
        ),
      );

      // Tablet has no slot -> falls back to mobile.
      await tester.pumpWidget(layout(900));
      expect(find.text('m'), findsOneWidget);
      expect(find.text('d'), findsNothing);

      // Desktop uses the desktop slot.
      await tester.pumpWidget(layout(1300));
      expect(find.text('d'), findsOneWidget);
      expect(find.text('m'), findsNothing);
    });
  });
}

class _Probe extends StatelessWidget {
  const _Probe();

  static XkWidthClass? lastWidthClass;
  static bool? lastIsMobile;
  static bool? lastIsTablet;
  static bool? lastIsDesktop;

  @override
  Widget build(BuildContext context) {
    lastWidthClass = context.widthClass();
    lastIsMobile = context.isMobile();
    lastIsTablet = context.isTablet();
    lastIsDesktop = context.isDesktop();
    return const SizedBox.shrink();
  }
}
