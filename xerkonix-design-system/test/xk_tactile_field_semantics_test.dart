import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xerkonix_design_system/xerkonix_design_system.dart';

SemanticsNode? _editableNamed(
  SemanticsNode root, {
  required String name,
  required bool obscured,
}) {
  SemanticsNode? found;
  void walk(SemanticsNode node) {
    final bool textField = node.hasFlag(SemanticsFlag.isTextField);
    final bool isObscured = node.hasFlag(SemanticsFlag.isObscured);
    if (textField && node.label == name && isObscured == obscured) {
      found = node;
    }
    node.visitChildren((SemanticsNode child) {
      walk(child);
      return true;
    });
  }

  walk(root);
  return found;
}

int _labelHits(SemanticsNode root, String name) {
  int n = 0;
  void walk(SemanticsNode node) {
    if (node.label == name) {
      n += 1;
    }
    node.visitChildren((SemanticsNode child) {
      walk(child);
      return true;
    });
  }

  walk(root);
  return n;
}

void main() {
  testWidgets(
    'editable node has exact label and text-field flags; name is not duplicated',
    (WidgetTester tester) async {
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

      final SemanticsNode root = tester.getSemantics(find.byType(Scaffold));
      final SemanticsNode? email = _editableNamed(
        root,
        name: '이메일',
        obscured: false,
      );
      final SemanticsNode? password = _editableNamed(
        root,
        name: '비밀번호',
        obscured: true,
      );
      expect(email, isNotNull, reason: 'no isTextField node labeled 이메일');
      expect(password, isNotNull, reason: 'no obscured isTextField labeled 비밀번호');
      expect(email!.label, '이메일');
      expect(password!.label, '비밀번호');
      expect(email.hasFlag(SemanticsFlag.isTextField), isTrue);
      expect(email.hasFlag(SemanticsFlag.isObscured), isFalse);
      expect(password.hasFlag(SemanticsFlag.isTextField), isTrue);
      expect(password.hasFlag(SemanticsFlag.isObscured), isTrue);
      expect(_labelHits(root, '이메일'), 1);
      expect(_labelHits(root, '비밀번호'), 1);

      final SemanticsNode fromFinder = tester.getSemantics(
        find.byType(TextField).at(0),
      );
      expect(fromFinder.hasFlag(SemanticsFlag.isTextField), isTrue);
      expect(fromFinder.label, '이메일');
      handle.dispose();
    },
  );

  testWidgets('XkTextInputField editable node keeps the exact public label', (
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
    final SemanticsNode root = tester.getSemantics(find.byType(Scaffold));
    final SemanticsNode? email = _editableNamed(
      root,
      name: '이메일',
      obscured: false,
    );
    expect(email, isNotNull);
    expect(email!.label, '이메일');
    expect(tester.getSemantics(find.byType(TextField)).hasFlag(
          SemanticsFlag.isTextField,
        ), isTrue);
    handle.dispose();
  });

  testWidgets('public borderRadius paints on the field chrome', (
    WidgetTester tester,
  ) async {
    const BorderRadius custom = BorderRadius.all(Radius.circular(4));
    await tester.pumpWidget(
      MaterialApp(
        theme: XkLightTheme.themeData,
        home: const Scaffold(
          body: XkTextInputField(
            label: '검색',
            borderRadius: custom,
          ),
        ),
      ),
    );
    await tester.pump();
    final DecoratedBox box = tester.widget<DecoratedBox>(
      find.descendant(
        of: find.byType(XkTactileField),
        matching: find.byType(DecoratedBox),
      ).first,
    );
    final BoxDecoration deco = box.decoration as BoxDecoration;
    expect(deco.borderRadius, custom);

    await tester.pumpWidget(
      MaterialApp(
        theme: XkLightTheme.themeData,
        home: const Scaffold(
          body: XkTextInputField(label: '검색'),
        ),
      ),
    );
    await tester.pump();
    final DecoratedBox def = tester.widget<DecoratedBox>(
      find.descendant(
        of: find.byType(XkTactileField),
        matching: find.byType(DecoratedBox),
      ).first,
    );
    expect(
      (def.decoration as BoxDecoration).borderRadius,
      BorderRadius.circular(XkTactileTokens.fieldRadius),
    );
  });
}
