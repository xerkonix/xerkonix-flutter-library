import 'package:flutter_test/flutter_test.dart';
import 'package:xerkonix_design_system_example/main.dart';

void main() {
  testWidgets('Example should render major sections', (tester) async {
    await tester.pumpWidget(const WeaveExampleApp());
    await tester.pumpAndSettle();

    expect(find.text('Iconography'), findsOneWidget);
    expect(find.text('Components'), findsOneWidget);
    expect(find.text('Pattern'), findsOneWidget);
    expect(find.text('Motion'), findsOneWidget);
  });

  testWidgets('Example should render icon and motion labels', (tester) async {
    await tester.pumpWidget(const WeaveExampleApp());
    await tester.pumpAndSettle();

    expect(find.text('chev-left'), findsWidgets);
    expect(find.text('Status Breath'), findsWidgets);
    expect(find.text('Signal Sweep'), findsWidgets);
    expect(find.text('Alert Beat'), findsWidgets);
  });
}
