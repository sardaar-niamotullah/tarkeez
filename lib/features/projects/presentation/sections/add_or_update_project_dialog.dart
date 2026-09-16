import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/shared_files/buttons/cancel_button.dart';
import 'package:tarkeez/core/shared_files/buttons/primary_button.dart';
import 'package:tarkeez/core/shared_files/widgets/common_text_input.dart';
import 'package:tarkeez/core/shared_files/widgets/dialog_box_wrapper.dart';
import 'package:tarkeez/features/projects/data/models/project_model.dart';

class AddOrUpdateProjectDialog extends StatelessWidget {
  final ProjectModel? project;

  const AddOrUpdateProjectDialog({super.key, this.project});

  @override
  Widget build(BuildContext context) {
    return DialogBoxWrapper(
      title: project == null ? 'Add project' : 'Update project',
      iconPath: SvgPaths.penLine,
      content: Column(
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
            // controller: formCubit.nameController,
            // errorText: formState.nameError,
          ),
          const SizedBox(height: 16),
          // ProjectColorOptionsSection(
          //   // selectedColorId: formState.selectedColorId,
          //   // onColorSelected: formCubit.selectColor,
          // ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: CancelButton(
                  enable: true,
                  onPressed: () => context.pop(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: PrimaryButton(
                  title: 'Save',
                  enable: true,
                  isLoading: false,
                  onPressed: () {}, // formCubit.submitProjectForm(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
