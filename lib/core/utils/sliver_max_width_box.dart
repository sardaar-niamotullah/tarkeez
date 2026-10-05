import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tailwind_breakpoints/tailwind_breakpoints.dart';

class SliverMaxWidthBox extends StatelessWidget {
  const new({
    super.key,
    required this.slivers,
    this.maxWidth = Breakpoints.lg - 32,
  });

  final List<Widget> slivers;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final side = math.max(
          0.0,
          (constraints.crossAxisExtent - maxWidth) / 2,
        );
        return SliverPadding(
          padding: .symmetric(horizontal: side),
          sliver: SliverMainAxisGroup(slivers: slivers),
        );
      },
    );
  }
}
