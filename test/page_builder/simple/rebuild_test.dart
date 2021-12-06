import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils.dart';
import 'component.dart';

void main() {
  group('check rebuild if disposed', () {
    testWidgets(
        'page has rebuildIfDisposed=true, go page add todo, then pop page, go back to page -> page has init again',
        (WidgetTester tester) async {
      await tester.pumpWidget(CachedWithRebuildOnDisposeBuilder());
      // show page and add todo
      await tester.tap(find.byType(IconButton).last);
      await tester.pumpAndSettle(Duration(milliseconds: 100));
      var presenter = AlfreedUtils.getPresenterByKey<MyPresenter, MyModel>(
          tester, ValueKey("cachedPresenter"));
      expect(presenter.state!.todoList!.length, equals(4));
      expect(find.byType(ListTile), findsNWidgets(4));
      presenter.addTodoWithRefresh("new todo one");
      await tester.pumpAndSettle(Duration(milliseconds: 100));
      expect(presenter.state!.todoList!.length, equals(5));
      expect(find.byType(ListTile), findsNWidgets(5));
      // pop page
      presenter.view.pop();
      await tester.pumpAndSettle(Duration(milliseconds: 100));
      expect(find.text('new todo one'), findsNothing);
      // show page again
      await tester.tap(find.byType(IconButton).last);
      await tester.pumpAndSettle(Duration(milliseconds: 100));
      expect(find.text('new todo one'), findsNothing);
      var presenter2 = AlfreedUtils.getPresenterByKey<MyPresenter, MyModel>(
          tester, ValueKey("cachedPresenter"));
      expect(presenter2.state!.todoList!.length, equals(4));
    });
  });
}
