import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xerkonix_design_system/xerkonix_design_system.dart';

const Key _fillKey = ValueKey<String>('xk-tactile-primary-fill');

Finder _fillFinder() => find.byKey(_fillKey);

Widget _harness({
  required ThemeData theme,
  required Color scaffoldColor,
  required Key captureKey,
}) {
  return MaterialApp(
    theme: theme,
    home: Scaffold(
      backgroundColor: scaffoldColor,
      body: SizedBox(
        width: 400,
        height: 200,
        child: Row(
          children: <Widget>[
            RepaintBoundary(
              key: captureKey,
              child: XkButton.action(
                onPressed: () {},
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
  final RenderRepaintBoundary boundary = tester.renderObject(
    find.byKey(key),
  );
  final ui.Image? image = await tester.runAsync(
    () => boundary.toImage(pixelRatio: 3),
  );
  expect(image, isNotNull, reason: 'toImage 가 래스터를 돌려줘야 한다');
  return image!;
}

bool _nearIceFill(int r, int g, int b) {
  // Light --ice #CFE3F5. Dark --primary-base #1A3045. Not aqua gem.
  final bool lightIce = (r - 207).abs() <= 40 &&
      (g - 227).abs() <= 40 &&
      (b - 245).abs() <= 40;
  final bool darkIce = (r - 26).abs() <= 28 &&
      (g - 48).abs() <= 28 &&
      (b - 69).abs() <= 28;
  return lightIce || darkIce;
}

({int aqua, int nearBlack, int opaque}) _countFill(ByteData rgba, int w, int h) {
  int aqua = 0;
  int nearBlack = 0;
  int opaque = 0;
  final Uint8List bytes = rgba.buffer.asUint8List();
  for (int y = 0; y < h; y++) {
    for (int x = 0; x < w; x++) {
      final int i = (y * w + x) * 4;
      final int a = bytes[i + 3];
      if (a < 128) {
        continue;
      }
      opaque++;
      final int r = bytes[i];
      final int g = bytes[i + 1];
      final int b = bytes[i + 2];
      if (_nearIceFill(r, g, b)) {
        aqua++;
      }
      if (r < 12 && g < 12 && b < 12) {
        nearBlack++;
      }
    }
  }
  return (aqua: aqua, nearBlack: nearBlack, opaque: opaque);
}

void _expectFillCoversFace(WidgetTester tester) {
  final RenderBox fill = tester.renderObject(_fillFinder());
  final RenderBox button = tester.renderObject(find.byType(XkButton));
  expect(fill.hasSize, isTrue);
  expect(fill.size.width, greaterThan(8), reason: 'ice-fill width');
  expect(fill.size.height, greaterThan(8), reason: 'ice-fill height');
  expect(fill.size.width, greaterThanOrEqualTo(button.size.width - 2));
  expect(fill.size.height, greaterThanOrEqualTo(button.size.height - 2));
}

Future<void> _maybeWriteArtifact(
  WidgetTester tester,
  ui.Image image,
  String name,
) async {
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
    final Directory outDir = Directory(dir);
    if (!outDir.existsSync()) {
      outDir.createSync(recursive: true);
    }
    File('$dir/$name').writeAsBytesSync(png.buffer.asUint8List());
  });
}

void main() {
  testWidgets(
    'light primary fill RenderBox is nonzero and raster is aqua-fill',
    (WidgetTester tester) async {
      const Key captureKey = ValueKey<String>('xk-gem-capture-light');
      await tester.pumpWidget(
        _harness(
          theme: XkLightTheme.themeData,
          scaffoldColor: XkColor.canvas,
          captureKey: captureKey,
        ),
      );
      await tester.pumpAndSettle();

      _expectFillCoversFace(tester);

      final ui.Image image = await _capture(tester, captureKey);
      try {
        final ByteData? rgba = await tester.runAsync<ByteData?>(
          () async => image.toByteData(format: ui.ImageByteFormat.rawRgba),
        );
        expect(rgba, isNotNull);
        final ({int aqua, int nearBlack, int opaque}) counts = _countFill(
          rgba!,
          image.width,
          image.height,
        );
        expect(counts.opaque, greaterThan(0));
        expect(
          counts.aqua / counts.opaque,
          greaterThan(0.35),
          reason:
              'light CTA raster must be TACTILE ice #CFE3F5, not canvas #F5F5F5 '
              '(got aqua ${counts.aqua} black ${counts.nearBlack}/${counts.opaque})',
        );
        expect(
          counts.nearBlack / counts.opaque,
          lessThan(0.08),
          reason:
              'light CTA raster must not be inverse #000 '
              '(got aqua ${counts.aqua} black ${counts.nearBlack}/${counts.opaque})',
        );
        await _maybeWriteArtifact(tester, image, 'primary_cta_light.png');
      } finally {
        image.dispose();
      }
    },
  );

  testWidgets(
    'dark primary fill RenderBox is nonzero and raster is aqua-fill',
    (WidgetTester tester) async {
      const Key captureKey = ValueKey<String>('xk-gem-capture-dark');
      await tester.pumpWidget(
        _harness(
          theme: XkDarkTheme.themeData,
          scaffoldColor: XkColor.darkCanvas,
          captureKey: captureKey,
        ),
      );
      await tester.pumpAndSettle();

      _expectFillCoversFace(tester);

      final ui.Image image = await _capture(tester, captureKey);
      try {
        final ByteData? rgba = await tester.runAsync<ByteData?>(
          () async => image.toByteData(format: ui.ImageByteFormat.rawRgba),
        );
        expect(rgba, isNotNull);
        final ({int aqua, int nearBlack, int opaque}) counts = _countFill(
          rgba!,
          image.width,
          image.height,
        );
        expect(counts.opaque, greaterThan(0));
        expect(
          counts.aqua / counts.opaque,
          greaterThan(0.35),
          reason:
              'dark CTA raster must be TACTILE ice / #1A3045, not canvas #141414 '
              '(got aqua ${counts.aqua} black ${counts.nearBlack}/${counts.opaque})',
        );
        expect(
          counts.nearBlack / counts.opaque,
          lessThan(0.08),
          reason:
              'dark CTA raster must not be inverse #000 '
              '(got aqua ${counts.aqua} black ${counts.nearBlack}/${counts.opaque})',
        );
        await _maybeWriteArtifact(tester, image, 'primary_cta_dark.png');
      } finally {
        image.dispose();
      }
    },
  );
}
