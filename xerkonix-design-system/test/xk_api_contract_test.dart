import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xerkonix_design_system/xerkonix_design_system.dart';

({int r, int g, int b}) _px(ByteData rgba, int w, int x, int y) {
  final int i = (y * w + x) * 4;
  return (
    r: rgba.getUint8(i),
    g: rgba.getUint8(i + 1),
    b: rgba.getUint8(i + 2),
  );
}

Future<({int r, int g, int b})> _centerOf(
  WidgetTester tester,
  Finder target,
) async {
  final RenderRepaintBoundary boundary = tester.renderObject(target);
  final ui.Image? image = await tester.runAsync(
    () => boundary.toImage(pixelRatio: 1),
  );
  expect(image, isNotNull);
  final ByteData? rgba = await tester.runAsync<ByteData?>(
    () => image!.toByteData(format: ui.ImageByteFormat.rawRgba),
  );
  expect(rgba, isNotNull);
  try {
    return _px(rgba!, image!.width, image.width ~/ 2, image.height ~/ 2);
  } finally {
    image!.dispose();
  }
}

void main() {
  testWidgets('XkInfoCard keeps explicit backgroundColor and borderColor', (
    WidgetTester tester,
  ) async {
    const Color bg = Color(0xFF112233);
    const Color bd = Color(0xFFA1B2C3);
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: XkInfoCard(
            metric: 'M',
            title: 'T',
            description: 'D',
            backgroundColor: bg,
            borderColor: bd,
          ),
        ),
      ),
    );
    final XkTactileSurface surface = tester.widget<XkTactileSurface>(
      find.byType(XkTactileSurface),
    );
    expect(surface.role, XkTactileSurfaceRole.information);
    expect(surface.fill, bg);
    expect(surface.borderColor, bd);
  });

  testWidgets('XkKpiCard and XkAlert keep explicit colors', (
    WidgetTester tester,
  ) async {
    const Color bg = Color(0xFF010203);
    const Color bd = Color(0xFF908070);
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: <Widget>[
              XkKpiCard(
                label: '처리',
                value: '1',
                backgroundColor: bg,
                borderColor: bd,
              ),
              XkAlert(
                title: 't',
                message: 'm',
                backgroundColor: bg,
                borderColor: bd,
              ),
            ],
          ),
        ),
      ),
    );
    final Iterable<XkGlass> glasses = tester.widgetList<XkGlass>(
      find.byType(XkGlass),
    );
    expect(glasses.length, 2);
    for (final XkGlass glass in glasses) {
      expect(glass.color, bg);
      expect(glass.borderColor, bd);
    }
  });

  testWidgets('explicit InfoCard fill paints, not role glass', (
    WidgetTester tester,
  ) async {
    const Color bg = Color(0xFFCC3366);
    const Key key = ValueKey<String>('info-paint');
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: RepaintBoundary(
              key: key,
              child: SizedBox(
                width: 280,
                height: 140,
                child: XkInfoCard(
                  metric: 'M',
                  title: 'T',
                  description: 'D',
                  backgroundColor: bg,
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    final ({int r, int g, int b}) c = await _centerOf(tester, find.byKey(key));
    expect(c.r, closeTo(0xCC, 28));
    expect(c.g, closeTo(0x33, 28));
    expect(c.b, closeTo(0x66, 28));
  });

  testWidgets(
    'XkInfoCard BorderRadiusDirectional resolves with Directionality',
    (WidgetTester tester) async {
      const BorderRadiusDirectional directional = BorderRadiusDirectional.only(
        topStart: Radius.circular(2),
        topEnd: Radius.circular(20),
      );
      await tester.pumpWidget(
        const MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: XkInfoCard(
                metric: 'M',
                title: 'T',
                description: 'D',
                borderRadius: directional,
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
      final XkTactileSurface surface = tester.widget<XkTactileSurface>(
        find.byType(XkTactileSurface),
      );
      expect(surface.role, XkTactileSurfaceRole.information);
      expect(surface.radius, isA<BorderRadiusDirectional>());
      final ClipRRect clip = tester.widget<ClipRRect>(
        find.descendant(
          of: find.byType(XkInfoCard),
          matching: find.byType(ClipRRect),
        ),
      );
      expect(clip.borderRadius, isA<BorderRadius>());
      final BorderRadius painted = clip.borderRadius.resolve(TextDirection.rtl);
      expect(painted.topLeft, const Radius.circular(20));
      expect(painted.topRight, const Radius.circular(2));
    },
  );

  testWidgets('XkTable BorderRadiusDirectional does not throw', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Directionality(
          textDirection: TextDirection.ltr,
          child: Scaffold(
            body: XkTable(
              borderRadius: const BorderRadiusDirectional.only(
                bottomStart: Radius.circular(3),
                bottomEnd: Radius.circular(9),
              ),
              columns: const <String>['a'],
              rows: const <XkTableRowData>[
                XkTableRowData(<XkTableCell>[XkTableCell(text: '1')]),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
    final ClipRRect clip = tester.widget<ClipRRect>(find.byType(ClipRRect));
    expect(clip.borderRadius, isA<BorderRadius>());
    final BorderRadius painted = clip.borderRadius.resolve(TextDirection.ltr);
    expect(painted.bottomLeft, const Radius.circular(3));
    expect(painted.bottomRight, const Radius.circular(9));
  });

  testWidgets('XkConfidenceMeter BorderRadiusDirectional resolves', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: XkConfidenceMeter(
              label: '확신',
              value: 0.4,
              borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(1),
                topEnd: Radius.circular(8),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
    final ClipRRect clip = tester.widget<ClipRRect>(find.byType(ClipRRect));
    expect(clip.borderRadius, isA<BorderRadius>());
    final BorderRadius painted = clip.borderRadius.resolve(TextDirection.rtl);
    expect(painted.topLeft, const Radius.circular(8));
    expect(painted.topRight, const Radius.circular(1));
  });

  testWidgets('primary paints a flat monochrome face', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: XkButton.primary(onPressed: () {}, child: const Text('시작하기')),
        ),
      ),
    );
    final DecoratedBox fill = tester.widget(
      find.byKey(const ValueKey<String>('xk-tactile-primary-fill')),
    );
    final BoxDecoration d = fill.decoration as BoxDecoration;
    expect(d.color, XkTactileTokens.light.primaryBase);
    expect(d.gradient, isNull);
    expect(d.boxShadow, isEmpty);
    expect(find.byKey(const ValueKey<String>('xk-gem-fill')), findsNothing);
  });

  testWidgets('primary and support expose button semantics and activate', (
    WidgetTester tester,
  ) async {
    int primary = 0;
    int support = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: <Widget>[
              XkButton.primary(
                onPressed: () => primary++,
                child: const Text('시작하기'),
              ),
              XkButton.support(
                onPressed: () => support++,
                child: const Text('취소'),
              ),
            ],
          ),
        ),
      ),
    );
    expect(
      tester.getSemantics(find.text('시작하기')),
      matchesSemantics(
        label: '시작하기',
        isButton: true,
        isEnabled: true,
        isFocusable: true,
        hasEnabledState: true,
        hasTapAction: true,
        hasFocusAction: true,
      ),
    );
    expect(
      tester.getSemantics(find.text('취소')),
      matchesSemantics(
        label: '취소',
        isButton: true,
        isEnabled: true,
        isFocusable: true,
        hasEnabledState: true,
        hasTapAction: true,
        hasFocusAction: true,
      ),
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(primary, 1);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();
    expect(support, 1);
  });

  testWidgets('disabled primary and support do not activate', (
    WidgetTester tester,
  ) async {
    int n = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: <Widget>[
              XkButton.primary(onPressed: null, child: const Text('시작하기')),
              XkButton.support(onPressed: null, child: const Text('취소')),
            ],
          ),
        ),
      ),
    );
    expect(
      tester.getSemantics(find.text('시작하기')),
      matchesSemantics(label: '시작하기', isButton: true, hasEnabledState: true),
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();
    await tester.tap(find.text('시작하기'), warnIfMissed: false);
    await tester.tap(find.text('취소'), warnIfMissed: false);
    await tester.pump();
    expect(n, 0);
  });

  testWidgets('XkTag uses caption size and keyboard activation', (
    WidgetTester tester,
  ) async {
    int n = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: <Widget>[
              const XkSectionLabel(title: 'people'),
              XkTag(label: '태그', onTap: () => n++),
            ],
          ),
        ),
      ),
    );
    final Text tag = tester.widget<Text>(find.text('태그'));
    expect(tag.style!.fontSize, 13);
    final Text section = tester.widget<Text>(find.text('PEOPLE'));
    expect(section.style!.fontSize, 13);
    expect(
      tester.getSemantics(find.text('태그')),
      matchesSemantics(
        label: '태그',
        isButton: true,
        isEnabled: true,
        isFocusable: true,
        hasEnabledState: true,
        hasTapAction: true,
        hasFocusAction: true,
      ),
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(n, 1);
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();
    expect(n, 2);
  });

  testWidgets('XkCard Tab then Enter invokes onTap', (
    WidgetTester tester,
  ) async {
    int n = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: XkCard(
            onTap: () => n++,
            child: const SizedBox(width: 48, height: 48),
          ),
        ),
      ),
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(n, 1);
  });

  group('product screen 6-B widgets', () {
    Widget app(Brightness b, Widget child) => MaterialApp(
      theme: XkTactileTheme.themeData(b),
      home: Scaffold(body: Center(child: child)),
    );

    for (final Brightness b in Brightness.values) {
      testWidgets('XkTactileAppIntro paints the ink plane ($b)', (
        WidgetTester tester,
      ) async {
        final XkTactileTokens t = XkTactileTokens.of(b);
        await tester.pumpWidget(
          app(
            b,
            XkTactileAppIntro(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text('제목'),
                  XkTactilePrimaryButton(
                    onPressed: () {},
                    child: const Text('시작'),
                  ),
                ],
              ),
            ),
          ),
        );
        final DecoratedBox plane = tester.widget<DecoratedBox>(
          find.byKey(const ValueKey<String>('xk-tactile-app-intro')),
        );
        final BoxDecoration d = plane.decoration as BoxDecoration;
        expect(d.color, t.appIntroSurface);
        expect(
          (d.border! as Border).top.color,
          XkTactileAppIntro.borderOf(XkTactileAppSurface.fromTokens(t)),
        );
        final RichText title = tester.widget<RichText>(
          find.descendant(of: find.text('제목'), matching: find.byType(RichText)),
        );
        expect(title.text.style!.color, t.onAppIntro);
        final DecoratedBox fill = tester.widget<DecoratedBox>(
          find.byKey(const ValueKey<String>('xk-tactile-primary-fill')),
        );
        expect((fill.decoration as BoxDecoration).color, t.appIntroPrimaryFill);
      });
    }

    testWidgets('primary button outside the ink plane keeps primaryBase', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        app(
          Brightness.dark,
          XkTactilePrimaryButton(onPressed: () {}, child: const Text('go')),
        ),
      );
      final DecoratedBox fill = tester.widget<DecoratedBox>(
        find.byKey(const ValueKey<String>('xk-tactile-primary-fill')),
      );
      expect(
        (fill.decoration as BoxDecoration).color,
        XkTactileTokens.dark.primaryBase,
      );
    });

    testWidgets('ink-plane focus ring uses appIntroFocusRing', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        app(
          Brightness.light,
          XkTactileAppIntro(
            child: XkTactilePrimaryButton(
              onPressed: () {},
              child: const Text('시작'),
            ),
          ),
        ),
      );
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      final DecoratedBox ring = tester.widget<DecoratedBox>(
        find.byKey(const ValueKey<String>('xk-tactile-primary-focus-ring')),
      );
      expect(
        ((ring.decoration as BoxDecoration).border! as Border).top.color,
        XkTactileTokens.light.appIntroFocusRing,
      );
    });

    testWidgets('XkTactileBrandWord is one Aquamarine hue on the ink plane', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        app(
          Brightness.light,
          const XkTactileAppIntro(child: XkTactileBrandWord('골든셋')),
        ),
      );
      expect(find.text('골든셋'), findsOneWidget);
      final ShaderMask mask = tester.widget<ShaderMask>(
        find.byKey(const ValueKey<String>('xk-tactile-brand-word')),
      );
      expect(mask.blendMode, BlendMode.srcIn);
      final Text text = tester.widget<Text>(find.text('골든셋'));
      expect(text.style!.color, XkTactileTokens.light.onAppIntroAccent);
    });

    testWidgets('XkTactileBrandWord outside the ink plane fails in debug', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        app(Brightness.light, const XkTactileBrandWord('골든셋')),
      );
      expect(tester.takeException(), isA<FlutterError>());
    });

    testWidgets('XkTactileHumanReview paints the review wash and edge', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        app(
          Brightness.dark,
          const XkTactileHumanReview(child: Text('확인 필요 · 금액 차이')),
        ),
      );
      final DecoratedBox box = tester.widget<DecoratedBox>(
        find.byKey(const ValueKey<String>('xk-tactile-human-review')),
      );
      final BoxDecoration d = box.decoration as BoxDecoration;
      expect(d.color, XkTactileTokens.dark.humanReviewSurface);
      expect(
        (d.border! as Border).top.color,
        XkTactileTokens.dark.humanReviewBorder,
      );
    });

    testWidgets('Material buttons invert inside the ink plane', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        app(
          Brightness.light,
          XkTactileAppIntro(
            child: FilledButton(onPressed: () {}, child: const Text('go')),
          ),
        ),
      );
      final ThemeData inner = Theme.of(
        tester.element(find.byType(FilledButton)),
      );
      expect(
        inner.filledButtonTheme.style!.backgroundColor!.resolve(
          <WidgetState>{},
        ),
        XkTactileTokens.light.appIntroPrimaryFill,
      );
      expect(
        inner.filledButtonTheme.style!.backgroundColor!.resolve(<WidgetState>{
          WidgetState.hovered,
        }),
        XkTactileTokens.light.appIntroPrimaryHover,
      );
      expect(
        inner.textTheme.titleLarge!.color,
        XkTactileTokens.light.onAppIntro,
      );
    });
  });
}
