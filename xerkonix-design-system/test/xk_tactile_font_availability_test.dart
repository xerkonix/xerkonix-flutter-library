import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xerkonix_design_system/xerkonix_design_system.dart';

Future<Uint8List> _raster({
  required WidgetTester tester,
  required String phrase,
  required Key key,
  String? family,
  double size = 48,
  FontWeight weight = FontWeight.w400,
  double? wght,
  double height = 1.65,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        body: Center(
          child: RepaintBoundary(
            key: key,
            child: Text(
              phrase,
              style: TextStyle(
                fontFamily: family,
                fontSize: size,
                fontWeight: weight,
                fontVariations: wght == null
                    ? null
                    : XkTactileFonts.variations(wght),
                height: height,
                color: const Color(0xFF111111),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  final RenderRepaintBoundary boundary = tester.renderObject(find.byKey(key));
  final ui.Image? image = await tester.runAsync(
    () => boundary.toImage(pixelRatio: 2),
  );
  expect(image, isNotNull);
  final ByteData? png = await tester.runAsync<ByteData?>(
    () => image!.toByteData(format: ui.ImageByteFormat.png),
  );
  image!.dispose();
  expect(png, isNotNull);
  final String? dir = Platform.environment['ARTIFACT_DIR'];
  if (dir != null && dir.isNotEmpty) {
    Directory(dir).createSync(recursive: true);
    final String slug = <String>[
      family == null || family.isEmpty ? 'engine' : family.replaceAll(' ', '_'),
      phrase,
      's${size.toStringAsFixed(0)}',
      'w${(wght ?? weight.value.toDouble()).toStringAsFixed(0)}',
      'lh${height.toStringAsFixed(2)}',
    ].join('_');
    File('$dir/$slug.png').writeAsBytesSync(png!.buffer.asUint8List());
  }
  return png!.buffer.asUint8List();
}

int _hamming(Uint8List a, Uint8List b) {
  final int n = a.length < b.length ? a.length : b.length;
  int d = 0;
  for (int i = 0; i < n; i++) {
    if (a[i] != b[i]) {
      d++;
    }
  }
  return d + (a.length - b.length).abs();
}

void main() {
  final File notoFile = File(XkTactileFonts.packageFilePath);

  test('official Noto CJK KR VF bytes are present', () {
    expect(notoFile.existsSync(), isTrue, reason: notoFile.path);
    expect(notoFile.lengthSync(), 10415420);
    final List<int> head = notoFile.readAsBytesSync().sublist(0, 4);
    expect(head, <int>[0x00, 0x01, 0x00, 0x00]);
  });

  testWidgets(
    '.SF NS / Inter / stack name without bytes match the engine default',
    (WidgetTester tester) async {
      const String phrase = 'Aa가';
      final Uint8List engine = await _raster(
        tester: tester,
        phrase: phrase,
        key: const ValueKey<String>('decl-engine'),
        family: null,
      );
      for (final String name in <String>[
        '.SF NS',
        'Inter',
        'Apple SD Gothic Neo',
        'Noto Sans CJK KR',
        'Pretendard',
      ]) {
        final Uint8List painted = await _raster(
          tester: tester,
          phrase: phrase,
          key: ValueKey<String>('decl-$name'),
          family: name,
        );
        expect(
          _hamming(painted, engine) / engine.length,
          lessThan(0.02),
          reason: '$name without FontLoader bytes is not a loaded face',
        );
      }
    },
  );

  testWidgets('XkTactileType uses the stack family and CSS axis values',
      (WidgetTester tester) async {
    expect(XkTactileType.body().fontFamily, XkTactileFonts.family);
    expect(XkTactileType.button().fontFamily, XkTactileFonts.family);
    expect(XkTactileType.button().fontSize, 13);
    expect(XkTactileType.body().fontSize, 15);
    expect(XkTactileType.display().fontSize, 28);
    expect(
      XkTactileType.button().fontVariations!.single.value,
      550,
    );
    expect(
      XkTactileType.label().fontVariations!.single.value,
      550,
    );
    expect(
      XkTactileType.display().fontVariations!.single.value,
      450,
    );
    expect(
      XkTactileType.body().fontVariations!.single.value,
      400,
    );
    expect(
      XkTactileTheme.themeData(Brightness.light).textTheme.bodyMedium?.fontFamily,
      XkTactileFonts.family,
    );
    expect(
      XkLightTheme.themeData.textTheme.bodyMedium?.fontFamily,
      XkTactileFonts.family,
    );
  });

  testWidgets(
    'loaded Noto VF paints 400/450/550 and is not claimed equal to live 5/6',
    (WidgetTester tester) async {
      expect(
        await XkTactileFonts.loadFromBytes(
          ByteData.sublistView(notoFile.readAsBytesSync()),
        ),
        isTrue,
      );

      const String latin = 'Start now';
      const String korean = '시작하기';
      const double size = 13;

      Future<Uint8List> phrase({
        required String text,
        required double wght,
        required double height,
        required String id,
      }) {
        return _raster(
          tester: tester,
          phrase: text,
          key: ValueKey<String>(id),
          family: XkTactileFonts.family,
          size: size,
          weight: FontWeight.w400,
          wght: wght,
          height: height,
        );
      }

      final Uint8List engineLatin = await _raster(
        tester: tester,
        phrase: latin,
        key: const ValueKey<String>('engine-latin'),
        family: null,
        size: size,
        height: 1.5,
      );
      final Uint8List engineKorean = await _raster(
        tester: tester,
        phrase: korean,
        key: const ValueKey<String>('engine-korean'),
        family: null,
        size: size,
        height: 1.5,
      );

      final Map<String, Uint8List> noto = <String, Uint8List>{};
      for (final String text in <String>[latin, korean]) {
        final String script = text == latin ? 'latin' : 'korean';
        for (final double wght in <double>[400, 450, 550]) {
          final String w = wght.toStringAsFixed(0);
          noto['$script-$w'] = await phrase(
            text: text,
            wght: wght,
            height: 1.5,
            id: 'noto-$script-$w',
          );
        }
      }
      final Uint8List korean165 = await phrase(
        text: korean,
        wght: 400,
        height: 1.65,
        id: 'noto-korean-400-lh165',
      );

      expect(
        _hamming(noto['latin-400']!, engineLatin) / engineLatin.length,
        greaterThan(0.02),
        reason: 'Loaded Noto Latin must differ from the engine default',
      );
      expect(
        _hamming(noto['korean-400']!, engineKorean) / engineKorean.length,
        greaterThan(0.02),
        reason: 'Loaded Noto Korean must differ from the engine default',
      );
      expect(
        _hamming(noto['latin-400']!, noto['latin-550']!) /
            noto['latin-400']!.length,
        greaterThan(0.005),
        reason: 'VF wght 400 and 550 must paint differently (Latin)',
      );
      expect(
        _hamming(noto['korean-400']!, noto['korean-550']!) /
            noto['korean-400']!.length,
        greaterThan(0.005),
        reason: 'VF wght 400 and 550 must paint differently (Korean)',
      );
      expect(
        _hamming(noto['korean-400']!, noto['korean-450']!) /
            noto['korean-400']!.length,
        greaterThan(0.002),
        reason: 'VF wght 400 and 450 must paint differently (Korean)',
      );
      expect(
        _hamming(noto['korean-400']!, korean165) / noto['korean-400']!.length,
        greaterThan(0.002),
        reason: 'line-height 1.5 vs 1.65 must change the raster',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            backgroundColor: const Color(0xFFFFFFFF),
            body: Center(
              child: RepaintBoundary(
                key: const ValueKey<String>('type-button'),
                child: Text(
                  korean,
                  style: XkTactileType.button(
                    color: const Color(0xFF111111),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final RenderRepaintBoundary bound = tester.renderObject(
        find.byKey(const ValueKey<String>('type-button')),
      );
      final ui.Image? image = await tester.runAsync(
        () => bound.toImage(pixelRatio: 2),
      );
      final ByteData? png = await tester.runAsync<ByteData?>(
        () => image!.toByteData(format: ui.ImageByteFormat.png),
      );
      image!.dispose();
      final Uint8List typeBytes = png!.buffer.asUint8List();
      expect(
        _hamming(typeBytes, engineKorean) / engineKorean.length,
        greaterThan(0.02),
        reason: 'XkTactileType.button must paint the loaded Noto face',
      );

      final String? dir = Platform.environment['ARTIFACT_DIR'];
      if (dir != null && dir.isNotEmpty) {
        File('$dir/phrase_compare.json').writeAsStringSync(
          '{"note":"Noto Sans CJK KR VF is the stack loadable fallback. '
          'Not claimed equal to live design.xerkonix.com .SF NS + '
          'Apple SD Gothic Neo.","family":"${XkTactileFonts.family}",'
          '"hamming":{'
          '"latin400_vs_engine":${_hamming(noto['latin-400']!, engineLatin)},'
          '"korean400_vs_engine":${_hamming(noto['korean-400']!, engineKorean)},'
          '"latin400_vs_550":${_hamming(noto['latin-400']!, noto['latin-550']!)},'
          '"korean400_vs_550":${_hamming(noto['korean-400']!, noto['korean-550']!)},'
          '"korean400_vs_450":${_hamming(noto['korean-400']!, noto['korean-450']!)},'
          '"korean_lh15_vs_165":${_hamming(noto['korean-400']!, korean165)},'
          '"type_button_vs_engine":${_hamming(typeBytes, engineKorean)}'
          '}}\n',
        );
        File('$dir/phrase_type_button.png').writeAsBytesSync(typeBytes);
      }
    },
  );
}
