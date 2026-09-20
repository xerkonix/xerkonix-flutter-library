import 'dart:io';
import 'dart:typed_data';
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

({int ice, int aqua, int flatBlue, int opaque}) _count(
  ByteData rgba,
  int w,
  int h,
) {
  int ice = 0;
  int aqua = 0;
  int flatBlue = 0;
  int opaque = 0;
  final Uint8List bytes = rgba.buffer.asUint8List();
  for (int y = 0; y < h; y++) {
    for (int x = 0; x < w; x++) {
      final int i = (y * w + x) * 4;
      if (bytes[i + 3] < 128) {
        continue;
      }
      opaque++;
      final int r = bytes[i];
      final int g = bytes[i + 1];
      final int b = bytes[i + 2];
      // --primary-base light #CFE3F5 (207,227,245) after white gradient blend.
      if ((r - 207).abs() <= 28 &&
          (g - 227).abs() <= 28 &&
          (b - 245).abs() <= 20) {
        ice++;
      }
      // leftover aqua-fill #0E79B4
      if ((r - 14).abs() <= 28 &&
          (g - 121).abs() <= 36 &&
          (b - 180).abs() <= 36) {
        aqua++;
      }
      // arbitrary flat accent #1E70B8 without ice blend
      if ((r - 30).abs() <= 12 &&
          (g - 112).abs() <= 12 &&
          (b - 184).abs() <= 12) {
        flatBlue++;
      }
    }
  }
  return (ice: ice, aqua: aqua, flatBlue: flatBlue, opaque: opaque);
}

({int darkIce, int opaque}) _countDark(ByteData rgba, int w, int h) {
  int darkIce = 0;
  int opaque = 0;
  final Uint8List bytes = rgba.buffer.asUint8List();
  for (int y = 0; y < h; y++) {
    for (int x = 0; x < w; x++) {
      final int i = (y * w + x) * 4;
      if (bytes[i + 3] < 128) {
        continue;
      }
      opaque++;
      final int r = bytes[i];
      final int g = bytes[i + 1];
      final int b = bytes[i + 2];
      // --primary-base dark #1A3045 (26,48,69)
      if ((r - 26).abs() <= 22 &&
          (g - 48).abs() <= 22 &&
          (b - 69).abs() <= 22) {
        darkIce++;
      }
    }
  }
  return (darkIce: darkIce, opaque: opaque);
}

Future<void> _write(WidgetTester tester, ui.Image image, String name) async {
  final String? dir = Platform.environment['ARTIFACT_DIR'];
  if (dir == null || dir.isEmpty) {
    return;
  }
  await tester.runAsync(() async {
    final ByteData? png = await image.toByteData(format: ui.ImageByteFormat.png);
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

  testWidgets('light primary is ice gradient, not aqua or flat blue', (
    WidgetTester tester,
  ) async {
    const Key captureKey = ValueKey<String>('tactile-primary-light');
    await tester.pumpWidget(
      _harness(
        theme: ThemeData.light(),
        scaffoldColor: XkTactileTokens.light.canvas,
        captureKey: captureKey,
        onPressed: () {},
      ),
    );
    await tester.pumpAndSettle();

    final Size fill = tester.getSize(find.byKey(_fillKey));
    expect(fill.height, greaterThanOrEqualTo(46));

    final ui.Image image = await _capture(tester, captureKey);
    try {
      final ByteData? rgba = await tester.runAsync<ByteData?>(
        () => image.toByteData(format: ui.ImageByteFormat.rawRgba),
      );
      final counts = _count(rgba!, image.width, image.height);
      expect(counts.opaque, greaterThan(0));
      expect(
        counts.ice / counts.opaque,
        greaterThan(0.20),
        reason: 'ice ${counts.ice}/${counts.opaque}',
      );
      expect(counts.aqua / counts.opaque, lessThan(0.08));
      expect(counts.flatBlue / counts.opaque, lessThan(0.08));
      await _write(tester, image, 'tactile_primary_light.png');
    } finally {
      image.dispose();
    }
  });

  testWidgets('dark primary uses --primary-base #1A3045', (
    WidgetTester tester,
  ) async {
    const Key captureKey = ValueKey<String>('tactile-primary-dark');
    await tester.pumpWidget(
      _harness(
        theme: ThemeData.dark(),
        scaffoldColor: XkTactileTokens.dark.canvas,
        captureKey: captureKey,
        onPressed: () {},
      ),
    );
    await tester.pumpAndSettle();
    final ui.Image image = await _capture(tester, captureKey);
    try {
      final ByteData? rgba = await tester.runAsync<ByteData?>(
        () => image.toByteData(format: ui.ImageByteFormat.rawRgba),
      );
      final counts = _countDark(rgba!, image.width, image.height);
      expect(counts.darkIce / counts.opaque, greaterThan(0.15));
      await _write(tester, image, 'tactile_primary_dark.png');
    } finally {
      image.dispose();
    }
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

  testWidgets('hover primary uses selected border and lift', (
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
      XkTactileTokens.light.selectedBorder,
    );
    final ui.Image image = await _capture(tester, captureKey);
    try {
      await _write(tester, image, 'tactile_primary_hover.png');
    } finally {
      image.dispose();
    }
  });

  testWidgets('hover-held click matches :active translateY(0), then hover lift', (
    WidgetTester tester,
  ) async {
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
      XkTactileTokens.light.selectedBorder,
      reason: 'hover chrome stays while pressed',
    );
    await mouse.up();
    await tester.pumpAndSettle();
    slide = tester.widget(find.byType(AnimatedSlide));
    expect(slide.offset.dy, isNot(0), reason: 'hover lift returns after up');
  });

  testWidgets('Tab focus ring does not grow the button rect', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: <Widget>[
              const SizedBox(
                width: 200,
                child: TextField(),
              ),
              XkButton.primary(
                onPressed: () {},
                child: const Text('시작하기'),
              ),
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
    expect(find.byKey(const ValueKey<String>('xk-tactile-primary-focus-ring')), findsOneWidget);
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
