import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/constants/img_paths.dart';
import 'package:tarkeez/core/shared_files/cubits/theme_cubit.dart';
import 'package:tarkeez/core/shared_files/widgets/section_image_lock_overlay.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/daily_rollups/bloc/daily_rollup_bloc.dart';
import 'package:tarkeez/features/profile/presentation/sections/widgets/personal_best_card.dart';

class PersonalBestPeriod {
  const PersonalBestPeriod({required this.seconds, required this.label});
  final int seconds;
  final String label;

  static const empty = PersonalBestPeriod(seconds: 0, label: '—');
}

class PersonalBestsSection extends StatelessWidget {
  final bool isLocked;
  const PersonalBestsSection({super.key, required this.isLocked});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text('Personal bests', style: TextUtils.title2(context)),
        const SizedBox(height: 8),
        if (isLocked)
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              return SectionImageLockOverlay(
                imgLocation: state.isDark
                    ? ImgPaths.personalBestLockBackdropsDark
                    : ImgPaths.personalBestLockBackdropsLight,
                height: 116,
                lockedTopicName: 'personal bests',
              );
            },
          ),
        if (!isLocked)
          BlocBuilder<DailyRollupBloc, DailyRollupState>(
            buildWhen: (previous, current) => current is DailyRollupLoaded,
            builder: (context, state) {
              final loaded = state is DailyRollupLoaded ? state : null;
              final bestDay = loaded?.bestDay ?? PersonalBestPeriod.empty;
              final bestWeek = loaded?.bestWeek ?? PersonalBestPeriod.empty;
              final bestMonth = loaded?.bestMonth ?? PersonalBestPeriod.empty;
              final bestYear = loaded?.bestYear ?? PersonalBestPeriod.empty;

              return GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                mainAxisExtent: 54,
                crossAxisSpacing: ContainerDesignUtils.halfPadding,
                mainAxisSpacing: ContainerDesignUtils.halfPadding,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  PersonalBestCard(
                    emoji: '☀️',
                    title: bestDay.label,
                    durationInSeconds: bestDay.seconds,
                  ),
                  PersonalBestCard(
                    emoji: '📅',
                    title: bestWeek.label,
                    durationInSeconds: bestWeek.seconds,
                    mainAxisAlignment: .end,
                    crossAxisAlignment: .end,
                  ),
                  PersonalBestCard(
                    emoji: '🗓️',
                    title: bestMonth.label,
                    durationInSeconds: bestMonth.seconds,
                  ),
                  PersonalBestCard(
                    emoji: '🌍',
                    title: bestYear.label,
                    durationInSeconds: bestYear.seconds,
                    mainAxisAlignment: .end,
                    crossAxisAlignment: .end,
                  ),
                ],
              );
            },
          ),
      ],
    );
  }
}
