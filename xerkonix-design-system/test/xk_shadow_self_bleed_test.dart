import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xerkonix_design_system/xerkonix_design_system.dart';

/// CSS outer `box-shadow` punches the border-box out of the shadow.
/// Flutter [BoxDecoration] draws the full blurred shape *under* the fill, so a
/// translucent fill shows its own shadow (self-bleed).
const Key _key = ValueKey<String>('bleed');

({int r, int g, int b}) _px(ByteData rgba, int w, int x, int y) {
  final int i = (y * w + x) * 4;
  return (r: rgba.getUint8(i), g: rgba.getUint8(i + 1), b: rgba.getUint8(i + 2));
}

Future<({int r, int g, int b})> _centerOf(
  WidgetTester tester, {
  required List<BoxShadow> shadows,
  required Color fill,
}) async {
  final bool previous = debugDisableShadows;
  debugDisableShadows = false;
  addTearDown(() {
    debugDisableShadows = previous;
  });
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        backgroundColor: XkColor.canvas,
        body: Center(
          child: RepaintBoundary(
            key: _key,
            child: ColoredBox(
              color: XkColor.canvas,
              child: SizedBox(
                width: 240,
                height: 96,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: fill,
                    borderRadius: XkRadius.ctlBorderRadius,
                    boxShadow: shadows,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  final RenderRepaintBoundary boundary = tester.renderObject(find.byKey(_key));
  final ui.Image? image = await tester.runAsync(
    () => boundary.toImage(pixelRatio: 2),
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
    debugDisableShadows = previous;
  }
}

void main() {
  const Color actionFill = XkColor.glassAction; // 22% white

  testWidgets('DecoratedBox token shadow self-bleeds through 22% fill', (
    WidgetTester tester,
  ) async {
    final ({int r, int g, int b}) withShadow = await _centerOf(
      tester,
      shadows: XkShadow.ctl(Brightness.light),
      fill: actionFill,
    );
    final ({int r, int g, int b}) noShadow = await _centerOf(
      tester,
      shadows: const <BoxShadow>[],
      fill: actionFill,
    );
    // If the shadow is painted under the interior, the center drops toward
    // 8% black over canvas (~227) composited with 22% white (~233).
    // No-shadow center is 22% white over #F7F7F7 (~249).
    expect(
      noShadow.r - withShadow.r,
      greaterThan(8),
      reason:
          'self-bleed: with-shadow center $withShadow must be darker than '
          'no-shadow $noShadow (DecoratedBox paints shadow under fill)',
    );
  });

  testWidgets('XkOuterShadow punches interior; center matches no-shadow fill', (
    WidgetTester tester,
  ) async {
    final bool previous = debugDisableShadows;
    debugDisableShadows = false;
    addTearDown(() {
      debugDisableShadows = previous;
    });
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          backgroundColor: XkColor.canvas,
          body: Center(
            child: RepaintBoundary(
              key: _key,
              child: ColoredBox(
                color: XkColor.canvas,
                child: SizedBox(
                  width: 240,
                  height: 96,
                  child: XkOuterShadow(
                    borderRadius: XkRadius.ctlBorderRadius,
                    shadows: XkShadow.ctl(Brightness.light),
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        color: actionFill,
                        borderRadius: XkRadius.ctlBorderRadius,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    final RenderRepaintBoundary boundary = tester.renderObject(
      find.byKey(_key),
    );
    final ui.Image? image = await tester.runAsync(
      () => boundary.toImage(pixelRatio: 2),
    );
    final ByteData? rgba = await tester.runAsync<ByteData?>(
      () => image!.toByteData(format: ui.ImageByteFormat.rawRgba),
    );
    late ({int r, int g, int b}) punched;
    try {
      punched = _px(rgba!, image!.width, image.width ~/ 2, image.height ~/ 2);
    } finally {
      image!.dispose();
      debugDisableShadows = previous;
    }
    final ({int r, int g, int b}) noShadow = await _centerOf(
      tester,
      shadows: const <BoxShadow>[],
      fill: actionFill,
    );
    expect(
      (punched.r - noShadow.r).abs(),
      lessThan(4),
      reason:
          'punched outer shadow must leave interior = fill over canvas, '
          'got $punched vs $noShadow',
    );
  });
}
