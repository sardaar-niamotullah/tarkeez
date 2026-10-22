import 'package:flutter/material.dart';

class TopRightNotchClipper extends CustomClipper<Path> {
  final double radius;
  final double filletRadius;

  TopRightNotchClipper({required this.radius, this.filletRadius = 0});

  @override
  Path getClip(Size size) {
    final s = filletRadius > 0 ? filletRadius : radius * 0.5;
    final path = Path();

    path.moveTo(0, 0);

    // Top edge up to first fillet start
    path.lineTo(size.width - radius * 2 - s, 0);

    // ① Convex fillet: horizontal top-edge → concave notch
    //    Center: (width - radius*2, 0)  — the original sharp corner A
    path.arcToPoint(
      Offset(size.width - radius * 2, s),
      radius: Radius.circular(s),
      clockwise: true,
    );

    // Concave notch arc (now properly tangent at both ends)
    path.arcToPoint(
      Offset(size.width - s, radius * 2),
      radius: Radius.circular(radius),
      clockwise: false,
    );

    // ② Convex fillet: concave notch → vertical right-edge
    //    Center: (width, radius*2)  — the original sharp corner B
    path.arcToPoint(
      Offset(size.width, radius * 2 + s),
      radius: Radius.circular(s),
      clockwise: true,
    );

    // Right edge down
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant TopRightNotchClipper old) =>
      old.radius != radius || old.filletRadius != filletRadius;
}
