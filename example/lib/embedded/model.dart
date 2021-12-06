class MyModel {
  String? title;
  List<TodoModel>? todoList;
}

class TodoModel {
  String title, subtitle;

  TodoModel(this.title, this.subtitle);
}
