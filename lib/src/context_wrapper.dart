import 'dart:io';

import 'package:flutter/material.dart';

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

  factory Device.phone() => Device.fromSize(Size(450, 300));

  factory Device.tablet() => Device.fromSize(Size(700, 300));

  factory Device.large() => Device.fromSize(Size(1000, 300));

  factory Device.xlarge() => Device.fromSize(Size(1920, 300));

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
    if (this.type == other.type) {
      return false;
    }
    return sizes[this.type]!.min < sizes[other.type]!.min;
  }

  bool operator >(covariant Device other) {
    if (this.type == other.type) {
      return false;
    }
    return sizes[this.type]!.min > sizes[other.type]!.min;
  }
}

class AlfreedContext {
  final BuildContext buildContext;
  // animations attributes
  final AnimationController? animationController;
  final List<AnimationController>? animationsControllers;
  // device info
  Device device;

  AlfreedContext(
    this.buildContext, {
    this.animationController,
    this.animationsControllers,
  }) : this.device = Device.fromSize(MediaQuery.of(buildContext).size);

  Orientation get orientation => MediaQuery.of(buildContext).orientation;

  bool isDesktop = Platform.isWindows || Platform.isLinux || Platform.isMacOS;

  bool isMobile = Platform.isAndroid || Platform.isIOS;
}
