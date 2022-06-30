import 'package:flutter/material.dart';

import 'content_builder.dart';
import 'models/anim.dart';

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

  /// Find the closest PresenterInherited above the current widget
  static PresenterInherited<T, M>? maybeOf<T extends Presenter, M>(
    BuildContext context,
  ) =>
      context.dependOnInheritedWidgetOfExactType<PresenterInherited<T, M>>();

  /// Find the closest PresenterInherited data with type M above the current widget
  /// and listen to data changes
  static M dataOf<T extends Presenter, M>(
    BuildContext context,
  ) =>
      context
          .dependOnInheritedWidgetOfExactType<PresenterInherited<T, M>>()
          ?.presenter
          .state;

  /// Find the closest PresenterInherited data with type M above the current widget
  /// and listen to data changes
  static T presenterOf<T extends Presenter, M>(
    BuildContext context,
  ) =>
      context
          .dependOnInheritedWidgetOfExactType<PresenterInherited<T, M>>()!
          .presenter;

  @override
  bool updateShouldNotify(PresenterInherited oldWidget) => true;
}

/// This class must be overriden too
abstract class AlfreedView {
  final BuildContext context;

  AlfreedView({required this.context});
}

enum PresenterState { created, viewCreated, disposed }

/// This class must be overriden too
abstract class Presenter<T, I extends AlfreedView> {
  /// the view where we build our page
  ContentView? _view;

  // used to check wheter we have to call init when content is built
  bool? hasInit;

  /// Current lifecyle state
  PresenterState? _presenterState;

  /// Interface defining the exposed methods of the view
  late I view;

  /// Model containing the current state of the view
  T state;

  /// arguments from route
  Object? args;

  /// recall init on hot reload
  final bool rebuildOnHotReload;

  /// Container controlling the current state of the view
  Presenter({
    required this.state,
    this.rebuildOnHotReload = false,
  }) : hasInit = false;

  /// called when view init
  @mustCallSuper
  void onInit() {
    hasInit = true;
    _presenterState = PresenterState.created;
  }

  /// called when view has been drawn for the 1st time
  @mustCallSuper
  void afterViewInit() {
    _presenterState = PresenterState.viewCreated;
  }

  /// called when view is pop out or hidden
  @mustCallSuper
  void onDeactivate() {
    _presenterState = PresenterState.disposed;
  }

  /// called only in dev mode. Reload state on hot reload
  @mustCallSuper
  void onReassemble() {
    if (rebuildOnHotReload) {
      onInit();
    }
  }

  /// call this to refresh the view
  /// if you mock [I] this will have no effect when calling forceRefreshView
  void refreshView() => _view?.forceRefreshView();

  /// call this to refresh animations
  /// this will start animations from your animation listener of MvvmBuilder
  Future<void> refreshAnimations() async => _view?.refreshAnimation();

  /// set the view reference to presenter
  set viewRef(ContentView view) => _view = view;

  /// animate your view using controllers
  Map<String, AlfreedAnimation>? get animations => _view?.animations;

  PresenterState? get presenterState => _presenterState;
}
