import 'package:flutter/material.dart';
import 'package:tarkeez/core/responsive/app_breakpoints.dart';

class MaximumWidthBox extends StatelessWidget {
  const new({
    super.key,
    required this.child,
    this.maxWidth = AppBreakpoints.xl,
  });
  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: .topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
