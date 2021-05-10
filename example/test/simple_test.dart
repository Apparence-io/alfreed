import 'package:alfreed_example/simple/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Builds page correctly', (WidgetTester tester) async {
    await tester.pumpWidget(SimpleBuilderApp());
    expect(find.text('my todo task 1'), findsOneWidget);
    expect(find.text('my todo task 2'), findsOneWidget);
    expect(find.text('my todo task 3'), findsOneWidget);
  });
}
