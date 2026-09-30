import 'package:flutter/material.dart';
import 'package:tarkeez/core/shared_files/enums/timeline_granularity.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class TimeVisualizerBarLabel extends StatelessWidget {
  final DateTime date;
  final double slotWidth;
  final bool showMonthDay;
  final TimelineGranularity granularity;

  const TimeVisualizerBarLabel({
    super.key,
    required this.date,
    required this.slotWidth,
    this.showMonthDay = true,
    this.granularity = TimelineGranularity.daily,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isMonthly = granularity == TimelineGranularity.monthly;

    final top = isMonthly ? monthLabel(date.month) : weekdayLabel(date.weekday);
    final bottom =
        isMonthly ? '${date.year}' : '${monthLabel(date.month)} ${date.day}';

    final color = scheme.onTertiary.withValues(alpha: .7);

    return SizedBox(
      width: slotWidth,
      child: Column(
        children: [
          Text(
            top,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.visible,
            style: TextUtils.paragraphSmall(context, color: color)
                .copyWith(fontSize: 10, height: 1),
          ),
          if (showMonthDay)
            Text(
              bottom,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.visible,
              style: TextUtils.paragraphSmall(context, color: color)
                  .copyWith(fontSize: 10),
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
