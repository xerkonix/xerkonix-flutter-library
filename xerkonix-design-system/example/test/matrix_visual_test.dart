import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xerkonix_design_system/xerkonix_design_system.dart';
import 'package:xerkonix_design_system_example/main.dart';

Future<void> _maybeWrite(WidgetTester tester, ui.Image image, String name) async {
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

Future<ui.Image> _shot(WidgetTester tester, Finder target) async {
  final RenderRepaintBoundary boundary = tester.renderObject(target);
  final ui.Image? image = await tester.runAsync(
    () => boundary.toImage(pixelRatio: 2),
  );
  expect(image, isNotNull);
  return image!;
}

double _aquaWash(ByteData rgba, int w, int h) {
  int opaque = 0;
  int cool = 0;
  final Uint8List bytes = rgba.buffer.asUint8List();
  for (int y = 0; y < h; y += 2) {
    for (int x = 0; x < w; x += 2) {
      final int i = (y * w + x) * 4;
      if (bytes[i + 3] < 128) {
        continue;
      }
      opaque++;
      final int r = bytes[i];
      final int g = bytes[i + 1];
      final int b = bytes[i + 2];
      if (b > r + 18 && b > g + 8) {
        cool++;
      }
    }
  }
  if (opaque == 0) {
    return 1;
  }
  return cool / opaque;
}

List<int> _pxAt(
  ByteData rgba,
  int w,
  int h,
  Offset logical,
  double scale,
) {
  final int x = (logical.dx * scale).round().clamp(0, w - 1);
  final int y = (logical.dy * scale).round().clamp(0, h - 1);
  final int i = (y * w + x) * 4;
  final Uint8List bytes = rgba.buffer.asUint8List();
  return <int>[bytes[i], bytes[i + 1], bytes[i + 2]];
}

Future<void> _loadFonts() async {
  final FontLoader pretendard = FontLoader(
    'packages/xerkonix_design_system/Pretendard',
  );
  for (final String w in <String>['Regular', 'Medium', 'SemiBold']) {
    pretendard.addFont(
      rootBundle.load(
        'packages/xerkonix_design_system/lib/fonts/pretendard/Pretendard-$w.otf',
      ),
    );
  }
  await pretendard.load();

  final List<String> roots = <String>[
    Platform.environment['FLUTTER_ROOT'] ?? '',
    '/opt/homebrew/share/flutter',
  ];
  for (final String root in roots) {
    if (root.isEmpty) {
      continue;
    }
    final File file = File(
      '$root/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
    );
    if (!file.existsSync()) {
      continue;
    }
    final FontLoader material = FontLoader('MaterialIcons');
    final Uint8List bytes = await file.readAsBytes();
    material.addFont(Future<ByteData>.value(ByteData.sublistView(bytes)));
    await material.load();
    break;
  }
}

bool _enableRealShadows() {
  final bool previous = debugDisableShadows;
  debugDisableShadows = false;
  addTearDown(() {
    debugDisableShadows = previous;
  });
  return previous;
}

void main() {
  setUpAll(_loadFonts);

  Future<void> pumpMatrix(
    WidgetTester tester, {
    required Size size,
    required bool dark,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        theme: XkLightTheme.themeData,
        darkTheme: XkDarkTheme.themeData,
        themeMode: dark ? ThemeMode.dark : ThemeMode.light,
        home: RepaintBoundary(
          key: const ValueKey<String>('matrix'),
          child: ComponentMatrixPage(
            isDark: dark,
            onThemeChanged: (_) {},
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('matrix light 1440 has aqua primary fill and no canvas aqua wash', (
    WidgetTester tester,
  ) async {
    final bool previous = _enableRealShadows();
    expect(debugDisableShadows, isFalse);
    try {
    await pumpMatrix(tester, size: const Size(1440, 900), dark: false);
    expect(find.text('더 명확한 가능성을 만듭니다.'), findsOneWidget);
    expect(find.text('Primary'), findsOneWidget);
    expect(find.text('Secondary'), findsOneWidget);
    expect(find.text('Success'), findsOneWidget);
    expect(find.text('Warning'), findsOneWidget);
    expect(find.text('Error'), findsOneWidget);
    expect(find.text('Info'), findsOneWidget);
    expect(find.byType(XkTactileField), findsWidgets);
    expect(
      find.descendant(
        of: find.byType(XkTextInputField),
        matching: find.byType(XkGlass),
      ),
      findsNothing,
    );
    expect(
      tester.widget<DecoratedBox>(
        find.byKey(const ValueKey<String>('xk-tactile-semantic-success-fill')),
      ).decoration,
      isA<BoxDecoration>().having((BoxDecoration d) => d.color, 'color', XkColor.ok),
    );

    final RenderBox fill = tester.renderObject(
      find.byKey(const ValueKey<String>('xk-tactile-primary-fill')).first,
    );
    expect(fill.size.width, greaterThan(40));
    expect(fill.size.height, greaterThan(24));

    final ui.Image image = await _shot(tester, find.byKey(const ValueKey<String>('matrix')));
    try {
      final ByteData? rgba = await tester.runAsync<ByteData?>(
        () async => image.toByteData(format: ui.ImageByteFormat.rawRgba),
      );
      expect(rgba, isNotNull);
      expect(
        _aquaWash(rgba!, image.width, image.height),
        lessThan(0.22),
        reason: 'canvas must not be an aqua wash',
      );
      final double scale = image.width / 1440;
      final Finder primaryFill = find
          .byKey(const ValueKey<String>('xk-tactile-primary-fill'))
          .first;
      final Offset fillSample =
          tester.getTopLeft(primaryFill) + const Offset(10, 8);
      final List<int> primary = _pxAt(
        rgba,
        image.width,
        image.height,
        fillSample,
        scale,
      );
      expect(
        primary[0] + primary[1] + primary[2],
        greaterThan(500),
        reason: 'primary center must be TACTILE ice #CFE3F5, not aqua gem or #000, got $primary',
      );
      expect(primary[0], greaterThan(150), reason: 'ice R too low: $primary');
      expect(primary[1], greaterThan(170), reason: 'ice G too low: $primary');
      expect(primary[2], greaterThan(primary[0] - 8), reason: 'ice B not cool: $primary');
      final Finder homeRow = find.ancestor(
        of: find.text('Home'),
        matching: find.byType(XkListRow),
      );
      final Size homeSize = tester.getSize(homeRow);
      expect(homeSize.height, greaterThan(8));
      final Offset homePad =
          tester.getTopLeft(homeRow) + Offset(6, homeSize.height / 2);
      final List<int> sel = _pxAt(
        rgba,
        image.width,
        image.height,
        homePad,
        scale,
      );
      expect(sel[0], greaterThan(190), reason: 'Home selection must stay pale, got $sel');
      expect(sel[1], greaterThan(200));
      expect(sel[2], greaterThan(200));
      expect(
        (sel[0] - 89).abs() + (sel[1] - 161).abs() + (sel[2] - 176).abs(),
        greaterThan(80),
        reason: 'Home selection must not be solid aqua-mid',
      );
      final Finder secondaryBtn = find.ancestor(
        of: find.text('Secondary'),
        matching: find.byType(XkButton),
      );
      final Size secondarySize = tester.getSize(secondaryBtn);
      final Offset secondaryPad =
          tester.getTopLeft(secondaryBtn) +
          Offset(8, secondarySize.height / 2);
      final List<int> secondary = _pxAt(
        rgba,
        image.width,
        image.height,
        secondaryPad,
        scale,
      );
      final int minSecondary = secondary[0] < secondary[1]
          ? (secondary[0] < secondary[2] ? secondary[0] : secondary[2])
          : (secondary[1] < secondary[2] ? secondary[1] : secondary[2]);
      expect(
        minSecondary,
        greaterThan(200),
        reason: 'Secondary must not be a dark groove, got $secondary',
      );
      final Finder card = find.byType(XkInfoCard).first;
      final Size cardSize = tester.getSize(card);
      final Offset underCard =
          tester.getTopLeft(card) + Offset(cardSize.width / 2, cardSize.height + 6);
      final List<int> band = _pxAt(
        rgba,
        image.width,
        image.height,
        underCard,
        scale,
      );
      expect(
        band[0],
        greaterThan(232),
        reason:
            '6px under a card must not be a hard 8px gray stair '
            '(debugDisableShadows artifact ≈227). got $band',
      );
      await _maybeWrite(tester, image, 'matrix-1440-light.widget.png');
    } finally {
      image.dispose();
    }
    } finally {
      debugDisableShadows = previous;
    }
  });

  testWidgets('matrix dark 1440 keeps aqua primary fill', (WidgetTester tester) async {
    final bool previous = _enableRealShadows();
    try {
    await pumpMatrix(tester, size: const Size(1440, 900), dark: true);
    final RenderBox fill = tester.renderObject(
      find.byKey(const ValueKey<String>('xk-tactile-primary-fill')).first,
    );
    expect(fill.size.width, greaterThan(40));
    final ui.Image image = await _shot(tester, find.byKey(const ValueKey<String>('matrix')));
    try {
      await _maybeWrite(tester, image, 'matrix-1440-dark.widget.png');
    } finally {
      image.dispose();
    }
    } finally {
      debugDisableShadows = previous;
    }
  });

  testWidgets('matrix 390 light shows mobile column and tab interaction', (
    WidgetTester tester,
  ) async {
    final bool previous = _enableRealShadows();
    try {
      await pumpMatrix(tester, size: const Size(390, 844), dark: false);
      expect(find.text('시작하기'), findsWidgets);
      final ui.Image image = await _shot(tester, find.byKey(const ValueKey<String>('matrix')));
      try {
        await _maybeWrite(tester, image, 'matrix-390-light.widget.png');
      } finally {
        image.dispose();
      }
      await tester.ensureVisible(find.text('Tab 2'));
      await tester.pump();
      await tester.tap(find.text('Tab 2'));
      await tester.pump();
      expect(find.text('Tab 2'), findsOneWidget);
      await tester.ensureVisible(find.text('시작하기').first);
      await tester.pump();
      await tester.tap(find.text('시작하기').first);
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text('변화를 시작할 준비가 되셨나요?'), findsWidgets);
      expect(find.text('취소'), findsWidgets);
    } finally {
      debugDisableShadows = previous;
    }
  });
}
