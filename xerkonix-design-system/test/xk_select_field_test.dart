// XkSelectField — 부모가 값을 바꾸면 화면이 그 값을 반영하는지(§23 batchG MINOR).
//
// #28 에서 값 key(ValueKey(value))를 지웠다. 그 뒤로는 DropdownButtonFormField 가 바뀐
// initialValue 를 didUpdateWidget 에서 스스로 반영한다. 키보드로 고르는 경로는
// xk_tactile_controls_keyboard_test.dart 가 보고, 여기서는 부모가 값을 바꾸는 경로를 본다:
// 'a' → 'b' → null → 'a'. 필드 상태 객체가 그대로인지(다시 마운트하지 않는지)도 본다.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xerkonix_design_system/xerkonix_design_system.dart';

class _Host extends StatefulWidget {
  const _Host({super.key});

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  String? value = 'a';

  void set(String? next) => setState(() => value = next);

  @override
  Widget build(BuildContext context) {
    return XkSelectField<String>(
      label: '고르기',
      value: value,
      options: const <XkSelectOption<String>>[
        XkSelectOption<String>(value: 'a', label: '가'),
        XkSelectOption<String>(value: 'b', label: '나'),
        XkSelectOption<String>(value: 'c', label: '다'),
      ],
      onChanged: set,
    );
  }
}

void main() {
  testWidgets('XkSelectField: parent value a → b → null → a shows on screen', (
    WidgetTester tester,
  ) async {
    final GlobalKey<_HostState> host = GlobalKey<_HostState>();
    await tester.pumpWidget(
      MaterialApp(
        theme: XkTactileTheme.themeData(Brightness.light),
        home: Scaffold(body: _Host(key: host)),
      ),
    );
    final Finder field = find.byType(DropdownButtonFormField<String>);
    final State<StatefulWidget> first = tester.state(field);

    // Shown value: the selected item text inside the closed field.
    List<String> shown() => <String>['가', '나', '다']
        .where(
          (String t) => find
              .descendant(of: field, matching: find.text(t))
              .hitTestable()
              .evaluate()
              .isNotEmpty,
        )
        .toList();

    expect(shown(), <String>['가']);
    for (final (String? next, List<String> want) in <(String?, List<String>)>[
      ('b', <String>['나']),
      (null, <String>[]),
      ('a', <String>['가']),
    ]) {
      host.currentState!.set(next);
      await tester.pumpAndSettle();
      expect(shown(), want, reason: 'parent value $next');
      expect(
        (tester.state(field) as FormFieldState<String>).value,
        next,
        reason: 'field value $next',
      );
      expect(
        identical(tester.state(field), first),
        isTrue,
        reason: 'field remounted on value $next',
      );
    }
  });
}
