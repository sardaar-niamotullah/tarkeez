import 'package:flutter/material.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class DurationTextUtils extends StatelessWidget {
  final int durationInSeconds;
  final double? fontSizePrimary, fontSizeSeconday;
  final Color? fontColorPrimary, fontColorSecondary;
  final bool showOnlyHour;
  final double middleGap;

  const DurationTextUtils({
    super.key,
    required this.durationInSeconds,
    this.fontSizePrimary,
    this.fontSizeSeconday,
    this.fontColorPrimary,
    this.fontColorSecondary,
    this.showOnlyHour = false,
    this.middleGap = 3,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final primaryStyle = TextUtils.title3(
      context,
    ).copyWith(fontSize: fontSizePrimary, color: fontColorPrimary);

    final durationInMinutes = durationInSeconds ~/ 60;

    if (showOnlyHour) {
      final hours = (durationInMinutes / 6).ceil() / 10;
      final hourText = hours == hours.toInt()
          ? '${hours.toInt()}h'
          : '${hours.toStringAsFixed(1)}h';
      return Text(hourText, style: primaryStyle);
    }

    final hours = durationInMinutes ~/ 60;
    final mins = durationInMinutes % 60;

    final secondaryStyle = TextUtils.paragraphSmallBold(
      context,
      color: scheme.onTertiary.withValues(alpha: .7),
    ).copyWith(fontSize: fontSizeSeconday, color: fontColorSecondary);

    final children = <Widget>[];
    if (hours > 0) {
      children.add(Text('${hours}h', style: primaryStyle));
    }
    if (hours > 0 && mins > 0) {
      children.add(SizedBox(width: middleGap));
    }
    if (mins > 0 || hours == 0) {
      children.add(
        Text('${mins}m', style: hours > 0 ? secondaryStyle : primaryStyle),
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
