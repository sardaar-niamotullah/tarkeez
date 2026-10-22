import 'package:flutter/material.dart';

class TimeVisualizerHorizontalLine extends CustomPainter {
  final int lineCount;
  final Color lineColor;

  TimeVisualizerHorizontalLine({required this.lineCount, required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    if (lineCount <= 1) return;
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 1;
    final halfStroke = paint.strokeWidth / 2;
    for (var i = 0; i < lineCount; i++) {
      final rawDy = size.height - (size.height * i / (lineCount - 1));
      final dy = i == lineCount - 1 ? halfStroke : rawDy;
      canvas.drawLine(Offset(0, dy), Offset(size.width, dy), paint);
    }
  }

  @override
  bool shouldRepaint(covariant TimeVisualizerHorizontalLine oldDelegate) {
    return oldDelegate.lineCount != lineCount ||
        oldDelegate.lineColor != lineColor;
  }
}
