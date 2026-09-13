import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xerkonix_design_system/xerkonix_design_system.dart';

const Key _fillKey = ValueKey<String>('xk-gem-fill');

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
              child: XkButton.primary(
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

({int nearBlack, int opaque}) _countNearBlack(ByteData rgba, int w, int h) {
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
      if (r < 12 && g < 12 && b < 12) {
        nearBlack++;
      }
    }
  }
  return (nearBlack: nearBlack, opaque: opaque);
}

void _expectFillCoversFace(WidgetTester tester) {
  final RenderBox fill = tester.renderObject(_fillFinder());
  final RenderBox button = tester.renderObject(find.byType(XkButton));
  expect(fill.hasSize, isTrue);
  expect(fill.size.width, greaterThan(8), reason: 'inverse fill width');
  expect(fill.size.height, greaterThan(8), reason: 'inverse fill height');
  expect(
    fill.size.width,
    closeTo(button.size.width - 6, 2),
    reason: 'fill should cover the inner face (3px pad each side)',
  );
  expect(
    fill.size.height,
    closeTo(button.size.height - 6, 2),
    reason: 'fill should cover the inner face vertically',
  );
  expect(button.size.width, greaterThan(fill.size.width));
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
    'light primary fill RenderBox is nonzero and raster is black',
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
        final ({int nearBlack, int opaque}) counts = _countNearBlack(
          rgba!,
          image.width,
          image.height,
        );
        expect(counts.opaque, greaterThan(0));
        expect(
          counts.nearBlack / counts.opaque,
          greaterThan(0.35),
          reason:
              'light CTA raster must be mostly #000 fill, not canvas #F7F7F7 '
              '(got ${counts.nearBlack}/${counts.opaque})',
        );
        await _maybeWriteArtifact(tester, image, 'primary_cta_light.png');
      } finally {
        image.dispose();
      }
    },
  );

  testWidgets(
    'dark primary fill RenderBox is nonzero and raster is black',
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
        final ({int nearBlack, int opaque}) counts = _countNearBlack(
          rgba!,
          image.width,
          image.height,
        );
        expect(counts.opaque, greaterThan(0));
        expect(
          counts.nearBlack / counts.opaque,
          greaterThan(0.35),
          reason:
              'dark CTA raster must be #000 fill, not canvas #141414 '
              '(got ${counts.nearBlack}/${counts.opaque})',
        );
        await _maybeWriteArtifact(tester, image, 'primary_cta_dark.png');
      } finally {
        image.dispose();
      }
    },
  );
}
