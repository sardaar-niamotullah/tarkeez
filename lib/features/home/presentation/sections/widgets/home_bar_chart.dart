import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/shared_files/enums/period_range.dart';
import 'package:tarkeez/core/theme/theme.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/features/daily_rollups/bloc/daily_rollup_bloc.dart';
import 'package:tarkeez/features/daily_rollups/data/models/timeline_model.dart';
import 'package:tarkeez/features/report/presentation/sections/report_timeline_chart_config.dart';
import 'package:tarkeez/features/report/presentation/sections/widgets/chart_y_axis_label.dart';
import 'package:tarkeez/features/report/presentation/sections/widgets/time_visualizer_bar.dart';
import 'package:tarkeez/features/report/presentation/sections/widgets/time_visualizer_bar_label.dart';
import 'package:tarkeez/features/report/presentation/sections/widgets/time_visualizer_horizontal_line.dart';

class HomeBarChart extends StatelessWidget {
  const HomeBarChart({super.key});

  static const double timelineChartBoxHorizontalPadding = 6 + 12;
  static const double labelAreaHeight = 12;
  static const double labelGap = 4;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return BlocBuilder<DailyRollupBloc, DailyRollupState>(
      builder: (context, state) {
        final entries = state is DailyRollupLoaded
            ? state.timelineForPeriod(PeriodRange.last3Days)
            : const <TimelineModel>[];

        return LayoutBuilder(
          builder: (context, constraints) {
            final totalWidgetWidth = constraints.maxWidth;

            final availableWidth =
                totalWidgetWidth -
                timelineChartBoxHorizontalPadding -
                ReportTimelineChartConfig.getYAxisIndexColumnWidth(context) -
                ReportTimelineChartConfig.getHorizontalGapAfterYAxis(context);

            final dataVisualiserBarWidth = availableWidth / 3;
            final chartHeight = 120; //availableWidth / 1.85;
            final barAreaHeight = chartHeight - labelAreaHeight - labelGap;
            final chartTopHours = ReportTimelineChartConfig.getChartTopHours(
              entries,
            );
            final minutesPerPixel = (chartTopHours * 60) / barAreaHeight;
            final hoursPerStep = ReportTimelineChartConfig.getHoursPerStep(
              entries,
            );
            final labelTopInset = ReportTimelineChartConfig.labelTopInset;
            final visibleEntries = ReportTimelineChartConfig.getVisibleEntries(
              entries,
            );
            final totalTimelineWidth =
                ReportTimelineChartConfig.getTotalTimelineWidth(
                  entries: entries,
                  availableWidth: availableWidth,
                  barWidth: dataVisualiserBarWidth,
                );

            return Container(
              width: .infinity,
              padding: const .only(left: 12, right: 6),
              decoration: BoxDecoration(
                color: scheme.onSurface,
                borderRadius: ContainerDesignUtils.allRadius,
              ),
              child: Row(
                crossAxisAlignment: .start,
                children: [
                  //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––
                  // Vertical data bars
                  //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––
                  Expanded(
                    child: SingleChildScrollView(
                      reverse: true,
                      scrollDirection: .horizontal,
                      child: SizedBox(
                        width: totalTimelineWidth,
                        height: chartHeight + labelTopInset,
                        child: Column(
                          children: [
                            SizedBox(
                              height: barAreaHeight + labelTopInset,
                              child: Stack(
                                clipBehavior: .none,
                                children: [
                                  //–––––––––––––––––––––––––––––––––––––––––––––––––––––
                                  // Background horizontal index lines
                                  //–––––––––––––––––––––––––––––––––––––––––––––––––––––
                                  Positioned.fill(
                                    top: labelTopInset,
                                    child: CustomPaint(
                                      painter: TimeVisualizerHorizontalLine(
                                        lineCount: 4,
                                        lineColor: AppTheme.dividerColor
                                            .withValues(alpha: .1),
                                      ),
                                    ),
                                  ),

                                  // -------------------------------------------
                                  // Main data bars
                                  // -------------------------------------------
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    top: labelTopInset,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: .horizontal,
                                      itemCount: visibleEntries.length,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        final entry = visibleEntries[index];

                                        return TimeVisualizerBar(
                                          entry: entry,
                                          minutesPerPixel: minutesPerPixel,
                                          barAreaHeight: barAreaHeight,
                                          slotWidth: dataVisualiserBarWidth,
                                          // showOnlyHour: true,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // -------------------------------------------------
                            // Gap between chart and labels
                            // -------------------------------------------------
                            const SizedBox(height: labelGap),

                            // -------------------------------------------------
                            // Date and day labels
                            // -------------------------------------------------
                            SizedBox(
                              height: labelAreaHeight,
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: .horizontal,
                                itemCount: visibleEntries.length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final entry = visibleEntries[index];

                                  return TimeVisualizerBarLabel(
                                    date: entry.date,
                                    slotWidth: dataVisualiserBarWidth,
                                    showMonthDay: false,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ---------------------------------------------------------
                  // Y axis labels
                  // ---------------------------------------------------------
                  Transform.translate(
                    offset: Offset(0, -6 + labelTopInset),
                    child: ChartYAxisLabel(
                      labelHeight: barAreaHeight + 12,
                      chartTopHours: chartTopHours,
                      hoursPerStep: hoursPerStep,
                      crossAxisAlignment: .start,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
