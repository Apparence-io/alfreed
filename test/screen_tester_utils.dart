import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

class ScreenSize {
  /// name this configuration
  String name;

  /// size configuration and pixel density
  double width, height, pixelDensity;

  ScreenSize(this.name, this.width, this.height, this.pixelDensity);
}

List<ScreenSize>? devicesScreenConfigs;

extension ScreenSizeManager on WidgetTester {
  Future<void> setScreenSize(ScreenSize screenSize) async {
    return _setScreenSize(
        width: screenSize.width,
        height: screenSize.height,
        pixelDensity: screenSize.pixelDensity);
  }

  Future<void> _setScreenSize(
      {double width = 540,
      double height = 960,
      double pixelDensity = 1}) async {
    final size = Size(width, height);
    await binding.setSurfaceSize(size);
    binding.window.physicalSizeTestValue = size;
    binding.window.devicePixelRatioTestValue = pixelDensity;
  }

  // works for Iphone 11 max
  Future<void> setIphone11Max() =>
      _setScreenSize(width: 414, height: 896, pixelDensity: 3);

  // works for iphones size : 6+, 6s, 7+, 8+
  Future<void> setIphone8Plus() =>
      _setScreenSize(width: 414, height: 736, pixelDensity: 3);

  Future<void> setWeb1920() =>
      _setScreenSize(width: 1920, height: 1200, pixelDensity: 3);

  Future<void> setWeb1280() =>
      _setScreenSize(width: 1280, height: 1024, pixelDensity: 3);

  Future<void> setTablet() =>
      _setScreenSize(width: 750, height: 400, pixelDensity: 3);
}
