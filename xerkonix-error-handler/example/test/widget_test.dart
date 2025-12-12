import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xerkonix_error_handler_example/main.dart';

void main() {
  testWidgets('Error Handler Example app should have error buttons', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MyHomePage(title: 'Test')));
    
    expect(find.text('Error Handler Test Result'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsWidgets);
  });

  testWidgets('Error Handler Example should display standard error buttons', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MyHomePage(title: 'Test')));
    
    expect(find.text('Standard Errors'), findsOneWidget);
    expect(find.text('Bad Request'), findsOneWidget);
    expect(find.text('Unauthorized'), findsOneWidget);
    expect(find.text('Not Found'), findsOneWidget);
    expect(find.text('Conflict'), findsOneWidget);
    expect(find.text('Server Error'), findsOneWidget);
  });

  testWidgets('Error Handler Example should display custom error buttons', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MyHomePage(title: 'Test')));
    
    expect(find.text('Custom Errors'), findsOneWidget);
    expect(find.text('Custom Exception'), findsOneWidget);
    expect(find.text('Custom Dialog'), findsOneWidget);
  });

  testWidgets('Error Handler Example should show instructions', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MyHomePage(title: 'Test')));
    
    expect(find.text('Test Instructions'), findsOneWidget);
  });
}

