import 'package:alfreed/src/models/anim.dart';
import 'package:flutter/material.dart';

import 'context_wrapper.dart';
import 'multi_anim_content_state.dart';
import 'page_builder.dart';
import 'presenter.dart';
import 'single_anim_content_state.dart';

/// builds a child for a [ContentBuilder]
typedef ContentBuilder<P extends Presenter, M> = Widget Function(
    AlfreedContext context, P presenter, M model);

/// Base class for views to implement
abstract class ContentView {
  /// force to refresh all view
  void forceRefreshView();

  /// calls refresh animation state
  Future<void> refreshAnimation();

  /// calls stop & dispose for each animation(s)
  Future<void> disposeAnimation();

  // if you prefer controll animation inside your presenter
  Map<String, AlfreedAnimation> get animations;
}

class MVVMContent<P extends Presenter, M> extends StatefulWidget {
  late final AlfreedAnimationBuilder? singleAnimController;
  late final AlfreedAnimationsBuilder? multipleAnimController;
  late final MvvmAnimationListener<P, M>? animListener;

  MVVMContent({
    Key? key,
    this.singleAnimController,
    this.multipleAnimController,
    this.animListener,
  }) : super(key: key);

  @override
  State<MVVMContent> createState() {
    if (multipleAnimController != null) {
      return MVVMMultipleTickerProviderContentState<P, M>(animListener!);
    }
    if (singleAnimController != null) {
      return MVVMSingleTickerProviderContentState<P, M>(animListener!);
    }
    return _MVVMContentState<P, M>();
  }
}

class _MVVMContentState<P extends Presenter, M> extends State<MVVMContent>
    implements ContentView {
  bool hasInit = false;

  _MVVMContentState();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    presenter.viewRef = this;
    if (!hasInit) {
      hasInit = true;
      presenter.onInit();
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        presenter.afterViewInit();
      });
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    hasInit = false;
  }

  @override
  void deactivate() {
    print("------ deactivate ---");
    presenter.onDeactivate();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) => SizeChangedLayoutNotifier(
      child: builder(mvvmContext, presenter, presenter.state));

  @override
  void forceRefreshView() {
    if (mounted) {
      setState(() {});
    }
  }

  AlfreedContext get mvvmContext => AlfreedContext(context);

  P get presenter => PresenterInherited.of<P, M>(context).presenter;

  ContentBuilder<P, M> get builder =>
      PresenterInherited.of<P, M>(context).builder;

  @override
  Future<void> refreshAnimation() => throw UnimplementedError();

  @override
  Future<void> disposeAnimation() => throw UnimplementedError();

  @override
  Map<String, AlfreedAnimation> get animations => throw UnimplementedError();
}
