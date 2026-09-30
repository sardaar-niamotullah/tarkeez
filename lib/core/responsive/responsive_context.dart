import 'package:flutter/material.dart';

import 'app_breakpoints.dart';

extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  ScreenSize get screenSize => AppBreakpoints.fromWidth(screenWidth);

  bool get isXs => screenWidth < AppBreakpoints.sm;
  bool get isSm => screenWidth >= AppBreakpoints.sm;
  bool get isMd => screenWidth >= AppBreakpoints.md;
  bool get isLg => screenWidth >= AppBreakpoints.lg;
  bool get isXl => screenWidth >= AppBreakpoints.xl;
}
