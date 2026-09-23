import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xerkonix_design_system/xerkonix_design_system.dart';

const Key _fillKey = ValueKey<String>('xk-tactile-primary-fill');
const Key _captureKey = ValueKey<String>('primary-capture');

Widget _harness(Brightness brightness) {
  return MaterialApp(
    theme: brightness == Brightness.dark
        ? XkDarkTheme.themeData
        : XkLightTheme.themeData,
    home: Scaffold(
      backgroundColor: XkTactileTokens.of(brightness).canvas,
      body: Row(
        children: <Widget>[
          RepaintBoundary(
            key: _captureKey,
            child: XkButton.action(onPressed: () {}, child: const Text('시작하기')),
          ),
        ],
      ),
    ),
  );
}

Future<({int target, int opaque})> _countPixels(
  WidgetTester tester,
  Color expected,
) async {
  final RenderRepaintBoundary boundary = tester.renderObject(
    find.byKey(_captureKey),
  );
  final ui.Image? image = await tester.runAsync(
    () => boundary.toImage(pixelRatio: 3),
  );
  expect(image, isNotNull);
  final ByteData? rgba = await tester.runAsync<ByteData?>(
    () => image!.toByteData(format: ui.ImageByteFormat.rawRgba),
  );
  expect(rgba, isNotNull);
  final Uint8List bytes = rgba!.buffer.asUint8List();
  int target = 0;
  int opaque = 0;
  for (int i = 0; i < bytes.length; i += 4) {
    if (bytes[i + 3] < 128) continue;
    opaque++;
    if ((bytes[i] - expected.r * 255).abs() <= 8 &&
        (bytes[i + 1] - expected.g * 255).abs() <= 8 &&
        (bytes[i + 2] - expected.b * 255).abs() <= 8) {
      target++;
    }
  }
  image!.dispose();
  return (target: target, opaque: opaque);
}

void main() {
  for (final Brightness brightness in Brightness.values) {
    testWidgets('primary face paints flat monochrome in $brightness', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_harness(brightness));
      await tester.pumpAndSettle();
      final XkTactileTokens tokens = XkTactileTokens.of(brightness);
      final DecoratedBox fill = tester.widget(find.byKey(_fillKey));
      final BoxDecoration decoration = fill.decoration as BoxDecoration;
      expect(decoration.color, tokens.primaryBase);
      expect(decoration.gradient, isNull);
      expect(decoration.boxShadow, isEmpty);
      expect(
        tester.getSize(find.byKey(_fillKey)).height,
        greaterThanOrEqualTo(46),
      );
      final ({int target, int opaque}) pixels = await _countPixels(
        tester,
        tokens.primaryBase,
      );
      expect(pixels.opaque, greaterThan(0));
      expect(pixels.target / pixels.opaque, greaterThan(0.55));
    });
  }
}
