import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'models/anim.dart';

enum WindowSize { phone, tablet, large, xlarge }

const sizes = {
  WindowSize.phone: DeviceRange(0, 576),
  WindowSize.tablet: DeviceRange(576, 992),
  WindowSize.large: DeviceRange(992, 1200),
  WindowSize.xlarge: DeviceRange(1200, 10000),
};

class DeviceRange {
  final int min, max;

  const DeviceRange(this.min, this.max);
}

class Device {
  Size size;
  WindowSize type;

  Device._(this.size, this.type);

  factory Device.phone() => Device.fromSize(const Size(450, 300));

  factory Device.tablet() => Device.fromSize(const Size(700, 300));

  factory Device.large() => Device.fromSize(const Size(1000, 300));

  factory Device.xlarge() => Device.fromSize(const Size(1920, 300));

  // inspired from twitter bootstrap
  factory Device.fromSize(Size size) {
    if (size.width > 0 && size.width <= 576) {
      return Device._(size, WindowSize.phone);
    }
    if (size.width > 576 && size.width <= 992) {
      return Device._(size, WindowSize.tablet);
    }
    if (size.width > 992 && size.width <= 1200) {
      return Device._(size, WindowSize.large);
    }
    return Device._(size, WindowSize.xlarge);
  }

  bool operator <(covariant Device other) {
    if (type == other.type) {
      return false;
    }
    return sizes[type]!.min < sizes[other.type]!.min;
  }

  bool operator >(covariant Device other) {
    if (type == other.type) {
      return false;
    }
    return sizes[type]!.min > sizes[other.type]!.min;
  }
}

class AlfreedContext {
  final BuildContext buildContext;
  final Map<String, AlfreedAnimation>? animations;
  Device device;

  AlfreedContext(
    this.buildContext, {
    this.animations,
  }) : device = Device.fromSize(MediaQuery.of(buildContext).size);

  Orientation get orientation => MediaQuery.of(buildContext).orientation;

  bool isDesktop = defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux ||
      defaultTargetPlatform == TargetPlatform.macOS;

  bool isMobile = defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;

  bool isWeb = kIsWeb;

  NavigatorState get navigator => Navigator.of(buildContext);
}
