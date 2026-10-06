import 'package:tarkeez/core/shared_files/buttons/go_premium_button.dart';
import 'package:tarkeez/core/shared_files/widgets/floating_action_button_wrapper.dart';
import 'package:tarkeez/core/shared_files/widgets/hero_image_background_layer.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:flutter/material.dart';
import 'package:tarkeez/core/utils/sliver_scroll_max_width_box.dart';
import 'package:tarkeez/features/home/presentation/sections/home_app_bar.dart';
import 'package:tarkeez/features/home/presentation/sections/home_bar_chart_section.dart';
import 'package:tarkeez/features/home/presentation/sections/recent_project_rollups_section.dart';
import 'package:tarkeez/features/sessions/presentation/session_log_interface.dart';

class HomeTab extends StatelessWidget {
  const new({super.key, required this.onMenuTap});
  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Stack(
      children: [
        const Positioned.fill(child: HeroImageBackgroundLayer()),
        Column(
          children: [
            HomeAppBar(onAppMenuTap: onMenuTap),
            // ──────────────────────────────────────────────
            // Homepage content
            // ──────────────────────────────────────────────
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: scheme.surface,
                        borderRadius: ContainerDesignUtils.topRadius,
                      ),
                      child: SliverScrollMaxWidthBox(
                        slivers: [
                          SliverList.list(
                            children: [
                              SizedBox(height: ContainerDesignUtils.padding),
                              GridView.count(
                                shrinkWrap: true,
                                crossAxisCount: 2,
                                mainAxisExtent: 248,
                                crossAxisSpacing: ContainerDesignUtils.padding,
                                physics: NeverScrollableScrollPhysics(),
                                children: [
                                  const SessionLogInterface(),
                                  const HomeBarChartSection(),
                                ],
                              ),
                              const SizedBox(height: 24),
                              // HomeBarChartSection(),
                              const RecentProjectRollupsSection(),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        FloatingActionButtonWrapper(actionButton: GoPremiumButton()),
      ],
    );
  }
}
