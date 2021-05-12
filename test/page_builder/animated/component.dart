import 'package:alfreed/alfreed.dart';
import 'package:flutter/material.dart';

class ViewInterface extends AlfreedView {
  ViewInterface(BuildContext context) : super(context: context);

  void showMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

class MyModel {
  String? title;
  List<TodoModel>? todoList;
  bool animate = false;
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
    this.state!.todoList = [];
    for (int i = 0; i < 4; i++) {
      this.state!.todoList!.add(new TodoModel("TODO $i", "my todo task $i"));
    }
    this.refreshView();
    state!.animate = true;
    refreshAnimations();
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

var myPageBuilder =
    AlfreedPageBuilder<MyPresenter, MyModel, ViewInterface>.animated(
  key: ValueKey("presenter"),
  singleAnimControllerBuilder: (ticker) {
    var controller =
        AnimationController(vsync: ticker, duration: Duration(seconds: 1));
    var animation1 = CurvedAnimation(
        parent: controller, curve: Interval(0, .4, curve: Curves.easeIn));
    var animation2 = CurvedAnimation(
        parent: controller, curve: Interval(0, .6, curve: Curves.easeIn));
    return {
      '': AlfreedAnimation(controller, subAnimations: [animation1, animation2])
    };
  },
  animListener: (context, presenter, model) {
    if (model.animate) {
      context.animations!.values.first.controller.forward(); //SIMPLIFY
    }
  },
  builder: (ctx, presenter, model) {
    return Scaffold(
      // key: _scaffoldKey,
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        onPressed: () => presenter.addTodoWithRefresh("Button Todo created"),
        child: Icon(Icons.plus_one),
      ),
    );
  },
  presenterBuilder: (context) => MyPresenter(),
  interfaceBuilder: (context) => ViewInterface(context),
);

// this should throw as we provide multiple animations
var pageWithMultiAnimOnSingle =
    AlfreedPageBuilder<MyPresenter, MyModel, ViewInterface>.animated(
  key: ValueKey("presenter"),
  singleAnimControllerBuilder: (ticker) {
    var controller =
        AnimationController(vsync: ticker, duration: Duration(seconds: 1));
    var animation1 = CurvedAnimation(
        parent: controller, curve: Interval(0, .4, curve: Curves.easeIn));
    var animation2 = CurvedAnimation(
        parent: controller, curve: Interval(0, .6, curve: Curves.easeIn));
    return {
      '1':
          AlfreedAnimation(controller, subAnimations: [animation1, animation2]),
      '2':
          AlfreedAnimation(controller, subAnimations: [animation1, animation2]),
    };
  },
  animListener: (context, presenter, model) {
    if (model.animate) {
      context.animations!.values.first.controller.forward();
    }
  },
  builder: (ctx, presenter, model) {
    return Scaffold(
      appBar: AppBar(title: Text(model.title ?? "")),
    );
  },
  presenterBuilder: (context) => MyPresenter(),
  interfaceBuilder: (context) => ViewInterface(context),
);

Route<dynamic> route(RouteSettings settings) {
  print("...[call route] ${settings.name}");
  return MaterialPageRoute(builder: myPageBuilder.build);
}

class AnimatedBuilderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(onGenerateRoute: route);
  }
}
