part of 'project_color_bloc.dart';

sealed class ProjectColorEvent {
  const ProjectColorEvent();
}

final class FetchProjectColorsEvent extends ProjectColorEvent {}