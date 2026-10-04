import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/shared_files/buttons/custom_dropdown_button.dart';
import 'package:tarkeez/core/shared_files/cubits/report_period_cubit.dart';
import 'package:tarkeez/core/shared_files/enums/chart_type.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/duration_text_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/daily_rollups/bloc/daily_rollup_bloc.dart';
import 'package:tarkeez/features/report/presentation/sections/report_bar_chart.dart';
import 'package:tarkeez/features/report/presentation/sections/report_line_chart.dart';

class TimelineSection extends StatefulWidget {
  const new({super.key});

  @override
  State<TimelineSection> createState() => _TimelineSectionState();
}

class _TimelineSectionState extends State<TimelineSection> {
  ChartType _selectedChartType = ChartType.bar;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final periodRange = context.watch<ReportPeriodCubit>().state;
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text('Timeline', style: TextUtils.title2(context)),
        const SizedBox(height: 8),
        Container(
          padding: .only(
            right: ContainerDesignUtils.padding,
            left: ContainerDesignUtils.halfPadding,
            top: ContainerDesignUtils.halfPadding,
            bottom: ContainerDesignUtils.halfPadding,
          ),
          decoration: BoxDecoration(
            color: scheme.onSurface,
            borderRadius: ContainerDesignUtils.topRadius,
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
                      ? state.totalSecondsForPeriod(periodRange)
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
        switch (_selectedChartType) {
          ChartType.bar => const ReportBarChart(),
          ChartType.line => const ReportLineChart(),
        },
      ],
    );
  }
}
