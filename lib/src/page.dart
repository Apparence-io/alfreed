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
    builder = build();
  }

  AlfreedPageBuilder<P, M, I> build();

  @override
  _AlfreedFullPageState createState() => _AlfreedFullPageState();
}

class _AlfreedFullPageState<P extends Presenter, M, I extends AlfreedView>
    extends State<AlfreedPage> {
  AlfreedPageBuilder<P, M, I>? _builder;

  _AlfreedFullPageState();

  @override
  void reassemble() {
    super.reassemble();
    _builder = widget.builder.copyWith(
      presenter: _builder?.presenter,
    ) as AlfreedPageBuilder<P, M, I>;
  }

  @override
  Widget build(BuildContext context) {
    if (_builder != null) {
      return _builder!.build(context, args: widget.args);
    }
    return widget.builder.build(context, args: widget.args);
  }
}
