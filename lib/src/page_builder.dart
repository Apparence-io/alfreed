import 'package:alfreed/src/context_wrapper.dart';
import 'package:flutter/material.dart';

import '../alfreed.dart';
import 'content_builder.dart';

/// builds a presenter
typedef PresenterBuilder<P extends Presenter> = P Function(
    BuildContext context);

/// builds the interface that the presenter can call to call the view
typedef AlfreedViewBuilder<I extends AlfreedView> = I Function(
    BuildContext context);

/// functions to handle animation state without refresh page
typedef MvvmAnimationListener<P extends Presenter, M> = void Function(
    AlfreedContext context, P presenter, M model);

/// builds a single [AnimationController]
typedef MvvmAnimationControllerBuilder = AnimationController Function(
    TickerProvider tickerProvider);

/// builds a list of [AnimationController]
typedef MvvmAnimationsControllerBuilder = List<AnimationController> Function(
    TickerProvider tickerProvider);

class AlfreedPageBuilder<P extends Presenter, M, I extends AlfreedView> {
  P? _presenter;
  Key? key;

  final PresenterBuilder<P> presenterBuilder;
  final ContentBuilder<P, M> builder;
  final AlfreedViewBuilder<I> interfaceBuilder;
  MvvmAnimationListener<P, M>? animListener;
  MvvmAnimationControllerBuilder? singleAnimControllerBuilder;
  MvvmAnimationsControllerBuilder? multipleAnimControllerBuilder;
  bool forceRebuild;

  AlfreedPageBuilder._({
    this.key,
    required this.presenterBuilder,
    required this.builder,
    required this.interfaceBuilder,
    this.animListener,
    this.singleAnimControllerBuilder,
    this.multipleAnimControllerBuilder,
    this.forceRebuild = false,
  });

  factory AlfreedPageBuilder({
    Key? key,
    required PresenterBuilder<P> presenterBuilder,
    required ContentBuilder<P, M> builder,
    required AlfreedViewBuilder<I> interfaceBuilder,
  }) =>
      AlfreedPageBuilder._(
        key: key,
        presenterBuilder: presenterBuilder,
        builder: builder,
        interfaceBuilder: interfaceBuilder,
      );

  factory AlfreedPageBuilder.animated({
    Key? key,
    required PresenterBuilder<P> presenterBuilder,
    required ContentBuilder<P, M> builder,
    required AlfreedViewBuilder<I> interfaceBuilder,
    required MvvmAnimationListener<P, M>? animListener,
    required MvvmAnimationControllerBuilder? singleAnimControllerBuilder,
  }) =>
      AlfreedPageBuilder._(
          key: key,
          presenterBuilder: presenterBuilder,
          builder: builder,
          interfaceBuilder: interfaceBuilder,
          animListener: animListener,
          singleAnimControllerBuilder: singleAnimControllerBuilder);

  factory AlfreedPageBuilder.animatedMulti({
    Key? key,
    required PresenterBuilder<P> presenterBuilder,
    required ContentBuilder<P, M> builder,
    required AlfreedViewBuilder<I> interfaceBuilder,
    required MvvmAnimationListener<P, M>? animListener,
    required MvvmAnimationsControllerBuilder? multipleAnimControllerBuilder,
  }) =>
      AlfreedPageBuilder._(
          key: key,
          presenterBuilder: presenterBuilder,
          builder: builder,
          interfaceBuilder: interfaceBuilder,
          animListener: animListener,
          multipleAnimControllerBuilder: multipleAnimControllerBuilder);

  Widget build(BuildContext context) {
    assert(
        ((singleAnimControllerBuilder != null ||
                    multipleAnimControllerBuilder != null) &&
                animListener != null) ||
            (singleAnimControllerBuilder == null &&
                multipleAnimControllerBuilder == null),
        'An Animated page was requested, but no listener was given.');
    assert(
        !(singleAnimControllerBuilder != null &&
            multipleAnimControllerBuilder != null),
        'Cannot have both a single and a multiple animation controller builder.');
    if (_presenter == null || forceRebuild) {
      _presenter = presenterBuilder(context);
      _presenter!.view = interfaceBuilder(context);
    }
    // Widget content;
    Widget content = MVVMContent<P, M>(
      singleAnimController: singleAnimControllerBuilder,
      multipleAnimController: multipleAnimControllerBuilder,
      animListener: animListener,
    );
    return PresenterInherited<P, M>(
      key: key,
      presenter: _presenter!,
      builder: builder,
      child: content,
    );
  }

  @visibleForTesting
  P get presenter => _presenter!;
}
