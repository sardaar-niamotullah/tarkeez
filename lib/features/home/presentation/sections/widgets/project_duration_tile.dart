import 'package:flutter/material.dart';
import 'package:tailwind_breakpoints/tailwind_breakpoints.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/duration_text_utils.dart';
import 'package:tarkeez/features/home/presentation/sections/widgets/project_duration_percentage_line.dart';
import 'package:tarkeez/features/home/presentation/sections/widgets/session_project_pill.dart';
import 'package:tarkeez/features/projects/data/models/project_model.dart';

class ProjectDurationTile extends StatelessWidget {
  const new({
    super.key,
    this.project,
    required this.durationInSeconds,
    required this.fraction,
    this.isActive = false,
  });

  final ProjectModel? project;
  final int durationInSeconds;
  final double fraction;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: .only(bottom: 8),
      padding: .only(left: 8, top: 2, bottom: 2, right: 4),
      decoration: BoxDecoration(
        color: isActive ? scheme.primary.withValues(alpha: .1) : null,
        borderRadius: ContainerDesignUtils.rightQuarterRadius,
        border: Border(
          left: BorderSide(
            color: isActive ? scheme.primary : Colors.transparent,
            width: 3,
          ),
        ),
      ),

      child: Row(
        children: [
          SessionProjectPill(
            project: project,
            width: context.sm ? 120 : 92,
            alignment: context.sm ? .center : .centerLeft,
          ),
          SizedBox(width: context.sm ? 64 : 24),
          Expanded(
            child: ProjectDurationPercentageLine(
              project: project,
              fraction: fraction,
            ),
          ),
          SizedBox(width: context.sm ? 48 : 16),
          SizedBox(
            width: 60,
            child: Align(
              alignment: .centerEnd,
              child: DurationTextUtils(durationInSeconds: durationInSeconds),
            ),
          ),
        ],
      ),
    );
  }
}
