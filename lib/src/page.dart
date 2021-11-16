import 'package:flutter/material.dart';

import '../alfreed.dart';

abstract class AlfreedPage<P extends Presenter, M, I extends AlfreedView>
    extends StatelessWidget {
  late final AlfreedPageBuilder<P, M, I> builder;
  final Object? args;

  AlfreedPage({
    Key? key,
    this.args,
  }) : super(key: key) {
    builder = alfreedPageBuilder..args = args;
  }

  @override
  Widget build(BuildContext context) => builder.build(context);

  AlfreedPageBuilder<P, M, I> get alfreedPageBuilder;
}

abstract class AlfreedFulPage<P extends Presenter, M, I extends AlfreedView>
    extends StatefulWidget {
  final Object? args;

  AlfreedFulPage({
    Key? key,
    this.args,
  });

  AlfreedPageBuilder<P, M, I> get alfreedPageBuilder;

  @override
  _AlfreedFulPageState createState() =>
      _AlfreedFulPageState(builder: alfreedPageBuilder..args = args);
}

class _AlfreedFulPageState<P extends Presenter, M, I extends AlfreedView>
    extends State<AlfreedFulPage> {
  final AlfreedPageBuilder<P, M, I> builder;

  _AlfreedFulPageState({required this.builder});

  @override
  Widget build(BuildContext context) => builder.build(context);
}
