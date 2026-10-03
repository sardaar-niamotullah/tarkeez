import 'package:tarkeez/core/shared_files/buttons/go_premium_button.dart';
import 'package:tarkeez/core/shared_files/widgets/floating_action_button_wrapper.dart';
import 'package:tarkeez/core/shared_files/widgets/hero_image_background_layer.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:flutter/material.dart';
import 'package:tarkeez/core/utils/maximum_width_box.dart';
import 'package:tarkeez/core/utils/primary_page_margin.dart';
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
        // ──────────────────────────────────────────────
        // Home App Bar bg layer
        // ──────────────────────────────────────────────
        const Positioned.fill(child: HeroImageBackgroundLayer()),
        Column(
          children: [
            // ──────────────────────────────────────────────
            // Home App Bar
            // ──────────────────────────────────────────────
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
                        color: scheme.onSurface,
                        borderRadius: ContainerDesignUtils.topRadius,
                      ),
                      child: MaximumWidthBox(
                        child: Column(
                          children: [
                            const SessionLogInterface(),
                            Expanded(
                              child: SingleChildScrollView(
                                child: PrimaryPageMargin(
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 24),
                                      const HomeBarChartSection(),
                                      const SizedBox(height: 24),
                                      const RecentProjectRollupsSection(),
                                    ],
                                  ),
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
          ],
        ),
        FloatingActionButtonWrapper(actionButton: GoPremiumButton()),
      ],
    );
  }
}
