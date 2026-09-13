import 'package:tarkeez/core/extensions/string_extension.dart';
import 'package:tarkeez/core/localization/app_texts.dart';
import 'package:tarkeez/core/shared_files/widgets/common_text_input.dart';
import 'package:tarkeez/core/constants/svg_paths.dart';
import 'package:tarkeez/features/profile/cubit/profile_form_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileUpdateFormSection extends StatelessWidget {
  const ProfileUpdateFormSection({super.key});

  @override
  Widget build(BuildContext context) {
    final texts = AppTexts.of(context);

    return BlocBuilder<ProfileFormCubit, ProfileFormState>(
      buildWhen: (prev, next) =>
          prev.savedProfile != next.savedProfile ||
          prev.nameError != next.nameError ||
          prev.bioError != next.bioError ||
          prev.professionError != next.professionError ||
          prev.educationError != next.educationError,
      builder: (context, state) {
        final cubit = context.read<ProfileFormCubit>();
        final saved = state.savedProfile;

        return Column(
          children: [
            // Full Name
            CommonTextInput(
              label: texts.fullName,
              hintText:
                  saved?.fullName.returnNullIfStringIsEmpty ??
                  texts.fullNameHint,
              labelBehavior: .always,
              prefixIconPath: SvgPaths.user,
              controller: cubit.nameController,
              errorText: state.nameError,
            ),

            const SizedBox(height: 16),

            // Bio
            CommonTextInput(
              label: texts.bio,
              hintText: saved?.bio.returnNullIfStringIsEmpty ?? texts.bioHint,
              labelBehavior: .always,
              prefixIconPath: SvgPaths.user,
              controller: cubit.bioController,
              errorText: state.bioError,
              maxLines: 3,
              keyboardType: TextInputType.multiline,
            ),

            const SizedBox(height: 16),

            // Profession
            CommonTextInput(
              label: texts.profession,
              hintText:
                  saved?.profession.returnNullIfStringIsEmpty ??
                  texts.professionHint,
              labelBehavior: .always,
              prefixIconPath: SvgPaths.briefcase,
              controller: cubit.professionController,
              errorText: state.professionError,
            ),

            const SizedBox(height: 16),

            // Education
            CommonTextInput(
              label: texts.education,
              hintText:
                  saved?.education.returnNullIfStringIsEmpty ??
                  texts.educationHint,
              labelBehavior: .always,
              prefixIconPath: SvgPaths.briefcase,
              controller: cubit.educationController,
              errorText: state.educationError,
            ),

            const SizedBox(height: 16),

            // Email
            CommonTextInput(
              label: texts.emailAddress,
              hintText:
                  saved?.email.returnNullIfStringIsEmpty ??
                  texts.emailAddressHint,
              readOnly: true,
              labelBehavior: .always,
              prefixIconPath: SvgPaths.letter,
              controller: cubit.emailController,
            ),
          ],
        );
      },
    );
  }
}
