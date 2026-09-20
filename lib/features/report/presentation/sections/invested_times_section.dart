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
          SingleChildScrollView(
            scrollDirection: .horizontal,
            child: Row(
              children: [
                InvestedTimeStatGroup(
                  emoji: '️☀️',
                  accentColor: AppTheme.trophyGold,
                  topSeconds: 1432, // today
                  topLabel: 'Today',
                  bottomSeconds: 4323, // yesterday
                  bottomLabel: 'Yesterday',
                ),
                const SizedBox(width: ContainerDesignUtils.halfPadding),
                InvestedTimeStatGroup(
                  emoji: '📅',
                  accentColor: AppTheme.crimsonTab,
                  topSeconds: 12342, // this week
                  topLabel: 'This week',
                  bottomSeconds: 3242, // last week
                  bottomLabel: 'Last week',
                ),
                const SizedBox(width: ContainerDesignUtils.halfPadding),
                InvestedTimeStatGroup(
                  emoji: '🗓️',
                  accentColor: AppTheme.blue,
                  topSeconds: 123434, // this month
                  topLabel: 'This month',
                  bottomSeconds: 53423, // last month
                  bottomLabel: 'Last month',
                ),
                const SizedBox(width: ContainerDesignUtils.halfPadding),
                InvestedTimeStatGroup(
                  emoji: '🌍',
                  accentColor: AppTheme.sandAmber,
                  topSeconds: 123456, // this year
                  topLabel: 'This year',
                  bottomSeconds: 432312, // last year
                  bottomLabel: 'Last year',
                ),
                const SizedBox(width: ContainerDesignUtils.halfPadding),
                InvestedTimeStatGroup(
                  emoji: '⏳',
                  accentColor: AppTheme.sandAmber,
                  topSeconds: 12132, // last 7 days
                  topLabel: 'Last 7 days',
                  middleSeconds: 124234, // last 30 days
                  middleLabel: 'Last 30 days',
                  bottomSeconds: 32423, // last 365 day
                  bottomLabel: 'Last 365 days',
                ),
              ],
            ),
          ),
      ],
    );
  }
}
