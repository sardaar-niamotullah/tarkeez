import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tailwind_breakpoints/tailwind_breakpoints.dart';
import 'package:tarkeez/core/extensions/period_range_extension.dart';
import 'package:tarkeez/core/shared_files/cubits/report_period_cubit.dart';
import 'package:tarkeez/features/daily_rollups/data/models/timeline_model.dart';

class ReportTimelineChartConfig {
  static const double horizontalPageMargin = 16 * 2;
  static double getTimelineChartBoxHorizontalPadding(BuildContext context) =>
      context.sm ? 30 : 18;
  static double getTimelineChartBoxVerticalPadding(BuildContext context) =>
      context.sm ? 8 : 0;
  static double getHorizontalGapAfterYAxis(BuildContext context) =>
      context.sm ? 8 : 4;
  static double getYAxisIndexColumnWidth(BuildContext context) {
    final granularity = context.watch<ReportPeriodCubit>().state.granularity;
    return granularity == .daily ? 18 : 23;
  }

  static const double barWidthInset = 12;
  static const double labelAreaHeight = 28;
  static const double labelGap = 4;
  static const double labelTopInset = 16.0;

  static const double maxChartBoxHeight = 300;
  static const double maxChartBoxWidth = Breakpoints.lg;

  static double getChartHeight(BuildContext context) => math.min(
    (getAvailableWidth(context) / 2.1) -
        getTimelineChartBoxVerticalPadding(context),
    maxChartBoxHeight -
        labelTopInset -
        getTimelineChartBoxVerticalPadding(context),
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
    final navRailWidth = context.md ? 88 : 0;
    final boxWidth = math.min(
      context.screenWidth - horizontalPageMargin - navRailWidth,
      maxChartBoxWidth - 32,
    );
    return boxWidth -
        getTimelineChartBoxHorizontalPadding(context) -
        getYAxisIndexColumnWidth(context) -
        getHorizontalGapAfterYAxis(context);
  }

  static double getBarWidth({
    required BuildContext context,
    required List<TimelineModel> entries,
    required double availableWidth,
  }) {
    final granularity = context.watch<ReportPeriodCubit>().state.granularity;

    final dailyWidth = availableWidth / (context.lg ? 15 : 7);
    final monthlyWidth = availableWidth / (context.lg ? 12 : 5);
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
