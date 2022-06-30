import 'package:flutter/material.dart';
import 'package:alfreed/alfreed.dart';

import 'model.dart';
import 'presenter.dart';

void main() {
  runApp(const SimpleBuilderApp());
}

class ViewInterface extends AlfreedView {
  ViewInterface(BuildContext context) : super(context: context);

  void showMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void pushPage1() => Navigator.of(context).pushReplacementNamed('/');

  void pop() => Navigator.of(context).pop();
}

class FirstPage extends AlfreedPage<MyPresenter, MyModel, ViewInterface> {
  FirstPage({Key? key}) : super(key: key);

  @override
  AlfreedPageBuilder<MyPresenter, MyModel, ViewInterface> build() {
    return AlfreedPageBuilder(
      key: const ValueKey("presenter"),
      builder: (ctx, presenter, model) {
        return Scaffold(
          appBar: AppBar(
            title: Text(model.title ?? ""),
            actions: [
              IconButton(
                icon: const Icon(Icons.add_alert),
                tooltip: 'Show Snackbar',
                onPressed: () =>
                    Navigator.of(ctx.buildContext).pushNamed('/second'),
              ),
              IconButton(
                icon: const Icon(Icons.ac_unit_rounded),
                tooltip: 'pop Snackbar',
                onPressed: () => debugPrint("test"),
              ),
            ],
          ),
          body: ListView.separated(
              itemBuilder: (context, index) => InkWell(
                    onTap: () => presenter.onClickItem(index),
                    child: ListTile(
                      title: Text(model.todoList![index].title),
                      subtitle: Text(model.todoList![index].subtitle),
                      trailing: StreamBuilder<int>(
                        builder: (context, snapshot) {
                          return Text('${snapshot.data}');
                        },
                        stream: model.todoList![index].counter$,
                      ),
                    ),
                  ),
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemCount: model.todoList?.length ?? 0),
          floatingActionButton: ctx.device < Device.large()
              ? FloatingActionButton(
                  backgroundColor: Colors.redAccent,
                  onPressed: () =>
                      presenter.addTodoWithRefresh("Button Todo created"),
                  // child: Icon(Icons.plus_one),
                  child: const Icon(Icons.ac_unit_outlined),
                )
              : null,
        );
      },
      presenterBuilder: (context) => MyPresenter(),
      interfaceBuilder: (context) => ViewInterface(context),
    );
  }
}

class SecondPage extends AlfreedPage<MyPresenter, MyModel, ViewInterface> {
  SecondPage({Key? key}) : super(key: key);

  @override
  AlfreedPageBuilder<MyPresenter, MyModel, ViewInterface> build() {
    return AlfreedPageBuilder(
      key: const ValueKey("presenter"),
      builder: (ctx, presenter, model) {
        return Scaffold(
          appBar: AppBar(
            title: Text(model.title ?? ""),
            actions: [
              IconButton(
                icon: const Icon(Icons.power_input),
                tooltip: 'pop Snackbar',
                onPressed: presenter.terminate,
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
          floatingActionButton: ctx.device < Device.large()
              ? FloatingActionButton(
                  backgroundColor: Colors.redAccent,
                  onPressed: () =>
                      presenter.addTodoWithRefresh("Button Todo created"),
                  child: const Icon(Icons.plus_one),
                )
              : null,
        );
      },
      presenterBuilder: (context) => MyPresenter(),
      interfaceBuilder: (context) => ViewInterface(context),
    );
  }
}

class StfulEmbedder extends StatefulWidget {
  final Widget child;

  const StfulEmbedder({Key? key, required this.child}) : super(key: key);

  @override
  _StfulEmbedderState createState() => _StfulEmbedderState();
}

class _StfulEmbedderState extends State<StfulEmbedder> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

Route<dynamic> route(RouteSettings settings) {
  debugPrint("...[call route] ${settings.name}");
  switch (settings.name) {
    case '/second':
      return MaterialPageRoute(builder: (_) => SecondPage());
    default:
      return MaterialPageRoute(builder: (_) {
        debugPrint("build first page");
        return StfulEmbedder(child: FirstPage());
      });
  }
}

class SimpleBuilderApp extends StatelessWidget {
  const SimpleBuilderApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(onGenerateRoute: route);
  }
}
