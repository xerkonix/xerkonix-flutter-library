import 'dart:io';
import 'dart:typed_data';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xerkonix_design_system/xerkonix_design_system.dart';

Color linear(XkTactileTokens t, double y) {
  final List<double> stops = t.panelGradient.stops!;
  for (int i = 1; i < stops.length; i++) {
    if (y <= stops[i]) {
      return Color.lerp(
        t.panelGradient.colors[i - 1],
        t.panelGradient.colors[i],
        (y - stops[i - 1]) / (stops[i] - stops[i - 1]),
      )!;
    }
  }
  return t.panelGradient.colors.last;
}

void main() {
  for (final Brightness brightness in Brightness.values) {
    for (final Size size in <Size>[
      const Size(240, 120),
      const Size(120, 240),
    ]) {
      testWidgets('CSS plate layers and ellipse $brightness $size', (
        WidgetTester tester,
      ) async {
        final XkTactileTokens t = XkTactileTokens.of(brightness);
        const Key key = ValueKey<String>('plate-pixels');
        await tester.pumpWidget(
          MaterialApp(
            theme: XkTactileTheme.themeData(brightness),
            home: Center(
              child: RepaintBoundary(
                key: key,
                child: ColoredBox(
                  color: t.canvas,
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: SizedBox(
                      width: size.width,
                      height: size.height,
                      child: const XkTactileSurface(child: SizedBox.expand()),
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
        final ui.Image image = (await tester.runAsync(
          () => boundary.toImage(),
        ))!;
        final ByteData data = (await tester.runAsync(
          () async =>
              (await image.toByteData(format: ui.ImageByteFormat.rawRgba))!,
        ))!;
        for (final Offset point in <Offset>[
          const Offset(.1, .1),
          const Offset(.5, .25),
          const Offset(.5, .5),
          const Offset(.9, .9),
        ]) {
          final int x = (size.width * point.dx).floor(),
              y = (size.height * point.dy).floor();
          final double px = (x + .5) / size.width, py = (y + .5) / size.height;
          // CSS percentage ellipse radii refer to width/height independently.
          // The first background (linear) paints over the radial haze.
          final double distance = math.sqrt(
            math.pow((px - .1) / 1.2, 2) + math.pow(py / .7, 2),
          );
          final Color haze = t.panelHaze.colors.first.withValues(
            alpha: t.panelHaze.colors.first.a * (1 - distance / .7).clamp(0, 1),
          );
          final Color expected = Color.alphaBlend(
            linear(t, py),
            Color.alphaBlend(haze, t.canvas),
          );
          final int index = ((y + 40) * image.width + x + 40) * 4;
          final List<int> actual = <int>[
            data.getUint8(index),
            data.getUint8(index + 1),
            data.getUint8(index + 2),
          ];
          final List<int> wanted = <int>[
            (expected.r * 255).round(),
            (expected.g * 255).round(),
            (expected.b * 255).round(),
          ];
          for (int c = 0; c < 3; c++) {
            expect(
              (actual[c] - wanted[c]).abs(),
              lessThanOrEqualTo(2),
              reason: '$point $actual versus CSS $wanted',
            );
          }
        }
        final String? out = Platform.environment['ARTIFACT_DIR'];
        if (out != null) {
          final ByteData png = (await tester.runAsync(
            () async =>
                (await image.toByteData(format: ui.ImageByteFormat.png))!,
          ))!;
          Directory(out).createSync(recursive: true);
          File(
            '$out/plate-${brightness.name}-${size.width.toInt()}.png',
          ).writeAsBytesSync(png.buffer.asUint8List());
        }
        image.dispose();
      });
    }
  }
  testWidgets('explicit fill and high contrast bypass both gradients', (
    WidgetTester tester,
  ) async {
    for (final bool highContrast in <bool>[false, true]) {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(highContrast: highContrast),
            child: Center(
              child: XkTactileSurface(
                fill: highContrast ? null : Colors.red,
                child: const SizedBox(width: 100, height: 80),
              ),
            ),
          ),
        ),
      );
      expect(
        find.byKey(const ValueKey<String>('xk-tactile-plate-linear')),
        findsNothing,
      );
      final BoxDecoration face =
          tester
                  .widget<DecoratedBox>(
                    find.byKey(
                      const ValueKey<String>('xk-tactile-surface-face'),
                    ),
                  )
                  .decoration
              as BoxDecoration;
      expect(face.gradient, isNull);
      expect(
        face.color,
        highContrast ? XkTactileTokens.light.glassFallback : Colors.red,
      );
    }
  });
}
