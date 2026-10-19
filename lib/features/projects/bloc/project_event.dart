part of 'project_bloc.dart';

sealed class ProjectEvent {
  const new();
}

final class CreateProjectsRequested extends ProjectEvent {
  const new({required this.name, required this.colorId});
  final String name;
  final int colorId;
}

final class FetchProjectsRequested extends ProjectEvent {}

final class UpdateProjectsRequested extends ProjectEvent {
  const new(this.project);
  final ProjectModel project;
}

final class DeleteProjectsRequested extends ProjectEvent {
  const new(this.project);
  final ProjectModel project;
}
