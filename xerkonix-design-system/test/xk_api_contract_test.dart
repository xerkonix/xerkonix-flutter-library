import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xerkonix_design_system/xerkonix_design_system.dart';

({int r, int g, int b}) _px(ByteData rgba, int w, int x, int y) {
  final int i = (y * w + x) * 4;
  return (r: rgba.getUint8(i), g: rgba.getUint8(i + 1), b: rgba.getUint8(i + 2));
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
    final XkGlass glass = tester.widget<XkGlass>(find.byType(XkGlass));
    expect(glass.color, bg);
    expect(glass.borderColor, bd);
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
    final ({int r, int g, int b}) c = await _centerOf(
      tester,
      find.byKey(key),
    );
    expect(c.r, closeTo(0xCC, 28));
    expect(c.g, closeTo(0x33, 28));
    expect(c.b, closeTo(0x66, 28));
  });

  testWidgets('XkInfoCard BorderRadiusDirectional resolves with Directionality', (
    WidgetTester tester,
  ) async {
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
    final XkGlass glass = tester.widget<XkGlass>(find.byType(XkGlass));
    expect(glass.borderRadius, isA<BorderRadiusDirectional>());
    final ClipRRect clip = tester.widget<ClipRRect>(find.byType(ClipRRect));
    expect(clip.borderRadius, isA<BorderRadius>());
    final BorderRadius painted = clip.borderRadius.resolve(TextDirection.rtl);
    expect(painted.topLeft, const Radius.circular(20));
    expect(painted.topRight, const Radius.circular(2));
  });

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

  testWidgets('primary has no sheen RadialGradient', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: XkButton.primary(
            onPressed: () {},
            child: const Text('시작하기'),
          ),
        ),
      ),
    );
    final Iterable<DecoratedBox> boxes = tester.widgetList<DecoratedBox>(
      find.byType(DecoratedBox),
    );
    for (final DecoratedBox box in boxes) {
      final Decoration d = box.decoration;
      if (d is BoxDecoration && d.gradient != null) {
        fail('primary must not paint a sheen gradient: $d');
      }
    }
    expect(find.byKey(const ValueKey<String>('xk-gem-fill')), findsOneWidget);
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
      matchesSemantics(
        label: '시작하기',
        isButton: true,
        hasEnabledState: true,
      ),
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

  testWidgets('XkCard Tab then Enter invokes onTap', (WidgetTester tester) async {
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
}
