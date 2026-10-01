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

  group('product screen v4 widgets', () {
    Widget app(Brightness b, Widget child) => MaterialApp(
      theme: XkTactileTheme.themeData(b),
      home: Scaffold(body: Center(child: child)),
    );

    for (final Brightness b in Brightness.values) {
      testWidgets('primary button paints the theme monochrome pair ($b)', (
        WidgetTester tester,
      ) async {
        final XkTactileTokens t = XkTactileTokens.of(b);
        await tester.pumpWidget(
          app(b, XkTactilePrimaryButton(onPressed: () {}, child: const Text('go'))),
        );
        final DecoratedBox fill = tester.widget<DecoratedBox>(
          find.byKey(const ValueKey<String>('xk-tactile-primary-fill')),
        );
        expect((fill.decoration as BoxDecoration).color, t.primaryBase);
        final TextStyle style = DefaultTextStyle.of(
          tester.element(find.text('go')),
        ).style;
        expect(style.color, t.primaryText);
      });
    }

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

    testWidgets('XkTactileButton text and quiet keep their light faces', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        app(
          Brightness.light,
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              XkTactileButton(
                kind: XkTactileButtonKind.text,
                onPressed: () {},
                child: const Text('text'),
              ),
              XkTactileButton(
                kind: XkTactileButtonKind.quiet,
                onPressed: () {},
                child: const Text('quiet'),
              ),
            ],
          ),
        ),
      );
      for (final String label in <String>['text', 'quiet']) {
        final TextStyle style = DefaultTextStyle.of(
          tester.element(find.text(label)),
        ).style;
        expect(style.color, XkTactileTokens.light.ink, reason: label);
        expect(style.decoration, isNot(TextDecoration.underline));
      }
      final BoxDecoration quiet =
          tester
                  .widget<DecoratedBox>(
                    find.byKey(const ValueKey<String>('xk-tactile-quiet-fill')),
                  )
                  .decoration
              as BoxDecoration;
      expect((quiet.border! as Border).top.color, XkTactileTokens.light.line);
    });

    for (final XkTactileEmphasisDarkKind kind in XkTactileEmphasisDarkKind.values) {
      testWidgets('XkTactileEmphasisDark ${kind.name}: dark token block inside, '
          'light page outside', (WidgetTester tester) async {
        final XkTactileTokens dark = XkTactileTokens.dark;
        late Brightness inner;
        await tester.pumpWidget(
          app(
            Brightness.light,
            SizedBox(
              width: 600,
              child: XkTactileEmphasisDark(
                kind: kind,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text('band'),
                    const Icon(Icons.circle, size: 12),
                    Builder(
                      builder: (BuildContext context) {
                        inner = Theme.of(context).brightness;
                        return XkTactilePrimaryButton(
                          onPressed: () {},
                          child: const Text('go'),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        expect(inner, Brightness.dark);
        final DecoratedBox box = tester.widget<DecoratedBox>(
          find.byKey(ValueKey<String>('xk-tactile-emphasis-dark-${kind.name}')),
        );
        expect((box.decoration as BoxDecoration).color, dark.canvas);
        expect(dark.canvas, const Color(0xFF111111));
        expect(
          DefaultTextStyle.of(tester.element(find.text('band'))).style.color,
          dark.ink,
        );
        expect(
          IconTheme.of(tester.element(find.byIcon(Icons.circle))).color,
          dark.ink,
        );
        // The primary button inverts through the dark block: light face, ink label.
        final DecoratedBox fill = tester.widget<DecoratedBox>(
          find.byKey(const ValueKey<String>('xk-tactile-primary-fill')),
        );
        expect((fill.decoration as BoxDecoration).color, dark.primaryBase);
        expect(dark.primaryBase, const Color(0xFFF5F5F5));
        expect(
          DefaultTextStyle.of(tester.element(find.text('go'))).style.color,
          dark.primaryText,
        );
        // Outside the band the page is still the light theme.
        expect(
          Theme.of(tester.element(find.byType(Scaffold))).brightness,
          Brightness.light,
        );
        // Padding follows the CSS: canvas focus 24; footer clamp(32,5vw,56) / clamp(24,5vw,56).
        final Padding pad = tester.widget<Padding>(
          find
              .descendant(
                of: find.byType(XkTactileEmphasisDark),
                matching: find.byType(Padding),
              )
              .first,
        );
        expect(
          pad.padding,
          kind == XkTactileEmphasisDarkKind.canvasFocus
              ? const EdgeInsets.all(24)
              : const EdgeInsets.symmetric(vertical: 32, horizontal: 30),
        );
      });
    }

    testWidgets('no ink first-impression plane API remains', (
      WidgetTester tester,
    ) async {
      // The retired widgets must not come back under the old names; a plain
      // panel head is XkTactileSurface like any other card.
      await tester.pumpWidget(
        app(
          Brightness.light,
          const XkTactileSurface(child: Text('head')),
        ),
      );
      expect(find.byType(XkTactileSurface), findsOneWidget);
      expect(
        XkTactileAppSurface.light.toString(),
        isNot(contains('appIntro')),
      );
    });
  });
}
