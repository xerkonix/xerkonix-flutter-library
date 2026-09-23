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
    expect(light.tabBarTheme.indicatorColor, XkTactileTokens.light.ice);
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
}
