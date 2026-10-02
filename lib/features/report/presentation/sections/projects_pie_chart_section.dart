import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tailwind_breakpoints/tailwind_breakpoints.dart';
import 'package:tarkeez/core/shared_files/cubits/report_period_cubit.dart';
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
import 'package:tarkeez/features/report/presentation/sections/widgets/core_project_pie_chart.dart';
import 'package:tarkeez/features/report/presentation/sections/widgets/pie_chart_project_details_section.dart';

class ProjectsPieChartSection extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final periodRange = context.watch<ReportPeriodCubit>().state;

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
              period: periodRange,
            );

            // No rollups in range → fall back to a single "No project"
            // entry at 0m so the pie chart and list always render.
            final projectDurations = aggregated.isEmpty
                ? const [
                    ProjectDurationModel(project: null, durationInSeconds: 0),
                  ]
                : aggregated;

            return Column(
              crossAxisAlignment: .start,
              children: [
                Text('Projects', style: TextUtils.title2(context)),
                const SizedBox(height: 8),
                Container(
                  padding: .only(
                    top: !context.sm ? 16 : 0,
                    left: 16,
                    right: 16,
                  ),
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
                          if (!context.sm)
                            Expanded(
                              child:
                                  BlocBuilder<
                                    DailyRollupBloc,
                                    DailyRollupState
                                  >(
                                    builder: (context, state) {
                                      final totalSeconds =
                                          state is DailyRollupLoaded
                                          ? state.totalSecondsForPeriod(
                                              periodRange,
                                            )
                                          : 0;
                                      return Padding(
                                        padding: const .only(left: 16),
                                        child: DurationTextUtils(
                                          durationInSeconds: totalSeconds,
                                          fontSizePrimary: 24,
                                          fontSizeSeconday: 14,
                                        ),
                                      );
                                    },
                                  ),
                            ),
                          //–––––––––––––––––––––––––––––––––––––––––––
                          // Pie chart — project rollups grouped by project
                          //–––––––––––––––––––––––––––––––––––––––––––
                          Expanded(
                            flex: 2,
                            child: SizedBox(
                              height: context.sm ? 360 : 200,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CoreProjectPieChart(
                                    projectDurations: projectDurations,
                                  ),
                                  if (context.sm)
                                    BlocBuilder<
                                      DailyRollupBloc,
                                      DailyRollupState
                                    >(
                                      builder: (context, state) {
                                        final totalSeconds =
                                            state is DailyRollupLoaded
                                            ? state.totalSecondsForPeriod(
                                                periodRange,
                                              )
                                            : 0;
                                        return DurationTextUtils(
                                          durationInSeconds: totalSeconds,
                                          fontSizePrimary: 24,
                                          fontSizeSeconday: 14,
                                        );
                                      },
                                    ),
                                ],
                              ),
                            ),
                          ),
                          if (context.sm) ...[
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 2,
                              child: PieChartProjectDetailsSection(
                                projectDurations: projectDurations,
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (!context.sm) ...[
                        const SizedBox(height: 16),
                        PieChartProjectDetailsSection(
                          projectDurations: projectDurations,
                        ),
                        const SizedBox(height: 16),
                      ],
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
