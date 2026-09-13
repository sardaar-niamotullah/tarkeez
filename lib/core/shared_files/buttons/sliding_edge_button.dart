import 'package:tarkeez/core/shared_files/buttons/edge_action_button.dart';
import 'package:flutter/material.dart';

// ────── Reusable positioned + slide-transition shell for EdgeActionButton ──────
class SlidingEdgeButton extends StatelessWidget {
  final double bottomOffset;
  final Animation<double> collapseAnimation;
  final Animation<Offset> slideAnimation;
  final String label;
  final String iconPath;
  final Color? backgroundColor;
  final VoidCallback onTap;

  const SlidingEdgeButton({
    super.key,
    required this.bottomOffset,
    required this.collapseAnimation,
    required this.slideAnimation,
    required this.label,
    required this.iconPath,
    required this.onTap,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      bottom: bottomOffset,
      child: SlideTransition(
        position: slideAnimation,
        child: EdgeActionButton(
          label: label,
          iconPath: iconPath,
          backgroundColor: backgroundColor,
          onTap: onTap,
          collapseAnimation: collapseAnimation,
        ),
      ),
    );
  }
}
