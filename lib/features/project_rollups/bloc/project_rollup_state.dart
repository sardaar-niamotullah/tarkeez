part of 'project_rollup_bloc.dart';

sealed class ProjectRollupState {}

class ProjectRollupInitial extends ProjectRollupState {}

class ProjectRollupLoading extends ProjectRollupState {
  ProjectRollupLoading({this.rollups, this.isInitialLoad = false});

  final List<ProjectRollupModel>? rollups;
  final bool isInitialLoad;
}

class ProjectRollupFailure extends ProjectRollupState {
  ProjectRollupFailure(this.message, {this.rollups});

  final String message;

  /// Last known data, so the UI keeps rendering and refresh can still recover.
  final List<ProjectRollupModel>? rollups;
}

class ProjectRollupLoaded extends ProjectRollupState {
  ProjectRollupLoaded({required this.rollups});

  final List<ProjectRollupModel> rollups;

  List<ProjectDurationModel> durationsForPeriod(
    PeriodRange period,
    List<ProjectModel> projects,
  ) => ProjectRollupStats.aggregateByProject(
    rollups: rollups,
    projects: projects,
    period: period,
  );
}
