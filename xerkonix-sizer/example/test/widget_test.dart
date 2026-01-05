import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example/home_page.dart';

void main() {
  testWidgets('Sizer Example app should display sizer information', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));
    
    await tester.pumpAndSettle();
    
    expect(find.text('Sizer Information'), findsOneWidget);
  });

  testWidgets('Sizer Example should show window dimensions', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));
    
    await tester.pumpAndSettle();
    
    expect(find.textContaining('Window Width'), findsOneWidget);
    expect(find.textContaining('Window Height'), findsOneWidget);
  });

  testWidgets('Sizer Example should show LP values', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));
    
    await tester.pumpAndSettle();
    
    expect(find.text('LP Values Test'), findsOneWidget);
    expect(find.textContaining('LP4'), findsWidgets);
  });

  testWidgets('Sizer Example should have rebuild button', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));
    
    await tester.pumpAndSettle();
    
    expect(find.text('Rebuild'), findsOneWidget);
  });
}
