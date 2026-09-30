import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/constants/project_colors.dart';
import 'package:tarkeez/core/shared_files/cubits/report_period_cubit.dart';
import 'package:tarkeez/core/shared_files/enums/period_range.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/duration_text_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/daily_rollups/bloc/daily_rollup_bloc.dart';
import 'package:tarkeez/features/project_rollups/bloc/project_rollup_bloc.dart';
import 'package:tarkeez/features/project_rollups/data/models/project_duration_model.dart';
import 'package:tarkeez/features/project_rollups/data/models/project_rollup_model.dart';
import 'package:tarkeez/features/project_rollups/stats/pie_chart_stats.dart';
import 'package:tarkeez/features/projects/bloc/project_bloc.dart';
import 'package:tarkeez/features/projects/data/models/project_model.dart';
import 'package:tarkeez/features/projects/presentation/sections/widgets/project_info_tile.dart';

class ProjectsPieChartSection extends StatefulWidget {
  const new({super.key});

  @override
  State<ProjectsPieChartSection> createState() =>
      ProjectsPieChartSectionState();
}

class ProjectsPieChartSectionState extends State<ProjectsPieChartSection> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final projectColors = ProjectColors.colors;

    return BlocBuilder<ReportPeriodCubit, PeriodRange>(
      builder: (context, selectedPeriod) {
        return BlocBuilder<ProjectRollupBloc, ProjectRollupState>(
          builder: (context, rollupState) {
            final List<ProjectRollupModel> rollups = switch (rollupState) {
              ProjectRollupLoaded(:final rollups) => rollups,
              ProjectRollupLoading(:final rollups) =>
                rollups ?? const <ProjectRollupModel>[],
              ProjectRollupFailure(:final rollups) =>
                rollups ?? const <ProjectRollupModel>[],
              _ => const <ProjectRollupModel>[],
            };
            return BlocBuilder<ProjectBloc, ProjectState>(
              builder: (context, projectState) {
                final List<ProjectModel> projects = switch (projectState) {
                  ProjectLoaded(:final projects) => projects,
                  ProjectLoading(:final projects) =>
                    projects ?? const <ProjectModel>[],
                  _ => const <ProjectModel>[],
                };

                final aggregated = PieChartStats.aggregateByProject(
                  rollups: rollups,
                  projects: projects,
                  period: selectedPeriod,
                );

                // No rollups in range → fall back to a single "No project"
                // entry at 0m so the pie chart and list always render.
                final projectDurations = aggregated.isEmpty
                    ? const [
                        ProjectDurationModel(
                          project: null,
                          durationInSeconds: 0,
                        ),
                      ]
                    : aggregated;

                final totalSeconds = projectDurations.fold<int>(
                  0,
                  (sum, entry) => sum + entry.durationInSeconds,
                );

                return Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text('Projects', style: TextUtils.title2(context)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const .only(top: 36, left: 16, right: 16),
                      decoration: BoxDecoration(
                        color: scheme.onSurface,
                        borderRadius: ContainerDesignUtils.allRadius,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              //–––––––––––––––––––––––––––––––––––––––––––
                              // Total duration — daily rollups, project-agnostic
                              //–––––––––––––––––––––––––––––––––––––––––––
                              Expanded(
                                child:
                                    BlocBuilder<
                                      DailyRollupBloc,
                                      DailyRollupState
                                    >(
                                      builder: (context, state) {
                                        final rollupTotalSeconds =
                                            state is DailyRollupLoaded
                                            ? state.totalSecondsForPeriod(
                                                selectedPeriod,
                                              )
                                            : 0;
                                        return DurationTextUtils(
                                          durationInSeconds: rollupTotalSeconds,
                                          fontSizePrimary: 24,
                                          fontSizeSeconday: 14,
                                        );
                                      },
                                    ),
                              ),
                              const SizedBox(width: 16),
                              //–––––––––––––––––––––––––––––––––––––––––––
                              // Pie chart — project rollups grouped by project
                              //–––––––––––––––––––––––––––––––––––––––––––
                              Expanded(
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: PieChart(
                                    PieChartData(
                                      sectionsSpace: 2,
                                      centerSpaceRadius: 48,
                                      borderData: FlBorderData(show: true),
                                      sections: _showingSections(
                                        projectDurations,
                                        totalSeconds,
                                        projectColors,
                                        scheme,
                                        context,
                                      ),
                                      pieTouchData: PieTouchData(
                                        touchCallback:
                                            (
                                              FlTouchEvent event,
                                              PieTouchResponse?
                                              pieTouchResponse,
                                            ) {
                                              setState(() {
                                                if (!event
                                                        .isInterestedForInteractions ||
                                                    pieTouchResponse == null ||
                                                    pieTouchResponse
                                                            .touchedSection ==
                                                        null) {
                                                  touchedIndex = -1;
                                                  return;
                                                }
                                                touchedIndex = pieTouchResponse
                                                    .touchedSection!
                                                    .touchedSectionIndex;
                                              });
                                            },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 24),
                            ],
                          ),
                          const SizedBox(height: 36),

                          //–––––––––––––––––––––––––––––––––––––––––––
                          // Project details
                          //–––––––––––––––––––––––––––––––––––––––––––
                          Container(
                            padding: const .symmetric(
                              horizontal: ContainerDesignUtils.padding,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: ContainerDesignUtils.allRadius,
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: projectDurations.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, i) {
                                final entry = projectDurations[i];
                                final tileColor = i.isEven
                                    ? scheme.surface
                                    : scheme.onSurface;
                                return ProjectInfoTile(
                                  project: entry.project,
                                  tileColor: tileColor,
                                  durationInSeconds: entry.durationInSeconds,
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  List<PieChartSectionData> _showingSections(
    List<ProjectDurationModel> projectDurations,
    int totalSeconds,
    List<Color> projectColors,
    ColorScheme scheme,
    BuildContext context,
  ) {
    return List.generate(projectDurations.length, (i) {
      final entry = projectDurations[i];
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 12 : 10;
      final radius = isTouched ? 60.0 : 50.0;

      final resolvedColor = entry.project != null
          ? projectColors[entry.project!.colorId]
          : scheme.onTertiary;

      final percentage = totalSeconds == 0
          ? 100.0
          : ((entry.durationInSeconds / totalSeconds) * 100 * 10).ceil() / 10;

      return PieChartSectionData(
        color: resolvedColor,
        value: totalSeconds == 0 ? 1 : entry.durationInSeconds.toDouble(),
        title: '${percentage.toStringAsFixed(1)}%',
        radius: radius,
        cornerRadius: 12,
        titleStyle: TextUtils.paragraphBold(
          context,
          color: scheme.tertiary,
        ).copyWith(fontSize: fontSize.toDouble()),
      );
    });
  }
}
