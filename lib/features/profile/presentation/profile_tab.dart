import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tailwind_breakpoints/tailwind_breakpoints.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/shared_files/buttons/go_premium_button.dart';
import 'package:tarkeez/core/shared_files/widgets/action_page_icon.dart';
import 'package:tarkeez/core/shared_files/widgets/custom_app_bar.dart';
import 'package:tarkeez/core/shared_files/widgets/floating_action_button_wrapper.dart';
import 'package:tarkeez/core/shared_files/widgets/hero_image_background_layer.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/maximum_width_box.dart';
import 'package:tarkeez/features/profile/presentation/sections/heatmap.dart';
import 'package:tarkeez/features/profile/presentation/sections/personal_bests_section.dart';
import 'package:tarkeez/features/profile/presentation/sections/streaks.dart';
import 'package:tarkeez/features/profile/presentation/sections/widgets/erase_all_data_button.dart';
import 'package:tarkeez/features/report/presentation/sections/invested_times_section.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        const Positioned.fill(child: HeroImageBackgroundLayer()),
        SafeArea(
          bottom: false,
          child: Column(
            children: [
              CustomAppBar(
                title: 'Profile',
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
                                MaximumWidthBox(
                                  child: Container(
                                    width: .infinity,
                                    padding: const .symmetric(
                                      horizontal: ContainerDesignUtils.padding,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: .start,
                                      children: [
                                        if (context.sm)
                                          Row(
                                            crossAxisAlignment: .start,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Streaks(),
                                              ),
                                              SizedBox(
                                                width: ContainerDesignUtils
                                                    .padding,
                                              ),
                                              Expanded(
                                                flex: 5,
                                                child: Heatmap(isLocked: false),
                                              ),
                                            ],
                                          ),
                                        if (!context.sm)
                                          Column(
                                            children: [
                                              Streaks(),
                                              SizedBox(
                                                height: ContainerDesignUtils
                                                    .padding,
                                              ),
                                              Heatmap(isLocked: false),
                                            ],
                                          ),
                                        SizedBox(height: 16),
                                        PersonalBestsSection(isLocked: false),
                                        SizedBox(height: 16),
                                        InvestedTimesSection(isLocked: false),
                                        SizedBox(height: 16),
                                        EraseAllDataButton(isLocked: false),
                                        SizedBox(height: 64),
                                      ],
                                    ),
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
        FloatingActionButtonWrapper(actionButton: GoPremiumButton()),
      ],
    );
  }
}
