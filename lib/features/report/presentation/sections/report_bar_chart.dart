import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tailwind_breakpoints/tailwind_breakpoints.dart';
import 'package:tarkeez/core/extensions/period_range_extension.dart';
import 'package:tarkeez/core/shared_files/cubits/report_period_cubit.dart';
import 'package:tarkeez/core/theme/theme.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/features/daily_rollups/bloc/daily_rollup_bloc.dart';
import 'package:tarkeez/features/daily_rollups/data/models/timeline_model.dart';
import 'package:tarkeez/features/report/presentation/sections/report_timeline_chart_config.dart';
import 'package:tarkeez/features/report/presentation/sections/widgets/chart_y_axis_label.dart';
import 'package:tarkeez/features/report/presentation/sections/widgets/time_visualizer_bar.dart';
import 'package:tarkeez/features/report/presentation/sections/widgets/time_visualizer_bar_label.dart';
import 'package:tarkeez/features/report/presentation/sections/widgets/time_visualizer_horizontal_line.dart';

class ReportBarChart extends StatelessWidget {
  const ReportBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final periodRange = context.watch<ReportPeriodCubit>().state;
    final granularity = periodRange.granularity;

    return BlocBuilder<DailyRollupBloc, DailyRollupState>(
      builder: (context, state) {
        final entries = state is DailyRollupLoaded
            ? state.timelineForPeriod(periodRange)
            : const <TimelineModel>[];

        final chartHeight = ReportTimelineChartConfig.getChartHeight(context);
        final labelTopInset = ReportTimelineChartConfig.labelTopInset;
        final barAreaHeight = ReportTimelineChartConfig.getBarAreaHeight(
          context,
        );
        final minutesPerPixel = ReportTimelineChartConfig.getMinutesPerPixel(
          context,
          entries,
        );
        final chartTopHours = ReportTimelineChartConfig.getChartTopHours(
          entries,
        );
        final hoursPerStep = ReportTimelineChartConfig.getHoursPerStep(entries);
        final availableWidth = ReportTimelineChartConfig.getAvailableWidth(
          context,
        );
        final dataVisualiserBarWidth = ReportTimelineChartConfig.getBarWidth(
          context: context,
          entries: entries,
          availableWidth: availableWidth,
        );
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
          // padding: .only(left: 6, right: 12),
          padding: .only(
            left: context.sm ? 12 : 6,
            right: context.sm ? 18 : 12,
            top: context.sm ? 6 : 0,
            bottom: context.sm ? 2 : 0,
          ),
          decoration: BoxDecoration(
            color: scheme.onSurface,
            borderRadius: ContainerDesignUtils.allRadius,
          ),
          constraints: const BoxConstraints(
            maxWidth: ReportTimelineChartConfig.maxChartBoxWidth,
            maxHeight: ReportTimelineChartConfig.maxChartBoxHeight,
          ),
          child: Row(
            crossAxisAlignment: .start,
            children: [
              //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––
              // Y axis labels
              //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––
              Transform.translate(
                offset: Offset(0, -6 + labelTopInset),
                child: ChartYAxisLabel(
                  labelHeight: barAreaHeight + 12,
                  chartTopHours: chartTopHours,
                  hoursPerStep: hoursPerStep,
                ),
              ),

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
                                    lineColor: AppTheme.dividerColor.withValues(
                                      alpha: .1,
                                    ),
                                  ),
                                ),
                              ),

                              //–––––––––––––––––––––––––––––––––––––––––––––––––––––
                              // Main data bars
                              //–––––––––––––––––––––––––––––––––––––––––––––––––––––
                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: 0,
                                top: labelTopInset,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: .horizontal,
                                  itemCount: visibleEntries.length,
                                  clipBehavior: .none,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final entry = visibleEntries[index];
                                    return TimeVisualizerBar(
                                      entry: entry,
                                      minutesPerPixel: minutesPerPixel,
                                      barAreaHeight: barAreaHeight,
                                      slotWidth: dataVisualiserBarWidth,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(
                          height: ReportTimelineChartConfig.labelGap,
                        ),

                        //–––––––––––––––––––––––––––––––––––––––––––––––––––––
                        // Date and day labels
                        //–––––––––––––––––––––––––––––––––––––––––––––––––––––
                        SizedBox(
                          height: ReportTimelineChartConfig.labelAreaHeight,
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
                                granularity: granularity,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
