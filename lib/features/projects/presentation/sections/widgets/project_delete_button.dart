import 'package:flutter/material.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/shared_files/buttons/action_button.dart';
import 'package:tarkeez/core/shared_files/widgets/delete_dialog.dart';
import 'package:tarkeez/features/projects/data/models/project_model.dart';

class ProjectDeleteButton extends StatelessWidget {
  final ProjectModel project;
  const ProjectDeleteButton({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ActionButton(
      iconColor: scheme.error,
      iconPath: SvgPaths.delete,
      backgroundColor: scheme.error.withValues(alpha: .1),
      onTap: () => showDialog(
        context: context,
        builder: (_) {
          return DeleteDialog(
            isLoading: false,
            onDeleteTap: () {},
            message:
                'Deleting this project will move all its tracked time to \'No project\'.\n\n'
                'This action cannot be undone.',
          );
        },
      ),
    );
  }
}
