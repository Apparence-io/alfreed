import 'package:alfreed/src/utils.dart';
import 'package:flutter/material.dart';

import '../alfreed.dart';
import 'content_builder.dart';

class SingleAnimationException implements Exception {
  String message;

  SingleAnimationException._(this.message);

  factory SingleAnimationException.multipleAnim() =>
      SingleAnimationException._(''' 
    You cannot provide more than one animation in a single animated page
    ''');

  String toString() => "Exception: $message";
}

class MVVMSingleTickerProviderContentState<P extends Presenter, M>
    extends State<MVVMContent>
    with TickerProviderStateMixin
    implements ContentView {
  Map<String, AlfreedAnimation>? _animation;
  final MvvmAnimationListener<P, M> animListener;
  bool hasInit = false;

  MVVMSingleTickerProviderContentState(this.animListener);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    presenter.viewRef = this;
    _animation = widget.singleAnimController!(this);
    if (_animation!.length > 1) throw SingleAnimationException.multipleAnim();
    if (!hasInit) {
      hasInit = true;
      presenter.onInit();
      ambiguate(WidgetsBinding.instance)!.addPostFrameCallback((_) {
        presenter.afterViewInit();
      });
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    presenter.onInit();
    hasInit = false;
  }

  @override
  void deactivate() {
    presenter.onDeactivate();
    this.disposeAnimation();
    super.deactivate();
  }

  @override
  void forceRefreshView() {
    if (mounted) {
      setState(() {});
    }
  }

  AlfreedContext get mvvmContext =>
      AlfreedContext(context, animations: _animation);

  P get presenter => PresenterInherited.of<P, M>(context).presenter;

  ContentBuilder<P, M> get builder =>
      PresenterInherited.of<P, M>(context).builder;

  @override
  Widget build(BuildContext context) =>
      builder(mvvmContext, presenter, presenter.state);

  @override
  Future<void> refreshAnimation() async {
    return animListener(mvvmContext, presenter, presenter.state);
  }

  @override
  Future<void> disposeAnimation() async {
    if (_animation != null && _animation!.length > 0) {
      for (var el in _animation!.values) {
        el.controller.stop();
        el.controller.dispose();
      }
    }
  }

  @override
  Map<String, AlfreedAnimation> get animations => _animation!;
}
