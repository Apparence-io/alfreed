import 'dart:async';

import 'package:rxdart/subjects.dart';

class MyModel {
  String? title;
  List<TodoModel>? todoList;
}

class TodoModel {
  String title, subtitle;

  BehaviorSubject<int> counterSubject;
  Stream<int> get counter$ => counterSubject.stream;

  TodoModel(this.title, this.subtitle) : counterSubject = BehaviorSubject() {
    counterSubject.add(0);
  }

  increment() async {
    int last = 0;
    last = await counter$.first;
    counterSubject.add(last + 1);
  }
}
