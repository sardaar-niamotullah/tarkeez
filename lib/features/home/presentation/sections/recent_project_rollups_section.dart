import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/features/home/presentation/sections/widgets/project_rollups_day_wise_section.dart';
import 'package:tarkeez/features/project_rollups/bloc/project_rollup_bloc.dart';
import 'package:tarkeez/features/project_rollups/data/models/project_rollup_model.dart';
import 'package:tarkeez/features/project_rollups/stats/day_wise_stats.dart';
import 'package:tarkeez/features/projects/bloc/project_bloc.dart';
import 'package:tarkeez/features/projects/data/models/project_model.dart';

class RecentProjectRollupsSection extends StatelessWidget {
  const new({super.key});

  static const _days = 5;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectBloc, ProjectState>(
      builder: (context, projectState) {
        final List<ProjectModel> projects = switch (projectState) {
          ProjectLoaded(:final projects) => projects,
          ProjectLoading(:final projects) => projects ?? const <ProjectModel>[],
          _ => const <ProjectModel>[],
        };
        return BlocBuilder<ProjectRollupBloc, ProjectRollupState>(
          builder: (context, state) {
            final List<ProjectRollupModel>? rollups = switch (state) {
              ProjectRollupLoaded(:final rollups) => rollups,
              ProjectRollupLoading(:final rollups) => rollups,
              ProjectRollupFailure(:final rollups) => rollups,
              _ => null,
            };

            if (rollups == null) {
              return state is ProjectRollupLoading
                  ? const Center(child: CircularProgressIndicator())
                  : const SizedBox.shrink();
            }

            final recentDays = DayWiseStats.recentDays(
              rollups: rollups,
              projects: projects,
              days: _days,
            );

            if (recentDays.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: Text('No sessions in the last 5 days')),
              );
            }

            return Column(
              children: [
                for (final day in recentDays)
                  ProjectRollupsDayWiseSection(
                    key: ValueKey(day.date),
                    day: day,
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
