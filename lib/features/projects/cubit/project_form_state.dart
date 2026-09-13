part of 'project_form_cubit.dart';

class ProjectFormState extends Equatable {
  final ProjectModel? savedProject;
  final int? selectedColorId;
  final String? nameError;
  final Set<String> touched;
  final bool canSubmit;
  final bool hasChanges;

  const ProjectFormState({
    this.savedProject,
    this.selectedColorId,
    this.nameError,
    this.touched = const {},
    this.canSubmit = false,
    this.hasChanges = false,
  });

  @override
  List<Object?> get props => [
    savedProject,
    selectedColorId,
    nameError,
    touched,
    canSubmit,
    hasChanges,
  ];

  ProjectFormState copyWith({
    ProjectModel? savedProject,
    int? selectedColorId,
    String? Function()? nameError,
    Set<String>? touched,
    bool? canSubmit,
    bool? hasChanges,
  }) {
    return ProjectFormState(
      savedProject: savedProject ?? this.savedProject,
      selectedColorId: selectedColorId ?? this.selectedColorId,
      nameError: nameError != null ? nameError() : this.nameError,
      touched: touched ?? this.touched,
      canSubmit: canSubmit ?? this.canSubmit,
      hasChanges: hasChanges ?? this.hasChanges,
    );
  }
}
