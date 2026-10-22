import 'package:flutter/material.dart';
import 'package:tailwind_breakpoints/tailwind_breakpoints.dart';

double appBarHeight(BuildContext context) {
  final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
  final isTallScreen = context.screenHeight > Breakpoints.md;

  if (context.lg && isTallScreen) return 124;
  if (context.md && isTallScreen) return 84;
  if (context.md) return 54;
  if (isIOS) return 34;

  return 48;
}
