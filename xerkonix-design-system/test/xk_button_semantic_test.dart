import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xerkonix_design_system/xerkonix_design_system.dart';

Widget _harness({
  required ThemeData theme,
  required Widget child,
}) {
  return MaterialApp(
    theme: theme,
    home: Scaffold(body: child),
  );
}

BoxDecoration _fillOf(WidgetTester tester, String role) {
  final DecoratedBox box = tester.widget<DecoratedBox>(
    find.byKey(ValueKey<String>('xk-tactile-semantic-$role-fill')),
  );
  return box.decoration as BoxDecoration;
}

void main() {
  testWidgets('success/warning/error/info keep meaning colors, not secondary', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _harness(
        theme: XkLightTheme.themeData,
        child: Column(
          children: <Widget>[
            XkButton.success(onPressed: () {}, child: const Text('성공')),
            XkButton.warning(onPressed: () {}, child: const Text('경고')),
            XkButton.error(onPressed: () {}, child: const Text('위험')),
            XkButton.info(onPressed: () {}, child: const Text('안내')),
            XkButton.support(onPressed: () {}, child: const Text('보조')),
          ],
        ),
      ),
    );
    await tester.pump();

    expect(_fillOf(tester, 'success').color, XkColor.ok);
    expect(_fillOf(tester, 'warning').color, XkColor.warn);
    expect(_fillOf(tester, 'error').color, XkColor.bad);
    expect(_fillOf(tester, 'info').color, XkColor.ink2);

    final DecoratedBox secondary = tester.widget<DecoratedBox>(
      find.byKey(const ValueKey<String>('xk-tactile-secondary-fill')),
    );
    final Color? secondaryFill =
        (secondary.decoration as BoxDecoration).color;
    expect(_fillOf(tester, 'success').color, isNot(secondaryFill));
    expect(_fillOf(tester, 'error').color, isNot(secondaryFill));
    expect(_fillOf(tester, 'success').color, isNot(XkTactileTokens.light.secondaryFill));
    expect(_fillOf(tester, 'error').color, isNot(XkTactileTokens.light.ice));
  });

  testWidgets('dark semantic factories use dark meaning colors', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _harness(
        theme: XkDarkTheme.themeData,
        child: Column(
          children: <Widget>[
            XkButton.success(onPressed: () {}, child: const Text('성공')),
            XkButton.warning(onPressed: () {}, child: const Text('경고')),
            XkButton.error(onPressed: () {}, child: const Text('위험')),
            XkButton.info(onPressed: () {}, child: const Text('안내')),
          ],
        ),
      ),
    );
    await tester.pump();

    expect(_fillOf(tester, 'success').color, XkColor.darkOk);
    expect(_fillOf(tester, 'warning').color, XkColor.darkWarn);
    expect(_fillOf(tester, 'error').color, XkColor.darkBad);
    expect(_fillOf(tester, 'info').color, XkColor.darkInk2);
  });

  testWidgets('semantic factories still expose semanticColor on the public API', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _harness(
        theme: XkLightTheme.themeData,
        child: XkButton.success(onPressed: () {}, child: const Text('성공')),
      ),
    );
    final XkButton button = tester.widget<XkButton>(find.byType(XkButton));
    expect(button.semanticColor, XkColor.ok);
    expect(button.buttonType, ButtonType.semantic);
  });
}
