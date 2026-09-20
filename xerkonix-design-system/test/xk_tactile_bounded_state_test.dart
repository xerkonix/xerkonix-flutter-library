import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xerkonix_design_system/xerkonix_design_system.dart';

const double _parentW = 400;
const String _long =
    '아주 긴 단추 문구가 한 줄에 안 들어가면 부모 너비를 채우지 않고 줄바꿈한다';

Widget _bounded({required Widget child}) {
  return MaterialApp(
    theme: XkLightTheme.themeData,
    home: Scaffold(
      body: Center(
        child: SizedBox(
          width: _parentW,
          child: child,
        ),
      ),
    ),
  );
}

BoxDecoration _fieldChrome(WidgetTester tester, Finder field) {
  final DecoratedBox box = tester.widget<DecoratedBox>(
    find.descendant(of: field, matching: find.byType(DecoratedBox)).first,
  );
  return box.decoration as BoxDecoration;
}

SemanticsNode _editable(WidgetTester tester, Finder field) {
  final SemanticsNode start = tester.getSemantics(field);
  SemanticsNode? found;
  void walk(SemanticsNode node) {
    if (node.flagsCollection.isTextField) {
      found = node;
    }
    node.visitChildren((SemanticsNode child) {
      walk(child);
      return true;
    });
  }

  walk(start);
  return found ?? start;
}

void main() {
  testWidgets('bounded parent: expanded false shrinks, true fills, long text wraps',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      _bounded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            XkTactilePrimaryButton(
              key: const ValueKey<String>('pri-false'),
              onPressed: () {},
              child: const Text('시작하기'),
            ),
            XkTactilePrimaryButton(
              key: const ValueKey<String>('pri-true'),
              expanded: true,
              onPressed: () {},
              child: const Text('시작하기'),
            ),
            XkTactileButton(
              key: const ValueKey<String>('sec-false'),
              onPressed: () {},
              child: const Text('보조'),
            ),
            XkTactileButton(
              key: const ValueKey<String>('sec-true'),
              expanded: true,
              onPressed: () {},
              child: const Text('보조'),
            ),
            XkTactilePrimaryButton(
              key: const ValueKey<String>('pri-wrap'),
              onPressed: () {},
              child: const Text(_long),
            ),
            XkTactileButton(
              key: const ValueKey<String>('sec-wrap'),
              onPressed: () {},
              child: const Text(_long),
            ),
          ],
        ),
      ),
    );
    await tester.pump();

    Size fillUnder(String key, String fill) {
      return tester.getSize(
        find.descendant(
          of: find.byKey(ValueKey<String>(key)),
          matching: find.byKey(ValueKey<String>(fill)),
        ),
      );
    }

    final Size priFalse = fillUnder('pri-false', 'xk-tactile-primary-fill');
    final Size priTrue = fillUnder('pri-true', 'xk-tactile-primary-fill');
    final Size secFalse = fillUnder('sec-false', 'xk-tactile-secondary-fill');
    final Size secTrue = fillUnder('sec-true', 'xk-tactile-secondary-fill');
    final Size priWrap = fillUnder('pri-wrap', 'xk-tactile-primary-fill');
    final Size secWrap = fillUnder('sec-wrap', 'xk-tactile-secondary-fill');

    debugPrint(
      'bounded-measure priFalse=$priFalse priTrue=$priTrue '
      'secFalse=$secFalse secTrue=$secTrue '
      'priWrap=$priWrap secWrap=$secWrap',
    );

    expect(priFalse.height, greaterThanOrEqualTo(XkTactileTokens.controlHeight));
    expect(secFalse.height, greaterThanOrEqualTo(XkTactileTokens.controlHeight));
    expect(priFalse.width, lessThan(_parentW - 40),
        reason: 'expanded=false must not fill the 400 parent (got $priFalse)');
    expect(secFalse.width, lessThan(_parentW - 40),
        reason: 'expanded=false secondary must shrink (got $secFalse)');
    expect(priTrue.width, closeTo(_parentW, 0.5));
    expect(secTrue.width, closeTo(_parentW, 0.5));

    expect(priWrap.width, lessThanOrEqualTo(_parentW + 0.5));
    expect(secWrap.width, lessThanOrEqualTo(_parentW + 0.5));
    expect(priWrap.height, greaterThan(XkTactileTokens.controlHeight + 8),
        reason: 'long label must wrap above min-height (got $priWrap)');
    expect(secWrap.height, greaterThan(XkTactileTokens.controlHeight + 8),
        reason: 'long label must wrap above min-height (got $secWrap)');
  });

  testWidgets('field focus/disabled/invalid keep readable labels', (
    WidgetTester tester,
  ) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    final FocusNode focus = FocusNode();
    addTearDown(focus.dispose);

    await tester.pumpWidget(
      MaterialApp(
        theme: XkLightTheme.themeData,
        home: Scaffold(
          body: Column(
            children: <Widget>[
              XkTextInputField(
                label: '이메일',
                hintText: 'name@example.com',
              ),
              XkTextInputField(
                label: '비밀번호',
                enabled: false,
              ),
              XkTextInputField(
                label: '인증번호',
                errorText: '코드가 올바르지 않습니다',
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('이메일'), findsOneWidget);
    expect(find.text('비밀번호'), findsOneWidget);
    expect(find.text('인증번호'), findsOneWidget);
    expect(find.text('코드가 올바르지 않습니다'), findsOneWidget);

    final Finder fields = find.byType(XkTactileField);
    expect(fields, findsNWidgets(3));

    final Finder inputs = find.byType(TextField);
    final SemanticsNode email = _editable(tester, inputs.at(0));
    final SemanticsNode password = _editable(tester, inputs.at(1));
    final SemanticsNode code = _editable(tester, inputs.at(2));
    expect(email.flagsCollection.isTextField, isTrue);
    expect(password.flagsCollection.isTextField, isTrue);
    expect(code.flagsCollection.isTextField, isTrue);
    expect(email.label.split('\n').first, '이메일');
    expect(password.label.split('\n').first, '비밀번호');
    expect(code.label.split('\n').first, '인증번호');

    final BoxDecoration rest = _fieldChrome(tester, fields.at(0));
    final BoxDecoration disabled = _fieldChrome(tester, fields.at(1));
    final BoxDecoration invalid = _fieldChrome(tester, fields.at(2));
    expect(rest.border?.top.color, XkTactileTokens.light.inputBorder);
    expect(disabled.border?.top.color, XkTactileTokens.light.inputBorder);
    expect(invalid.border?.top.color, XkTactileTokens.light.accentDeep);
    expect(find.text('이메일').hitTestable(), findsOneWidget);
    expect(find.text('비밀번호').hitTestable(), findsOneWidget);
    expect(find.text('인증번호').hitTestable(), findsOneWidget);

    await tester.tap(inputs.at(0));
    await tester.pump();
    final BoxDecoration focused = _fieldChrome(tester, fields.at(0));
    expect(focused.border?.top.color, XkTactileTokens.light.accent);
    expect(focused.boxShadow, isNotNull);
    expect(_editable(tester, inputs.at(0)).label.split('\n').first, '이메일');
    expect(_editable(tester, inputs.at(0)).flagsCollection.isTextField, isTrue);
    handle.dispose();
  });
}
