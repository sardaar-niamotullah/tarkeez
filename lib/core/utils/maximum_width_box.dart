import 'package:flutter/material.dart';
import 'package:tailwind_breakpoints/tailwind_breakpoints.dart';

class MaximumWidthBox extends StatelessWidget {
  const new({super.key, required this.child, this.maxWidth = Breakpoints.lg});
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
