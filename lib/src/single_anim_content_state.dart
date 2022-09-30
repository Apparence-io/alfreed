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

  @override
  String toString() => "Exception: $message";
}

class MVVMSingleTickerProviderContentState<P extends Presenter, M>
    extends State<MVVMContent>
    with TickerProviderStateMixin
    implements ContentView {
  Map<String, AlfreedAnimation>? _animation;
  final MvvmAnimationListener<P, M> animListener;

  MVVMSingleTickerProviderContentState(this.animListener);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    presenter.viewRef = this;
    _animation = widget.singleAnimController!(this);
    if (_animation!.length > 1) throw SingleAnimationException.multipleAnim();
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
    disposeAnimation();
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

  bool get hasInit => presenter.hasInit!;

  set hasInit(bool value) => presenter.hasInit = value;

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
    if (_animation != null && _animation!.isNotEmpty) {
      for (var el in _animation!.values) {
        el.controller.stop();
        el.controller.dispose();
      }
    }
  }

  @override
  Map<String, AlfreedAnimation> get animations => _animation!;
}
