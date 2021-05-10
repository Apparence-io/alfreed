import 'package:flutter/material.dart';

import 'content_builder.dart';

/// Wraps presenter inside a persistent Widget
class PresenterInherited<T extends Presenter, M> extends InheritedWidget {
  /// Presenter coupled to the view built by builder
  final T presenter;

  /// Method used to build the view corresponding to the presenter
  final ContentBuilder<T, M> builder;

  /// Wraps presenter inside a persistent Widget
  const PresenterInherited({
    Key? key,
    required this.presenter,
    required Widget child,
    required this.builder,
  }) : super(key: key, child: child);

  /// Find the closest PresenterInherited above the current widget
  static PresenterInherited<T, M> of<T extends Presenter, M>(
    BuildContext context,
  ) =>
      context.dependOnInheritedWidgetOfExactType<PresenterInherited<T, M>>()!;

  @override
  bool updateShouldNotify(PresenterInherited oldWidget) => true;
}

/// This class must be overriden too
abstract class AlfreedView {
  final BuildContext context;

  AlfreedView({required this.context});
}

/// This class must be overriden too
abstract class Presenter<T, I extends AlfreedView> {
  /// the view where we build our page
  ContentView? _view;

  /// Interface defining the exposed methods of the view
  late I view;

  /// Model containing the current state of the view
  T? state;

  /// Container controlling the current state of the view
  Presenter({required this.state});

  /// called when view init
  void onInit() {}

  /// called when view has been drawn for the 1st time
  void afterViewInit() {}

  /// call this to refresh the view
  /// if you mock [I] this will have no effect when calling forceRefreshView
  void refreshView() => _view?.forceRefreshView();

  /// set the view reference to presenter
  set viewRef(ContentView view) => _view = view;
}
