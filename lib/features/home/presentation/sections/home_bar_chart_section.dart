import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      color: scheme.onSurface,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text('Last 3 days', style: TextUtils.title2(context)),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Center(
                  child: Container(
                    padding: .symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: ContainerDesignUtils.allRadius,
                    ),
                    child: BlocBuilder<DailyRollupBloc, DailyRollupState>(
                      builder: (context, state) {
                        final totalSeconds = state is DailyRollupLoaded
                            ? state.totalSecondsForPeriod(PeriodRange.last3Days)
                            : 0;
                        return DurationTextUtils(
                          durationInSeconds: totalSeconds,
                          fontSizePrimary: 24,
                          fontSizeSeconday: 14,
                          fontColorPrimary: scheme.primary,
                          fontColorSecondary: scheme.primary.withValues(
                            alpha: .75,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const Expanded(flex: 3, child: HomeBarChart()),
            ],
          ),
        ],
      ),
    );
  }
}
