import 'dart:math';

import 'package:flutter/material.dart';
import 'package:alfreed/alfreed.dart';

class EmbeddedViewModel {
  String text;

  EmbeddedViewModel({
    required this.text,
  });

  factory EmbeddedViewModel.empty() => EmbeddedViewModel(text: 'Empty');
}

class EmbeddedViewInterface extends AlfreedView {
  EmbeddedViewInterface(BuildContext context) : super(context: context);
}

class EmbeddedPage extends AlfreedPage<EmbeddedPresenter, EmbeddedViewModel,
    EmbeddedViewInterface> {
  EmbeddedPage({Object? args, Key? key}) : super(args: args, key: key);

  @override
  AlfreedPageBuilder<EmbeddedPresenter, EmbeddedViewModel,
      EmbeddedViewInterface> build() {
    return AlfreedPageBuilder(
      presenterBuilder: (context) => EmbeddedPresenter(),
      interfaceBuilder: (context) => EmbeddedViewInterface(context),
      builder: (context, presenter, model) => Container(
        padding: const EdgeInsets.all(4),
        child: Text(model.text),
      ),
    );
  }
}

class EmbeddedPresenter
    extends Presenter<EmbeddedViewModel, EmbeddedViewInterface> {
  EmbeddedPresenter() : super(state: EmbeddedViewModel.empty());

  @override
  void onInit() {
    super.onInit();
    var rdm = Random().nextInt(5);
    Future.delayed(Duration(seconds: rdm), () {
      state.text = '$rdm';
      refreshView();
    });
  }
}
