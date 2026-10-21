part of 'project_bloc.dart';

sealed class ProjectState {
  const new();
}

final class ProjectInitial extends ProjectState {}

final class ProjectLoading extends ProjectState {
  const new({this.projects, this.isInitialLoad = true});
  final List<ProjectModel>? projects;
  final bool isInitialLoad;
}

final class ProjectFailure extends ProjectState {
  const new(this.errorMessage);
  final String errorMessage;
}

final class ProjectLoaded extends ProjectState {
  final List<ProjectModel> projects;
  final bool isCreated, isUpdated, isDeleted;

  const new(
    this.projects, {
    this.isCreated = false,
    this.isUpdated = false,
    this.isDeleted = false,
  }) : assert(
         (isCreated ? 1 : 0) + (isUpdated ? 1 : 0) + (isDeleted ? 1 : 0) <= 1,
         'Only one of isCreated / isUpdated / isDeleted may be true at a time.',
       );
  const ProjectLoaded.plain(List<ProjectModel> projects) : this(projects);
  const ProjectLoaded.created(List<ProjectModel> projects)
    : this(projects, isCreated: true);
  const ProjectLoaded.updated(List<ProjectModel> projects)
    : this(projects, isUpdated: true);
  const ProjectLoaded.deleted(List<ProjectModel> projects)
    : this(projects, isDeleted: true);
}
