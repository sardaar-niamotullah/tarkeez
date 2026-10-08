import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tailwind_breakpoints/tailwind_breakpoints.dart';
import 'package:tarkeez/core/shared_files/enums/period_range.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/duration_text_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/daily_rollups/bloc/daily_rollup_bloc.dart';
import 'package:tarkeez/features/home/presentation/sections/widgets/home_bar_chart.dart';

class HomeBarChartSection extends StatelessWidget {
  const HomeBarChartSection({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      height: context.xs ? 248 : 224,
      padding: .symmetric(
        horizontal: ContainerDesignUtils.padding,
        vertical: context.md ? ContainerDesignUtils.padding : 16,
      ),
      decoration: BoxDecoration(
        color: scheme.onSurface,
        borderRadius: ContainerDesignUtils.allRadius,
      ),
      child: Column(
        mainAxisAlignment: .spaceBetween,
        children: [
          Row(
            children: [
              Text('Last 5 days', style: TextUtils.title2(context)),
              const Spacer(),
              BlocBuilder<DailyRollupBloc, DailyRollupState>(
                builder: (context, state) {
                  final totalSeconds = state is DailyRollupLoaded
                      ? state.totalSecondsForPeriod(PeriodRange.last5Days)
                      : 0;
                  return DurationTextUtils(
                    durationInSeconds: totalSeconds,
                    fontSizePrimary: 18,
                    fontSizeSeconday: 14,
                  );
                },
              ),
              const SizedBox(width: 4),
            ],
          ),
          const HomeBarChart(),
        ],
      ),
    );
  }
}
