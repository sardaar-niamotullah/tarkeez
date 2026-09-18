import 'package:tarkeez/core/shared_files/buttons/custom_dropdown_button.dart';
import 'package:tarkeez/core/utils/primary_page_margin.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/report/presentation/sections/projects_pie_chart_section.dart';
import 'package:tarkeez/features/report/presentation/sections/report_bar_chart.dart';
import 'package:tarkeez/features/report/presentation/sections/report_filter_tile.dart';
import 'package:tarkeez/core/shared_files/widgets/hero_image_background_layer.dart';
import 'package:tarkeez/core/shared_files/widgets/action_page_icon.dart';
import 'package:tarkeez/core/shared_files/widgets/custom_app_bar.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:flutter/material.dart';
import 'package:tarkeez/features/report/presentation/sections/report_line_chart.dart';
import 'package:tarkeez/features/report/presentation/sections/time_log_sessions_section.dart';

class ReportTab extends StatefulWidget {
  const ReportTab({super.key});

  @override
  State<ReportTab> createState() => _ReportTabState();
}

class _ReportTabState extends State<ReportTab> {
  String _selectedChartType = 'Bar chart';

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
                          PrimaryPageMargin(
                            child: Column(
                              crossAxisAlignment: .start,
                              children: [
                                const SizedBox(height: 16),
                                //––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
                                // Timeline section
                                //––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
                                Row(
                                  mainAxisAlignment: .spaceBetween,
                                  children: [
                                    Text(
                                      'Timeline',
                                      style: TextUtils.title2(context),
                                    ),
                                    CustomDropdownButton<String>(
                                      items: const ['Bar chart', 'Line chart'],
                                      initialValue: _selectedChartType,
                                      buttonWidth: 136,
                                      labelBuilder: (value) => value,
                                      onChanged: (value) {
                                        setState(
                                          () => _selectedChartType = value,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                _selectedChartType == 'Bar chart'
                                    ? const ReportBarChart()
                                    : const ReportLineChart(),
                                const SizedBox(height: 16),
                                //––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
                                // Pie chart part
                                //––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
                                const ProjectsPieChartSection(),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ],
                      ),
                      //––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
                      // Time session section
                      //––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
                      SliverPadding(
                        padding: .symmetric(
                          horizontal: ContainerDesignUtils.padding,
                        ),
                        sliver: const TimeLogSessionsSection(isLocked: true),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
