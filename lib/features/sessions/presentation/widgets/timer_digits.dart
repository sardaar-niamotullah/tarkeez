import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tailwind_breakpoints/tailwind_breakpoints.dart';
import 'package:tarkeez/core/theme/app_fonts.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

/// The big "left : right" display shared by the linear and the pomodoro timer.
class TimerDigits extends StatelessWidget {
  const new({
    super.key,
    required this.left,
    required this.right,
    this.dotsVisible = true,
  });

  final String left;
  final String right;

  /// The linear timer blinks it while running, the pomodoro keeps it on.
  final bool dotsVisible;

  /// Width of the widest digit in [style]: every digit gets a slot this wide.
  static double _slotWidth(BuildContext context, TextStyle style) {
    var widest = 0.0;
    for (var digit = 0; digit < 10; digit++) {
      final painter = TextPainter(
        text: TextSpan(text: '$digit', style: style),
        textDirection: .ltr,
        textScaler: MediaQuery.textScalerOf(context),
      )..layout();
      widest = math.max(widest, painter.width);
      painter.dispose();
    }
    return widest;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final compact = context.between(Breakpoints.md, Breakpoints.lg);
    final digitStyle = TextUtils.title1(
      context,
      fontFamily: AppFontFamily.sourceSans,
    ).copyWith(fontSize: compact ? 72 : 92);
    final slot = _slotWidth(context, digitStyle);
    final dotSize = compact ? 12.0 : 14.0;
    final dot = Container(
      height: dotSize,
      width: dotSize,
      decoration: BoxDecoration(
        color: scheme.onTertiary.withValues(alpha: dotsVisible ? .9 : 0),
        shape: .circle,
      ),
    );

    // Each digit is centered in its own slot, so "1" and "0" take the same width.
    Widget digits(String text) => Row(
      mainAxisSize: .min,
      children: [
        for (final char in text.split(''))
          SizedBox(
            width: slot,
            child: Text(char, textAlign: .center, style: digitStyle),
          ),
      ],
    );

    // scaleDown: "120:00" is wider than "0:25" and must still fit narrow phones.
    return FittedBox(
      fit: .scaleDown,
      child: Row(
        mainAxisSize: .min,
        crossAxisAlignment: .center,
        children: [
          digits(left),
          Container(
            margin: .symmetric(horizontal: 6),
            child: Column(
              children: [
                dot,
                SizedBox(height: compact ? 10 : 12),
                dot,
              ],
            ),
          ),
          digits(right),
        ],
      ),
    );
  }
}
