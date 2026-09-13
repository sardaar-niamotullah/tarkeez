import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/shared_files/buttons/action_button.dart';
import 'package:tarkeez/core/shared_files/widgets/delete_dialog.dart';
import 'package:tarkeez/features/projects/bloc/project_bloc.dart';
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
        builder: (_) => 
        BlocConsumer<ProjectBloc, ProjectState>(
          listener: (context, state) {
            if (state is ProjectLoaded || state is ProjectFailure) {
              context.pop();
            }
          },
          builder: (context, state) {
            return DeleteDialog(
              isLoading: state is ProjectLoading,
              onDeleteTap: () {
                context.read<ProjectBloc>().add(
                  DeleteProjectsRequested(project),
                );
              },
              message:
                  'Deleting this project will move all its tracked time to \'No project\'.\n\n'
                  'This action cannot be undone.',
            );
          },
        ),
      ),
    );
  }
}
