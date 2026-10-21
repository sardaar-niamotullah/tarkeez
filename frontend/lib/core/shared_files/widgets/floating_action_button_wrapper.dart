import 'package:flutter/material.dart';
import 'package:tailwind_breakpoints/tailwind_breakpoints.dart';

class FloatingActionButtonWrapper extends StatelessWidget {
  const new({super.key, required this.actionButton});

  final Widget actionButton;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Align(
        alignment: .bottomCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Breakpoints.lg),
          child: Align(
            alignment: .bottomRight,
            child: Padding(
              padding: .only(right: 16, bottom: context.md ? 32 : 16),
              child: actionButton,
            ),
          ),
        ),
      ),
    );
  }
}
