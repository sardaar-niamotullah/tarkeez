import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/extensions/period_range_extension.dart';
import 'package:tarkeez/core/shared_files/cubits/report_period_cubit.dart';
import 'package:tarkeez/features/daily_rollups/data/models/timeline_model.dart';

class ReportTimelineChartConfig {
  static const double horizontalPageMargin = 16 * 2;
  static const double timelineChartBoxHorizontalPadding = 6 + 12;
  static double getYAxisIndexColumnWidth(BuildContext context) {
    final granularity = context.watch<ReportPeriodCubit>().state.granularity;
    return granularity == .daily ? 18 : 23;
  }

  static const double horizontalGapAfterYAxis = 4;
  static const double barWidthInset = 12;
  static const double labelAreaHeight = 28;
  static const double labelGap = 4;
  static const double labelTopInset = 16.0;

  static const double maxChartBoxHeight = 300;
  static const double maxChartBoxWidth = 1200;

  static double getChartHeight(BuildContext context) => math.min(
    getAvailableWidth(context) / 2.1,
    maxChartBoxHeight - labelTopInset,
  );

  static int getMaxMinutes(List<TimelineModel> entries) {
    if (entries.isEmpty) return 180;
    final maxSeconds = entries.map((entry) => entry.seconds).reduce(math.max);
    return maxSeconds ~/ 60;
  }

  static int getMaxHours(List<TimelineModel> entries) =>
      (getMaxMinutes(entries) / 60).ceil();

  static int getChartTopHours(List<TimelineModel> entries) {
    final maxHours = getMaxHours(entries);
    return math.max(3, ((maxHours + 2) ~/ 3) * 3);
  }

  static int getHoursPerStep(List<TimelineModel> entries) =>
      getChartTopHours(entries) ~/ 3;

  static double getBarAreaHeight(BuildContext context) {
    final chartHeight = getChartHeight(context);
    return chartHeight - labelAreaHeight - labelGap;
  }

  static double getMinutesPerPixel(
    BuildContext context,
    List<TimelineModel> entries,
  ) {
    final chartTopHours = getChartTopHours(entries);
    final barAreaHeight = getBarAreaHeight(context);
    return (chartTopHours * 60) / barAreaHeight;
  }

  static double getAvailableWidth(BuildContext context) {
    final boxWidth = math.min(
      MediaQuery.of(context).size.width - horizontalPageMargin,
      maxChartBoxWidth,
    );
    return boxWidth -
        timelineChartBoxHorizontalPadding -
        getYAxisIndexColumnWidth(context) -
        horizontalGapAfterYAxis;
  }

  static double getBarWidth({
    required BuildContext context,
    required List<TimelineModel> entries,
    required double availableWidth,
  }) {
    final granularity = context.watch<ReportPeriodCubit>().state.granularity;
    

    final dailyWidth = availableWidth / 7;
    final monthlyWidth = availableWidth / 5;
    final lessThanWeekWidth = availableWidth / math.max(entries.length, 1);

    final calculatedWidth = granularity == .monthly
        ? monthlyWidth
        : entries.length <= 7
        ? lessThanWeekWidth
        : dailyWidth;

    return calculatedWidth;
  }

  static List<TimelineModel> getVisibleEntries(List<TimelineModel> entries) =>
      entries.reversed.toList();

  static double getTotalTimelineWidth({
    required List<TimelineModel> entries,
    required double availableWidth,
    required double barWidth,
  }) => math.max(availableWidth, entries.length * barWidth);
}
