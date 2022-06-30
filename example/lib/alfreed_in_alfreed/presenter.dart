import 'package:alfreed/alfreed.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'model.dart';

class MyPresenter extends Presenter<MyModel, ViewInterface> {
  MyPresenter() : super(state: MyModel()) {
    debugPrint("create presenter");
    state.title = "My todo list";
  }

  @override
  Future onInit() async {
    state.todoList = [];
    for (int i = 0; i < 4; i++) {
      state.todoList!.add(TodoModel("TODO $i", "my todo task $i"));
    }
    refreshView();
    super.onInit();
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

  void terminate() {
    view.pop();
  }
}
