import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/core/extensions/text_editing_controller_extensions.dart';
import 'package:tarkeez/core/localization/app_texts.dart';
import 'package:tarkeez/core/shared_files/buttons/cancel_button.dart';
import 'package:tarkeez/core/shared_files/buttons/primary_button.dart';
import 'package:tarkeez/core/shared_files/snackbar/snack_bar_public_api.dart';
import 'package:tarkeez/core/shared_files/widgets/common_text_input.dart';
import 'package:tarkeez/core/shared_files/widgets/dialog_box_wrapper.dart';
import 'package:tarkeez/features/profile/bloc/profile_bloc.dart';
import 'package:tarkeez/features/profile/cubit/profile_form_cubit.dart';

class UpdateProfileDetailsDialog extends StatelessWidget {
  const UpdateProfileDetailsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final texts = AppTexts.of(context);
    final formCubit = context.read<ProfileFormCubit>();

    return BlocListener<ProfileBloc, ProfileState>(
      listenWhen: (_, curr) => curr is ProfileLoaded || curr is ProfileFailure,
      listener: (context, state) {
        if (state is ProfileLoaded) {
          formCubit.populate(state.profile);
          if (state.isUpdated) {
            showSuccessSnackBar(
              context,
              message: 'Profile updated successfully.',
            );
            context.pop();
          }
        } else if (state is ProfileFailure) {
          showErrorSnackBar(context, message: state.message);
        }
      },
      child: DialogBoxWrapper(
        title: texts.updateProfileDetails,
        iconPath: SvgPaths.editPen,
        content: BlocBuilder<ProfileFormCubit, ProfileFormState>(
          builder: (context, formState) {
            return Column(
              children: [
                const SizedBox(height: 16),
                CommonTextInput(
                  label: texts.fullName,
                  hintText: texts.fullNameHint,
                  labelBehavior: formCubit.nameController.labelBehavior,
                  prefixIconPath: SvgPaths.user,
                  controller: formCubit.nameController,
                  errorText: formState.nameError,
                ),
                const SizedBox(height: 16),
                CommonTextInput(
                  label: texts.bio,
                  hintText: texts.bioHint,
                  labelBehavior: formCubit.bioController.labelBehavior,
                  prefixIconPath: SvgPaths.document,
                  controller: formCubit.bioController,
                  errorText: formState.bioError,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                CommonTextInput(
                  label: texts.profession,
                  hintText: texts.professionHint,
                  labelBehavior: formCubit.professionController.labelBehavior,
                  prefixIconPath: SvgPaths.briefcase,
                  controller: formCubit.professionController,
                  errorText: formState.professionError,
                ),
                const SizedBox(height: 16),
                CommonTextInput(
                  label: texts.education,
                  hintText: texts.educationHint,
                  labelBehavior: formCubit.educationController.labelBehavior,
                  prefixIconPath: SvgPaths.academicCap,
                  controller: formCubit.educationController,
                  errorText: formState.educationError,
                ),
                const SizedBox(height: 24),
                BlocSelector<ProfileBloc, ProfileState, bool>(
                  selector: (s) => s is ProfileLoading,
                  builder: (context, isSubmitting) {
                    return Row(
                      children: [
                        Expanded(
                          child: CancelButton(
                            enable: !isSubmitting,
                            onPressed: () => context.pop(),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: PrimaryButton(
                            title: 'Save',
                            enable: formState.canSubmit && !isSubmitting,
                            isLoading: isSubmitting,
                            onPressed: () =>
                                formCubit.submitProfileForm(context),
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
    );
  }
}