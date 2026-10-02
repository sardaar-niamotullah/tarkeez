import 'package:tailwind_breakpoints/tailwind_breakpoints.dart';
import 'package:tarkeez/core/shared_files/buttons/go_premium_button.dart';
import 'package:tarkeez/core/utils/maximum_width_box.dart';
import 'package:tarkeez/core/utils/primary_page_margin.dart';
import 'package:tarkeez/features/report/presentation/sections/projects_pie_chart_section.dart';
import 'package:tarkeez/features/report/presentation/sections/report_filter_tile.dart';
import 'package:tarkeez/core/shared_files/widgets/hero_image_background_layer.dart';
import 'package:tarkeez/core/shared_files/widgets/action_page_icon.dart';
import 'package:tarkeez/core/shared_files/widgets/custom_app_bar.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:flutter/material.dart';
import 'package:tarkeez/features/report/presentation/sections/timeline_section.dart';

class ReportTab extends StatelessWidget {
  const ReportTab({super.key});

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
              // ──────────────────────────────────────────────────────────
              // App bar
              // ──────────────────────────────────────────────────────────
              CustomAppBar(
                title: 'Reports',
                isBackButtonEnabled: false,
                actions: [ActionPageIcon(iconPath: SvgPaths.pieChart)],
              ),
              Expanded(
                child: Container(
                  clipBehavior: .hardEdge,
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    borderRadius: ContainerDesignUtils.topRadius,
                  ),
                  child: CustomScrollView(
                    slivers: [
                      //––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
                      // Filter
                      //––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
                      const ReportFilterTile(),

                      SliverList.list(
                        children: [
                          MaximumWidthBox(
                            child: PrimaryPageMargin(
                              child: Column(
                                crossAxisAlignment: .start,
                                children: [
                                  const SizedBox(height: 12),
                                  //––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
                                  // Timeline section
                                  //––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
                                  TimelineSection(),
                                  const SizedBox(height: 16),
                                  //––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
                                  // Pie chart part
                                  //––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
                                  ProjectsPieChartSection(),
                                  const SizedBox(height: 64),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: .bottomCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: Breakpoints.xl),
              child: const Align(
                alignment: .bottomRight,
                child: Padding(
                  padding: .only(right: 16, bottom: 16),
                  child: GoPremiumButton(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
