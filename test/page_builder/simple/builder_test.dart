import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils.dart';
import 'component.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Builds page correctly using alfreed',
      (WidgetTester tester) async {
    await tester.pumpWidget(SimpleBuilderApp());
    expect(find.text('my todo task 1'), findsOneWidget);
    expect(find.text('my todo task 2'), findsOneWidget);
    expect(find.text('my todo task 3'), findsOneWidget);
  });

  testWidgets('Using presenter directly -> add a todo and refresh view',
      (WidgetTester tester) async {
    await tester.pumpWidget(SimpleBuilderApp());
    var presenter = AlfreedUtils.getPresenterByKey<MyPresenter, MyModel>(
        tester, ValueKey("presenter"));
    presenter.addTodo('my todo task NEW');
    expect(find.text('my todo task NEW'), findsNothing);
    presenter.refreshView();
    await tester.pumpAndSettle(Duration(milliseconds: 100));
    expect(find.text('my todo task NEW'), findsOneWidget);
  });

  testWidgets('Press add todo from floating button -> a new Todo is available',
      (WidgetTester tester) async {
    await tester.pumpWidget(SimpleBuilderApp());
    var floatingFinder = find.byType(FloatingActionButton);
    expect(find.text('Button Todo created'), findsNothing);
    await tester.tap(floatingFinder);
    await tester.pumpAndSettle(Duration(milliseconds: 100));
    expect(find.text('Button Todo created'), findsOneWidget);
  });

  testWidgets(
      'route to page1 then second page -> second page is shown, deactivated is called',
      (WidgetTester tester) async {
    await tester.pumpWidget(SimpleBuilderApp());
    var presenter = AlfreedUtils.getPresenterByKey<MyPresenter, MyModel>(
        tester, ValueKey("presenter"));
    var secondPageButton = find.byType(IconButton);
    await tester.tap(secondPageButton.first);
    await tester.pumpAndSettle(Duration(milliseconds: 100));
    await tester.pumpAndSettle(Duration(milliseconds: 100));
    await tester.pumpAndSettle(Duration(milliseconds: 100));
    expect(find.text('second page'), findsOneWidget);
    expect(presenter.state!.deactivated, isTrue);
  });
}
