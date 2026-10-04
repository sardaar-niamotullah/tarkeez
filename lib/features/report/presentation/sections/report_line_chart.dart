import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tailwind_breakpoints/tailwind_breakpoints.dart';
import 'package:tarkeez/core/shared_files/cubits/report_period_cubit.dart';
import 'package:tarkeez/core/theme/theme.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/daily_rollups/bloc/daily_rollup_bloc.dart';
import 'package:tarkeez/features/daily_rollups/data/models/timeline_model.dart';
import 'package:tarkeez/features/report/presentation/sections/report_timeline_chart_config.dart';
import 'package:tarkeez/features/report/presentation/sections/widgets/chart_y_axis_label.dart';
import 'package:tarkeez/features/report/presentation/sections/widgets/time_visualizer_bar_label.dart';

class ReportLineChart extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final periodRange = context.watch<ReportPeriodCubit>().state;

    return BlocBuilder<DailyRollupBloc, DailyRollupState>(
      builder: (context, state) {
        final entries = state is DailyRollupLoaded
            ? state.timelineForPeriod(periodRange)
            : const <TimelineModel>[];

        if (entries.isEmpty) const SizedBox.shrink();
        final chartHeight = ReportTimelineChartConfig.getChartHeight(context);
        final barAreaHeight = ReportTimelineChartConfig.getBarAreaHeight(
          context,
        );
        final chartEntries = ReportTimelineChartConfig.getVisibleEntries(
          entries,
        );
        final chartTopHours = ReportTimelineChartConfig.getChartTopHours(
          entries,
        );
        final chartTopMinutes = chartTopHours * 60;
        final hoursPerStep = ReportTimelineChartConfig.getHoursPerStep(entries);
        final availableWidth = ReportTimelineChartConfig.getAvailableWidth(
          context,
        );
        final pointWidth = ReportTimelineChartConfig.getBarWidth(
          context: context,
          entries: chartEntries,
          availableWidth: availableWidth,
        );
        final totalChartWidth = ReportTimelineChartConfig.getTotalTimelineWidth(
          entries: chartEntries,
          availableWidth: availableWidth,
          barWidth: pointWidth,
        );
        return Container(
          width: .infinity,
          padding: .only(
            left: context.sm ? 12 : 6,
            right: context.sm ? 18 : 12,
            top: context.sm ? 6 : 8,
            bottom: context.sm ? 2 : 0,
          ),
          decoration: BoxDecoration(
            color: scheme.onSurface,
            borderRadius: ContainerDesignUtils.bottomRadius,
          ),
          child: Row(
            crossAxisAlignment: .start,
            children: [
              // ------------------------------------------------------------
              // Y AXIS LABELS
              // ------------------------------------------------------------
              Transform.translate(
                offset: context.sm ? const Offset(0, 7) : const Offset(0, 2),
                child: ChartYAxisLabel(
                  labelHeight: barAreaHeight - (context.sm ? 3.5 : 0),
                  chartTopHours: chartTopHours,
                  hoursPerStep: hoursPerStep,
                ),
              ),
              // ------------------------------------------------------------
              // CHART
              // ------------------------------------------------------------
              Expanded(
                child: SingleChildScrollView(
                  reverse: true,
                  scrollDirection: .horizontal,
                  child: SizedBox(
                    width: totalChartWidth,
                    height: chartHeight,
                    child: LineChart(
                      duration: .zero,
                      LineChartData(
                        minX: -0.29,
                        maxX:
                            (chartEntries.length - 1).clamp(
                              1,
                              double.infinity,
                            ) +
                            .29,
                        minY: 0,
                        maxY: chartTopMinutes.toDouble() + 36,

                        borderData: FlBorderData(show: false),

                        // --------------------------------------------------
                        // LINE
                        // --------------------------------------------------
                        lineBarsData: [
                          LineChartBarData(
                            isCurved: true,
                            curveSmoothness: 0.2,
                            color: scheme.primary,
                            barWidth: 3,
                            shadow: Shadow(
                              color: scheme.primary.withValues(alpha: 0.25),
                              blurRadius: 4,
                            ),
                            spots: chartEntries.asMap().entries.map((item) {
                              final index = item.key;
                              final entry = item.value;

                              return FlSpot(
                                index.toDouble(),
                                (entry.seconds ~/ 60).toDouble(),
                              );
                            }).toList(),

                            // AREA BELOW LINE
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                begin: .topCenter,
                                end: .bottomCenter,
                                colors: [
                                  scheme.primary.withValues(alpha: 0.3),
                                  scheme.primary.withValues(alpha: 0.05),
                                ],
                              ),
                            ),

                            dotData: const FlDotData(show: true),
                          ),
                        ],

                        // --------------------------------------------------
                        // GRID
                        // --------------------------------------------------
                        gridData: const FlGridData(
                          show: false,
                          drawVerticalLine: false,
                        ),

                        // --------------------------------------------------
                        // HORIZONTAL LINES
                        // --------------------------------------------------
                        extraLinesData: ExtraLinesData(
                          horizontalLines: [
                            HorizontalLine(
                              y: 1,
                              color: AppTheme.dividerColor.withValues(
                                alpha: 0.1,
                              ),
                              strokeWidth: 1,
                            ),
                            HorizontalLine(
                              y: chartTopMinutes / 3,
                              color: AppTheme.dividerColor.withValues(
                                alpha: 0.1,
                              ),
                              strokeWidth: 1,
                            ),
                            HorizontalLine(
                              y: chartTopMinutes * 2 / 3,
                              color: AppTheme.dividerColor.withValues(
                                alpha: 0.1,
                              ),
                              strokeWidth: 1,
                            ),
                            HorizontalLine(
                              y: chartTopMinutes - 1,
                              color: AppTheme.dividerColor.withValues(
                                alpha: 0.1,
                              ),
                              strokeWidth: 1,
                            ),
                          ],
                        ),

                        // --------------------------------------------------
                        // TOUCH
                        // --------------------------------------------------
                        lineTouchData: LineTouchData(
                          enabled: true,
                          touchSpotThreshold: pointWidth / 2,
                          getTouchLineStart: (_, _) => -double.infinity,
                          getTouchLineEnd: (_, _) => .infinity,

                          getTouchedSpotIndicator:
                              (
                                LineChartBarData barData,
                                List<int> spotIndexes,
                              ) {
                                return spotIndexes.map((spotIndex) {
                                  return TouchedSpotIndicatorData(
                                    FlLine(
                                      color: scheme.primary.withValues(
                                        alpha: 0.35,
                                      ),
                                      strokeWidth: 1,
                                      dashArray: [5, 4],
                                    ),
                                    FlDotData(
                                      show: true,
                                      getDotPainter:
                                          (spot, percent, barData, index) {
                                            return FlDotCirclePainter(
                                              radius: 5,
                                              color: scheme.primary,
                                              strokeWidth: 2,
                                              strokeColor: scheme.onSurface,
                                            );
                                          },
                                    ),
                                  );
                                }).toList();
                              },

                          // ------------------------------------------------
                          // TOOLTIP
                          // ------------------------------------------------
                          touchTooltipData: LineTouchTooltipData(
                            getTooltipColor: (_) => Colors.transparent,
                            tooltipPadding: .zero,
                            tooltipMargin: 24,
                            getTooltipItems: (List<LineBarSpot> touchedSpots) {
                              return touchedSpots.map((barSpot) {
                                final index = barSpot.x.toInt();

                                if (index < 0 || index >= chartEntries.length) {
                                  return null;
                                }

                                final entry = chartEntries[index];

                                final durationInMinutes = entry.seconds ~/ 60;
                                final hours = durationInMinutes ~/ 60;
                                final minutes = durationInMinutes % 60;
                                final durationText = hours == 0
                                    ? '${minutes}m'
                                    : minutes == 0
                                    ? '${hours}h'
                                    : '${hours}h ${minutes}m';

                                return LineTooltipItem(
                                  durationText,
                                  TextUtils.paragraphSmallBold(context)
                                      .copyWith(
                                        fontSize: 10,
                                        color: scheme.onTertiary,
                                      ),
                                );
                              }).toList();
                            },
                          ),
                        ),

                        // --------------------------------------------------
                        // AXIS TITLES
                        // --------------------------------------------------
                        titlesData: FlTitlesData(
                          show: true,
                          // LEFT
                          leftTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          // RIGHT
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          // TOP
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          // BOTTOM
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 35,
                              minIncluded: false,
                              maxIncluded: false,
                              interval: 1,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                final index = value.toInt();
                                if (index < 0 || index >= chartEntries.length) {
                                  return const SizedBox.shrink();
                                }
                                final entry = chartEntries[index];
                                return SideTitleWidget(
                                  meta: meta,
                                  child: TimeVisualizerBarLabel(
                                    date: entry.date,
                                    slotWidth: pointWidth,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
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
