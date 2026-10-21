import 'package:flutter/material.dart';
import 'package:tarkeez/core/shared_files/enums/timeline_granularity.dart';
import 'package:tarkeez/core/utils/rollup_date_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';

class TimeVisualizerBarLabel extends StatelessWidget {
  const new({
    super.key,
    required this.date,
    required this.slotWidth,
    this.showMonthDay = true,
    this.granularity = .daily,
  });

  final DateTime date;
  final double slotWidth;
  final bool showMonthDay;
  final TimelineGranularity granularity;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isMonthly = granularity == TimelineGranularity.monthly;

    final month = RollupDateUtils.monthNames[date.month - 1];
    final weekday = RollupDateUtils.weekdayNames[date.weekday - 1];
    final top = isMonthly ? month : weekday;
    final bottom = isMonthly ? '${date.year}' : '$month ${date.day}';

    final color = scheme.onTertiary.withValues(alpha: .7);

    return SizedBox(
      width: slotWidth,
      child: Column(
        children: [
          Text(
            top,
            maxLines: 1,
            softWrap: false,
            overflow: .visible,
            style: TextUtils.paragraphSmall(
              context,
              color: color,
            ).copyWith(fontSize: 10, height: 1),
          ),
          if (showMonthDay)
            Text(
              bottom,
              maxLines: 1,
              softWrap: false,
              overflow: .visible,
              style: TextUtils.paragraphSmall(
                context,
                color: color,
              ).copyWith(fontSize: 10),
            ),
        ],
      ),
    );
  }
}
