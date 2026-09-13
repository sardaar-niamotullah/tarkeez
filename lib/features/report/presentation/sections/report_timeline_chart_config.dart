import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tarkeez/features/report/data/model/timeline_model.dart';

class ReportTimelineChartConfig {
  static const double horizontalPageMargin = 16 * 2;
  static const double timelineChartBoxHorizontalPadding = 6 + 12;
  static const double yAxisIndexColumnWidth = 18;
  static const double horizontalGapAfterYAxis = 4;
  static const double barWidthInset = 12;
  static const double labelAreaHeight = 28;
  static const double labelGap = 4;
  static const double labelTopInset = 16.0;

  static double getChartHeight(BuildContext context) {
    return getAvailableWidth(context) / 2.1;
  }

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
    return MediaQuery.of(context).size.width -
        horizontalPageMargin -
        timelineChartBoxHorizontalPadding -
        yAxisIndexColumnWidth -
        horizontalGapAfterYAxis;
  }

  static double getBarWidth({
    required List<TimelineModel> entries,
    required double availableWidth,
  }) {
    return entries.length <= 7
        ? availableWidth / math.max(entries.length, 1)
        : availableWidth / 7;
  }

  static List<TimelineModel> getVisibleEntries(List<TimelineModel> entries) {
    return entries.reversed.toList();
  }

  static double getTotalTimelineWidth({
    required List<TimelineModel> entries,
    required double availableWidth,
    required double barWidth,
  }) {
    return math.max(availableWidth, entries.length * barWidth);
  }
}
