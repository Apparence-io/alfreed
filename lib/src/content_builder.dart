import 'package:alfreed/src/models/anim.dart';
import 'package:alfreed/src/utils.dart';
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
  final AlfreedAnimationBuilder? singleAnimController;
  final AlfreedAnimationsBuilder? multipleAnimController;
  final MvvmAnimationListener<P, M>? animListener;

  const MVVMContent({
    Key? key,
    this.singleAnimController,
    this.multipleAnimController,
    this.animListener,
  }) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
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
  _MVVMContentState();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    presenter.viewRef = this;
    if (!hasInit) {
      presenter.onInit();
    }
    ambiguate(WidgetsBinding.instance)!.addPostFrameCallback((_) {
      if (mounted) {
        presenter.afterViewInit();
      }
    });
  }

  @override
  void reassemble() {
    presenter.onReassemble();
    super.reassemble();
  }

  @override
  void deactivate() {
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

  bool get hasInit => presenter.hasInit!;

  set hasInit(bool value) => presenter.hasInit = value;

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
