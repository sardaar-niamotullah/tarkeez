import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tailwind_breakpoints/tailwind_breakpoints.dart';
import 'package:tarkeez/core/shared_files/cubits/session_timer_cubit.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/home/presentation/sections/widgets/project_rollups_day_wise_section.dart';
import 'package:tarkeez/features/project_rollups/bloc/project_rollup_bloc.dart';
import 'package:tarkeez/features/project_rollups/data/models/project_rollup_model.dart';
import 'package:tarkeez/features/project_rollups/stats/day_wise_projects_rollup_stats.dart';
import 'package:tarkeez/features/projects/bloc/project_bloc.dart';
import 'package:tarkeez/features/projects/data/models/project_model.dart';

class RecentProjectRollupsSection extends StatelessWidget {
  const new({super.key});

  static const _days = 5;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isRunning = context.select(
      (SessionTimerCubit c) => c.state.isRunning,
    );
    final runningProjectId = context.select(
      (SessionTimerCubit c) => c.state.project?.id,
    );

    return BlocBuilder<ProjectBloc, ProjectState>(
      builder: (context, projectState) {
        final List<ProjectModel> projects = switch (projectState) {
          ProjectLoaded(:final projects) => projects,
          ProjectLoading(:final projects) => projects ?? const <ProjectModel>[],
          _ => const <ProjectModel>[],
        };
        return BlocBuilder<ProjectRollupBloc, ProjectRollupState>(
          builder: (context, state) {
            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);
            final List<ProjectRollupModel>? rollups = switch (state) {
              ProjectRollupLoaded(:final rollups) => rollups,
              ProjectRollupLoading(:final rollups) => rollups,
              ProjectRollupFailure(:final rollups) => rollups,
              _ => null,
            };

            if (state is ProjectRollupLoading) {
              return Padding(
                padding: .symmetric(horizontal: context.md ? 0 : 16),
                child: LinearProgressIndicator(
                  minHeight: 3,
                  backgroundColor: scheme.surface,
                  borderRadius: ContainerDesignUtils.allRadius,
                ),
              );
            }

            if (rollups == null) {
              return Padding(
                padding: .symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    'No sessions in the last 5 days',
                    style: TextUtils.paragraph(context),
                  ),
                ),
              );
            }

            final recentDays = DayWiseProjectsRollupStats.recentDays(
              rollups: rollups,
              projects: projects,
              days: _days,
            );

            if (recentDays.isEmpty) {
              return Padding(
                padding: .symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    'No sessions in the last 5 days',
                    style: TextUtils.paragraph(context),
                  ),
                ),
              );
            }

            return Column(
              children: [
                for (final day in recentDays)
                  ProjectRollupsDayWiseSection(
                    day: day,
                    key: ValueKey(day.date),
                    activeProjectId: runningProjectId,
                    isRunning: isRunning && day.date == today,
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
