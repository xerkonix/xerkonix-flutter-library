// DS `.panel` 카드 재질(DS #115·#116)과 보조 버튼 경계를 실제 픽셀로 잰다.
//
// 기준: 카드·보조 버튼 바깥 경계는 바로 바깥 바탕과 3:1 이상이다
// (DS DESIGN-SYSTEM.md §2·§7). 그림자를 켠 채(debugDisableShadows=false)
// 그리고, 네 변 가운데에서 장치 픽셀 단위로 잰다:
//   경계 띠 = 1 논리 px 테가 걸친 장치 픽셀들.
//   띠의 픽셀 q 마다 바깥쪽 바로 옆 두 픽셀(q-1, q-2, 중심이 테 밖)과의
//   WCAG 대비 중 낮은 값을 구하고, 띠에서 가장 좋은 값을 그 변의 값으로 한다.
// 위치·크기가 소수인 배치(DPR 1·2)를 함께 잰다 — 1배 화면에서 테가 두
// 픽셀로 나뉘어 옅어지지 않는지 본다(XkTactileEdge).
//
// EDGE_REPORT=<파일> 이면 잰 숫자를 그 파일에 덧붙인다.
// ARTIFACT_DIR=<폴더> 이면 잰 장면 PNG 를 남긴다.

import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xerkonix_design_system/xerkonix_design_system.dart';

const Key _stage = ValueKey<String>('edge-stage');
const Key _target = ValueKey<String>('edge-target');

double _lum(List<int> c) {
  double ch(int v) {
    final double x = v / 255;
    return x <= 0.04045
        ? x / 12.92
        : math.pow((x + 0.055) / 1.055, 2.4).toDouble();
  }

  return 0.2126 * ch(c[0]) + 0.7152 * ch(c[1]) + 0.0722 * ch(c[2]);
}

double _contrast(List<int> a, List<int> b) {
  final double la = _lum(a);
  final double lb = _lum(b);
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}

List<int> _px(Uint8List rgba, int w, int x, int y) {
  final int i = (y * w + x) * 4;
  return <int>[rgba[i], rgba[i + 1], rgba[i + 2]];
}

String _hex(List<int> c) =>
    '#${c.map((int v) => v.toRadixString(16).padLeft(2, '0')).join().toUpperCase()}';

/// A DS `.glass-stage` mist light laid flat on the canvas (its strongest
/// point): `--backdrop-tint-mist` light rgba(207,211,218,.45) /
/// dark rgba(56,61,69,.55).
Color _mist(Brightness b) => b == Brightness.light
    ? Color.alphaBlend(const Color(0x73CFD3DA), XkTactileTokens.light.canvas)
    : Color.alphaBlend(const Color(0x8C383D45), XkTactileTokens.dark.canvas);

class _Side {
  _Side(this.name, this.value, this.edge, this.out);
  final String name;
  final double value;
  final List<int> edge;
  final List<int> out;
}

class _Placement {
  const _Placement(this.name, this.dpr, this.dx, this.dy);
  final String name;
  final double dpr;
  final double dx;
  final double dy;
}

class _Subject {
  const _Subject(this.name, this.viewWidth, this.build);
  final String name;
  final double viewWidth;
  final Widget Function() build;
}

Future<List<_Side>> _measure(
  WidgetTester tester, {
  required Brightness brightness,
  required Color ground,
  required _Subject subject,
  required _Placement at,
  required String artifact,
}) async {
  final Size view = Size(subject.viewWidth, 280);
  final double d = at.dpr;
  tester.view.physicalSize = view * d;
  tester.view.devicePixelRatio = d;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  final bool previous = debugDisableShadows;
  debugDisableShadows = false;
  try {
    await tester.pumpWidget(
      MaterialApp(
        theme: XkTactileTheme.themeData(brightness),
        home: Align(
          alignment: Alignment.topLeft,
          child: RepaintBoundary(
            key: _stage,
            child: ColoredBox(
              color: ground,
              child: SizedBox.fromSize(
                size: view,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: at.dx, top: at.dy),
                    child: KeyedSubtree(key: _target, child: subject.build()),
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
      find.byKey(_stage),
    );
    final ui.Image image = (await tester.runAsync(
      () => boundary.toImage(pixelRatio: d),
    ))!;
    final Uint8List rgba = (await tester.runAsync<ByteData?>(
      () => image.toByteData(format: ui.ImageByteFormat.rawRgba),
    ))!.buffer.asUint8List();
    final String? dir = Platform.environment['ARTIFACT_DIR'];
    if (dir != null && dir.isNotEmpty) {
      await tester.runAsync(() async {
        final ByteData? png = await image.toByteData(
          format: ui.ImageByteFormat.png,
        );
        Directory(dir).createSync(recursive: true);
        File('$dir/$artifact.png').writeAsBytesSync(png!.buffer.asUint8List());
      });
    }
    final int w = image.width;
    image.dispose();
    final Offset origin = tester.getTopLeft(find.byKey(_stage));
    final Rect r = tester.getRect(find.byKey(_target)).shift(-origin);
    final double l = r.left * d;
    final double t = r.top * d;
    final double rt = r.right * d;
    final double b = r.bottom * d;
    final int cx = ((l + rt) / 2).floor();
    final int cy = ((t + b) / 2).floor();

    // Band pixel index along one axis, outward step, and whether a pixel's
    // centre lies outside the 1 logical px border.
    _Side side(
      String name,
      int from,
      int to,
      int step,
      bool Function(int) outside,
      List<int> Function(int) at,
    ) {
      double best = 0;
      List<int> bestEdge = at(from);
      List<int> bestOut = at(from - step);
      for (int q = from; q <= to; q++) {
        if (!outside(q - step) || !outside(q - 2 * step)) {
          continue;
        }
        final double c = math.min(
          _contrast(at(q), at(q - step)),
          _contrast(at(q), at(q - 2 * step)),
        );
        if (c > best) {
          best = c;
          bestEdge = at(q);
          bestOut = at(q - step);
        }
      }
      return _Side(name, best, bestEdge, bestOut);
    }

    return <_Side>[
      side(
        'top',
        t.floor(),
        (t + d).ceil() - 1,
        1,
        (int y) => y + 0.5 <= t,
        (int y) => _px(rgba, w, cx, y),
      ),
      side(
        'left',
        l.floor(),
        (l + d).ceil() - 1,
        1,
        (int x) => x + 0.5 <= l,
        (int x) => _px(rgba, w, x, cy),
      ),
      // bottom / right: walk with negative step so q - step is outward.
      side(
        'bottom',
        -(b.ceil() - 1),
        -(b - d).floor(),
        1,
        (int ny) => -ny + 0.5 >= b,
        (int ny) => _px(rgba, w, cx, -ny),
      ),
      side(
        'right',
        -(rt.ceil() - 1),
        -(rt - d).floor(),
        1,
        (int nx) => -nx + 0.5 >= rt,
        (int nx) => _px(rgba, w, -nx, cy),
      ),
    ];
  } finally {
    debugDisableShadows = previous;
  }
}

void _report(String label, List<_Side> sides) {
  final double worst = sides.map((_Side e) => e.value).reduce(math.min);
  final String line =
      '$label  min ${worst.toStringAsFixed(2)}:1  '
      '${sides.map((_Side e) => '${e.name} ${_hex(e.edge)}/${_hex(e.out)} ${e.value.toStringAsFixed(2)}').join(' · ')}';
  // ignore: avoid_print
  print('EDGE $line');
  final String? path = Platform.environment['EDGE_REPORT'];
  if (path != null && path.isNotEmpty) {
    File(path).writeAsStringSync('$line\n', mode: FileMode.append);
  }
}

void main() {
  final List<_Subject> subjects = <_Subject>[
    _Subject(
      'card(information)',
      480,
      () => const SizedBox(
        width: 240.4,
        height: 120.6,
        child: XkTactileSurface(child: SizedBox.expand()),
      ),
    ),
    _Subject(
      'card(glass)',
      480,
      () => const SizedBox(
        width: 240.4,
        height: 120.6,
        child: XkTactileSurface(
          role: XkTactileSurfaceRole.glass,
          child: SizedBox.expand(),
        ),
      ),
    ),
    // Mobile: a 390 wide view, card across the width (blur 16 path).
    _Subject(
      'card(information) 390',
      390,
      () => const SizedBox(
        width: 357.4,
        height: 120.6,
        child: XkTactileSurface(child: SizedBox.expand()),
      ),
    ),
    _Subject(
      'secondary button',
      480,
      () => XkTactileButton(onPressed: () {}, child: const Text('보조')),
    ),
    _Subject(
      'quiet button',
      480,
      () => XkTactileButton(
        kind: XkTactileButtonKind.quiet,
        onPressed: () {},
        child: const Text('보조'),
      ),
    ),
    _Subject(
      'human review',
      480,
      () => const SizedBox(
        width: 240.4,
        child: XkTactileHumanReview(child: Text('확인 필요')),
      ),
    ),
  ];
  const List<_Placement> placements = <_Placement>[
    _Placement('dpr1 int', 1, 40, 40),
    _Placement('dpr1 frac.3/.7', 1, 40.3, 40.7),
    _Placement('dpr1 frac.5', 1, 40.5, 40.5),
    _Placement('dpr2 int', 2, 40, 40),
    _Placement('dpr2 frac.25/.75', 2, 40.25, 40.75),
  ];
  final List<(String, Brightness)> grounds = <(String, Brightness)>[
    ('light canvas', Brightness.light),
    ('light mist', Brightness.light),
    ('dark canvas', Brightness.dark),
    ('dark mist', Brightness.dark),
  ];

  for (final (String groundName, Brightness brightness) in grounds) {
    final Color ground = groundName.endsWith('mist')
        ? _mist(brightness)
        : XkTactileTokens.of(brightness).canvas;
    for (final _Subject subject in subjects) {
      for (final _Placement at in placements) {
        final String label = '${subject.name} · $groundName · ${at.name}';
        testWidgets('$label: edge 3:1 or more', (WidgetTester tester) async {
          final String artifact = 'edge-${subject.name}-$groundName-${at.name}'
              .replaceAll(RegExp(r'[^A-Za-z0-9]+'), '-');
          final List<_Side> sides = await _measure(
            tester,
            brightness: brightness,
            ground: ground,
            subject: subject,
            at: at,
            artifact: artifact,
          );
          _report(label, sides);
          for (final _Side e in sides) {
            expect(
              e.value,
              greaterThanOrEqualTo(3.0),
              reason:
                  '$label ${e.name}: edge ${_hex(e.edge)} vs outside ${_hex(e.out)}',
            );
          }
        });
      }
    }
  }

  testWidgets('card face is not darkened by its own shadow', (
    WidgetTester tester,
  ) async {
    final bool previous = debugDisableShadows;
    debugDisableShadows = false;
    try {
      await tester.pumpWidget(
        MaterialApp(
          theme: XkTactileTheme.themeData(Brightness.light),
          home: Center(
            child: RepaintBoundary(
              key: _stage,
              child: ColoredBox(
                color: XkTactileTokens.light.canvas,
                child: const Padding(
                  padding: EdgeInsets.all(40),
                  child: SizedBox(
                    width: 240,
                    height: 120,
                    child: XkTactileSurface(child: SizedBox.expand()),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      final RenderRepaintBoundary boundary = tester.renderObject(
        find.byKey(_stage),
      );
      final ui.Image image = (await tester.runAsync(() => boundary.toImage()))!;
      final Uint8List rgba = (await tester.runAsync<ByteData?>(
        () => image.toByteData(format: ui.ImageByteFormat.rawRgba),
      ))!.buffer.asUint8List();
      final List<int> center = _px(
        rgba,
        image.width,
        image.width ~/ 2,
        image.height ~/ 2,
      );
      image.dispose();
      final Color want = Color.alphaBlend(
        XkTactileTokens.light.panelFill,
        XkTactileTokens.light.canvas,
      );
      final int wantR = (want.r * 255).round();
      expect(
        (center[0] - wantR).abs(),
        lessThanOrEqualTo(2),
        reason: 'center ${_hex(center)}',
      );
    } finally {
      debugDisableShadows = previous;
    }
  });

  testWidgets('information card: panel material, blur 16 at 390 wide', (
    WidgetTester tester,
  ) async {
    Future<double> blurAt(double width) async {
      tester.view.physicalSize = Size(width, 600);
      tester.view.devicePixelRatio = 1;
      await tester.pumpWidget(
        MaterialApp(
          theme: XkTactileTheme.themeData(Brightness.light),
          home: const Center(
            child: SizedBox(
              width: 200,
              height: 80,
              child: XkTactileSurface(child: SizedBox.expand()),
            ),
          ),
        ),
      );
      final BackdropFilter filter = tester.widget<BackdropFilter>(
        find.byType(BackdropFilter),
      );
      final String text = filter.filter.toString();
      final RegExpMatch? m = RegExp(r'blur\(([0-9.]+)').firstMatch(text);
      expect(m, isNotNull, reason: text);
      return double.parse(m!.group(1)!);
    }

    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    expect(await blurAt(1440), XkTactileTokens.panelBlur);
    expect(await blurAt(390), XkTactileTokens.panelBlurMobile);
    final BoxDecoration face =
        tester
                .widget<DecoratedBox>(
                  find.byKey(const ValueKey<String>('xk-tactile-surface-face')),
                )
                .decoration
            as BoxDecoration;
    expect(face.color, XkTactileTokens.light.panelFill);
    final BoxDecoration edge =
        tester
                .widget<DecoratedBox>(
                  find.byKey(const ValueKey<String>('xk-tactile-surface-edge')),
                )
                .decoration
            as BoxDecoration;
    expect(edge.border, isA<XkTactileEdge>());
    expect(
      (edge.border! as Border).top.color,
      XkTactileTokens.light.panelBorder,
    );
    expect(
      face.boxShadow,
      isNull,
      reason: 'depth is the outer painter, not under the face',
    );
  });

  testWidgets('high contrast: opaque face, no blur, edge stays', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: XkTactileTheme.themeData(Brightness.dark),
        home: const MediaQuery(
          data: MediaQueryData(highContrast: true),
          child: Center(
            child: SizedBox(
              width: 200,
              height: 80,
              child: XkTactileSurface(child: SizedBox.expand()),
            ),
          ),
        ),
      ),
    );
    expect(find.byType(BackdropFilter), findsNothing);
    final BoxDecoration face =
        tester
                .widget<DecoratedBox>(
                  find.byKey(const ValueKey<String>('xk-tactile-surface-face')),
                )
                .decoration
            as BoxDecoration;
    expect(face.color, XkTactileTokens.dark.glassFallback);
    final BoxDecoration edge =
        tester
                .widget<DecoratedBox>(
                  find.byKey(const ValueKey<String>('xk-tactile-surface-edge')),
                )
                .decoration
            as BoxDecoration;
    expect(edge.border, isA<XkTactileEdge>());
    expect(
      (edge.border! as Border).top.color,
      XkTactileTokens.dark.panelBorder,
    );
  });

  test('Material card theme edge is panelBorder', () {
    for (final Brightness b in Brightness.values) {
      final ShapeBorder? shape = XkTactileTheme.themeData(b).cardTheme.shape;
      expect(shape, isA<RoundedRectangleBorder>());
      expect(
        (shape! as RoundedRectangleBorder).side.color,
        XkTactileTokens.of(b).panelBorder,
      );
    }
  });
}
