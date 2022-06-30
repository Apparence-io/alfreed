import 'package:alfreed/alfreed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'component.dart';

/// Presenter is mocked  to test content builder
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  var presenterMock = MyPresenterMock();

  var myPageBuilder = AlfreedPageBuilder<MyPresenter, MyModel, ViewInterface>(
    key: const ValueKey("presenter"),
    builder: (ctx, presenter, model) {
      return Scaffold(
        // key: _scaffoldKey,
        appBar: AppBar(
          title: Text(model.title ?? ""),
          actions: [
            IconButton(
              icon: const Icon(Icons.add_alert),
              tooltip: 'Show Snackbar',
              onPressed: () => Navigator.of(ctx.buildContext)
                  .pushReplacementNamed('/second',
                      arguments: PageArguments("test")),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () =>
                  Navigator.of(ctx.buildContext).pushNamed('/page3'),
            ),
          ],
        ),
        body: ListView.separated(
            itemBuilder: (context, index) => InkWell(
                  onTap: () => presenter.onClickItem(index),
                  child: ListTile(
                    title: Text(model.todoList![index].title),
                    subtitle: Text(model.todoList![index].subtitle),
                  ),
                ),
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemCount: model.todoList?.length ?? 0),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.redAccent,
          onPressed: () => presenter.addTodoWithRefresh("Button Todo created"),
          child: const Icon(Icons.plus_one),
        ),
      );
    },
    presenterBuilder: (context) => presenterMock,
    interfaceBuilder: (context) => ViewInterface(context),
  );

  _beforeEach(WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(onGenerateRoute: (RouteSettings settings) {
      switch (settings.name) {
        case '/second':
          secondPage.args = settings.arguments;
          return MaterialPageRoute(builder: secondPage.build);
        case '/page3':
          return MaterialPageRoute(builder: page3.build);
        default:
          return MaterialPageRoute(builder: myPageBuilder.build);
      }
    }));
  }

  tearDown(() {
    reset(presenterMock);
  });

  testWidgets('on page started -> onInit is called, onViewCreated is called',
      (WidgetTester tester) async {
    var state = MyModel();
    when(presenterMock.hasInit).thenReturn(false);
    when(presenterMock.state).thenReturn(state);
    when(presenterMock.onInit()).thenReturn(null);
    when(presenterMock.afterViewInit()).thenReturn(null);
    await _beforeEach(tester);
    verify(presenterMock.onInit()).called(1);
    verify(presenterMock.afterViewInit()).called(1);
  });

  testWidgets(
      'push page3, pop page, push back page3 -> onInit is not called again',
      (WidgetTester tester) async {
    var state = MyModel();
    when(presenterMock.state).thenReturn(state);
    when(presenterMock.hasInit).thenReturn(false);
    when(presenterMock.onInit()).thenReturn(null);
    when(presenterMock.afterViewInit()).thenReturn(null);
    await _beforeEach(tester);
    await tester.tap(find.byType(IconButton).at(1));
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
    await tester.pageBack();
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
    verify(presenterMock.onInit()).called(1);
    verify(presenterMock.afterViewInit()).called(1);
  });
}
