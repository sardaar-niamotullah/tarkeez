import 'package:flutter/material.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/report/presentation/sections/report_timeline_chart_config.dart';

class ChartYAxisLabel extends StatelessWidget {
  final double labelHeight;
  final int chartTopHours, hoursPerStep;
  final CrossAxisAlignment? crossAxisAlignment;
  const ChartYAxisLabel({
    super.key,
    required this.labelHeight,
    required this.chartTopHours,
    required this.hoursPerStep,
    this.crossAxisAlignment,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textStyle = TextUtils.paragraphXs(
      context,
      color: scheme.onTertiary.withValues(alpha: .7),
    );

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
          Text('${chartTopHours}h', style: textStyle),
          Text('${hoursPerStep * 2}h', style: textStyle),
          Text('${hoursPerStep}h', style: textStyle),
          Text('0h', style: textStyle),
        ],
      ),
    );
  }
}
