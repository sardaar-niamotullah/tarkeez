import 'package:flutter/material.dart';
import 'package:tarkeez/core/theme/theme.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/projects/data/models/project_model.dart';

class TimeLogProjectPill extends StatelessWidget {
  final ProjectModel? project;
  final double width;
  const TimeLogProjectPill({super.key, this.project, this.width = 116});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final resolvedColor = scheme.onTertiary;
    return Container(
      width: width,
      padding: .symmetric(
        horizontal: ContainerDesignUtils.halfPadding,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: resolvedColor,
        borderRadius: ContainerDesignUtils.allQuarterRadius,
      ),
      child: Center(
        child: Text(
          project?.name ?? 'No project',
          style: TextUtils.paragraphBold(
            context,
            color: project != null ? AppTheme.white : scheme.tertiary,
          ),
          maxLines: 1,
          overflow: .ellipsis,
        ),
      ),
    );
  }
}
