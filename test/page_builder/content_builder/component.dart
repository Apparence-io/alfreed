import 'package:alfreed/alfreed.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';

class MyPresenterMock<MyModel, ViewInterface> extends Mock
    implements MyPresenter {}

class ViewInterface extends AlfreedView {
  ViewInterface(BuildContext context) : super(context: context);

  void showMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void pushPage1() => Navigator.of(context).pushReplacementNamed('/');
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
  void onInit() {
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

var secondPage = AlfreedPageBuilder<MyPresenter, MyModel, ViewInterface>(
  key: const ValueKey("presenter"),
  builder: (ctx, presenter, model) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(child: Text("second page")),
    );
  },
  presenterBuilder: (context) => MyPresenter(),
  interfaceBuilder: (context) => ViewInterface(context),
);

var page3 = AlfreedPageBuilder<MyPresenter, MyModel, ViewInterface>(
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
