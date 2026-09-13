import 'dart:io';
import 'package:tarkeez/core/shared_files/validators/form_validators.dart';
import 'package:tarkeez/features/profile/bloc/profile_bloc.dart';
import 'package:tarkeez/features/profile/data/models/profile_media_type.dart';
import 'package:tarkeez/features/profile/data/models/profile_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_form_state.dart';

class ProfileFormCubit extends Cubit<ProfileFormState> {
  ProfileFormCubit() : super(const ProfileFormState()) {
    nameController.addListener(() => _onChanged('name'));
    bioController.addListener(() => _onChanged('bio'));
    professionController.addListener(() => _onChanged('profession'));
    educationController.addListener(() => _onChanged('education'));
  }

  final nameController = TextEditingController();
  final bioController = TextEditingController();
  final professionController = TextEditingController();
  final educationController = TextEditingController();
  final emailController = TextEditingController();

  @override
  Future<void> close() {
    nameController.dispose();
    bioController.dispose();
    professionController.dispose();
    educationController.dispose();
    emailController.dispose();
    return super.close();
  }

  void reset() {
    final profile = state.savedProfile;

    if (profile != null) {
      populate(profile);
    }
  }

  void _onChanged(String field) {
    emit(
      _validateFormState(state.copyWith(touched: {...state.touched, field})),
    );
  }

  // ─────────────────────────────────────────────────────────
  // Submit
  // ─────────────────────────────────────────────────────────
  bool submitProfileForm(BuildContext context) {
    final validated = _validateFormState(
      state.copyWith(touched: const {'name', 'bio', 'profession', 'education'}),
    );
    emit(validated);
    if (!validated.canSubmit) return false;
    context.read<ProfileBloc>().add(
      UpdateProfileRequested(profile: currentProfile),
    );
    return true;
  }

  // ─────────────────────────────────────────────────────────
  // Image handling
  // ─────────────────────────────────────────────────────────
  void setPickedImage(File file, ProfileMediaType mediaType) {
    emit(
      _validateFormState(
        state.copyWith(
          pickedImageFile: () => file,
          pickedMediaType: () => mediaType,
        ),
      ),
    );
  }

  void discardPickedImage() {
    emit(
      _validateFormState(
        state.copyWith(
          pickedImageFile: () => null,
          pickedMediaType: () => null,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // Current profile from form
  // ─────────────────────────────────────────────────────────
  ProfileModel get currentProfile => ProfileModel(
    id: state.savedProfile?.id,
    fullName: nameController.text.trim(),
    email: emailController.text.trim(),
    bio: bioController.text.trim().isEmpty ? null : bioController.text.trim(),
    avatarUrl: state.savedProfile?.avatarUrl,
    coverUrl: state.savedProfile?.coverUrl,
    profession: professionController.text.trim().isEmpty
        ? null
        : professionController.text.trim(),
    education: educationController.text.trim().isEmpty
        ? null
        : educationController.text.trim(),
    countryCode: state.savedProfile?.countryCode,
  );

  // ─────────────────────────────────────────────────────────
  // Populate form from saved profile
  // ─────────────────────────────────────────────────────────
  void populate(ProfileModel profile) {
    nameController.text = profile.fullName;
    bioController.text = profile.bio ?? '';
    professionController.text = profile.profession ?? '';
    educationController.text = profile.education ?? '';
    emailController.text = profile.email;

    emit(
      _validateFormState(
        state.copyWith(
          touched: const {},
          savedProfile: profile,
          pickedImageFile: () => null,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // Validation
  // ─────────────────────────────────────────────────────────
  ProfileFormState _validateFormState(ProfileFormState s) {
    final name = nameController.text.trim();
    final bio = bioController.text.trim();
    final profession = professionController.text.trim();
    final education = educationController.text.trim();

    final currentBio = bio.isEmpty ? null : bio;
    final currentProfession = profession.isEmpty ? null : profession;
    final currentEducation = education.isEmpty ? null : education;

    final next = s.copyWith(
      nameError: () =>
          s.touched.contains('name') ? FormValidators.validateName(name) : null,
      bioError: () =>
          s.touched.contains('bio') ? FormValidators.validateBio(bio) : null,
      professionError: () => s.touched.contains('profession')
          ? FormValidators.validateProfession(profession)
          : null,
      educationError: () => s.touched.contains('education')
          ? FormValidators.validateEducation(education)
          : null,
    );

    final savedProfile = next.savedProfile;

    final hasChanges = savedProfile == null
        ? name.isNotEmpty ||
              bio.isNotEmpty ||
              profession.isNotEmpty ||
              education.isNotEmpty ||
              next.pickedImageFile != null
        : name != savedProfile.fullName ||
              currentBio != savedProfile.bio ||
              currentProfession != savedProfile.profession ||
              currentEducation != savedProfile.education ||
              next.pickedImageFile != null;

    final isValid =
        FormValidators.validateName(name) == null &&
        FormValidators.validateBio(bio) == null &&
        FormValidators.validateProfession(profession) == null &&
        FormValidators.validateEducation(education) == null;

    return next.copyWith(
      hasChanges: hasChanges,
      canSubmit: hasChanges && isValid,
    );
  }
}
