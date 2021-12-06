import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils.dart';
import 'component.dart';

void main() {
  // TestWidgetsFlutterBinding.ensureInitialized();

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
    var presenter = AlfreedUtils.getPresenterByKey<MyPresenter, MyModel>(
        tester, ValueKey("presenter"));
    var floatingFinder = find.byType(FloatingActionButton);
    expect(find.text('Button Todo created'), findsNothing);
    await tester.tap(floatingFinder);
    await tester.pumpAndSettle(Duration(milliseconds: 100));
    expect(find.text('Button Todo created'), findsOneWidget);
    expect(presenter.state!.todoList!.length, equals(5));
  });

  testWidgets('state is reset after rebuild', (WidgetTester tester) async {
    await tester.pumpWidget(SimpleBuilderApp());
    var presenter = AlfreedUtils.getPresenterByKey<MyPresenter, MyModel>(
        tester, ValueKey("presenter"));
    expect(presenter.state!.todoList!.length, equals(4));
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
    expect(find.text('second page'), findsOneWidget);
    expect(presenter.state!.deactivated, isTrue);
  });

  testWidgets(
      'go second page add todo, then pop page, go back to second page -> second page is on initial state',
      (WidgetTester tester) async {
    await tester.pumpWidget(SimpleBuilderApp());
    await tester.tap(find.byType(IconButton).first);
    await tester.pumpAndSettle(Duration(milliseconds: 100));

    // show second page and add todo - back to page1
    var presenter = AlfreedUtils.getPresenterByKey<MyPresenter, MyModel>(
        tester, ValueKey("presenter"));
    expect(presenter.state!.todoList!.length, equals(4));
    presenter.addTodo("Second page");
    expect(find.text('second page'), findsOneWidget);
    expect(presenter.state!.todoList!.length, equals(5));
    presenter.view.pushPage1();
    await tester.pumpAndSettle(Duration(milliseconds: 100));
    expect(find.text('second page'), findsNothing);

    // show second page again
    await tester.tap(find.byType(IconButton).first);
    await tester.pumpAndSettle(Duration(milliseconds: 100));
    var presenter2 = AlfreedUtils.getPresenterByKey<MyPresenter, MyModel>(
        tester, ValueKey("presenter"));
    expect(find.text('second page'), findsOneWidget);
    expect(presenter2.state!.todoList!.length, equals(4));
  });

  testWidgets(
      'route to page1 then second page -> second page is shown using arguments',
      (WidgetTester tester) async {
    await tester.pumpWidget(SimpleBuilderApp());
    var secondPageButton = find.byType(IconButton);
    await tester.tap(secondPageButton.first);
    await tester.pumpAndSettle(Duration(milliseconds: 100));
    var presenter = AlfreedUtils.getPresenterByKey<MyPresenter, MyModel>(
        tester, ValueKey("presenter"));
    expect(find.text('second page'), findsOneWidget);
    expect(presenter.args, isNotNull);
    var pageArgs = presenter.args as PageArguments;
    expect(pageArgs.title, "test");
  });

  testWidgets(
      'add todo, then push page3, go back to second page -> second page is on previous state, onInit is not called again',
      (WidgetTester tester) async {
    await tester.pumpWidget(SimpleBuilderApp());
    // add a todo
    var presenterPage1 = AlfreedUtils.getPresenterByKey<MyPresenter, MyModel>(
        tester, ValueKey("presenter"));
    var floatingFinder = find.byType(FloatingActionButton);
    await tester.tap(floatingFinder);
    await tester.pumpAndSettle(Duration(milliseconds: 100));
    expect(presenterPage1.state!.todoList!.length, equals(5));
    // push page3
    await tester.tap(find.byType(IconButton).at(1));
    await tester.pumpAndSettle(Duration(milliseconds: 100));
    // pop page3
    var presenterPage3 = AlfreedUtils.getPresenterByKey<MyPresenter, MyModel>(
        tester, ValueKey("presenter3"));
    presenterPage3.view.pop();
    // page one has still 5 todo
    expect(presenterPage1.state!.todoList!.length, equals(5));
  });

  testWidgets(
      'page has rebuildIfDisposed=false, go page add todo, then pop page, go back to page -> page has restored previous state',
      (WidgetTester tester) async {
    await tester.pumpWidget(CachedBuilder());
    // show page and add todo
    await tester.tap(find.byType(IconButton).last);
    await tester.pumpAndSettle(Duration(milliseconds: 100));
    var presenter = AlfreedUtils.getPresenterByKey<MyPresenter, MyModel>(
        tester, ValueKey("presenter"));
    expect(presenter.state!.todoList!.length, equals(4));
    expect(find.byType(ListTile), findsNWidgets(4));
    presenter.addTodoWithRefresh("new todo one");
    await tester.pumpAndSettle(Duration(milliseconds: 100));
    expect(presenter.state!.todoList!.length, equals(5));
    expect(find.byType(ListTile), findsNWidgets(5));
    //pop page
    presenter.view.pop();
    await tester.pumpAndSettle(Duration(milliseconds: 100));
    expect(find.text('new todo one'), findsNothing);
    // show page again
    await tester.tap(find.byType(IconButton).last);
    await tester.pumpAndSettle(Duration(milliseconds: 100));
    var presenter2 = AlfreedUtils.getPresenterByKey<MyPresenter, MyModel>(
        tester, ValueKey("presenter"));
    expect(find.text('new todo one'), findsOneWidget);
    expect(presenter2.state!.todoList!.length, equals(5));
  });
}
