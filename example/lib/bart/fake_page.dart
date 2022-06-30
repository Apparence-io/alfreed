import 'package:alfreed/alfreed.dart';
import 'package:flutter/material.dart';

import 'model.dart';
import 'presenter.dart';
import 'view_interface.dart';

class PageFake extends AlfreedPage<MyPresenter, MyModel, ViewInterface> {
  final Color bgColor;
  final bool rebuildAfterDisposed;
  final PageStorageKey? pageStorageKey;

  PageFake(this.bgColor,
      {this.rebuildAfterDisposed = true, this.pageStorageKey})
      : super(key: pageStorageKey);

  @override
  AlfreedPageBuilder<MyPresenter, MyModel, ViewInterface> build() {
    return AlfreedPageBuilder(
      key: const ValueKey("presenter"),
      builder: (ctx, presenter, model) {
        return Scaffold(
          appBar: AppBar(
            title: Text(model.title ?? ""),
            automaticallyImplyLeading: false,
          ),
          backgroundColor: bgColor,
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
      rebuildIfDisposed: rebuildAfterDisposed,
    );
  }
}
