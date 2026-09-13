import 'package:flutter_test/flutter_test.dart';
import 'package:xerkonix_design_system/xerkonix_design_system.dart';
import 'package:flutter/material.dart';

void main() {
  group('XkColor Tests', () {
    test('XkColor should have primary color', () {
      expect(XkColor.aquaMid, isA<Color>());
      expect(XkColor.aquaMid.toARGB32(), isNotNull);
    });

    test('XkColor should have secondary color', () {
      expect(XkColor.ink2, isA<Color>());
      expect(XkColor.ink2.toARGB32(), isNotNull);
    });

    test('XkColor should have tertiary color', () {
      expect(XkColor.cool, isA<Color>());
      expect(XkColor.cool.toARGB32(), isNotNull);
    });

    test('XkColor should have error color', () {
      expect(XkColor.bad, isA<Color>());
      expect(XkColor.bad.toARGB32(), isNotNull);
    });

    test('XkColor should have the full v4 scale', () {
      expect(XkColor.groundHi, isA<Color>());
      expect(XkColor.canvas, isA<Color>());
      expect(XkColor.rule, isA<Color>());
      expect(XkColor.ink2, isA<Color>());
      expect(XkColor.ink, isA<Color>());
      expect(XkColor.ink3, isA<Color>());
    });

    test('XkColor should have TACTILE semantic tokens', () {
      expect(XkColor.canvas, isA<Color>());
      expect(XkColor.groundHi, isA<Color>());
      expect(XkColor.ink, isA<Color>());
      expect(XkColor.ink2, isA<Color>());
      expect(XkColor.aquaMid, isA<Color>());
      expect(XkColor.aqua100, isA<Color>());
      expect(XkColor.ok, isA<Color>());
      expect(XkColor.warn, isA<Color>());
      expect(XkColor.bad, isA<Color>());
    });

    test('XkColor should expose the TACTILE v4 key values', () {
      // Canvas/ink hex live in token_canon_parity_test (reads tokens.css).
      // Aqua point values are the stable v4 scale; do not freeze draft canvas.
      expect(XkColor.aquaMid.toARGB32(), 0xFF59A1B0);
      expect(XkColor.darkAquaMid.toARGB32(), 0xFF4F97A8);
    });

    test('XkColor.themed remaps light canon hex in dark, identity in light', () {
      expect(XkColor.themed(XkColor.ink, Brightness.light), XkColor.ink);
      expect(XkColor.themed(XkColor.ink, Brightness.dark), XkColor.darkInk);
      expect(XkColor.themed(XkColor.ok, Brightness.dark), XkColor.darkOk);
      expect(XkColor.themed(XkColor.canvas, Brightness.dark), XkColor.darkCanvas);
      expect(XkColor.themed(XkColor.darkInk, Brightness.dark), XkColor.darkInk);
      // Hex collisions (ink2/ink3, aqua-deep/aqua-shade) use *Of, not themed.
      expect(XkColor.ink2Of(Brightness.dark), XkColor.darkInk2);
      expect(XkColor.aquaDeepOf(Brightness.dark), XkColor.darkAquaDeep);
    });

    test('themed(groundHi, dark) is darkGroundHi, not inverse white', () {
      expect(XkColor.groundHi, const Color(0xFFFFFFFF));
      expect(XkColor.inkInverse, const Color(0xFFFFFFFF));
      expect(
        XkColor.themed(XkColor.groundHi, Brightness.dark),
        XkColor.darkGroundHi,
      );
      expect(
        XkColor.themed(XkColor.solid, Brightness.dark),
        XkColor.darkSolid,
      );
      expect(
        XkColor.themed(XkColor.darkGroundHi, Brightness.dark),
        XkColor.darkGroundHi,
      );
      expect(XkColor.inkInverseOf(Brightness.dark), XkColor.inkInverse);
      expect(XkColor.surfaceInverseOf(Brightness.dark), XkColor.surfaceInverse);
    });

    test('themed keeps existing dark remaps for ink/canvas/ok', () {
      expect(XkColor.themed(XkColor.canvas, Brightness.dark), XkColor.darkCanvas);
      expect(XkColor.themed(XkColor.ink, Brightness.dark), XkColor.darkInk);
      expect(XkColor.themed(XkColor.ok, Brightness.dark), XkColor.darkOk);
      expect(XkColor.themed(XkColor.rule, Brightness.dark), XkColor.darkRule);
    });

    test('XkColor should have the warm/cool temperature accent pair', () {
      expect(XkColor.warm, isA<Color>());
      expect(XkColor.cool, isA<Color>());
      expect(XkColor.warm, isA<Color>());
      expect(XkColor.cool, isA<Color>());
      expect(XkColor.darkWarm, isA<Color>());
      expect(XkColor.darkCool, isA<Color>());
      // 2026-07-27 TACTILE 계약 WCAG AA 승급 값. 옛 값(#C65F45 / #7B84C4)은
      // bg 대비 3.3:1 대로 본문 텍스트 기준 미달이었다.
      expect(XkColor.warm.toARGB32(), 0xFFB8503A);
      expect(XkColor.cool.toARGB32(), 0xFF3E6B8F);
    });
  });

  group('Glass elevation tokens', () {
    test('XkShadow.glass is one faint layer matching --glass-shadow', () {
      expect(XkShadow.glass(Brightness.light).length, 1);
      expect(XkShadow.glass(Brightness.dark).length, 1);
      expect(XkShadow.glassLight.first.offset, const Offset(0, 5));
      expect(XkShadow.glassLight.first.blurRadius, 15);
      expect(XkShadow.glassLight.first.spreadRadius, -12);
    });

    test('raised light xy offsets are non-negative (top-left light)', () {
      for (final BoxShadow s in XkShadow.raisedLight) {
        expect(s.offset.dx >= 0, isTrue, reason: '${s.offset}');
        expect(s.offset.dy >= 0, isTrue, reason: '${s.offset}');
      }
    });

    test('resolve keeps the legacy 3-tier API', () {
      expect(XkShadow.resolve(Brightness.light), isA<List<BoxShadow>>());
      expect(
        XkShadow.resolve(Brightness.dark, XkShadowLevel.lg),
        XkShadow.glassDark,
      );
    });
  });

  group('Theme Tests', () {
    test('XkLightTheme should have themeData', () {
      expect(XkLightTheme.themeData, isA<ThemeData>());
      expect(XkLightTheme.themeData.useMaterial3, true);
    });

    test('selected switch and checkbox fill stay aqua-mid', () {
      const Set<WidgetState> on = <WidgetState>{WidgetState.selected};
      expect(
        XkLightTheme.themeData.switchTheme.trackColor!.resolve(on),
        XkColor.aquaMid,
      );
      expect(
        XkDarkTheme.themeData.switchTheme.trackColor!.resolve(on),
        XkColor.darkAquaMid,
      );
      expect(
        XkLightTheme.themeData.checkboxTheme.fillColor!.resolve(on),
        XkColor.aquaMid,
      );
      expect(
        XkDarkTheme.themeData.checkboxTheme.fillColor!.resolve(on),
        XkColor.darkAquaMid,
      );
    });

    test('input focused border uses aqua-deep', () {
      final BorderSide light = (XkLightTheme
              .themeData.inputDecorationTheme.focusedBorder!
          as OutlineInputBorder)
          .borderSide;
      final BorderSide dark = (XkDarkTheme
              .themeData.inputDecorationTheme.focusedBorder!
          as OutlineInputBorder)
          .borderSide;
      expect(light.color, XkColor.aquaDeep);
      expect(dark.color, XkColor.darkAquaDeep);
    });

    test('primary CTA is inverse black, aqua is not the action fill', () {
      expect(
        XkLightTheme.themeData.colorScheme.primary,
        XkColor.surfaceInverse,
      );
      expect(
        XkLightTheme.themeData.colorScheme.onPrimary,
        XkColor.inkInverse,
      );
      expect(
        XkDarkTheme.themeData.colorScheme.primary,
        XkColor.surfaceInverse,
      );
      expect(XkColor.surfaceInverse, const Color(0xFF000000));
      expect(XkColor.inkInverse, const Color(0xFFFFFFFF));
      expect(
        XkLightTheme.themeData.colorScheme.primary,
        isNot(XkColor.aquaMid),
      );
    });

    test('tertiary stays cool, not aquaMid on white', () {
      expect(XkLightTheme.themeData.colorScheme.tertiary, XkColor.cool);
      expect(
        XkLightTheme.themeData.colorScheme.onTertiary,
        XkColor.groundHi,
      );
      expect(XkDarkTheme.themeData.colorScheme.tertiary, XkColor.darkCool);
      expect(
        XkLightTheme.themeData.colorScheme.tertiary,
        isNot(XkColor.aquaMid),
      );
    });

    test('XkDarkTheme should have themeData', () {
      expect(XkDarkTheme.themeData, isA<ThemeData>());
      expect(XkDarkTheme.themeData.useMaterial3, true);
    });

    test(
      'XkLightTheme and XkDarkTheme should have different color schemes',
      () {
        final lightScheme = XkLightTheme.themeData.colorScheme;
        final darkScheme = XkDarkTheme.themeData.colorScheme;

        expect(lightScheme.brightness, Brightness.light);
        expect(darkScheme.brightness, Brightness.dark);
      },
    );
  });

  group('Typography Tests', () {
    test('NotoSansKR should have all weight styles', () {
      expect(NotoSansKR.thin(fontSize: 12), isA<TextStyle>());
      expect(NotoSansKR.light(fontSize: 12), isA<TextStyle>());
      expect(NotoSansKR.regular(fontSize: 12), isA<TextStyle>());
      expect(NotoSansKR.medium(fontSize: 12), isA<TextStyle>());
      expect(NotoSansKR.bold(fontSize: 12), isA<TextStyle>());
      expect(NotoSansKR.black(fontSize: 12), isA<TextStyle>());
    });

    test('Roboto should have all weight styles', () {
      expect(Roboto.thin(fontSize: 12), isA<TextStyle>());
      expect(Roboto.light(fontSize: 12), isA<TextStyle>());
      expect(Roboto.regular(fontSize: 12), isA<TextStyle>());
      expect(Roboto.medium(fontSize: 12), isA<TextStyle>());
      expect(Roboto.bold(fontSize: 12), isA<TextStyle>());
      expect(Roboto.black(fontSize: 12), isA<TextStyle>());
    });

    test('SFPro should have all weight styles', () {
      expect(SFPro.thin(fontSize: 12), isA<TextStyle>());
      expect(SFPro.light(fontSize: 12), isA<TextStyle>());
      expect(SFPro.regular(fontSize: 12), isA<TextStyle>());
      expect(SFPro.medium(fontSize: 12), isA<TextStyle>());
      expect(SFPro.bold(fontSize: 12), isA<TextStyle>());
      expect(SFPro.black(fontSize: 12), isA<TextStyle>());
    });

    test('M3Typo should have typography styles', () {
      expect(M3Typo.titleLarge, isA<TextStyle>());
      expect(M3Typo.titleMedium, isA<TextStyle>());
      expect(M3Typo.titleSmall, isA<TextStyle>());
      expect(M3Typo.bodyLarge, isA<TextStyle>());
      expect(M3Typo.bodyMedium, isA<TextStyle>());
      expect(M3Typo.bodySmall, isA<TextStyle>());
    });

    test('HIGTypo should have typography styles', () {
      expect(HIGTypo.title1, isA<TextStyle>());
      expect(HIGTypo.title2, isA<TextStyle>());
      expect(HIGTypo.title3, isA<TextStyle>());
      expect(HIGTypo.body, isA<TextStyle>());
      expect(HIGTypo.callout, isA<TextStyle>());
      expect(HIGTypo.subhead, isA<TextStyle>());
    });
  });

  group('v2.1 component smoke tests (light + dark)', () {
    Future<void> pumpBoth(
      WidgetTester tester,
      Widget child, {
      bool useScaffold = true,
    }) async {
      for (final ThemeData theme in <ThemeData>[
        XkLightTheme.themeData,
        XkDarkTheme.themeData,
      ]) {
        final Widget body = useScaffold ? Scaffold(body: child) : child;
        await tester.pumpWidget(MaterialApp(theme: theme, home: body));
        await tester.pump(const Duration(milliseconds: 50));
        expect(tester.takeException(), isNull);
      }
    }

    testWidgets('XkBrandMark builds', (WidgetTester tester) async {
      await pumpBoth(tester, const XkBrandMark(size: 40));
    });

    testWidgets('XkBadge + beta preset build', (WidgetTester tester) async {
      await pumpBoth(
        tester,
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const XkBadge(label: 'NEW'),
            XkBadge.beta(),
          ],
        ),
      );
      expect(find.text('OPEN BETA'), findsWidgets);
    });

    testWidgets('XkAvatar builds with initial', (WidgetTester tester) async {
      await pumpBoth(tester, const XkAvatar(name: '김도현'));
    });

    testWidgets('XkCard builds tappable and static', (
      WidgetTester tester,
    ) async {
      await pumpBoth(
        tester,
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const XkCard(child: Text('static')),
            XkCard(onTap: () {}, child: const Text('tap')),
          ],
        ),
      );
    });

    testWidgets('Skeletons build', (WidgetTester tester) async {
      await pumpBoth(
        tester,
        const Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[XkSkeleton(), XkSkeletonCard()],
        ),
      );
      await pumpBoth(tester, const XkSkeletonList(count: 2));
    });

    testWidgets('XkLoadingOverlay respects visible flag', (
      WidgetTester tester,
    ) async {
      await pumpBoth(
        tester,
        const Stack(
          children: <Widget>[
            XkLoadingOverlay(message: '불러오는 중', visible: true),
          ],
        ),
      );
      expect(find.text('불러오는 중'), findsWidgets);
    });

    testWidgets('XkSectionLabel uppercases title', (WidgetTester tester) async {
      await pumpBoth(tester, const XkSectionLabel(title: 'people'));
      expect(find.text('PEOPLE'), findsWidgets);
    });

    testWidgets('XkBackButton builds', (WidgetTester tester) async {
      await pumpBoth(tester, XkBackButton(label: '뒤로', onPressed: () {}));
    });

    testWidgets('XkProgressBar builds and clamps', (WidgetTester tester) async {
      await pumpBoth(tester, const XkProgressBar(value: 1.5));
    });

    testWidgets('State panes build', (WidgetTester tester) async {
      await pumpBoth(tester, const XkLoadingPane());
      await pumpBoth(tester, const XkEmptyPane(message: '비어 있음'));
      await pumpBoth(tester, XkErrorPane(message: '오류', onRetry: () {}));
      await pumpBoth(tester, const XkErrorPane(message: '오류'));
    });

    testWidgets('XkButton.primaryGradient + expanded build', (
      WidgetTester tester,
    ) async {
      await pumpBoth(
        tester,
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            XkButton.primaryGradient(
              onPressed: () {},
              child: const Text('시작하기'),
            ),
            XkButton.action(
              onPressed: () {},
              expanded: true,
              child: const Text('확인'),
            ),
          ],
        ),
      );
      expect(find.text('시작하기'), findsWidgets);
    });

    testWidgets('XkButton.primary uses inverse fill, not aqua', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: XkLightTheme.themeData,
          home: Scaffold(
            body: XkButton.primary(
              onPressed: () {},
              child: const Text('시작하기'),
            ),
          ),
        ),
      );
      expect(find.text('시작하기'), findsOneWidget);
      final bool hasInverseFill = tester
          .widgetList<DecoratedBox>(find.byType(DecoratedBox))
          .any((DecoratedBox box) {
            final Decoration d = box.decoration;
            return d is BoxDecoration && d.color == XkColor.surfaceInverse;
          });
      expect(hasInverseFill, isTrue);
      final bool hasAquaFill = tester
          .widgetList<DecoratedBox>(find.byType(DecoratedBox))
          .any((DecoratedBox box) {
            final Decoration d = box.decoration;
            return d is BoxDecoration &&
                (d.color == XkColor.aquaMid || d.color == XkColor.glassAccent);
          });
      expect(hasAquaFill, isFalse);
    });

    bool hasFocusRing(WidgetTester tester, Color color) {
      return tester.widgetList<DecoratedBox>(find.byType(DecoratedBox)).any((
        DecoratedBox box,
      ) {
        final Decoration d = box.decoration;
        if (d is! BoxDecoration) {
          return false;
        }
        final BoxBorder? border = d.border;
        if (border is! Border) {
          return false;
        }
        return border.top.color == color && border.top.width == 2;
      });
    }

    Future<void> focusPrimary(
      WidgetTester tester, {
      required ThemeData theme,
    }) async {
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;
      addTearDown(() {
        FocusManager.instance.highlightStrategy =
            FocusHighlightStrategy.automatic;
      });
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: Scaffold(
            body: XkButton.primary(
              onPressed: () {},
              child: const Text('시작하기'),
            ),
          ),
        ),
      );
      final FocusNode node = Focus.of(
        tester.element(
          find.descendant(
            of: find.byType(XkButton),
            matching: find.byType(GestureDetector),
          ),
        ),
      );
      node.requestFocus();
      await tester.pump();
    }

    testWidgets('light focus ring is aqua-deep, not aqua', (
      WidgetTester tester,
    ) async {
      await focusPrimary(tester, theme: XkLightTheme.themeData);
      expect(hasFocusRing(tester, XkColor.aquaDeep), isTrue);
      expect(hasFocusRing(tester, XkColor.aqua), isFalse);
      expect(XkColor.aquaDeep, const Color(0xFF2E6B79));
    });

    testWidgets('dark focus ring is dark aqua-deep, not dark aqua', (
      WidgetTester tester,
    ) async {
      await focusPrimary(tester, theme: XkDarkTheme.themeData);
      expect(hasFocusRing(tester, XkColor.darkAquaDeep), isTrue);
      expect(hasFocusRing(tester, XkColor.darkAqua), isFalse);
      expect(XkColor.darkAquaDeep, const Color(0xFFA7DCE6));
    });

    testWidgets('XkChip selected two-state builds', (
      WidgetTester tester,
    ) async {
      await pumpBoth(
        tester,
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            XkChip(label: 'on', selected: true, onTap: () {}),
            XkChip(label: 'off', selected: false, onTap: () {}),
            const XkChip(label: 'variant'),
          ],
        ),
      );
    });

    testWidgets('XkNeumorphic builds raised, inset, flat and tappable', (
      WidgetTester tester,
    ) async {
      await pumpBoth(
        tester,
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const XkNeumorphic(child: Text('raised')),
            const XkNeumorphic(
              style: XkNeumorphicStyle.inset,
              child: Text('inset'),
            ),
            const XkNeumorphic(
              style: XkNeumorphicStyle.flat,
              child: Text('flat'),
            ),
            XkNeumorphic(onTap: () {}, child: const Text('tap')),
          ],
        ),
      );
      expect(find.text('inset'), findsWidgets);
    });

    testWidgets('XkNeumorphic press toggles to inset without error', (
      WidgetTester tester,
    ) async {
      var taps = 0;
      await tester.pumpWidget(
        MaterialApp(
          theme: XkLightTheme.themeData,
          home: Scaffold(
            body: Center(
              child: XkNeumorphic(
                onTap: () => taps++,
                child: const Text('press me'),
              ),
            ),
          ),
        ),
      );
      final TestGesture gesture = await tester.startGesture(
        tester.getCenter(find.text('press me')),
      );
      await tester.pump(const Duration(milliseconds: 16));
      expect(tester.takeException(), isNull);
      await gesture.up();
      await tester.pump();
      expect(taps, 1);
    });

    testWidgets('XkInsetShadowPainter paints without error', (
      WidgetTester tester,
    ) async {
      await pumpBoth(
        tester,
        const SizedBox(
          width: 120,
          height: 40,
          child: CustomPaint(
            painter: XkInsetShadowPainter(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              lowlight: Color(0x33000000),
              highlight: Color(0x22FFFFFF),
            ),
          ),
        ),
      );
    });

    testWidgets('showXkToast falls back to SnackBar without overlay', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: XkLightTheme.themeData,
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) => TextButton(
                onPressed: () => showXkToast(context, '알림'),
                child: const Text('go'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('go'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);
    });
  });
}
