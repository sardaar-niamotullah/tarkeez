import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/constants/img_paths.dart';
import 'package:tarkeez/core/shared_files/cubits/theme_cubit.dart';
import 'package:tarkeez/core/shared_files/widgets/section_image_lock_overlay.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/profile/presentation/sections/widgets/personal_best_card.dart';

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
          Stack(
            children: [
              const SizedBox(width: .infinity, height: 116),
              Row(
                children: [
                  Expanded(
                    child: PersonalBestCard(
                      title: 'Day',
                      durationInSeconds: 91321,
                      emoji: '☀️',
                    ),
                  ),
                  const SizedBox(width: ContainerDesignUtils.halfPadding),
                  Expanded(
                    child: PersonalBestCard(
                      title: 'Week',
                      durationInSeconds: 91321,
                      emoji: '📅',
                      mainAxisAlignment: .end,
                      crossAxisAlignment: .end,
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 62,
                left: 0,
                right: 0,
                child: Row(
                  children: [
                    Expanded(
                      child: PersonalBestCard(
                        title: 'Month',
                        durationInSeconds: 12345,
                        emoji: '🗓️',
                      ),
                    ),
                    const SizedBox(width: ContainerDesignUtils.halfPadding),
                    Expanded(
                      child: PersonalBestCard(
                        title: 'Year',
                        durationInSeconds: 123456,
                        emoji: '🌍',
                        mainAxisAlignment: .end,
                        crossAxisAlignment: .end,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }
}
