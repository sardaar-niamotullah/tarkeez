import 'package:flutter/material.dart';

class PrimaryPageMargin extends StatelessWidget {
  final Widget child;
  static final double margin = 16;
  const PrimaryPageMargin({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .symmetric(horizontal: margin),
      child: child,
    );
  }
}
