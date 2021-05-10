import 'package:alfreed/alfreed.dart';
import 'main.dart';
import 'model.dart';

class MyPresenter extends Presenter<MyModel, ViewInterface> {
  MyPresenter() : super(state: MyModel()) {
    this.state!.title = "My todo list";
    this.state!.todoList = [];
  }

  @override
  Future onInit() async {
    this.state!.todoList = [];
    for (int i = 0; i < 15; i++) {
      this.state!.todoList!.add(new TodoModel("TODO $i", "my todo task $i"));
    }
    this.refreshView();
  }

  onClickItem(int index) {
    view.showMessage("Item clicked $index");
  }
}
