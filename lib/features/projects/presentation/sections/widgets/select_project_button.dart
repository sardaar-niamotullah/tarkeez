import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tarkeez/core/constants/project_colors.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/theme/theme.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:tarkeez/features/projects/data/models/project_model.dart';
import 'package:tarkeez/features/projects/presentation/sections/pick_project_bottom_sheet.dart';

class SelectProjectButton extends StatelessWidget {
  final ProjectModel? selectedProject;
  final ValueChanged<ProjectModel?> onProjectSelected;

  const SelectProjectButton({
    super.key,
    this.selectedProject,
    required this.onProjectSelected,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isProjectSeleted = selectedProject != null;
    final projectColors = ProjectColors.colors;

    final resolvedColor = selectedProject != null
        ? projectColors[selectedProject!.colorId]
        : scheme.surface;

    return Listener(
      behavior: .opaque,
      onPointerUp: (_) async {
        final result = await showModalBottomSheet<ProjectSelectionResult>(
          context: context,
          builder: (_) =>
              PickProjectBottomSheet(selectedProject: selectedProject),
        );
        // null means the sheet was dismissed without pressing 'Done'
        // keep whatever was previously selected.
        if (result != null) onProjectSelected(result.project);
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: ContainerDesignUtils.allRadius,
          child: Ink(
            width: isProjectSeleted ? 124 : 64,
            decoration: BoxDecoration(
              borderRadius: ContainerDesignUtils.allRadius,
              color: resolvedColor,
              border: isProjectSeleted
                  ? null
                  : .all(
                      color: scheme.primary.withValues(alpha: .75),
                      width: 2,
                    ),
            ),
            child: isProjectSeleted
                ? SizedBox(
                    height: 24,
                    child: Center(
                      child: Text(
                        maxLines: 1,
                        overflow: .ellipsis,
                        selectedProject!.name,
                        style: TextUtils.paragraphBold(
                          context,
                          color: AppTheme.white,
                        ),
                      ),
                    ),
                  )
                : SvgPicture.asset(
                    SvgPaths.add,
                    height: 28,
                    width: 28,
                    colorFilter: .mode(scheme.primary, .srcIn),
                  ),
          ),
        ),
      ),
    );
  }
}
