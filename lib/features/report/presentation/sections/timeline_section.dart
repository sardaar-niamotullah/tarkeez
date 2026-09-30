import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/shared_files/buttons/custom_dropdown_button.dart';
import 'package:tarkeez/core/shared_files/enums/chart_type.dart';
import 'package:tarkeez/core/shared_files/enums/period_range.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/duration_text_utils.dart';
import 'package:tarkeez/features/daily_rollups/bloc/daily_rollup_bloc.dart';
import 'package:tarkeez/features/report/presentation/sections/report_bar_chart.dart';
import 'package:tarkeez/features/report/presentation/sections/report_line_chart.dart';

class TimelineSection extends StatefulWidget {
  const new({super.key, required this.periodRange});

  final PeriodRange periodRange;

  @override
  State<TimelineSection> createState() => _TimelineSectionState();
}

class _TimelineSectionState extends State<TimelineSection> {
  ChartType _selectedChartType = ChartType.bar;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Container(
          padding: .only(
            right: ContainerDesignUtils.padding,
            left: ContainerDesignUtils.halfPadding,
            top: ContainerDesignUtils.quarterPadding,
            bottom: ContainerDesignUtils.quarterPadding,
          ),
          decoration: BoxDecoration(
            color: scheme.onSurface,
            borderRadius: ContainerDesignUtils.allRadius,
          ),
          child: Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              CustomDropdownButton<ChartType>(
                items: ChartType.values,
                buttonWidth: 130,
                buttonColor: scheme.surface,
                initialValue: _selectedChartType,
                labelBuilder: (type) => type.label,
                onChanged: (value) {
                  setState(() => _selectedChartType = value);
                },
              ),
              BlocBuilder<DailyRollupBloc, DailyRollupState>(
                builder: (context, state) {
                  final totalSeconds = state is DailyRollupLoaded
                      ? state.totalSecondsForPeriod(widget.periodRange)
                      : 0;
                  return DurationTextUtils(
                    durationInSeconds: totalSeconds,
                    fontSizePrimary: 18,
                    fontSizeSeconday: 14,
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        switch (_selectedChartType) {
          ChartType.bar => const ReportBarChart(),
          ChartType.line => const ReportLineChart(),
        },
      ],
    );
  }
}
