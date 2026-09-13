import 'package:flutter/material.dart';

class TimeLogInterfaceBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final width = size.width;
    final height = size.height;

    final path = Path();
    path.moveTo(0, 30);
    path.cubicTo(30, 35, 0, 60, 50, 60);
    path.lineTo(width - 80, 60);
    path.cubicTo(width, 60, width - 45, 5, width, 0);
    path.lineTo(width, height);
    path.lineTo(0, height);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
