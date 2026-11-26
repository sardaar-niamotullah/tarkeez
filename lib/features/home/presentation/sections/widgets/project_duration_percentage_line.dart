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

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final projectColors = ProjectColors.colors;

    final resolvedColor = project != null
        ? projectColors[project!.colorId]
        : scheme.onTertiary;

    final clamped = fraction.clamp(0.0, 1.0);

    return Row(
      children: [
        Expanded(
          child: Container(
            height: 8,
            alignment: .centerLeft,
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: ContainerDesignUtils.allRadius,
            ),
            child: FractionallySizedBox(
              widthFactor: clamped,
              child: Container(
                decoration: BoxDecoration(
                  color: resolvedColor,
                  borderRadius: ContainerDesignUtils.allRadius,
                ),
              ),
            ),
          ),
        ),
        Container(
          width: 26,
          margin: .only(left: context.xs ? 16 : 8),
          child: Text(
            '${(clamped * 100).round()}%',
            style: TextUtils.paragraphXs(
              context,
              color: scheme.onTertiary.withValues(alpha: .7),
            ),
          ),
        ),
      ],
    );
  }
}
