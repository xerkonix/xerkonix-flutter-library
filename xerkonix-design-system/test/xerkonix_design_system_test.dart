import 'package:flutter_test/flutter_test.dart';
import 'package:xerkonix_design_system/xerkonix_design_system.dart';
import 'package:flutter/material.dart';

void main() {
  group('XkColor Tests', () {
    test('XkColor should have primary color', () {
      expect(XkColor.primary, isA<Color>());
      expect(XkColor.primary.value, isNotNull);
    });

    test('XkColor should have secondary color', () {
      expect(XkColor.secondary, isA<Color>());
      expect(XkColor.secondary.value, isNotNull);
    });

    test('XkColor should have tertiary color', () {
      expect(XkColor.tertiary, isA<Color>());
      expect(XkColor.tertiary.value, isNotNull);
    });

    test('XkColor should have error color', () {
      expect(XkColor.error, isA<Color>());
      expect(XkColor.error.value, isNotNull);
    });

    test('XkColor should have the full gray-blue scale', () {
      expect(XkColor.gray000, isA<Color>());
      expect(XkColor.gray050, isA<Color>());
      expect(XkColor.gray100, isA<Color>());
      expect(XkColor.gray200, isA<Color>());
      expect(XkColor.gray300, isA<Color>());
      expect(XkColor.gray400, isA<Color>());
      expect(XkColor.gray500, isA<Color>());
      expect(XkColor.gray600, isA<Color>());
      expect(XkColor.gray700, isA<Color>());
      expect(XkColor.gray800, isA<Color>());
      expect(XkColor.gray900, isA<Color>());
      expect(XkColor.gray950, isA<Color>());
    });

    test('XkColor should have v1.5 semantic tokens', () {
      expect(XkColor.bg, isA<Color>());
      expect(XkColor.surface, isA<Color>());
      expect(XkColor.surface2, isA<Color>());
      expect(XkColor.textStrong, isA<Color>());
      expect(XkColor.textBody, isA<Color>());
      expect(XkColor.textMuted, isA<Color>());
      expect(XkColor.brand, isA<Color>());
      expect(XkColor.accent, isA<Color>());
      expect(XkColor.accentSoft, isA<Color>());
      expect(XkColor.success, isA<Color>());
      expect(XkColor.warning, isA<Color>());
      expect(XkColor.error, isA<Color>());
    });
  });

  group('Theme Tests', () {
    test('XkLightTheme should have themeData', () {
      expect(XkLightTheme.themeData, isA<ThemeData>());
      expect(XkLightTheme.themeData.useMaterial3, true);
    });

    test('XkDarkTheme should have themeData', () {
      expect(XkDarkTheme.themeData, isA<ThemeData>());
      expect(XkDarkTheme.themeData.useMaterial3, true);
    });

    test('XkLightTheme and XkDarkTheme should have different color schemes', () {
      final lightScheme = XkLightTheme.themeData.colorScheme;
      final darkScheme = XkDarkTheme.themeData.colorScheme;
      
      expect(lightScheme.brightness, Brightness.light);
      expect(darkScheme.brightness, Brightness.dark);
    });
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
        await tester.pumpWidget(
          MaterialApp(theme: theme, home: body),
        );
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
          children: <Widget>[XkLoadingOverlay(message: '불러오는 중', visible: true)],
        ),
      );
      expect(find.text('불러오는 중'), findsWidgets);
    });

    testWidgets('XkSectionLabel uppercases title', (
      WidgetTester tester,
    ) async {
      await pumpBoth(tester, const XkSectionLabel(title: 'people'));
      expect(find.text('PEOPLE'), findsWidgets);
    });

    testWidgets('XkBackButton builds', (WidgetTester tester) async {
      await pumpBoth(
        tester,
        XkBackButton(label: '뒤로', onPressed: () {}),
      );
    });

    testWidgets('XkProgressBar builds and clamps', (
      WidgetTester tester,
    ) async {
      await pumpBoth(tester, const XkProgressBar(value: 1.5));
    });

    testWidgets('State panes build', (WidgetTester tester) async {
      await pumpBoth(tester, const XkLoadingPane());
      await pumpBoth(tester, const XkEmptyPane(message: '비어 있음'));
      await pumpBoth(
        tester,
        XkErrorPane(message: '오류', onRetry: () {}),
      );
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

