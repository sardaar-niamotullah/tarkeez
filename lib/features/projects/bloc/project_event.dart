part of 'project_bloc.dart';

sealed class ProjectEvent {
  const ProjectEvent();
}

final class CreateProjectsRequested extends ProjectEvent {
  final String name;
  final int colorId;
  const CreateProjectsRequested({required this.name, required this.colorId});
}

final class FetchProjectsRequested extends ProjectEvent {}

final class UpdateProjectsRequested extends ProjectEvent {
  final ProjectModel project;
  const UpdateProjectsRequested(this.project);
}

final class DeleteProjectsRequested extends ProjectEvent {
  final ProjectModel project;
  const DeleteProjectsRequested(this.project);
}
