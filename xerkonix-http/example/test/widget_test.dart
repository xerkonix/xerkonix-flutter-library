import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example/main.dart';

void main() {
  testWidgets('HTTP Example app should have test button', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MyHomePage(title: 'Test')));
    
    expect(find.text('Test'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsWidgets);
  });

  testWidgets('HTTP Example should display result card', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MyHomePage(title: 'Test')));
    
    expect(find.text('HTTP Methods Test'), findsOneWidget);
    expect(find.text('No request made yet'), findsOneWidget);
  });

  testWidgets('HTTP Example should have all method buttons', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MyHomePage(title: 'Test')));
    
    expect(find.text('GET'), findsOneWidget);
    expect(find.text('POST'), findsOneWidget);
    expect(find.text('PUT'), findsOneWidget);
    expect(find.text('DELETE'), findsOneWidget);
    expect(find.text('PATCH'), findsOneWidget);
    expect(find.text('CUSTOM'), findsOneWidget);
  });

  testWidgets('HTTP Example should show instructions', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MyHomePage(title: 'Test')));
    
    expect(find.text('Test Instructions'), findsOneWidget);
  });
}
