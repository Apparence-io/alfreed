import 'package:alfreed/src/utils.dart';
import 'package:flutter/material.dart';

import '../alfreed.dart';
import 'content_builder.dart';

class MVVMMultipleTickerProviderContentState<P extends Presenter, M>
    extends State<MVVMContent>
    with TickerProviderStateMixin
    implements ContentView {
  Map<String, AlfreedAnimation>? _animations;
  final MvvmAnimationListener<P, M> animListener;

  MVVMMultipleTickerProviderContentState(this.animListener);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    presenter.viewRef = this;
    _animations = widget.multipleAnimController!(this);
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
      AlfreedContext(context, animations: _animations);

  bool get hasInit => presenter.hasInit!;

  set hasInit(bool value) => presenter.hasInit = value;

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
    if (_animations != null && _animations!.isNotEmpty) {
      for (var el in _animations!.values) {
        el.controller.stop();
        el.controller.dispose();
      }
    }
  }

  @override
  Map<String, AlfreedAnimation> get animations => _animations!;
}
