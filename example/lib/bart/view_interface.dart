import 'package:alfreed/alfreed.dart';
import 'package:flutter/material.dart';

class ViewInterface extends AlfreedView {
  ViewInterface(BuildContext context) : super(context: context);

  void showMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void pushPage1() => Navigator.of(context).pushReplacementNamed('/');

  void pop() => Navigator.of(context).pop();
}
