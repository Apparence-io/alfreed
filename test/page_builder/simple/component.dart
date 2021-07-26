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
    this.state!.title = "My todo list";
    this.state!.todoList = [];
  }

  @override
  Future onInit() async {
    print("...onInit called");
    for (int i = 0; i < 4; i++) {
      this.state!.todoList!.add(new TodoModel("TODO $i", "my todo task $i"));
    }
    this.refreshView();
    super.onInit();
  }

  @override
  void onDeactivate() {
    state!.deactivated = true;
    super.onDeactivate();
  }

  void addTodo(String s) {
    this
        .state!
        .todoList!
        .add(new TodoModel("TODO ${this.state!.todoList!.length - 1}", s));
  }

  void addTodoWithRefresh(String s) {
    this
        .state!
        .todoList!
        .add(new TodoModel("TODO ${this.state!.todoList!.length - 1}", s));
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
  FirstPage({Object? args, this.rebuildAfterDisposed = true})
      : super(args: args);

  @override
  AlfreedPageBuilder<MyPresenter, MyModel, ViewInterface>
      get alfreedPageBuilder {
    return AlfreedPageBuilder<MyPresenter, MyModel, ViewInterface>(
      key: ValueKey("presenter"),
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
              separatorBuilder: (context, index) => Divider(height: 1),
              itemCount: model.todoList?.length ?? 0),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.redAccent,
            onPressed: () =>
                presenter.addTodoWithRefresh("Button Todo created"),
            child: Icon(Icons.plus_one),
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
    Object? args,
  }) : super(args: args);

  @override
  AlfreedPageBuilder<MyPresenter, MyModel, ViewInterface>
      get alfreedPageBuilder {
    return AlfreedPageBuilder<MyPresenter, MyModel, ViewInterface>(
      key: ValueKey("presenter"),
      builder: (ctx, presenter, model) {
        return Scaffold(
          body: Center(child: Text("second page")),
        );
      },
      presenterBuilder: (context) => MyPresenter(),
      interfaceBuilder: (context) => ViewInterface(context),
    );
  }
}

class ThirdPage extends AlfreedPage<MyPresenter, MyModel, ViewInterface> {
  ThirdPage();

  @override
  AlfreedPageBuilder<MyPresenter, MyModel, ViewInterface>
      get alfreedPageBuilder {
    return AlfreedPageBuilder<MyPresenter, MyModel, ViewInterface>(
      key: ValueKey("presenter3"),
      builder: (ctx, presenter, model) {
        return Scaffold(
          appBar: AppBar(),
          body: Center(child: Text("page3")),
        );
      },
      presenterBuilder: (context) => MyPresenter(),
      interfaceBuilder: (context) => ViewInterface(context),
    );
  }
}

Route<dynamic> route(RouteSettings settings) {
  print("push ${settings.name}");
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(onGenerateRoute: route);
  }
}

Widget? firstPageCache;

Route<dynamic> routeWithCache(RouteSettings settings) {
  print("push ${settings.name}");
  switch (settings.name) {
    case '/second':
      return MaterialPageRoute(
          builder: (_) => SecondPage(args: settings.arguments));
    case '/page3':
      return MaterialPageRoute(builder: (_) => ThirdPage());
    case '/pageWithNoRebuildAfterDisposed':
      if (firstPageCache == null) {
        print("build first page");
        firstPageCache = FirstPage(rebuildAfterDisposed: false);
      }
      return MaterialPageRoute(builder: (_) => firstPageCache!);
    default:
      return MaterialPageRoute(builder: (_) => FirstPage());
  }
}

class CachedBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(onGenerateRoute: routeWithCache);
  }
}
