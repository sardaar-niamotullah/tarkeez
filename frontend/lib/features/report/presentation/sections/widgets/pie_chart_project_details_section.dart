import 'package:flutter/material.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/features/project_rollups/data/models/project_duration_model.dart';
import 'package:tarkeez/features/projects/presentation/sections/widgets/project_info_tile.dart';

class PieChartProjectDetailsSection extends StatelessWidget {
  const new({super.key, required this.projectDurations});

  final List<ProjectDurationModel> projectDurations;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const .symmetric(horizontal: ContainerDesignUtils.padding),
      decoration: BoxDecoration(borderRadius: ContainerDesignUtils.allRadius),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: projectDurations.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, i) {
          final entry = projectDurations[i];
          final tileColor = i.isEven ? scheme.surface : scheme.onSurface;
          return ProjectInfoTile(
            project: entry.project,
            tileColor: tileColor,
            durationInSeconds: entry.durationInSeconds,
          );
        },
      ),
    );
  }
}
