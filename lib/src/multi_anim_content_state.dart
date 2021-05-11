import 'package:alfreed/src/context_wrapper.dart';
import 'package:flutter/material.dart';

import '../alfreed.dart';
import 'content_builder.dart';

class MVVMMultipleTickerProviderContentState<P extends Presenter, M>
    extends State<MVVMContent>
    with TickerProviderStateMixin
    implements ContentView {
  List<AnimationController>? _controller;
  final MvvmAnimationListener<P, M> animListener;
  bool hasInit = false;

  MVVMMultipleTickerProviderContentState(this.animListener);

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
    _controller = widget.multipleAnimController!(this);
  }

  @override
  void reassemble() {
    super.reassemble();
    presenter.onInit();
    hasInit = false;
  }

  @override
  void deactivate() {
    // presenter.onDestroy();
    // Dispose all animations
    this.disposeAnimation();
    super.deactivate();
    // presenter.afterViewDestroyed();
  }

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
  Widget build(BuildContext context) =>
      builder(mvvmContext, presenter, presenter.state);

  @override
  Future<void> refreshAnimation() async =>
      animListener(mvvmContext, presenter, presenter.state);

  @override
  Future<void> disposeAnimation() async {
    if (_controller != null && _controller!.length > 0) {
      for (var controller in _controller!) {
        controller.stop();
        controller.dispose();
      }
    }
  }
}
