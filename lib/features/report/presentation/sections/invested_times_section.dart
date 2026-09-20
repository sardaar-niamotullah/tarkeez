import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/constants/img_paths.dart';
import 'package:tarkeez/core/shared_files/cubits/theme_cubit.dart';
import 'package:tarkeez/core/shared_files/widgets/section_image_lock_overlay.dart';
import 'package:tarkeez/core/theme/theme.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/daily_rollups/bloc/daily_rollup_bloc.dart';
import 'package:tarkeez/features/report/presentation/sections/widgets/invested_time_stat_group.dart';

class InvestedTimesSection extends StatelessWidget {
  final bool isLocked;

  const InvestedTimesSection({super.key, required this.isLocked});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Invested times', style: TextUtils.title2(context)),
        const SizedBox(height: 8),
        if (isLocked)
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              return SectionImageLockOverlay(
                imgLocation: state.isDark
                    ? ImgPaths.investedTimesLockBackdropsDark
                    : ImgPaths.investedTimesLockBackdropsLight,
                height: 116,
                lockedTopicName: 'invested times',
              );
            },
          ),
        if (!isLocked)
          BlocBuilder<DailyRollupBloc, DailyRollupState>(
            buildWhen: (previous, current) => current is DailyRollupLoaded,
            builder: (context, state) {
              final loaded = state is DailyRollupLoaded ? state : null;

              return SingleChildScrollView(
                scrollDirection: .horizontal,
                child: Row(
                  children: [
                    InvestedTimeStatGroup(
                      emoji: '️☀️',
                      accentColor: AppTheme.trophyGold,
                      topSeconds: loaded?.today ?? 0,
                      topLabel: 'Today',
                      bottomSeconds: loaded?.yesterday ?? 0,
                      bottomLabel: 'Yesterday',
                    ),
                    const SizedBox(width: ContainerDesignUtils.halfPadding),
                    InvestedTimeStatGroup(
                      emoji: '📅',
                      accentColor: AppTheme.crimsonTab,
                      topSeconds: loaded?.thisWeek ?? 0,
                      topLabel: 'This week',
                      bottomSeconds: loaded?.lastWeek ?? 0,
                      bottomLabel: 'Last week',
                    ),
                    const SizedBox(width: ContainerDesignUtils.halfPadding),
                    InvestedTimeStatGroup(
                      emoji: '🗓️',
                      accentColor: AppTheme.blue,
                      topSeconds: loaded?.thisMonth ?? 0,
                      topLabel: 'This month',
                      bottomSeconds: loaded?.lastMonth ?? 0,
                      bottomLabel: 'Last month',
                    ),
                    const SizedBox(width: ContainerDesignUtils.halfPadding),
                    InvestedTimeStatGroup(
                      emoji: '🌍',
                      accentColor: AppTheme.sandAmber,
                      topSeconds: loaded?.thisYear ?? 0,
                      topLabel: 'This year',
                      bottomSeconds: loaded?.lastYear ?? 0,
                      bottomLabel: 'Last year',
                    ),
                    const SizedBox(width: ContainerDesignUtils.halfPadding),
                    InvestedTimeStatGroup(
                      emoji: '⏳',
                      accentColor: AppTheme.sandAmber,
                      topSeconds: loaded?.last7Days ?? 0,
                      topLabel: 'Last 7 days',
                      middleSeconds: loaded?.last30Days ?? 0,
                      middleLabel: 'Last 30 days',
                      bottomSeconds: loaded?.last365Days ?? 0,
                      bottomLabel: 'Last 365 days',
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}
