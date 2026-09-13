import 'package:flutter_test/flutter_test.dart';
import 'package:xerkonix_design_system_example/main.dart';

void main() {
  testWidgets('Example should render the component matrix', (tester) async {
    await tester.pumpWidget(const TACTILEExampleApp());
    await tester.pump();

    expect(find.text('더 명확한 가능성을 만듭니다.'), findsOneWidget);
    expect(find.text('Primary'), findsOneWidget);
    expect(find.text('Secondary'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
  });

  testWidgets('Example should render select, tabs, and dialog copy', (
    tester,
  ) async {
    await tester.pumpWidget(const TACTILEExampleApp());
    await tester.pump();

    expect(find.text('수집'), findsWidgets);
    expect(find.text('Tab 1'), findsOneWidget);
    expect(find.text('변화를 시작할 준비가 되셨나요?'), findsOneWidget);
  });
}
