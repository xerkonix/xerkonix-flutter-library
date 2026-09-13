import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xerkonix_design_system/xerkonix_design_system.dart';

void main() {
  testWidgets('XkListRow Tab then Enter activates onTap', (
    WidgetTester tester,
  ) async {
    int n = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: XkListRow(
            label: '문서 정리',
            onTap: () => n++,
          ),
        ),
      ),
    );
    await tester.pump();
    expect(
      tester.getSemantics(find.text('문서 정리')),
      matchesSemantics(
        label: '문서 정리',
        isButton: true,
        isEnabled: true,
        isFocusable: true,
        hasEnabledState: true,
        hasSelectedState: true,
        hasTapAction: true,
        hasFocusAction: true,
      ),
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(n, 1);
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();
    expect(n, 2);
  });

  testWidgets('XkTabs Tab then Space selects the focused tab', (
    WidgetTester tester,
  ) async {
    int index = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: XkTabs(
            labels: const <String>['Tab 1', 'Tab 2', 'Tab 3'],
            index: index,
            onSelect: (int i) => index = i,
          ),
        ),
      ),
    );
    await tester.pump();
    expect(
      tester.getSemantics(find.text('Tab 2')),
      matchesSemantics(
        label: 'Tab 2',
        isButton: true,
        isEnabled: true,
        isFocusable: true,
        hasEnabledState: true,
        hasSelectedState: true,
        hasTapAction: true,
        hasFocusAction: true,
      ),
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();
    expect(index, 1);
  });

  testWidgets('XkGlass onTap keeps focus ring and ActivateIntent', (
    WidgetTester tester,
  ) async {
    int n = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: XkGlass(
            onTap: () => n++,
            child: const SizedBox(width: 48, height: 48),
          ),
        ),
      ),
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(n, 1);
  });

  Future<void> pumpDialog(
    WidgetTester tester, {
    required Size size,
    required VoidCallback onPrimary,
    required VoidCallback onSecondary,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        theme: XkLightTheme.themeData,
        home: Scaffold(
          body: XkDialog(
            title: '변화를 시작할 준비가 되셨나요? 이 확인은 현재 화면의 선택을 적용합니다.',
            body: List.filled(
              12,
              '지금, 더 명확한 가능성을 경험하세요. 이 확인은 현재 화면의 선택을 적용합니다. 나중에 하기를 누르면 아무 것도 바뀌지 않습니다.',
            ).join(' '),
            primaryLabel: '이 작업을 지금 시작하고 결과를 저장합니다',
            secondaryLabel: '나중에 다시 확인하고 지금은 닫습니다',
            onPrimary: onPrimary,
            onSecondary: onSecondary,
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('XkDialog 320 long labels wrap and body scrolls', (
    WidgetTester tester,
  ) async {
    int primary = 0;
    int secondary = 0;
    await pumpDialog(
      tester,
      size: const Size(320, 568),
      onPrimary: () => primary++,
      onSecondary: () => secondary++,
    );
    expect(tester.takeException(), isNull);
    expect(
      find.text('이 작업을 지금 시작하고 결과를 저장합니다'),
      findsOneWidget,
    );
    expect(
      find.text('나중에 다시 확인하고 지금은 닫습니다'),
      findsOneWidget,
    );
    final Size dialog = tester.getSize(find.byType(XkDialog));
    expect(dialog.width, lessThanOrEqualTo(320));
    expect(dialog.height, lessThanOrEqualTo(568 * 0.85 + 1));
    final Rect dialogRect = tester.getRect(find.byType(XkDialog));
    final Rect primaryRect = tester.getRect(
      find.text('이 작업을 지금 시작하고 결과를 저장합니다'),
    );
    final Rect secondaryRect = tester.getRect(
      find.text('나중에 다시 확인하고 지금은 닫습니다'),
    );
    expect(dialogRect.inflate(1).contains(primaryRect.topLeft), isTrue);
    expect(dialogRect.inflate(1).contains(secondaryRect.bottomRight), isTrue);
    expect(primaryRect.top, greaterThan(secondaryRect.bottom - 1));
    final ScrollableState scroll = tester.state<ScrollableState>(
      find.byType(Scrollable),
    );
    expect(scroll.position.maxScrollExtent, greaterThan(0));
    await tester.tap(find.text('나중에 다시 확인하고 지금은 닫습니다'));
    await tester.pump();
    expect(secondary, 1);
    await tester.tap(find.text('이 작업을 지금 시작하고 결과를 저장합니다'));
    await tester.pump();
    expect(primary, 1);
  });

  testWidgets('XkDialog 390 long labels wrap and actions stay inside', (
    WidgetTester tester,
  ) async {
    int primary = 0;
    await pumpDialog(
      tester,
      size: const Size(390, 844),
      onPrimary: () => primary++,
      onSecondary: () {},
    );
    expect(tester.takeException(), isNull);
    final Size dialog = tester.getSize(find.byType(XkDialog));
    expect(dialog.width, lessThanOrEqualTo(390));
    final Rect dialogRect = tester.getRect(find.byType(XkDialog));
    final Rect primaryRect = tester.getRect(
      find.text('이 작업을 지금 시작하고 결과를 저장합니다'),
    );
    expect(dialogRect.inflate(1).contains(primaryRect.center), isTrue);
    await tester.tap(find.text('이 작업을 지금 시작하고 결과를 저장합니다'));
    await tester.pump();
    expect(primary, 1);
  });
}
