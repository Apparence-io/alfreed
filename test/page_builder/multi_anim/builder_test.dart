import 'package:alfreed/src/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'component.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Multi anim builder', () {
    testWidgets('Builds page correctly using alfreed',
        (WidgetTester tester) async {
      await tester.pumpWidget(MultiAnimBuilderApp());
      expect(find.text('my todo task 1'), findsOneWidget);
      expect(find.text('my todo task 2'), findsOneWidget);
      expect(find.text('my todo task 3'), findsOneWidget);
    });

    testWidgets('Using presenter directly -> add a todo and refresh view',
        (WidgetTester tester) async {
      await tester.pumpWidget(MultiAnimBuilderApp());
      var presenter = AlfreedUtils.getPresenterByKey<MyPresenter, MyModel>(
          tester, ValueKey("presenter"));
      presenter.addTodo('my todo task NEW');
      expect(find.text('my todo task NEW'), findsNothing);
      presenter.refreshView();
      await tester.pumpAndSettle(Duration(milliseconds: 100));
      expect(find.text('my todo task NEW'), findsOneWidget);
    });

    testWidgets(
        'Press add todo from floating button -> a new Todo is available',
        (WidgetTester tester) async {
      await tester.pumpWidget(MultiAnimBuilderApp());
      var floatingFinder = find.byType(FloatingActionButton);
      expect(find.text('Button Todo created'), findsNothing);
      await tester.tap(floatingFinder);
      await tester.pumpAndSettle(Duration(milliseconds: 100));
      expect(find.text('Button Todo created'), findsOneWidget);
    });
  });
}
