part of 'project_color_bloc.dart';

sealed class ProjectColorState {
  const ProjectColorState();
  Color? colorFor(int? colorId) => null;
}

final class ProjectColorInitial extends ProjectColorState {}

final class ProjectColorLoading extends ProjectColorState {}

final class ProjectColorLoaded extends ProjectColorState {
  final List<ProjectColorModel> projectColors;
  const ProjectColorLoaded(this.projectColors);

  @override
  Color? colorFor(int? colorId) {
    if (colorId == null) return null;
    final match = projectColors.firstWhereOrNull((c) => c.id == colorId);
    return match != null ? colorFromHexCode(match.hexCode) : null;
  }
}

final class ProjectColorFailure extends ProjectColorState {
  final String errorMessage;
  const ProjectColorFailure(this.errorMessage);
}
