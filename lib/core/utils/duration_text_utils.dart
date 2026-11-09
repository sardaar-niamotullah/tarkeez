import 'package:flutter/material.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class DurationTextUtils extends StatelessWidget {
  const new({
    super.key,
    required this.durationInSeconds,
    this.fontSizePrimary,
    this.fontSizeSeconday,
    this.fontColorPrimary,
    this.fontColorSecondary,
    this.showOnlyHour = false,
    this.showDayHour = false,
    this.middleGap = 3,
  });

  final int durationInSeconds;
  final double? fontSizePrimary, fontSizeSeconday;
  final Color? fontColorPrimary, fontColorSecondary;
  final bool showOnlyHour, showDayHour;
  final double middleGap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final primaryStyle = TextUtils.title3(context)
        .copyWith(fontSize: fontSizePrimary, color: fontColorPrimary);

    final durationInMinutes = durationInSeconds ~/ 60;

    if (showOnlyHour) {
      final hours = (durationInMinutes / 6).ceil() / 10;
      final hourText = hours == hours.toInt()
          ? '${hours.toInt()}h'
          : '${hours.toStringAsFixed(1)}h';
      return Text(hourText, style: primaryStyle);
    }

    final totalHours = durationInMinutes ~/ 60;
    final useDays = showDayHour && totalHours >= 24;

    // Two units are shown: d + h when useDays, otherwise h + m.
    final first = useDays ? totalHours ~/ 24 : totalHours;
    final second = useDays ? totalHours % 24 : durationInMinutes % 60;
    final firstUnit = useDays ? 'd' : 'h';
    final secondUnit = useDays ? 'h' : 'm';

    final secondaryStyle = TextUtils.paragraphSmallBold(
      context,
      color: scheme.onTertiary.withValues(alpha: .7),
    ).copyWith(fontSize: fontSizeSeconday, color: fontColorSecondary);

    final children = <Widget>[];
    if (first > 0) {
      children.add(Text('$first$firstUnit', style: primaryStyle));
    }
    if (first > 0 && second > 0) {
      children.add(SizedBox(width: middleGap));
    }
    if (second > 0 || first == 0) {
      children.add(
        Text(
          '$second$secondUnit',
          style: first > 0 ? secondaryStyle : primaryStyle,
        ),
      );
    }

    return Row(
      mainAxisSize: .min,
      textBaseline: .alphabetic,
      mainAxisAlignment: .center,
      crossAxisAlignment: .baseline,
      children: children,
    );
  }
}
