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
    required this.dotsVisible,
  });

  final String left;
  final String right;
  final bool dotsVisible;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final compact = context.between(Breakpoints.md, Breakpoints.lg);
    final digitStyle = TextUtils.title1(
      context,
      fontFamily: AppFontFamily.poppins,
    ).copyWith(fontSize: compact ? 64 : 84);
    final dotSize = compact ? 12.0 : 14.0;
    final dot = Container(
      height: dotSize,
      width: dotSize,
      decoration: BoxDecoration(
        color: scheme.onTertiary.withValues(alpha: dotsVisible ? .9 : 0),
        shape: .circle,
      ),
    );

    // scaleDown: "120:00" is wider than "0:25" and must still fit narrow phones.
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: .min,
        crossAxisAlignment: .center,
        children: [
          Text(left, style: digitStyle),
          Container(
            margin: .symmetric(horizontal: 3.5),
            child: Column(
              children: [dot, SizedBox(height: compact ? 10 : 12), dot],
            ),
          ),
          Text(right, style: digitStyle),
        ],
      ),
    );
  }
}