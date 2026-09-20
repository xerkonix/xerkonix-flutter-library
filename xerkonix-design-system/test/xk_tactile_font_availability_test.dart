import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xerkonix_design_system/xerkonix_design_system.dart';

Future<Uint8List> _raster(
  WidgetTester tester,
  String family,
  Key key,
) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        body: Center(
          child: RepaintBoundary(
            key: key,
            child: Text(
              'Aa가',
              style: TextStyle(
                fontFamily: family.isEmpty ? null : family,
                fontSize: 48,
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
    final String slug = family.isEmpty ? 'engine-default' : family.replaceAll(' ', '_');
    File('$dir/type_$slug.png').writeAsBytesSync(png!.buffer.asUint8List());
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
  testWidgets(
    '.SF NS and Inter declarations match the engine default, not a loaded face',
    (WidgetTester tester) async {
      final Uint8List engine = await _raster(
        tester,
        '',
        const ValueKey<String>('type-engine'),
      );
      final Uint8List sf = await _raster(
        tester,
        '.SF NS',
        const ValueKey<String>('type-sfns'),
      );
      final Uint8List inter = await _raster(
        tester,
        'Inter',
        const ValueKey<String>('type-inter'),
      );
      final Uint8List pretendardDeclared = await _raster(
        tester,
        'Pretendard',
        const ValueKey<String>('type-pretendard-declared'),
      );

      final int sfVsEngine = _hamming(sf, engine);
      final int interVsEngine = _hamming(inter, engine);
      final int pretendardDeclaredVsEngine = _hamming(pretendardDeclared, engine);

      expect(
        sfVsEngine / engine.length,
        lessThan(0.02),
        reason: '.SF NS is not available to this renderer; got $sfVsEngine',
      );
      expect(
        interVsEngine / engine.length,
        lessThan(0.02),
        reason: 'Inter is not loaded; got $interVsEngine',
      );
      // FontManifest listing is not enough in the test embedder — same
      // "declaration only" miss as .SF NS. Load bytes, then compare.
      expect(
        pretendardDeclaredVsEngine / engine.length,
        lessThan(0.02),
        reason:
            'Pretendard in pubspec/FontManifest still matched the engine '
            'default ($pretendardDeclaredVsEngine). Listing a family is not paint.',
      );

      final FontLoader loader = FontLoader('PretendardLoaded');
      final File fontFile = File('lib/fonts/pretendard/Pretendard-Regular.otf');
      expect(fontFile.existsSync(), isTrue, reason: fontFile.path);
      loader.addFont(
        Future<ByteData>.value(
          ByteData.sublistView(fontFile.readAsBytesSync()),
        ),
      );
      await loader.load();
      final Uint8List pretendardLoaded = await _raster(
        tester,
        'PretendardLoaded',
        const ValueKey<String>('type-pretendard-loaded'),
      );
      final int loadedVsEngine = _hamming(pretendardLoaded, engine);
      expect(
        loadedVsEngine / engine.length,
        greaterThan(0.02),
        reason:
            'After FontLoader, Pretendard must differ from the engine default '
            '($loadedVsEngine).',
      );
    },
  );

  testWidgets('XkTactileType omits fontFamily', (WidgetTester tester) async {
    expect(XkTactileType.body().fontFamily, isNull);
    expect(XkTactileType.button().fontFamily, isNull);
    expect(XkTactileType.button().fontSize, 13);
    expect(XkTactileType.body().fontSize, 15);
  });

  testWidgets(
    'same phrase/size/weight rasters: do not claim Pretendard equals live 5/6',
    (WidgetTester tester) async {
      const String phrase = '시작하기';
      const double size = 13;
      const FontWeight weight = FontWeight.w500;

      Future<Uint8List> raster(String family, Key key) async {
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
                      fontFamily: family.isEmpty ? null : family,
                      fontSize: size,
                      fontWeight: weight,
                      height: 1.5,
                      color: const Color(0xFF111111),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final RenderRepaintBoundary boundary = tester.renderObject(
          find.byKey(key),
        );
        final ui.Image? image = await tester.runAsync(
          () => boundary.toImage(pixelRatio: 2),
        );
        final ByteData? png = await tester.runAsync<ByteData?>(
          () => image!.toByteData(format: ui.ImageByteFormat.png),
        );
        image!.dispose();
        final String? dir = Platform.environment['ARTIFACT_DIR'];
        if (dir != null && dir.isNotEmpty) {
          Directory(dir).createSync(recursive: true);
          final String slug =
              family.isEmpty ? 'engine' : family.replaceAll(' ', '_');
          File('$dir/phrase_${slug}_13w500.png')
              .writeAsBytesSync(png!.buffer.asUint8List());
        }
        return png!.buffer.asUint8List();
      }

      final Uint8List engine = await raster(
        '',
        const ValueKey<String>('phrase-engine'),
      );
      final Uint8List sf = await raster(
        '.SF NS',
        const ValueKey<String>('phrase-sf'),
      );
      final Uint8List inter = await raster(
        'Inter',
        const ValueKey<String>('phrase-inter'),
      );
      final Uint8List tactile = await tester.runAsync<Uint8List>(() async {
        return Uint8List(0);
      }) ?? Uint8List(0);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            backgroundColor: const Color(0xFFFFFFFF),
            body: Center(
              child: RepaintBoundary(
                key: const ValueKey<String>('phrase-tactile'),
                child: Text(phrase, style: XkTactileType.button(color: const Color(0xFF111111))),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final RenderRepaintBoundary tactileBound = tester.renderObject(
        find.byKey(const ValueKey<String>('phrase-tactile')),
      );
      final ui.Image? tactileImage = await tester.runAsync(
        () => tactileBound.toImage(pixelRatio: 2),
      );
      final ByteData? tactilePng = await tester.runAsync<ByteData?>(
        () => tactileImage!.toByteData(format: ui.ImageByteFormat.png),
      );
      tactileImage!.dispose();
      final Uint8List tactileBytes = tactilePng!.buffer.asUint8List();

      final FontLoader loader = FontLoader('PretendardPhrase');
      final File fontFile = File('lib/fonts/pretendard/Pretendard-Regular.otf');
      loader.addFont(
        Future<ByteData>.value(
          ByteData.sublistView(fontFile.readAsBytesSync()),
        ),
      );
      await loader.load();
      final Uint8List loaded = await raster(
        'PretendardPhrase',
        const ValueKey<String>('phrase-pretendard'),
      );

      final Map<String, int> vsEngine = <String, int>{
        '.SF NS': _hamming(sf, engine),
        'Inter': _hamming(inter, engine),
        'XkTactileType.button': _hamming(tactileBytes, engine),
        'PretendardLoaded': _hamming(loaded, engine),
      };
      expect(vsEngine['.SF NS']! / engine.length, lessThan(0.02));
      expect(vsEngine['Inter']! / engine.length, lessThan(0.02));
      expect(vsEngine['XkTactileType.button']! / engine.length, lessThan(0.02));
      expect(vsEngine['PretendardLoaded']! / engine.length, greaterThan(0.02));

      final String? dir = Platform.environment['ARTIFACT_DIR'];
      if (dir != null && dir.isNotEmpty) {
        File('$dir/phrase_13w500_compare.json').writeAsStringSync(
          '{"phrase":"$phrase","size":$size,"weight":500,'
          '"note":"PretendardLoaded is not claimed equal to live design.xerkonix.com 5/6. '
          'Those glyphs were measured as .SF NS + Apple SD Gothic Neo in Chrome. '
          'This file is renderer-local Hamming vs engine default.",'
          '"hamming_vs_engine_default":{'
          '".SF NS":${vsEngine['.SF NS']},'
          '"Inter":${vsEngine['Inter']},'
          '"XkTactileType.button":${vsEngine['XkTactileType.button']},'
          '"PretendardLoaded":${vsEngine['PretendardLoaded']}'
          '}}\n',
        );
        File('$dir/phrase_tactile_13w500.png')
            .writeAsBytesSync(tactileBytes);
      }
      expect(tactile, isNotNull);
    },
  );
}
