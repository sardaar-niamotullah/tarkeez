import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/constants/img_paths.dart';
import 'package:tarkeez/core/shared_files/cubits/theme_cubit.dart';
import 'package:tarkeez/core/shared_files/widgets/section_image_lock_overlay.dart';
import 'package:tarkeez/core/theme/theme.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/report/presentation/sections/widgets/invested_time_stat_group.dart';

class InvestedTimesSection extends StatelessWidget {
  final bool isLocked;
  final int yesterday;
  final int today;
  final int lastWeek;
  final int thisWeek;
  final int lastMonth;
  final int thisMonth;
  final int thisYear;
  final int lastYear;
  final int lastSevenDays;
  final int lastThirtyDays;
  final int last365Days;

  const InvestedTimesSection({
    super.key,
    required this.isLocked,
    required this.today,
    required this.yesterday,
    required this.thisWeek,
    required this.lastWeek,
    required this.thisMonth,
    required this.lastMonth,
    required this.thisYear,
    required this.lastYear,
    required this.lastSevenDays,
    required this.lastThirtyDays,
    required this.last365Days,
  });

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
          SingleChildScrollView(
            scrollDirection: .horizontal,
            child: Row(
              children: [
                InvestedTimeStatGroup(
                  emoji: '️☀️',
                  accentColor: AppTheme.trophyGold,
                  topLabel: 'Today',
                  topSeconds: today,
                  bottomLabel: 'Yesterday',
                  bottomSeconds: yesterday,
                ),
                const SizedBox(width: ContainerDesignUtils.halfPadding),
                InvestedTimeStatGroup(
                  emoji: '📅',
                  accentColor: AppTheme.crimsonTab,
                  topLabel: 'This week',
                  topSeconds: thisWeek,
                  bottomLabel: 'Last week',
                  bottomSeconds: lastWeek,
                ),
                const SizedBox(width: ContainerDesignUtils.halfPadding),
                InvestedTimeStatGroup(
                  emoji: '🗓️',
                  accentColor: AppTheme.blue,
                  topLabel: 'This month',
                  topSeconds: thisMonth,
                  bottomLabel: 'Last month',
                  bottomSeconds: lastMonth,
                ),
                const SizedBox(width: ContainerDesignUtils.halfPadding),
                InvestedTimeStatGroup(
                  emoji: '🌍',
                  accentColor: AppTheme.sandAmber,
                  topLabel: 'This year',
                  topSeconds: thisYear,
                  bottomLabel: 'Last year',
                  bottomSeconds: lastYear,
                ),
                const SizedBox(width: ContainerDesignUtils.halfPadding),
                InvestedTimeStatGroup(
                  emoji: '⏳',
                  accentColor: AppTheme.sandAmber,
                  topLabel: 'Last 7 days',
                  topSeconds: lastSevenDays,
                  middleLabel: 'Last 30 days',
                  middleSeconds: lastThirtyDays,
                  bottomLabel: 'Last 365 days',
                  bottomSeconds: last365Days,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
