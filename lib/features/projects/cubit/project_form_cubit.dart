import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/shared_files/validators/form_validators.dart';
import 'package:tarkeez/features/projects/bloc/project_bloc.dart';
import 'package:tarkeez/features/projects/data/models/project_model.dart';

part 'project_form_state.dart';

class ProjectFormCubit extends Cubit<ProjectFormState> {
  ProjectFormCubit() : super(const ProjectFormState()) {
    nameController.addListener(() => _onChanged('name'));
  }
  final nameController = TextEditingController();

  @override
  Future<void> close() {
    nameController.dispose();
    return super.close();
  }

  void reset() {
    final project = state.savedProject;
    if (project != null) populate(project);
  }

  void _onChanged(String field) => emit(
    _validateFormState(state.copyWith(touched: {...state.touched, field})),
  );

  // ─────────────────────────────────────────────────────────
  // Color selection
  // ─────────────────────────────────────────────────────────
  void selectColor(int colorId) =>
      emit(_validateFormState(state.copyWith(selectedColorId: colorId)));

  /// Call once when opening the dialog for a brand-new project, so a
  /// color is preselected before the user touches anything.
  void initializeNewProject() => emit(
    _validateFormState(
      ProjectFormState(selectedColorId: Random().nextInt(21) + 1),
    ),
  );

  // ─────────────────────────────────────────────────────────
  // Submit
  // ─────────────────────────────────────────────────────────
  bool submitProjectForm(BuildContext context) {
    final validated = _validateFormState(
      state.copyWith(touched: const {'name'}),
    );
    emit(validated);
    if (!validated.canSubmit) return false;

    final name = nameController.text.trim();
    final colorId = validated.selectedColorId!;
    final savedProject = validated.savedProject;

    if (savedProject == null) {
      context.read<ProjectBloc>().add(
        CreateProjectsRequested(name: name, colorId: colorId),
      );
    } else {
      context.read<ProjectBloc>().add(
        UpdateProjectsRequested(
          savedProject.copyWith(name: name, colorId: colorId),
        ),
      );
    }
    return true;
  }

  // ─────────────────────────────────────────────────────────
  // Populate form from an existing project
  // ─────────────────────────────────────────────────────────
  void populate(ProjectModel project) {
    nameController.text = project.name;
    emit(
      _validateFormState(
        ProjectFormState(
          savedProject: project,
          selectedColorId: project.colorId,
          touched: const {},
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // Validation
  // ─────────────────────────────────────────────────────────
  ProjectFormState _validateFormState(ProjectFormState s) {
    final name = nameController.text.trim();

    final next = s.copyWith(
      nameError: () =>
          s.touched.contains('name') ? FormValidators.validateName(name) : null,
    );

    final savedProject = next.savedProject;
    final hasChanges = savedProject == null
        ? name.isNotEmpty
        : name != savedProject.name ||
              next.selectedColorId != savedProject.colorId;

    final isValid =
        FormValidators.validateName(name) == null &&
        next.selectedColorId != null;

    return next.copyWith(
      hasChanges: hasChanges,
      canSubmit: hasChanges && isValid,
    );
  }
}
