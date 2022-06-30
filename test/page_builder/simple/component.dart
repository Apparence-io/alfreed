import 'package:alfreed/alfreed.dart';
import 'package:flutter/material.dart';

class ViewInterface extends AlfreedView {
  ViewInterface(BuildContext context) : super(context: context);

  void showMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void pushPage1() => Navigator.of(context).pushReplacementNamed('/');

  void pop() => Navigator.of(context).pop();
}

class MyModel {
  String? title;
  List<TodoModel>? todoList;
  bool deactivated = false;
}

class TodoModel {
  String title, subtitle;

  TodoModel(this.title, this.subtitle);
}

class MyPresenter extends Presenter<MyModel, ViewInterface> {
  MyPresenter() : super(state: MyModel()) {
    state.title = "My todo list";
    state.todoList = [];
  }

  @override
  Future onInit() async {
    debugPrint("...onInit called");
    for (int i = 0; i < 4; i++) {
      state.todoList!.add(TodoModel("TODO $i", "my todo task $i"));
    }
    refreshView();
    super.onInit();
  }

  @override
  void onDeactivate() {
    state.deactivated = true;
    super.onDeactivate();
  }

  void addTodo(String s) {
    state.todoList!.add(TodoModel("TODO ${state.todoList!.length - 1}", s));
  }

  void addTodoWithRefresh(String s) {
    state.todoList!.add(TodoModel("TODO ${state.todoList!.length - 1}", s));
    refreshView();
  }

  onClickItem(int index) {
    view.showMessage("Item clicked $index");
  }
}

class PageArguments {
  String title;

  PageArguments(this.title);
}

class FirstPage extends AlfreedPage<MyPresenter, MyModel, ViewInterface> {
  final bool rebuildAfterDisposed;
  final String? presenterName;
  FirstPage(
      {Key? key,
      Object? args,
      this.rebuildAfterDisposed = true,
      this.presenterName})
      : super(key: key, args: args);

  @override
  AlfreedPageBuilder<MyPresenter, MyModel, ViewInterface> build() {
    return AlfreedPageBuilder(
      key: ValueKey(presenterName ?? "presenter"),
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
              IconButton(
                icon: const Icon(Icons.access_time),
                onPressed: () => Navigator.of(ctx.buildContext)
                    .pushNamed('/pageWithNoRebuildAfterDisposed'),
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
            onPressed: () =>
                presenter.addTodoWithRefresh("Button Todo created"),
            child: const Icon(Icons.plus_one),
          ),
        );
      },
      presenterBuilder: (context) => MyPresenter(),
      interfaceBuilder: (context) => ViewInterface(context),
      rebuildIfDisposed: rebuildAfterDisposed,
    );
  }
}

class SecondPage extends AlfreedPage<MyPresenter, MyModel, ViewInterface> {
  SecondPage({
    Key? key,
    Object? args,
  }) : super(key: key, args: args);

  @override
  AlfreedPageBuilder<MyPresenter, MyModel, ViewInterface> build() {
    return AlfreedPageBuilder(
      key: const ValueKey("presenter"),
      builder: (ctx, presenter, model) {
        return const Scaffold(
          body: Center(child: Text("second page")),
        );
      },
      presenterBuilder: (context) => MyPresenter(),
      interfaceBuilder: (context) => ViewInterface(context),
    );
  }
}

class ThirdPage extends AlfreedPage<MyPresenter, MyModel, ViewInterface> {
  ThirdPage({Key? key}) : super(key: key);

  @override
  AlfreedPageBuilder<MyPresenter, MyModel, ViewInterface> build() {
    return AlfreedPageBuilder(
      key: const ValueKey("presenter3"),
      builder: (ctx, presenter, model) {
        return Scaffold(
          appBar: AppBar(),
          body: const Center(child: Text("page3")),
        );
      },
      presenterBuilder: (context) => MyPresenter(),
      interfaceBuilder: (context) => ViewInterface(context),
    );
  }
}

Route<dynamic> route(RouteSettings settings) {
  debugPrint("push ${settings.name}");
  switch (settings.name) {
    case '/second':
      return MaterialPageRoute(
          builder: (_) => SecondPage(args: settings.arguments));
    case '/page3':
      return MaterialPageRoute(builder: (_) => ThirdPage());
    case '/pageWithNoRebuildAfterDisposed':
      return MaterialPageRoute(builder: (_) => FirstPage());
    default:
      return MaterialPageRoute(builder: (_) => FirstPage());
  }
}

class SimpleBuilderApp extends StatelessWidget {
  const SimpleBuilderApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(onGenerateRoute: route);
  }
}

Widget? firstPageCache;

Route<dynamic> routeWithCache(RouteSettings settings) {
  debugPrint("push ${settings.name}");
  switch (settings.name) {
    case '/second':
      return MaterialPageRoute(
          builder: (_) => SecondPage(args: settings.arguments));
    case '/page3':
      return MaterialPageRoute(builder: (_) => ThirdPage());
    case '/pageWithNoRebuildAfterDisposed':
      if (firstPageCache == null) {
        debugPrint("build first page");
        firstPageCache = FirstPage(rebuildAfterDisposed: false);
      }
      return MaterialPageRoute(builder: (_) => firstPageCache!);
    default:
      return MaterialPageRoute(builder: (_) => FirstPage());
  }
}

class CachedBuilder extends StatelessWidget {
  const CachedBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(onGenerateRoute: routeWithCache);
  }
}

Route<dynamic> routeWithCacheForceRebuild(RouteSettings settings) {
  debugPrint("push ${settings.name}");
  switch (settings.name) {
    case '/second':
      return MaterialPageRoute(
          builder: (_) => SecondPage(args: settings.arguments));
    case '/page3':
      return MaterialPageRoute(builder: (_) => ThirdPage());
    case '/pageWithNoRebuildAfterDisposed':
      return MaterialPageRoute(
          builder: (_) => FirstPage(
                rebuildAfterDisposed: true,
                presenterName: "cachedPresenter",
              ));
    default:
      return MaterialPageRoute(
        builder: (_) => FirstPage(
          rebuildAfterDisposed: false,
          presenterName: "presenter",
        ),
      );
  }
}

class CachedWithRebuildOnDisposeBuilder extends StatelessWidget {
  const CachedWithRebuildOnDisposeBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(onGenerateRoute: routeWithCacheForceRebuild);
  }
}
