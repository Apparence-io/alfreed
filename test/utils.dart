import 'package:alfreed/alfreed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class AlfreedUtils {
  static P getPresenterByKey<P extends Presenter, M>(
      WidgetTester tester, Key key) {
    var presenterFinder = find.byKey(key);
    expect(presenterFinder, findsOneWidget,
        reason: "A key must be provided to your presenter");
    return (presenterFinder.evaluate().first.widget as PresenterInherited<P, M>)
        .presenter;
  }
}
