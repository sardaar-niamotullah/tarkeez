import 'package:flutter/material.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/report/presentation/sections/report_timeline_chart_config.dart';

class ChartYAxisLabel extends StatelessWidget {
  const new({
    super.key,
    required this.labelHeight,
    required this.chartTopHours,
    required this.hoursPerStep,
    this.crossAxisAlignment,
  });

  final double labelHeight;
  final double chartTopHours, hoursPerStep;
  final CrossAxisAlignment? crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textStyle = TextUtils.paragraphXs(
      context,
      color: scheme.onTertiary.withValues(alpha: .7),
    );

    // 1.5 -> "1.5h", 2.0 -> "2h"
    String label(double hours) => '${hours % 1 == 0 ? hours.toInt() : hours}h';

    return Container(
      height: labelHeight,
      margin: .only(
        right: crossAxisAlignment == null
            ? ReportTimelineChartConfig.getHorizontalGapAfterYAxis(context)
            : 0,
        left: crossAxisAlignment != null
            ? ReportTimelineChartConfig.getHorizontalGapAfterYAxis(context)
            : 0,
      ),
      width: ReportTimelineChartConfig.getYAxisIndexColumnWidth(context),
      child: Column(
        mainAxisAlignment: .spaceBetween,
        crossAxisAlignment: crossAxisAlignment ?? .end,
        children: [
          Text(label(chartTopHours), style: textStyle),
          Text(label(hoursPerStep * 2), style: textStyle),
          Text(label(hoursPerStep), style: textStyle),
          Text('0h', style: textStyle),
        ],
      ),
    );
  }
}