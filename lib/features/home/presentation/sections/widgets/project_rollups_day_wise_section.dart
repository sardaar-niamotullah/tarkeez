import 'package:flutter/material.dart';
import 'package:tailwind_breakpoints/tailwind_breakpoints.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/duration_text_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/home/presentation/sections/widgets/project_duration_tile.dart';
import 'package:tarkeez/features/project_rollups/stats/day_wise_stats.dart';

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
  Color _segmentColor(ColorScheme scheme, int index) {
    final palette = [
      scheme.primary,
      scheme.secondary,
      scheme.tertiary,
      scheme.error,
    ];
    return palette[index % palette.length];
  }

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
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(_label(context), style: TextUtils.title2(context)),
              DurationTextUtils(
                durationInSeconds: total,
                fontSizePrimary: 18,
                fontSizeSeconday: 14,
              ),
            ],
          ),
          Row(
            children: [
              for (int i = 0; i < day.projects.length; i++)
                Expanded(
                  flex: day.projects[i].durationInSeconds,
                  child: Container(
                    margin: .only(right: i == day.projects.length - 1 ? 0 : 4),
                    height: 4,
                    decoration: BoxDecoration(
                      color: _segmentColor(scheme, i),
                      borderRadius: ContainerDesignUtils.allRadius,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
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

// class ProjectRollupsDayWiseSection extends StatelessWidget {
//   const new({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final scheme = Theme.of(context).colorScheme;
//     final segments = [
//       (flex: 50, color: scheme.primary),
//       (flex: 40, color: scheme.secondary),
//       (flex: 10, color: scheme.error),
//     ];
//     return Container(
//       margin: .only(bottom: ContainerDesignUtils.margin),
//       padding: .symmetric(
//         horizontal: ContainerDesignUtils.padding,
//         vertical: context.md ? ContainerDesignUtils.padding : 0,
//       ),
//       decoration: BoxDecoration(
//         color: scheme.onSurface,
//         borderRadius: ContainerDesignUtils.allRadius,
//       ),
//       child: Column(
//         children: [
//           //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//           // Date title and total duration
//           //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//           Row(
//             mainAxisAlignment: .spaceBetween,
//             children: [
//               Text('Today', style: TextUtils.title2(context)),
//               const DurationTextUtils(
//                 durationInSeconds: 65321,
//                 fontSizePrimary: 18,
//                 fontSizeSeconday: 14,
//               ),
//             ],
//           ),
//           //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//           // Seperation line with percentage seperaton
//           //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//           Row(
//             children: [
//               for (int i = 0; i < segments.length; i++)
//                 Expanded(
//                   flex: segments[i].flex,
//                   child: Container(
//                     margin: .only(right: i == segments.length - 1 ? 0 : 4),
//                     height: 4,
//                     decoration: BoxDecoration(
//                       color: segments[i].color,
//                       borderRadius: ContainerDesignUtils.allRadius,
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//           // Project's list
//           //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//           const ProjectDurationTile(isActive: true),
//           const ProjectDurationTile(isActive: false),
//           const ProjectDurationTile(isActive: false),
//           const ProjectDurationTile(isActive: false),
//         ],
//       ),
//     );
//   }
// }
