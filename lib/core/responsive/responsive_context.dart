import 'package:flutter/material.dart';
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
}
