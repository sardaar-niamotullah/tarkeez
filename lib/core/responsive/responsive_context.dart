import 'package:flutter/material.dart';
import 'package:tarkeez/core/responsive/app_breakpoints.dart';

extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  ScreenSize get screenSize => AppBreakpoints.fromWidth(screenWidth);

  bool get xxs => screenWidth < AppBreakpoints.xs;
  bool get xs => screenWidth >= AppBreakpoints.xs;
  bool get sm => screenWidth >= AppBreakpoints.sm;
  bool get md => screenWidth >= AppBreakpoints.md;
  bool get lg => screenWidth >= AppBreakpoints.lg;
  bool get xl => screenWidth >= AppBreakpoints.xl;
  bool get xxl => screenWidth >= AppBreakpoints.xxl;
}
