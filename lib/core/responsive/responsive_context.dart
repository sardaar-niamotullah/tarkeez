import 'package:flutter/material.dart';
import 'package:tarkeez/core/shared_files/enums/screen_size.dart';

import 'app_breakpoints.dart';

extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;
  ScreenSize get screenSize => AppBreakpoints.fromWidth(screenWidth);

  bool get isXs => screenSize == ScreenSize.xs;
  bool get isSm => screenSize == ScreenSize.sm;
  bool get isMd => screenSize == ScreenSize.md;
  bool get isLg => screenSize == ScreenSize.lg;
  bool get isXl => screenSize == ScreenSize.xl;
  bool get isXxl => screenSize == ScreenSize.xxl;
}
