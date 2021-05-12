import 'package:flutter/material.dart';

class AlfreedAnimation {
  AnimationController controller;
  List<Animation>? subAnimations;

  AlfreedAnimation(this.controller, {this.subAnimations});
}
