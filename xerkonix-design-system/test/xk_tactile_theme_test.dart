import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xerkonix_design_system/xerkonix_design_system.dart';

void main() {
  test('dark canvas is current TACTILE #111111, not product #141414', () {
    expect(XkTactileTokens.dark.canvas, const Color(0xFF111111));
    expect(
      XkTactileTheme.themeData(Brightness.dark).scaffoldBackgroundColor,
      const Color(0xFF111111),
    );
    expect(
      XkTactileTheme.themeData(Brightness.dark).scaffoldBackgroundColor,
      isNot(const Color(0xFF141414)),
    );
  });

  test('Material primary uses the theme monochrome pair', () {
    final ThemeData light = XkTactileTheme.themeData(Brightness.light);
    final ThemeData dark = XkTactileTheme.themeData(Brightness.dark);
    expect(light.colorScheme.primary, XkTactileTokens.light.primaryBase);
    expect(light.colorScheme.onPrimary, XkTactileTokens.light.primaryText);
    expect(dark.colorScheme.primary, XkTactileTokens.dark.primaryBase);
    expect(light.colorScheme.primary, const Color(0xFF111111));
    expect(dark.colorScheme.primary, const Color(0xFFF5F5F5));
    expect(light.colorScheme.secondary, XkTactileTokens.light.ink);
    expect(dark.colorScheme.secondary, XkTactileTokens.dark.ink);
    expect(light.cardTheme.color, XkTactileTokens.light.panelFill);
    expect(
      light.dialogTheme.backgroundColor,
      XkTactileTokens.light.overlayFill,
    );
    expect(light.popupMenuTheme.color, XkTactileTokens.light.overlayFill);
    expect(
      light.bottomSheetTheme.backgroundColor,
      XkTactileTokens.light.overlayFill,
    );
    expect(
      light.drawerTheme.backgroundColor,
      XkTactileTokens.light.overlayFill,
    );
    expect(
      light.snackBarTheme.backgroundColor,
      XkTactileTokens.light.overlayFill,
    );
    // Tab indicator is the neutral selected face, not ice or Aquamarine.
    expect(
      light.tabBarTheme.indicatorColor,
      XkTactileTokens.light.selectedBorder,
    );
    final ShapeDecoration tab = light.tabBarTheme.indicator! as ShapeDecoration;
    expect(tab.color, XkTactileTokens.light.selectedFill);
  });

  testWidgets('used Material controls read theme roles', (
    WidgetTester tester,
  ) async {
    final ThemeData theme = XkTactileTheme.themeData(Brightness.light);
    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: Scaffold(
          appBar: AppBar(title: const Text('bar')),
          drawer: const Drawer(child: Text('drawer')),
          body: ListView(
            children: <Widget>[
              const Card(child: Text('card')),
              FilledButton(onPressed: () {}, child: const Text('go')),
              Switch(value: true, onChanged: (_) {}),
              Checkbox(value: true, onChanged: (_) {}),
            ],
          ),
        ),
      ),
    );
    await tester.pump();
    expect(
      tester.widget<Card>(find.byType(Card)).color ?? theme.cardTheme.color,
      theme.cardTheme.color,
    );
    expect(
      Theme.of(tester.element(find.byType(AppBar))).appBarTheme.backgroundColor,
      theme.appBarTheme.backgroundColor,
    );
    expect(
      Theme.of(tester.element(find.byType(FilledButton))).colorScheme.primary,
      XkTactileTokens.light.primaryBase,
    );
  });

  group('product screen v4 roles (XkTactileAppSurface)', () {
    final Map<String, dynamic> rolesJson =
        jsonDecode(File('../tools/tactile_theme_roles.json').readAsStringSync())
            as Map<String, dynamic>;
    final Map<String, dynamic> app = rolesJson['app'] as Map<String, dynamic>;

    Color hex(String v) => Color(int.parse(v.substring(2), radix: 16));

    Map<String, Color> rolesOf(XkTactileAppSurface s) => <String, Color>{
      'currentLabel': s.currentLabel,
      'keyMetric': s.keyMetric,
      'humanReviewLabel': s.humanReviewLabel,
      'selectedCue': s.selectedCue,
      'humanReviewSurface': s.humanReviewSurface,
      'humanReviewBorder': s.humanReviewBorder,
    };

    /// CSS `color-mix(in srgb, a p%, b)` — premultiplied, 8-bit rounded.
    Color srgbMix(Color a, double p, Color b) {
      final double alpha = a.a * p + b.a * (1 - p);
      if (alpha == 0) {
        return const Color(0x00000000);
      }
      double ch(double x, double y) =>
          (x * a.a * p + y * b.a * (1 - p)) / alpha;
      int q(double v) => (v * 255 + 0.5).floor().clamp(0, 255);
      return Color.fromARGB(
        q(alpha),
        q(ch(a.r, b.r)),
        q(ch(a.g, b.g)),
        q(ch(a.b, b.b)),
      );
    }

    double contrast(Color fg, Color bg) {
      final Color top = Color.alphaBlend(fg, bg);
      final double l1 = top.computeLuminance();
      final double l2 = bg.computeLuminance();
      final double hi = math.max(l1, l2);
      final double lo = math.min(l1, l2);
      return (hi + 0.05) / (lo + 0.05);
    }

    test('names are exactly the DS mapping table roles', () {
      final Set<String> want = (app['roles'] as Map<String, dynamic>).keys
          .toSet();
      expect(rolesOf(XkTactileAppSurface.light).keys.toSet(), want);
      // Retired 2026-10-01: no ink plane, brand word or completion light.
      expect(want.where((String n) => n.contains('Intro')), isEmpty);
      expect(want, isNot(contains('completionSheen')));
      expect(app.containsKey('derived'), isFalse);
    });

    test('emphasis-dark bands read the [data-theme=dark] token block', () {
      final Map<String, dynamic> band =
          app['emphasisDark'] as Map<String, dynamic>;
      expect(band['kinds'], <String>['canvasFocus', 'footer']);
      expect(
        XkTactileEmphasisDarkKind.values.map((XkTactileEmphasisDarkKind k) => k.name),
        band['kinds'],
      );
      final Map<String, dynamic> tokens = band['tokens'] as Map<String, dynamic>;
      final XkTactileTokens d = XkTactileTokens.dark;
      final Map<String, Color> got = <String, Color>{
        'canvas': d.canvas,
        'ink': d.ink,
        'accent': d.accent,
        'muted': d.muted,
      };
      expect(tokens.keys.toSet(), got.keys.toSet());
      got.forEach((String name, Color c) {
        expect(c, hex((tokens[name] as Map<String, dynamic>)['dark'] as String), reason: name);
      });
      expect(d.canvas, const Color(0xFF111111));
      expect(d.ink, const Color(0xFFF5F5F5));
      expect(d.accent, const Color(0xFF65C9D9));
      expect(d.muted, const Color(0xFFAEB4BD));
    });

    for (final Brightness b in Brightness.values) {
      final String kind = b == Brightness.dark ? 'dark' : 'light';

      test('$kind roles equal generator json (app-surface.css)', () {
        final XkTactileAppSurface s = XkTactileTheme.themeData(
          b,
        ).extension<XkTactileAppSurface>()!;
        final Map<String, dynamic> spec = app['roles'] as Map<String, dynamic>;
        rolesOf(s).forEach((String role, Color got) {
          expect(
            got,
            hex((spec[role] as Map<String, dynamic>)[kind] as String),
            reason: role,
          );
        });
      });

      test('$kind derived roles follow the mapping formulas', () {
        final XkTactileTokens t = XkTactileTokens.of(b);
        final XkTactileAppSurface s = XkTactileAppSurface.fromTokens(t);
        const Color ink = Color(0xFF111111);
        final Color accentText = b == Brightness.dark
            ? t.accent
            : srgbMix(t.accent, 0.54, ink);
        for (final Color c in <Color>[
          s.currentLabel,
          s.keyMetric,
          s.humanReviewLabel,
          s.selectedCue,
        ]) {
          expect(c, accentText);
        }
        expect(
          s.humanReviewSurface,
          srgbMix(t.accent, b == Brightness.dark ? 0.13 : 0.11, t.surface),
        );
      });

      test('$kind reading roles keep AA contrast', () {
        final XkTactileTokens t = XkTactileTokens.of(b);
        final XkTactileAppSurface s = XkTactileAppSurface.fromTokens(t);
        final Map<String, (Color, Color)> pairs = <String, (Color, Color)>{
          'currentLabel/canvas': (s.currentLabel, t.canvas),
          'currentLabel/surface': (s.currentLabel, t.surface),
          'currentLabel/raised': (s.currentLabel, t.surfaceRaised),
          'keyMetric/surface': (s.keyMetric, t.surface),
          'selectedCue/canvas': (s.selectedCue, t.canvas),
          'humanReviewLabel/wash': (s.humanReviewLabel, s.humanReviewSurface),
          'ink/wash': (t.ink, s.humanReviewSurface),
          'ink/canvas': (t.ink, t.canvas),
          'muted/canvas': (t.muted, t.canvas),
          'primaryText/primary': (t.primaryText, t.primaryBase),
          'ink/selectedFill': (
            t.ink,
            Color.alphaBlend(t.selectedFill, t.canvas),
          ),
        };
        pairs.forEach((String name, (Color, Color) p) {
          expect(
            contrast(p.$1, p.$2),
            greaterThanOrEqualTo(4.5),
            reason: '$kind $name',
          );
        });
        // Focus ring is a required edge on the canvas: 3:1.
        expect(contrast(t.focusRing, t.canvas), greaterThanOrEqualTo(3));
      });

      test('$kind Material stays monochrome; indicators are neutral', () {
        final XkTactileTokens t = XkTactileTokens.of(b);
        final ThemeData theme = XkTactileTheme.themeData(b);
        final ColorScheme cs = theme.colorScheme;
        for (final Color c in <Color>[cs.primary, cs.secondary, cs.tertiary]) {
          expect(c, isNot(t.accent));
          expect(c, isNot(theme.extension<XkTactileAppSurface>()!.selectedCue));
        }
        expect(cs.primary, t.primaryBase);
        expect(theme.navigationBarTheme.indicatorColor, t.selectedFill);
        expect(theme.navigationRailTheme.indicatorColor, t.selectedFill);
        final RoundedRectangleBorder shape =
            theme.navigationBarTheme.indicatorShape! as RoundedRectangleBorder;
        expect(shape.side.color, t.selectedBorder);
        expect(
          theme.navigationBarTheme.labelTextStyle!.resolve(<WidgetState>{
            WidgetState.selected,
          })!.color,
          t.ink,
        );
        expect(theme.navigationRailTheme.selectedIconTheme!.color, t.ink);
        expect(theme.progressIndicatorTheme.color, t.accent);
        expect(
          theme.checkboxTheme.fillColor!.resolve(<WidgetState>{
            WidgetState.selected,
          }),
          t.controlOn,
        );
      });
    }

    testWidgets('of() falls back by brightness without the extension', (
      WidgetTester tester,
    ) async {
      late XkTactileAppSurface got;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: Brightness.dark),
          home: Builder(
            builder: (BuildContext context) {
              got = XkTactileAppSurface.of(context);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(got.currentLabel, XkTactileTokens.dark.currentLabel);
      expect(got.humanReviewSurface, XkTactileTokens.dark.humanReviewSurface);
    });

    test('lerp reaches the other theme', () {
      final XkTactileAppSurface end = XkTactileAppSurface.light.lerp(
        XkTactileAppSurface.dark,
        1,
      );
      expect(end.currentLabel, XkTactileTokens.dark.currentLabel);
      expect(end.humanReviewBorder, XkTactileTokens.dark.humanReviewBorder);
      expect(end, XkTactileAppSurface.dark);
    });

    testWidgets('NavigationBar selected destination paints the neutral face', (
      WidgetTester tester,
    ) async {
      final ThemeData theme = XkTactileTheme.themeData(Brightness.light);
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: Scaffold(
            bottomNavigationBar: NavigationBar(
              selectedIndex: 0,
              destinations: const <Widget>[
                NavigationDestination(icon: Icon(Icons.home), label: '홈'),
                NavigationDestination(icon: Icon(Icons.list), label: '목록'),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final NavigationIndicator indicator = tester
          .widgetList<NavigationIndicator>(find.byType(NavigationIndicator))
          .first;
      expect(indicator.color, XkTactileTokens.light.selectedFill);
    });
  });
}
