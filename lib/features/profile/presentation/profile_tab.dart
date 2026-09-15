import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/localization/app_texts.dart';
import 'package:tarkeez/core/shared_files/buttons/go_premium_button.dart';
import 'package:tarkeez/core/shared_files/widgets/action_page_icon.dart';
import 'package:tarkeez/core/shared_files/widgets/custom_app_bar.dart';
import 'package:tarkeez/core/shared_files/widgets/hero_image_background_layer.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/features/profile/presentation/sections/heatmap.dart';
import 'package:tarkeez/features/profile/presentation/sections/personal_bests_section.dart';
import 'package:tarkeez/features/profile/presentation/sections/streaks.dart';
import 'package:tarkeez/features/report/presentation/sections/invested_times_section.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final texts = AppTexts.of(context);
    final scheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        const Positioned.fill(child: HeroImageBackgroundLayer()),
        SafeArea(
          bottom: false,
          child: Column(
            children: [
              CustomAppBar(
                title: texts.profile,
                isBackButtonEnabled: false,
                actions: [ActionPageIcon(iconPath: SvgPaths.user)],
              ),
              Expanded(
                child: Skeletonizer(
                  enabled: false,
                  child: Container(
                    clipBehavior: .hardEdge,
                    decoration: BoxDecoration(
                      color: scheme.surface,
                      borderRadius: ContainerDesignUtils.topRadius,
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                const SizedBox(height: 16),
                                Container(
                                  padding: const .symmetric(
                                    horizontal: ContainerDesignUtils.padding,
                                  ),
                                  child: const Column(
                                    crossAxisAlignment: .start,
                                    children: [
                                      Streaks(),
                                      SizedBox(height: 16),
                                      Heatmap(isLocked: false),
                                      SizedBox(height: 16),
                                      PersonalBestsSection(isLocked: false),
                                      SizedBox(height: 16),
                                      InvestedTimesSection(
                                        isLocked: false,
                                        today: 14565,
                                        yesterday: 13230,
                                        thisWeek: 11260,
                                        lastWeek: 11224,
                                        thisMonth: 11201,
                                        lastMonth: 13152,
                                        thisYear: 423459,
                                        lastYear: 123456,
                                        lastSevenDays: 1234,
                                        lastThirtyDays: 12321,
                                        last365Days: 12321,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Positioned(bottom: 16, right: 16, child: GoPremiumButton()),
      ],
    );
  }
}
