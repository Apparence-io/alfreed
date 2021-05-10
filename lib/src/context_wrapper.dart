import 'package:flutter/material.dart';

class AlfreedContext {
  final BuildContext buildContext;
  final AnimationController? animationController;
  final List<AnimationController>? animationsControllers;

  AlfreedContext(
    this.buildContext, {
    this.animationController,
    this.animationsControllers,
  });
}
