import 'package:flutter/material.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class TimeVisualizerBarLabel extends StatelessWidget {
  final DateTime date;
  final double slotWidth;
  final bool showMonthDay;

  const TimeVisualizerBarLabel({
    super.key,
    required this.date,
    required this.slotWidth,
    this.showMonthDay = true,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final weekday = weekdayLabel(date.weekday);
    final monthDay = '${monthLabel(date.month)} ${date.day}';

    return SizedBox(
      width: slotWidth,
      child: Column(
        children: [
          Text(
            weekday,
            maxLines: 1,
            softWrap: false,
            overflow: .visible,
            style: TextUtils.paragraphSmall(
              context,
              color: scheme.onTertiary.withValues(alpha: .7),
            ).copyWith(fontSize: 10, height: 1),
          ),
          if (showMonthDay)
            Text(
              monthDay,
              maxLines: 1,
              softWrap: false,
              overflow: .visible,
              style: TextUtils.paragraphSmall(
                context,
                color: scheme.onTertiary.withValues(alpha: .7),
              ).copyWith(fontSize: 10),
            ),
        ],
      ),
    );
  }
}

String weekdayLabel(int weekday) {
  const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  return labels[weekday - 1];
}

String monthLabel(int month) {
  const labels = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return labels[month - 1];
}
