import 'package:flutter/material.dart';

class PrimaryPageMargin extends StatelessWidget {
  const new({super.key, required this.child, this.margin = 16});

  final Widget child;
  final double margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .symmetric(horizontal: margin),
      child: child,
    );
  }
}
