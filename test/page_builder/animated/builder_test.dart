import 'package:alfreed/src/single_anim_content_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils.dart';
import 'component.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Animated builder', () {
    testWidgets('Builds page correctly using alfreed',
        (WidgetTester tester) async {
      await tester.pumpWidget(const AnimatedBuilderApp());
      expect(find.text('my todo task 1'), findsOneWidget);
      expect(find.text('my todo task 2'), findsOneWidget);
      expect(find.text('my todo task 3'), findsOneWidget);
    });

    testWidgets('Using presenter directly -> add a todo and refresh view',
        (WidgetTester tester) async {
      await tester.pumpWidget(const AnimatedBuilderApp());
      var presenter = AlfreedUtils.getPresenterByKey<MyPresenter, MyModel>(
          tester, const ValueKey("presenter"));
      presenter.addTodo('my todo task NEW');
      expect(find.text('my todo task NEW'), findsNothing);
      presenter.refreshView();
      await tester.pumpAndSettle(const Duration(milliseconds: 100));
      expect(find.text('my todo task NEW'), findsOneWidget);
    });

    testWidgets(
        'Press add todo from floating button -> a new Todo is available',
        (WidgetTester tester) async {
      await tester.pumpWidget(const AnimatedBuilderApp());
      var floatingFinder = find.byType(FloatingActionButton);
      expect(find.text('Button Todo created'), findsNothing);
      await tester.tap(floatingFinder);
      await tester.pumpAndSettle(const Duration(milliseconds: 100));
      expect(find.text('Button Todo created'), findsOneWidget);
    });
  });

  group('Animated builder errors', () {
    testWidgets(
        'Provide multiple animation using single animate factory -> throw',
        (WidgetTester tester) async {
      // ignore: prefer_typing_uninitialized_variables
      var exceptionRes;
      FlutterError.onError = (details) {
        exceptionRes = details.exception;
      };
      Route<dynamic> route(RouteSettings settings) =>
          MaterialPageRoute(builder: pageWithMultiAnimOnSingle.build);
      await tester.pumpWidget(MaterialApp(onGenerateRoute: route));
      FlutterError.onError = (details) => FlutterError.presentError(details);
      expect(exceptionRes, isNotNull);
      expect(exceptionRes, isInstanceOf<SingleAnimationException>());
      expect(
          exceptionRes.toString(),
          contains(
              'You cannot provide more than one animation in a single animated page'));
    });
  });
}
