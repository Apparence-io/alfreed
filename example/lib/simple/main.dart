import 'package:flutter/material.dart';
import 'package:alfreed/alfreed.dart';

import 'model.dart';
import 'presenter.dart';

void main() {
  runApp(SimpleBuilderApp());
}

class ViewInterface extends AlfreedView {
  ViewInterface(BuildContext context) : super(context: context);

  void showMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

var myPageBuilder = AlfreedPageBuilder<MyPresenter, MyModel, ViewInterface>(
  key: ValueKey("presenter"),
  builder: (ctx, presenter, model) {
    return Scaffold(
      appBar: AppBar(title: Text(model.title ?? "")),
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
      floatingActionButton: ctx.device < Device.large()
          ? FloatingActionButton(
              backgroundColor: Colors.redAccent,
              onPressed: () =>
                  presenter.addTodoWithRefresh("Button Todo created"),
              child: Icon(Icons.plus_one),
            )
          : null,
    );
  },
  presenterBuilder: (context) => MyPresenter(),
  interfaceBuilder: (context) => ViewInterface(context),
);

Route<dynamic> route(RouteSettings settings) {
  print("...[call route] ${settings.name}");
  return MaterialPageRoute(builder: myPageBuilder.build);
}

class SimpleBuilderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(onGenerateRoute: route);
  }
}
