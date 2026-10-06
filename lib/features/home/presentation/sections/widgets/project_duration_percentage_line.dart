import 'package:flutter/material.dart';
import 'package:tarkeez/core/constants/project_colors.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/projects/data/models/project_model.dart';

class ProjectDurationPercentageLine extends StatelessWidget {
  const new({super.key, this.project});

  final ProjectModel? project;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final projectColors = ProjectColors.colors;

    final resolvedColor = project != null
        ? projectColors[project!.colorId]
        : scheme.onTertiary;

    return Row(
      children: [
        Stack(
          children: [
            Container(
              height: 8,
              width: 100,
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: ContainerDesignUtils.allRadius,
              ),
            ),
            Container(
              height: 8,
              width: 50,
              decoration: BoxDecoration(
                color: resolvedColor,
                borderRadius: ContainerDesignUtils.allRadius,
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Text(
          '50%',
          style: TextUtils.paragraphXs(
            context,
            color: scheme.onTertiary.withValues(alpha: .7),
          ),
        ),
      ],
    );
  }
}
