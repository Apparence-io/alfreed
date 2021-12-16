import 'package:flutter/material.dart';

import '../alfreed.dart';

abstract class AlfreedPage<P extends Presenter, M, I extends AlfreedView>
    extends StatefulWidget {
  final Object? args;
  late final AlfreedPageBuilder<P, M, I> builder;

  AlfreedPage({
    Key? key,
    this.args,
  }) : super(key: key) {
    builder = alfreedPageBuilder..args = args;
  }

  AlfreedPageBuilder<P, M, I> get alfreedPageBuilder;

  @override
  _AlfreedFullPageState createState() => _AlfreedFullPageState(this.builder);
}

class _AlfreedFullPageState<P extends Presenter, M, I extends AlfreedView>
    extends State<AlfreedPage> {
  AlfreedPageBuilder<P, M, I> _builder;

  _AlfreedFullPageState(this._builder);

  @override
  void reassemble() {
    super.reassemble();
    _builder = widget.alfreedPageBuilder.copyWith(
      presenter: _builder.presenter,
    ) as AlfreedPageBuilder<P, M, I>;
  }

  @override
  Widget build(BuildContext context) => _builder.build(context);
}
