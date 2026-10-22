// XkCheckbox · XkRadio · XkSwitch 키보드 회귀 시험(§23 batchF MAJOR).
//
// 포커스 링을 켜고 끌 때 Material 컨트롤이 다시 마운트되면 안의 FocusNode 가
// 버려져, Tab 으로 들어간 포커스가 빠지고 Space·Enter 가 onChanged 를 부르지
// 않는다. 링만 남는다. 여기서는 Tab → 안정화 → primaryFocus 가 컨트롤 안 →
// Space·Enter 로 onChanged → 링 하나를 본다.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xerkonix_design_system/xerkonix_design_system.dart';

import 'xk_test_rings.dart';

bool _focusInside(WidgetTester tester, Finder control) {
  final BuildContext? focused = FocusManager.instance.primaryFocus?.context;
  if (focused == null) {
    return false;
  }
  final Element target = tester.element(control);
  bool inside = false;
  void up(Element e) {
    if (e == target) {
      inside = true;
    }
  }

  up(focused as Element);
  focused.visitAncestorElements((Element e) {
    up(e);
    return !inside;
  });
  return inside;
}

void main() {
  late FocusHighlightStrategy strategy;
  setUp(() {
    strategy = FocusManager.instance.highlightStrategy;
    FocusManager.instance.highlightStrategy =
        FocusHighlightStrategy.alwaysTraditional;
  });
  tearDown(() => FocusManager.instance.highlightStrategy = strategy);

  for (final Brightness b in Brightness.values) {
    for (final String kind in <String>['XkCheckbox', 'XkRadio', 'XkSwitch']) {
      testWidgets('$kind ${b.name}: Tab keeps focus, Space and Enter each '
          'call onChanged, one ring', (WidgetTester tester) async {
        final List<Object?> changes = <Object?>[];
        Widget control(bool on) => switch (kind) {
          'XkCheckbox' => XkCheckbox(value: on, onChanged: changes.add),
          'XkSwitch' => XkSwitch(value: on, onChanged: changes.add),
          _ => RadioGroup<int>(
            groupValue: on ? 1 : 0,
            onChanged: changes.add,
            child: const XkRadio<int>(value: 1),
          ),
        };
        await tester.pumpWidget(
          MaterialApp(
            theme: XkTactileTheme.themeData(b),
            home: Scaffold(body: Center(child: control(false))),
          ),
        );
        final Finder target = switch (kind) {
          'XkCheckbox' => find.byType(Checkbox),
          'XkSwitch' => find.byType(Switch),
          _ => find.byType(Radio<int>),
        };
        expect(xkFocusRings(), findsNothing);
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pumpAndSettle();
        expect(
          _focusInside(tester, target),
          isTrue,
          reason:
              'primaryFocus ${FocusManager.instance.primaryFocus} is not in $kind',
        );
        expect(xkFocusRings(), findsOneWidget);
        await tester.sendKeyEvent(LogicalKeyboardKey.space);
        await tester.pumpAndSettle();
        expect(changes, hasLength(1), reason: 'Space');
        expect(_focusInside(tester, target), isTrue, reason: 'after Space');
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pumpAndSettle();
        // Enter activates like Space. The test does not feed the new value
        // back, so each key asks again: checkbox / switch onChanged(true),
        // radio onChanged(1) (still unselected). Two calls for all three.
        expect(changes, hasLength(2), reason: 'Enter');
        expect(_focusInside(tester, target), isTrue, reason: 'after Enter');
        expect(xkFocusRings(), findsOneWidget);
      });
    }

    testWidgets('${b.name}: Tab through a column keeps one ring and real '
        'focus', (WidgetTester tester) async {
      int checks = 0, switches = 0, radios = 0, presses = 0;
      await tester.pumpWidget(
        MaterialApp(
          theme: XkTactileTheme.themeData(b),
          home: Scaffold(
            body: Column(
              children: <Widget>[
                XkCheckbox(value: false, onChanged: (_) => checks++),
                XkSwitch(value: false, onChanged: (_) => switches++),
                RadioGroup<int>(
                  groupValue: 0,
                  onChanged: (_) => radios++,
                  child: const XkRadio<int>(value: 1),
                ),
                TextButton(onPressed: () => presses++, child: const Text('저장')),
              ],
            ),
          ),
        ),
      );
      final List<Finder> order = <Finder>[
        find.byType(Checkbox),
        find.byType(Switch),
        find.byType(Radio<int>),
        find.byType(TextButton),
      ];
      for (int round = 0; round < 2; round++) {
        for (int i = 0; i < order.length; i++) {
          await tester.sendKeyEvent(LogicalKeyboardKey.tab);
          await tester.pumpAndSettle();
          expect(
            _focusInside(tester, order[i]),
            isTrue,
            reason:
                'round $round tab ${i + 1}: '
                '${FocusManager.instance.primaryFocus}',
          );
          expect(
            xkFocusRings(),
            i < 3 ? findsOneWidget : findsNothing,
            reason: 'round $round tab ${i + 1}: rings',
          );
        }
      }
      // Space on each control once.
      for (int i = 0; i < 4; i++) {
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pumpAndSettle();
        await tester.sendKeyEvent(LogicalKeyboardKey.space);
        await tester.pumpAndSettle();
      }
      expect(<int>[checks, switches, radios, presses], <int>[1, 1, 1, 1]);
    });
  }

  testWidgets('XkChip choice · XkTag · XkTactileField keep focus on Tab', (
    WidgetTester tester,
  ) async {
    int choice = 0, tag = 0;
    final TextEditingController text = TextEditingController();
    addTearDown(text.dispose);
    await tester.pumpWidget(
      MaterialApp(
        theme: XkTactileTheme.themeData(Brightness.light),
        home: Scaffold(
          body: Column(
            children: <Widget>[
              XkChip(label: '고르기', selected: false, onTap: () => choice++),
              XkTag(label: '태그', onTap: () => tag++),
              XkTactileField(
                child: TextField(
                  controller: text,
                  decoration: XkTactileField.inputDecoration(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(
      find.byKey(const ValueKey<String>('xk-chip-choice-focus-ring')),
      findsOneWidget,
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();
    expect(choice, 1);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(
      find.byKey(const ValueKey<String>('xk-tag-focus-ring')),
      findsOneWidget,
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(tag, 1);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(
      find.byKey(const ValueKey<String>('xk-tactile-field-focus-ring')),
      findsOneWidget,
    );
    expect(_focusInside(tester, find.byType(TextField)), isTrue);
    await tester.enterText(find.byType(TextField), '가나');
    await tester.pump();
    expect(text.text, '가나');
    expect(_focusInside(tester, find.byType(TextField)), isTrue);
  });

  testWidgets('XkSelectField: keyboard pick keeps focus and changes value', (
    WidgetTester tester,
  ) async {
    String? value = 'a';
    final List<String?> picks = <String?>[];
    await tester.pumpWidget(
      MaterialApp(
        theme: XkTactileTheme.themeData(Brightness.light),
        home: Scaffold(
          body: StatefulBuilder(
            builder: (BuildContext context, StateSetter set) =>
                XkSelectField<String>(
                  label: '고르기',
                  value: value,
                  options: const <XkSelectOption<String>>[
                    XkSelectOption<String>(value: 'a', label: '가'),
                    XkSelectOption<String>(value: 'b', label: '나'),
                    XkSelectOption<String>(value: 'c', label: '다'),
                  ],
                  onChanged: (String? v) {
                    picks.add(v);
                    set(() => value = v);
                  },
                ),
          ),
        ),
      ),
    );
    final Finder field = find.byType(DropdownButtonFormField<String>);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    expect(_focusInside(tester, field), isTrue, reason: 'Tab');
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(picks, <String?>['b']);
    expect(value, 'b');
    expect(find.text('나'), findsOneWidget, reason: 'shows the new value');
    expect(
      _focusInside(tester, field),
      isTrue,
      reason: 'focus after pick: ${FocusManager.instance.primaryFocus}',
    );
  });
}
