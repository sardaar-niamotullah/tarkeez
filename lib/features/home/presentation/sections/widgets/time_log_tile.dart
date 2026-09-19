import 'package:flutter/material.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/duration_text_utils.dart';
import 'package:tarkeez/features/home/presentation/sections/widgets/session_project_pill.dart';
import 'package:tarkeez/features/projects/data/models/project_model.dart';

class TimeLogTile extends StatelessWidget {
  final ProjectModel? project;
  final bool isActive;

  const TimeLogTile({super.key, this.project, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: .only(bottom: 8),
      padding: .only(left: 8, top: 2, bottom: 2, right: 8),
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
        mainAxisAlignment: .spaceBetween,
        children: [
          SessionProjectPill(project: project),
          DurationTextUtils(durationInSeconds: 6532),
        ],
      ),
    );
  }
}
