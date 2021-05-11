import 'dart:ui';

import 'package:alfreed/src/context_wrapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Create a Device from size', () {
    test('450px width screen => phone', () {
      expect(Device.fromSize(Size(450, 300)).type, equals(WindowSize.phone));
    });

    test('700 width screen => tablet', () {
      expect(Device.fromSize(Size(700, 500)).type, equals(WindowSize.tablet));
    });

    test('1000 width screen => large', () {
      expect(Device.fromSize(Size(1000, 700)).type, equals(WindowSize.large));
    });

    test('1920 width screen => xlarge ', () {
      expect(Device.fromSize(Size(1920, 1000)).type, equals(WindowSize.xlarge));
    });
  });

  group('Compare devices', () {
    test('phone < tablet or large or xlarge ', () {
      var device = Device.fromSize(Size(450, 300));
      expect(device < Device.phone(), isFalse);
      expect(device < Device.tablet(), isTrue);
      expect(device < Device.large(), isTrue);
      expect(device < Device.xlarge(), isTrue);
    });

    test('tablet < large or xlarge || tablet > phone', () {
      var device = Device.fromSize(Size(700, 300));
      expect(device < Device.large(), isTrue);
      expect(device < Device.xlarge(), isTrue);
      expect(device > Device.phone(), isTrue);
    });

    test('large < xlarge || large > tablet or phone', () {
      var device = Device.fromSize(Size(1000, 300));
      expect(device < Device.xlarge(), isTrue);
      expect(device > Device.tablet(), isTrue);
      expect(device > Device.phone(), isTrue);
    });

    test('xlarge > tablet or large or phone ', () {
      var device = Device.fromSize(Size(1920, 300));
      expect(device > Device.phone(), isTrue);
      expect(device > Device.tablet(), isTrue);
      expect(device > Device.large(), isTrue);
    });
  });
}
