part of 'profile_form_cubit.dart';

class ProfileFormState extends Equatable {
  final ProfileModel? savedProfile;

  final String? nameError;
  final String? bioError;
  final String? professionError;
  final String? educationError;

  final File? pickedImageFile;
  final ProfileMediaType? pickedMediaType;
  final Set<String> touched;
  final bool canSubmit;
  final bool hasChanges;

  const ProfileFormState({
    this.savedProfile,
    this.nameError,
    this.bioError,
    this.professionError,
    this.educationError,
    this.pickedImageFile,
    this.pickedMediaType,
    this.touched = const {},
    this.canSubmit = false,
    this.hasChanges = false,
  });

  @override
  List<Object?> get props => [
    savedProfile,
    nameError,
    bioError,
    professionError,
    educationError,
    pickedImageFile,
    pickedMediaType,
    touched,
    canSubmit,
    hasChanges,
  ];

  ProfileFormState copyWith({
    ProfileModel? savedProfile,
    String? Function()? nameError,
    String? Function()? bioError,
    String? Function()? professionError,
    String? Function()? educationError,
    File? Function()? pickedImageFile,
    ProfileMediaType? Function()? pickedMediaType,
    Set<String>? touched,
    bool? canSubmit,
    bool? hasChanges,
  }) {
    return ProfileFormState(
      savedProfile: savedProfile ?? this.savedProfile,
      nameError: nameError != null ? nameError() : this.nameError,
      bioError: bioError != null ? bioError() : this.bioError,
      professionError: professionError != null
          ? professionError()
          : this.professionError,
      educationError: educationError != null
          ? educationError()
          : this.educationError,
      pickedImageFile: pickedImageFile != null
          ? pickedImageFile()
          : this.pickedImageFile,
      pickedMediaType: pickedMediaType != null
          ? pickedMediaType()
          : this.pickedMediaType,
      touched: touched ?? this.touched,
      canSubmit: canSubmit ?? this.canSubmit,
      hasChanges: hasChanges ?? this.hasChanges,
    );
  }
}
