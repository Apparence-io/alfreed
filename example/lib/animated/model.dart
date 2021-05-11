class MyModel {
  String? title;
  List<TodoModel>? todoList;

  bool animate = false;
}

class TodoModel {
  String title, subtitle;

  TodoModel(this.title, this.subtitle);
}
