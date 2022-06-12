import 'package:bart/bart.dart';
import 'package:flutter/material.dart';

import 'fake_list.dart';
import 'fake_page.dart';

List<BartMenuRoute> subRoutes() {
  return [
    BartMenuRoute.bottomBar(
      label: "Home",
      icon: Icons.home,
      path: '/home',
      pageBuilder: (context, settings) => PageFake(
        Colors.black12,
        rebuildAfterDisposed: false,
        pageStorageKey: PageStorageKey<String>("home"),
      ),
    ),
    BartMenuRoute.bottomBar(
      label: "Library",
      icon: Icons.video_library_rounded,
      path: '/library',
      pageBuilder: (context, settings) => PageFake(
        Colors.blueGrey.shade100,
        rebuildAfterDisposed: false,
        pageStorageKey: PageStorageKey<String>("library"),
      ),
    ),
    BartMenuRoute.bottomBar(
      label: "Profile",
      icon: Icons.person,
      path: '/profile',
      pageBuilder: (context, settings) => PageFake(
        Colors.yellow.shade100,
        rebuildAfterDisposed: false,
      ),
    ),
    BartMenuRoute.bottomBar(
      label: "Colors",
      icon: Icons.person,
      path: '/colors',
      pageBuilder: (context, settings) => ColorBoxPage(
        key: PageStorageKey<String>('colors'),
      ),
    )
  ];
}
