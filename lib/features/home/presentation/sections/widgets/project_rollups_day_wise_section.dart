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
      child: Row(
        crossAxisAlignment: .start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  _label(context),
                  style: TextUtils.title2(context)
                      .copyWith(fontSize: context.xs ? 18 : 14),
                ),
                DurationTextUtils(
                  durationInSeconds: total,
                  fontSizePrimary: context.xs ? 24 : 20,
                  fontSizeSeconday: context.xs ? 18 : 16,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              mainAxisSize: .min,
              children: [
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
          ),
        ],
      ),
    );
  }
}
