import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xerkonix_logger_example/main.dart';

void main() {
  testWidgets('Logger Example app should have logger buttons', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MyHomePage(title: 'Test')));
    
    expect(find.text('Logger Test Result'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsWidgets);
  });

  testWidgets('Logger Example should display all logger type buttons', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MyHomePage(title: 'Test')));
    
    expect(find.text('Default Logger'), findsOneWidget);
    expect(find.text('Level Loggers'), findsOneWidget);
    expect(find.text('Fun Loggers'), findsOneWidget);
    expect(find.text('Exception Loggers'), findsOneWidget);
    expect(find.text('HTTP Loggers'), findsOneWidget);
  });

  testWidgets('Logger Example should show instructions', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MyHomePage(title: 'Test')));
    
    expect(find.text('Test Instructions'), findsOneWidget);
  });
}
