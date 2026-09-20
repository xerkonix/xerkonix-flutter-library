import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xerkonix_design_system/xerkonix_design_system.dart';

String? _nameNear(WidgetTester tester, Finder field) {
  SemanticsNode node = tester.getSemantics(field);
  for (int i = 0; i < 10; i++) {
    if (node.label.isNotEmpty) {
      return node.label;
    }
    final SemanticsNode? parent = node.parent;
    if (parent == null) {
      return null;
    }
    node = parent;
  }
  return null;
}

bool _treeHasLabel(SemanticsNode root, String name) {
  if (root.label.contains(name)) {
    return true;
  }
  bool found = false;
  root.visitChildren((SemanticsNode child) {
    if (_treeHasLabel(child, name)) {
      found = true;
      return false;
    }
    return true;
  });
  return found;
}

void main() {
  testWidgets('external label is the TextField accessible name', (
    WidgetTester tester,
  ) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    await tester.pumpWidget(
      MaterialApp(
        theme: XkLightTheme.themeData,
        home: const Scaffold(
          body: Column(
            children: <Widget>[
              XkTactileField(
                label: '이메일',
                child: TextField(),
              ),
              XkTactileField(
                label: '비밀번호',
                child: TextField(obscureText: true),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    final Finder fields = find.byType(TextField);
    expect(fields, findsNWidgets(2));
    expect(_nameNear(tester, fields.at(0)), contains('이메일'));
    expect(_nameNear(tester, fields.at(1)), contains('비밀번호'));

    final SemanticsNode root = tester.getSemantics(find.byType(Scaffold));
    expect(_treeHasLabel(root, '이메일'), isTrue);
    expect(_treeHasLabel(root, '비밀번호'), isTrue);
    handle.dispose();
  });

  testWidgets('XkTextInputField delegates to XkTactileField and keeps names', (
    WidgetTester tester,
  ) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    await tester.pumpWidget(
      MaterialApp(
        theme: XkLightTheme.themeData,
        home: const Scaffold(
          body: XkTextInputField(label: '이메일'),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(XkTactileField), findsOneWidget);
    expect(find.byType(XkGlass), findsNothing);
    expect(_nameNear(tester, find.byType(TextField)), contains('이메일'));
    handle.dispose();
  });
}
