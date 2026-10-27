part of 'project_rollup_bloc.dart';

sealed class ProjectRollupState {}

class ProjectRollupInitial extends ProjectRollupState {}

class ProjectRollupLoading extends ProjectRollupState {
  new({this.rollups, this.isInitialLoad = false});
  final List<ProjectRollupModel>? rollups;
  final bool isInitialLoad;
}

class ProjectRollupFailure extends ProjectRollupState {
  new(this.message, {this.rollups});
  final String message;
  final List<ProjectRollupModel>? rollups;
}

class ProjectRollupLoaded extends ProjectRollupState {
  new({required this.rollups});

  final List<ProjectRollupModel> rollups;

  List<ProjectDurationModel> durationsForPeriod(
    PeriodRange period,
    List<ProjectModel> projects,
  ) => PieChartStats.aggregateByProject(
    rollups: rollups,
    projects: projects,
    period: period,
  );
}
