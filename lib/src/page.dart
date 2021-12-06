import 'package:flutter/material.dart';

import '../alfreed.dart';

// abstract class AlfreedPage<P extends Presenter, M, I extends AlfreedView>
//     extends StatelessWidget {
//   late final AlfreedPageBuilder<P, M, I> builder;
//   final Object? args;

//   AlfreedPage({
//     Key? key,
//     this.args,
//   }) : super(key: key) {
//     builder = alfreedPageBuilder..args = args;
//   }

//   @override
//   Widget build(BuildContext context) => builder.build(context);

//   AlfreedPageBuilder<P, M, I> get alfreedPageBuilder;
// }

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
  _AlfreedFullPageState createState() => _AlfreedFullPageState();
}

class _AlfreedFullPageState<P extends Presenter, M, I extends AlfreedView>
    extends State<AlfreedPage> {
  _AlfreedFullPageState();

  @override
  Widget build(BuildContext context) => widget.builder.build(context);
}
