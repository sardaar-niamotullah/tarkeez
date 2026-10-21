import 'package:flutter/material.dart';
import 'package:tailwind_breakpoints/tailwind_breakpoints.dart';
import 'package:tarkeez/core/constants/project_colors.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/projects/data/models/project_model.dart';

class ProjectDurationPercentageLine extends StatelessWidget {
  const new({super.key, this.project, required this.fraction});

  final ProjectModel? project;
  final double fraction;

  double _barWidth(BuildContext context) => context.lg
      ? 280
      : context.md
      ? 180
      : context.sm
      ? 160
      : context.xs
      ? 100
      : 70;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final projectColors = ProjectColors.colors;

    final resolvedColor = project != null
        ? projectColors[project!.colorId]
        : scheme.onTertiary;

    final clamped = fraction.clamp(0.0, 1.0);
    final barWidth = _barWidth(context);

    return Row(
      children: [
        Stack(
          children: [
            Container(
              height: 8,
              width: barWidth,
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: ContainerDesignUtils.allRadius,
              ),
            ),
            Container(
              height: 8,
              width: barWidth * clamped,
              decoration: BoxDecoration(
                color: resolvedColor,
                borderRadius: ContainerDesignUtils.allRadius,
              ),
            ),
          ],
        ),
        SizedBox(width: context.xs ? 16 : 8),
        Text(
          '${(clamped * 100).round()}%',
          style: TextUtils.paragraphXs(
            context,
            color: scheme.onTertiary.withValues(alpha: .7),
          ),
        ),
      ],
    );
  }
}
