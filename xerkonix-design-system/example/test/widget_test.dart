import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xerkonix_design_system_example/main.dart';

void main() {
  testWidgets('Design System Example app should display color palette', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MyHomePage(title: 'Test')));
    
    expect(find.text('Color Palette'), findsOneWidget);
  });

  testWidgets('Design System Example should display typography sections', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MyHomePage(title: 'Test')));
    
    expect(find.text('Typography - NotoSansKR'), findsOneWidget);
    expect(find.text('Typography - Roboto'), findsOneWidget);
    expect(find.text('Typography - SFPro'), findsOneWidget);
    expect(find.text('Typography - Material 3'), findsOneWidget);
    expect(find.text('Typography - Human Interface Guidelines'), findsOneWidget);
  });

  testWidgets('Design System Example should have theme toggle buttons', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MyHomePage(title: 'Test')));
    
    expect(find.text('Light Theme'), findsOneWidget);
    expect(find.text('Dark Theme'), findsOneWidget);
  });

  testWidgets('Design System Example should display NotoSansKR text', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MyHomePage(title: 'Test')));
    
    expect(find.textContaining('노토산스'), findsWidgets);
  });

  testWidgets('Design System Example should display Roboto text', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MyHomePage(title: 'Test')));
    
    expect(find.textContaining('Roboto'), findsWidgets);
  });

  testWidgets('Design System Example should display SFPro text', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MyHomePage(title: 'Test')));
    
    expect(find.textContaining('SFPro'), findsWidgets);
  });
}
