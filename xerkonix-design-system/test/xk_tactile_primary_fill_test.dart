import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xerkonix_design_system/xerkonix_design_system.dart';

const Key _fillKey = ValueKey<String>('xk-tactile-primary-fill');

Widget _harness({
  required ThemeData theme,
  required Color scaffoldColor,
  required Key captureKey,
  VoidCallback? onPressed,
  TextScaler? textScaler,
}) {
  return MaterialApp(
    theme: theme.copyWith(
      textTheme: theme.textTheme.apply(fontFamily: XkTactileFonts.family),
    ),
    builder: textScaler == null
        ? null
        : (BuildContext context, Widget? child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: textScaler),
              child: child!,
            );
          },
    home: Scaffold(
      backgroundColor: scaffoldColor,
      body: SizedBox(
        width: 400,
        height: 200,
        child: Row(
          children: <Widget>[
            RepaintBoundary(
              key: captureKey,
              child: XkButton.primary(
                onPressed: onPressed,
                child: const Text('시작하기'),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Future<ui.Image> _capture(WidgetTester tester, Key key) async {
  final RenderRepaintBoundary boundary = tester.renderObject(find.byKey(key));
  final ui.Image? image = await tester.runAsync(
    () => boundary.toImage(pixelRatio: 3),
  );
  expect(image, isNotNull);
  return image!;
}

Future<void> _write(WidgetTester tester, ui.Image image, String name) async {
  final String? dir = Platform.environment['ARTIFACT_DIR'];
  if (dir == null || dir.isEmpty) {
    return;
  }
  await tester.runAsync(() async {
    final ByteData? png = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    if (png == null) {
      return;
    }
    Directory(dir).createSync(recursive: true);
    File('$dir/$name').writeAsBytesSync(png.buffer.asUint8List());
  });
}

void main() {
  setUpAll(() async {
    final File fontFile = File('lib/fonts/noto_sans_cjk_kr/NotoSansKR-VF.ttf');
    expect(fontFile.existsSync(), isTrue, reason: fontFile.path);
    final bool ok = await XkTactileFonts.loadFromBytes(
      ByteData.sublistView(fontFile.readAsBytesSync()),
    );
    expect(ok, isTrue);
  });

  testWidgets('light primary is a flat ink button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _harness(
        theme: ThemeData.light(),
        scaffoldColor: XkTactileTokens.light.canvas,
        captureKey: const ValueKey<String>('tactile-primary-light'),
        onPressed: () {},
      ),
    );
    await tester.pumpAndSettle();
    final Size fill = tester.getSize(find.byKey(_fillKey));
    final DecoratedBox box = tester.widget(find.byKey(_fillKey));
    final BoxDecoration decoration = box.decoration as BoxDecoration;
    expect(fill.height, greaterThanOrEqualTo(46));
    expect(decoration.color, const Color(0xFF111111));
    expect(decoration.gradient, isNull);
    expect(decoration.boxShadow, isEmpty);
    expect(XkTactileTokens.light.primaryText, const Color(0xFFF5F5F5));
    expect(XkTactileTokens.light.accent, const Color(0xFF269DB0));
  });

  testWidgets('dark primary reverses the monochrome pair', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _harness(
        theme: ThemeData.dark(),
        scaffoldColor: XkTactileTokens.dark.canvas,
        captureKey: const ValueKey<String>('tactile-primary-dark'),
        onPressed: () {},
      ),
    );
    await tester.pumpAndSettle();
    final DecoratedBox box = tester.widget(find.byKey(_fillKey));
    final BoxDecoration decoration = box.decoration as BoxDecoration;
    expect(decoration.color, const Color(0xFFF5F5F5));
    expect(decoration.gradient, isNull);
    expect(decoration.boxShadow, isEmpty);
    expect(XkTactileTokens.dark.primaryText, const Color(0xFF111111));
    expect(XkTactileTokens.dark.accent, const Color(0xFF65C9D9));
  });

  testWidgets('disabled primary is 40% opacity and has no drop shadow', (
    WidgetTester tester,
  ) async {
    const Key captureKey = ValueKey<String>('tactile-primary-disabled');
    await tester.pumpWidget(
      _harness(
        theme: ThemeData.light(),
        scaffoldColor: XkTactileTokens.light.canvas,
        captureKey: captureKey,
        onPressed: null,
      ),
    );
    await tester.pumpAndSettle();
    final Opacity opacity = tester.widget(
      find.byKey(const ValueKey<String>('xk-tactile-primary-opacity')),
    );
    expect(opacity.opacity, XkTactileTokens.disabledOpacity);
    final DecoratedBox fill = tester.widget(find.byKey(_fillKey));
    expect(fill.decoration is BoxDecoration, isTrue);
    expect((fill.decoration as BoxDecoration).boxShadow, isEmpty);
    final ui.Image image = await _capture(tester, captureKey);
    try {
      await _write(tester, image, 'tactile_primary_disabled.png');
    } finally {
      image.dispose();
    }
  });

  testWidgets('hover primary uses neutral hover fill and lift', (
    WidgetTester tester,
  ) async {
    const Key captureKey = ValueKey<String>('tactile-primary-hover');
    await tester.pumpWidget(
      _harness(
        theme: ThemeData.light(),
        scaffoldColor: XkTactileTokens.light.canvas,
        captureKey: captureKey,
        onPressed: () {},
      ),
    );
    await tester.pumpAndSettle();
    final TestGesture mouse = await tester.createGesture(
      kind: PointerDeviceKind.mouse,
    );
    await mouse.addPointer();
    addTearDown(mouse.removePointer);
    await mouse.moveTo(tester.getCenter(find.byKey(_fillKey)));
    await tester.pumpAndSettle();
    final DecoratedBox fill = tester.widget(find.byKey(_fillKey));
    final BoxDecoration deco = fill.decoration as BoxDecoration;
    expect(deco.border, isNotNull);
    expect(
      (deco.border! as Border).top.color,
      XkTactileTokens.light.primaryHoverTop,
    );
    final ui.Image image = await _capture(tester, captureKey);
    try {
      await _write(tester, image, 'tactile_primary_hover.png');
    } finally {
      image.dispose();
    }
  });

  testWidgets(
    'hover-held click matches :active translateY(0), then hover lift',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        _harness(
          theme: ThemeData.light(),
          scaffoldColor: XkTactileTokens.light.canvas,
          captureKey: const ValueKey<String>('tactile-primary-active'),
          onPressed: () {},
        ),
      );
      await tester.pumpAndSettle();
      final TestGesture mouse = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      await mouse.addPointer();
      addTearDown(mouse.removePointer);
      await mouse.moveTo(tester.getCenter(find.byKey(_fillKey)));
      await tester.pumpAndSettle();
      AnimatedSlide slide = tester.widget(find.byType(AnimatedSlide));
      expect(slide.offset.dy, isNot(0), reason: 'hover must lift');
      expect(
        find.byKey(const ValueKey<String>('xk-tactile-primary-lift-hover')),
        findsOneWidget,
      );
      await mouse.down(tester.getCenter(find.byKey(_fillKey)));
      await tester.pump();
      slide = tester.widget(find.byType(AnimatedSlide));
      expect(slide.offset, Offset.zero, reason: ':active is translateY(0)');
      expect(
        find.byKey(const ValueKey<String>('xk-tactile-primary-lift-active')),
        findsOneWidget,
      );
      final DecoratedBox fill = tester.widget(find.byKey(_fillKey));
      expect(
        ((fill.decoration as BoxDecoration).border! as Border).top.color,
        XkTactileTokens.light.primaryHoverTop,
        reason: 'hover chrome stays while pressed',
      );
      await mouse.up();
      await tester.pumpAndSettle();
      slide = tester.widget(find.byType(AnimatedSlide));
      expect(slide.offset.dy, isNot(0), reason: 'hover lift returns after up');
    },
  );

  testWidgets('Tab focus ring does not grow the button rect', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: <Widget>[
              const SizedBox(width: 200, child: TextField()),
              XkButton.primary(onPressed: () {}, child: const Text('시작하기')),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byType(TextField));
    await tester.pump();
    final Rect before = tester.getRect(find.byType(XkTactilePrimaryButton));
    final Size fillBefore = tester.getSize(find.byKey(_fillKey));
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey<String>('xk-tactile-primary-focus-ring')),
      findsOneWidget,
    );
    final Rect after = tester.getRect(find.byType(XkTactilePrimaryButton));
    expect(after, before);
    expect(tester.getSize(find.byKey(_fillKey)), fillBefore);
  });

  testWidgets('min-height 46 grows with text scale instead of overflowing', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _harness(
        theme: ThemeData.light(),
        scaffoldColor: XkTactileTokens.light.canvas,
        captureKey: const ValueKey<String>('tactile-primary-scale'),
        onPressed: () {},
        textScaler: const TextScaler.linear(2),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    final Size fill = tester.getSize(find.byKey(_fillKey));
    expect(fill.height, greaterThan(46));
    expect(tester.getRect(find.text('시작하기')).height, greaterThan(20));
  });
}
