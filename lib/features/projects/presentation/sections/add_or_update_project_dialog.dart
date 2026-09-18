import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/shared_files/buttons/cancel_button.dart';
import 'package:tarkeez/core/shared_files/buttons/primary_button.dart';
import 'package:tarkeez/core/shared_files/widgets/common_text_input.dart';
import 'package:tarkeez/core/shared_files/widgets/dialog_box_wrapper.dart';
import 'package:tarkeez/features/projects/bloc/project_bloc.dart';
import 'package:tarkeez/features/projects/cubit/project_form_cubit.dart';
import 'package:tarkeez/features/projects/data/models/project_model.dart';
import 'package:tarkeez/features/projects/presentation/sections/project_color_options_section.dart';

class AddOrUpdateProjectDialog extends StatelessWidget {
  final ProjectModel? project;

  const AddOrUpdateProjectDialog({super.key, this.project});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = ProjectFormCubit();
        if (project != null) {
          cubit.populate(project!);
        } else {
          cubit.initializeNewProject();
        }
        return cubit;
      },
      child: BlocListener<ProjectBloc, ProjectState>(
        listenWhen: (previous, current) =>
            current is ProjectLoaded &&
            (current.isCreated || current.isUpdated),
        listener: (context, state) => context.pop(),
        child: DialogBoxWrapper(
          title: project == null ? 'Add project' : 'Update project',
          iconPath: SvgPaths.penLine,
          content: BlocBuilder<ProjectFormCubit, ProjectFormState>(
            builder: (context, formState) {
              final formCubit = context.read<ProjectFormCubit>();
              return Column(
                crossAxisAlignment: .start,
                children: [
                  const SizedBox(height: 16),
                  CommonTextInput(
                    label: 'Project name',
                    hintText: project == null
                        ? 'Give your project a name'
                        : 'Update your project name',
                    labelBehavior: project == null ? .auto : .always,
                    prefixIconPath: SvgPaths.projects,
                    controller: formCubit.nameController,
                    errorText: formState.nameError,
                  ),
                  const SizedBox(height: 16),
                  ProjectColorOptionsSection(
                    selectedColorId: formState.selectedColorId,
                    onColorSelected: formCubit.selectColor,
                  ),
                  const SizedBox(height: 24),
                  BlocSelector<ProjectBloc, ProjectState, bool>(
                    selector: (s) => s is ProjectLoading,
                    builder: (context, isSubmitting) {
                      return Row(
                        children: [
                          CancelButton(
                            enable: !isSubmitting,
                            isCupertinoVersion: true,
                            onPressed: () => context.pop(),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: PrimaryButton(
                              title: 'Save',
                              enable: formState.canSubmit && !isSubmitting,
                              isLoading: isSubmitting,
                              onPressed: () =>
                                  formCubit.submitProjectForm(context),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
