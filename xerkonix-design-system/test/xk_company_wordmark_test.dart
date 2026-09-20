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

    await tester.tap(find.byType(TextButton));
    await tester.pump();
    expect(opened, 1);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(opened, 2);
  });

  testWidgets('one mark in light and dark', (WidgetTester tester) async {
    await _pump(tester, onOpenHome: () {}, brightness: Brightness.light);
    expect(find.byType(XkCompanyWordmark), findsOneWidget);
    await _pump(tester, onOpenHome: () {}, brightness: Brightness.dark);
    expect(find.byType(XkCompanyWordmark), findsOneWidget);
  });
}
