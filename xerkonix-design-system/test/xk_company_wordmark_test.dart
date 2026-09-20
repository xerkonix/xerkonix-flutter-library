import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xerkonix_design_system/xerkonix_design_system.dart';

Future<void> _pump(
  WidgetTester tester, {
  required VoidCallback onOpenHome,
  Brightness brightness = Brightness.light,
}) {
  return tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(brightness: brightness),
      home: Scaffold(
        body: XkCompanyWordmark(onOpenHome: onOpenHome),
      ),
    ),
  );
}

void main() {
  testWidgets('tap and Enter open company home once each', (
    WidgetTester tester,
  ) async {
    int opened = 0;
    await _pump(tester, onOpenHome: () => opened += 1);

    expect(find.byType(XkCompanyWordmark), findsOneWidget);
    expect(XkCompanyWordmark.homeUrl, 'https://xerkonix.com/');

    await tester.tap(find.byType(XkCompanyWordmark));
    await tester.pump();
    expect(opened, 1);

    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(find.byKey(XkCompanyWordmark.focusRingKey), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(opened, 2);
  });

  testWidgets('순방향 Tab 한 번에 워드마크 focus-visible', (WidgetTester tester) async {
    await _pump(tester, onOpenHome: () {});
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pump();
    expect(find.byKey(XkCompanyWordmark.focusRingKey), findsNothing);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(find.byKey(XkCompanyWordmark.focusRingKey), findsOneWidget);
    bool inside = false;
    FocusManager.instance.primaryFocus?.context?.visitAncestorElements(
      (Element ancestor) {
        if (ancestor.widget is XkCompanyWordmark) {
          inside = true;
          return false;
        }
        return true;
      },
    );
    expect(inside, isTrue);
  });

  testWidgets('one mark in light and dark', (WidgetTester tester) async {
    await _pump(tester, onOpenHome: () {}, brightness: Brightness.light);
    expect(find.byType(XkCompanyWordmark), findsOneWidget);
    await _pump(tester, onOpenHome: () {}, brightness: Brightness.dark);
    expect(find.byType(XkCompanyWordmark), findsOneWidget);
  });

  testWidgets('필드에서 순방향 Tab 이 워드마크 링까지 간다', (WidgetTester tester) async {
    int opened = 0;
    final FocusNode fieldNode = FocusNode(
      onKeyEvent: XkTactileField.tabMovesToNeighbor,
    );
    addTearDown(fieldNode.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FocusTraversalGroup(
            policy: WidgetOrderTraversalPolicy(),
            child: Column(
              children: <Widget>[
                XkCompanyWordmark(onOpenHome: () => opened += 1),
                TextField(focusNode: fieldNode, autofocus: true),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(fieldNode.hasFocus, isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(find.byKey(XkCompanyWordmark.focusRingKey), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(opened, 1);
  });
}
