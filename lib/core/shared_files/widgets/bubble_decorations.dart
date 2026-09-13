import 'package:flutter/material.dart';

/// Solid filled bubble
class BubbleSolid extends StatelessWidget {
  final double size;
  final Color color;
  final double opacity;

  const BubbleSolid({
    super.key,
    required this.size,
    required this.color,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: opacity),
      ),
    );
  }
}

/// Ring-only bubble (hollow)
class BubbleRing extends StatelessWidget {
  final double size;
  final Color color;
  final double opacity;

  const BubbleRing({
    super.key,
    required this.size,
    required this.color,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: .all(color: color.withValues(alpha: opacity), width: 1.5),
      ),
    );
  }
}
