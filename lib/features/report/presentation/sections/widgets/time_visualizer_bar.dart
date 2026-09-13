import 'package:flutter/material.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/duration_text_utils.dart';
import 'package:tarkeez/features/report/data/model/timeline_model.dart';
import 'package:tarkeez/features/report/presentation/sections/report_timeline_chart_config.dart';

class TimeVisualizerBar extends StatelessWidget {
  final TimelineModel entry;
  final double minutesPerPixel;
  final double barAreaHeight;
  final double slotWidth;
  final bool showOnlyHour;

  const TimeVisualizerBar({
    super.key,
    required this.entry,
    required this.minutesPerPixel,
    required this.barAreaHeight,
    required this.slotWidth,
    this.showOnlyHour = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final durationInMinutes = entry.seconds ~/ 60;
    final barHeight = durationInMinutes <= 0
        ? 0.0
        : (durationInMinutes / minutesPerPixel).clamp(1.0, barAreaHeight);

    return SizedBox(
      width: slotWidth,
      child: Align(
        alignment: .bottomCenter,
        child: Stack(
          clipBehavior: .none,
          children: [
            Container(
              width: slotWidth - ReportTimelineChartConfig.barWidthInset,
              height: barHeight,
              decoration: BoxDecoration(
                borderRadius: ContainerDesignUtils.topHalfRadius,
                gradient: LinearGradient(
                  begin: .topLeft,
                  end: .bottomRight,
                  colors: [scheme.primaryContainer, scheme.primary],
                ),
              ),
            ),

            if (barHeight != 0)
              Positioned(
                left: 0,
                right: 0,
                bottom: barHeight,
                child: Center(
                  child: DurationTextUtils(
                    durationInSeconds: entry.seconds,
                    fontSizePrimary: 10,
                    fontSizeSeconday: 8,
                    middleGap: 1,
                    showOnlyHour: showOnlyHour,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
