import 'package:flutter/material.dart';
import 'package:tailwind_breakpoints/tailwind_breakpoints.dart';
import 'package:tarkeez/core/constants/project_colors.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/duration_text_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/home/presentation/sections/widgets/project_duration_tile.dart';
import 'package:tarkeez/features/project_rollups/stats/day_wise_stats.dart';
import 'package:tarkeez/features/projects/data/models/project_model.dart';

class ProjectRollupsDayWiseSection extends StatelessWidget {
  const new({super.key, required this.day, this.activeProjectId});

  final DayRollupModel day;

  /// Project of the currently running session (only meaningful for today).
  final String? activeProjectId;

  String _label(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    if (day.date == today) return 'Today';
    if (day.date == yesterday) return 'Yesterday';
    return MaterialLocalizations.of(context).formatMediumDate(day.date);
  }

  // TODO: replace with the same colorId -> Color mapping SessionProjectPill uses,
  // so the bar segments match each project's pill.
  Color _segmentColor(ColorScheme scheme, ProjectModel? project) =>
      project != null
      ? ProjectColors.colors[project.colorId]
      : scheme.onTertiary;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final total = day.totalSeconds;

    return Container(
      margin: .only(bottom: ContainerDesignUtils.margin),
      padding: .symmetric(
        horizontal: ContainerDesignUtils.padding,
        vertical: context.md ? ContainerDesignUtils.padding : 0,
      ),
      decoration: BoxDecoration(
        color: scheme.onSurface,
        borderRadius: ContainerDesignUtils.allRadius,
      ),
      child: Column(
        children: [
          Row(
            // mainAxisAlignment: .spaceBetween,
            children: [
              Text(_label(context), style: TextUtils.title2(context)),
              const Spacer(),
              DurationTextUtils(
                durationInSeconds: total,
                fontSizePrimary: 18,
                fontSizeSeconday: 14,
              ),
              const SizedBox(width: 4),
            ],
          ),
          // Row(
          //   children: [
          //     for (int i = 0; i < day.projects.length; i++)
          //       Expanded(
          //         flex: day.projects[i].durationInSeconds,
          //         child: Container(
          //           margin: .only(right: i == day.projects.length - 1 ? 0 : 4),
          //           height: 4,
          //           decoration: BoxDecoration(
          //             color: _segmentColor(scheme, day.projects[i].project),
          //             borderRadius: ContainerDesignUtils.allRadius,
          //           ),
          //         ),
          //       ),
          //   ],
          // ),
          const SizedBox(height: 8),
          for (final item in day.projects)
            ProjectDurationTile(
              project: item.project,
              durationInSeconds: item.durationInSeconds,
              fraction: total == 0 ? 0 : item.durationInSeconds / total,
              isActive:
                  activeProjectId != null &&
                  item.project?.id == activeProjectId,
            ),
        ],
      ),
    );
  }
}
