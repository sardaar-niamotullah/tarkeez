import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/shared_files/buttons/action_button.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/duration_text_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/projects/data/bloc/project_color_bloc.dart';
import 'package:tarkeez/features/projects/data/models/project_model.dart';
import 'package:tarkeez/features/projects/presentation/sections/add_or_update_project_dialog.dart';
import 'package:tarkeez/features/projects/presentation/sections/widgets/project_delete_button.dart';

class ProjectInfoTile extends StatelessWidget {
  final ProjectModel? project;
  final int? durationInSeconds;
  final Color tileColor;
  final bool isLocked;

  const ProjectInfoTile({
    super.key,
    this.project,
    this.durationInSeconds,
    required this.tileColor,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final resolvedColor =
        context.watch<ProjectColorBloc>().state.colorFor(project?.colorId) ??
        scheme.onTertiary;

    return Container(
      padding: .symmetric(
        horizontal: ContainerDesignUtils.padding,
        vertical: ContainerDesignUtils.halfPadding,
      ),
      decoration: BoxDecoration(
        color: tileColor,
        borderRadius: ContainerDesignUtils.allRadius,
      ),
      child: Row(
        children: [
          Container(
            padding: .all(2),
            decoration: BoxDecoration(
              shape: .circle,
              color: resolvedColor.withValues(alpha: .5),
            ),
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(shape: .circle, color: resolvedColor),
              child: !isLocked
                  ? null
                  : Center(
                      child: SvgPicture.asset(
                        SvgPaths.lock,
                        height: 16,
                        colorFilter: .mode(scheme.onTertiary, .srcIn),
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              project?.name ?? 'No project',
              style: TextUtils.paragraphBold(context),
              maxLines: 1,
              overflow: .ellipsis,
            ),
          ),
          if (durationInSeconds == null && project != null) ...[
            const SizedBox(width: 16),
            Row(
              children: [
                ActionButton(
                  iconPath: SvgPaths.editPen,
                  iconColor: scheme.primary,
                  backgroundColor: scheme.primary.withValues(alpha: .1),
                  onTap: () => showDialog(
                    context: context,
                    builder: (_) => AddOrUpdateProjectDialog(project: project),
                  ),
                ),
                const SizedBox(width: 6),
                ProjectDeleteButton(project: project!),
              ],
            ),
          ],
          if (durationInSeconds != null) ...[
            const SizedBox(width: 16),
            DurationTextUtils(durationInSeconds: durationInSeconds!),
          ],
        ],
      ),
    );
  }
}
