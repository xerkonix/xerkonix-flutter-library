import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xerkonix_design_system/xerkonix_design_system.dart';

const Key _selectedKey = ValueKey<String>('xk-selected-capture');
const Key _ctlKey = ValueKey<String>('xk-ctl-capture');

({int r, int g, int b}) _px(ByteData rgba, int w, int x, int y) {
  final int i = (y * w + x) * 4;
  return (r: rgba.getUint8(i), g: rgba.getUint8(i + 1), b: rgba.getUint8(i + 2));
}

void main() {
  test('glossLow is transparent; sheen/nav/action follow 4.5.0 alphas', () {
    expect(XkColor.glossLow.a, 0);
    expect(XkColor.darkGlossLow.a, 0);
    expect(XkColor.glossSheen.a, closeTo(0.55, 0.01));
    expect(XkColor.glassNavigation.a, closeTo(0.68, 0.01));
    expect(XkColor.glass.a, closeTo(0.52, 0.01));
    expect(XkColor.glassAction.a, closeTo(0.18, 0.01));
    expect(XkColor.glass, isNot(XkColor.groundHi));
    expect(XkColor.glassNavigation, isNot(XkColor.groundHi));
  });

  test('selectedFill is aqua-tint at 30%, not aqua-mid', () {
    final Color fill = XkColor.selectedFill(Brightness.light);
    expect(fill.a, closeTo(0.30, 0.001));
    expect(fill.r, XkColor.aquaTint.r);
    expect(fill.g, XkColor.aquaTint.g);
    expect(fill.b, XkColor.aquaTint.b);
    expect(fill, isNot(XkColor.aquaMid));
  });

  testWidgets('selected raster is 30% tint over canvas, not a solid aqua bar', (
    WidgetTester tester,
  ) async {
    const Size box = Size(160, 48);
    await tester.pumpWidget(
      MaterialApp(
        theme: XkLightTheme.themeData,
        home: const Scaffold(
          backgroundColor: XkColor.canvas,
          body: Center(
            child: RepaintBoundary(
              key: _selectedKey,
              child: ColoredBox(
                color: XkColor.canvas,
                child: SizedBox(
                  width: 160,
                  height: 48,
                  child: XkSelected(
                    selected: true,
                    child: SizedBox.expand(),
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
      find.byKey(_selectedKey),
    );
    expect(boundary.size, box);
    final ui.Image? image = await tester.runAsync(
      () => boundary.toImage(pixelRatio: 2),
    );
    expect(image, isNotNull);
    final ByteData? rgba = await tester.runAsync<ByteData?>(
      () => image!.toByteData(format: ui.ImageByteFormat.rawRgba),
    );
    expect(rgba, isNotNull);
    try {
      final int w = image!.width;
      final int h = image.height;
      final ({int r, int g, int b}) c = _px(rgba!, w, w ~/ 2, h ~/ 2);
      // 30% #BFE4F5 over #F5F5F5 ≈ (229, 240, 245)
      expect(c.r, closeTo(231, 14));
      expect(c.g, closeTo(241, 14));
      expect(c.b, closeTo(244, 14));
      expect(c.r, greaterThan(200), reason: 'fill must stay pale');
      expect(c.g, greaterThan(200));
      expect(c.b, greaterThan(200));
      // Solid aqua-mid bar is ~ (89, 161, 176)
      expect(
        (c.r - 89).abs() + (c.g - 161).abs() + (c.b - 176).abs(),
        greaterThan(120),
        reason: 'must not paint opaque --aqua-mid',
      );
    } finally {
      image!.dispose();
    }
  });

  testWidgets('action glass center is not a dark gray groove', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: XkLightTheme.themeData,
        home: Scaffold(
          backgroundColor: XkColor.canvas,
          body: Center(
            child: RepaintBoundary(
              key: _ctlKey,
              child: const ColoredBox(
                color: XkColor.canvas,
                child: SizedBox(
                  width: 220,
                  height: 48,
                  child: XkGlass(
                    role: XkGlassRole.action,
                    padding: EdgeInsets.zero,
                    child: SizedBox.expand(),
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
      find.byKey(_ctlKey),
    );
    final ui.Image? image = await tester.runAsync(
      () => boundary.toImage(pixelRatio: 2),
    );
    expect(image, isNotNull);
    final ByteData? rgba = await tester.runAsync<ByteData?>(
      () => image!.toByteData(format: ui.ImageByteFormat.rawRgba),
    );
    expect(rgba, isNotNull);
    try {
      final int w = image!.width;
      final int h = image.height;
      final ({int r, int g, int b}) c = _px(rgba!, w, w ~/ 2, h ~/ 2);
      final int minC = [c.r, c.g, c.b].reduce((int a, int b) => a < b ? a : b);
      expect(
        minC,
        greaterThan(220),
        reason: 'ctl center $c must not read as a dark groove',
      );
      expect((c.r - c.g).abs(), lessThan(18), reason: 'no gray-cyan gradient');
      expect((c.g - c.b).abs(), lessThan(18));
    } finally {
      image!.dispose();
    }
  });

  Future<({int r, int g, int b})> sampleUnderGlass(
    WidgetTester tester, {
    required bool disableShadows,
  }) async {
    final bool previous = debugDisableShadows;
    debugDisableShadows = disableShadows;
    addTearDown(() {
      debugDisableShadows = previous;
    });
    const Key key = ValueKey<String>('shadow-band');
    await tester.pumpWidget(
      MaterialApp(
        theme: XkLightTheme.themeData,
        home: const Scaffold(
          backgroundColor: XkColor.canvas,
          body: Center(
            child: RepaintBoundary(
              key: key,
              child: ColoredBox(
                color: XkColor.canvas,
                child: SizedBox(
                  width: 200,
                  height: 120,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: 200,
                      height: 80,
                      child: XkGlass(
                        padding: EdgeInsets.zero,
                        child: SizedBox.expand(),
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
      find.byKey(key),
    );
    final ui.Image? image = await tester.runAsync(
      () => boundary.toImage(pixelRatio: 2),
    );
    expect(image, isNotNull);
    final ByteData? rgba = await tester.runAsync<ByteData?>(
      () => image!.toByteData(format: ui.ImageByteFormat.rawRgba),
    );
    expect(rgba, isNotNull);
    try {
      // 6px below the 80px glass, horizontal center. pixelRatio 2.
      return _px(rgba!, image!.width, image.width ~/ 2, ((80 + 6) * 2).round());
    } finally {
      image!.dispose();
      debugDisableShadows = previous;
    }
  }

  testWidgets('debugDisableShadows paints a hard 8px gray stair under glass', (
    WidgetTester tester,
  ) async {
    final ({int r, int g, int b}) band = await sampleUnderGlass(
      tester,
      disableShadows: true,
    );
    expect(
      band.r,
      lessThan(236),
      reason: 'hard shadow band should sit well below canvas #F5F5F5, got $band',
    );
  });

  testWidgets('debugDisableShadows=false does not paint an 8px stair', (
    WidgetTester tester,
  ) async {
    final ({int r, int g, int b}) band = await sampleUnderGlass(
      tester,
      disableShadows: false,
    );
    expect(
      band.r,
      greaterThan(232),
      reason: 'soft --glass-shadow must not be a hard gray strip, got $band',
    );
  });
}
