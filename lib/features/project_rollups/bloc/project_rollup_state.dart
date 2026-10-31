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
  new({required this.persisted, this.live = const []});

  /// Rows read from SQLite.
  final List<ProjectRollupModel> persisted;

  /// Slices of the running session, not saved yet. Empty when nothing runs.
  final List<ProjectRollupModel> live;

  /// What the UI reads: saved rows plus the running session. Every consumer
  /// sums rows per date and project, so the extra rows need no merging.
  late final List<ProjectRollupModel> rollups =
      live.isEmpty ? persisted : [...persisted, ...live];

  List<ProjectDurationModel> durationsForPeriod(
    PeriodRange period,
    List<ProjectModel> projects,
  ) => PieChartStats.aggregateByProject(
    rollups: rollups,
    projects: projects,
    period: period,
  );

  ProjectRollupLoaded copyWith({
    List<ProjectRollupModel>? persisted,
    List<ProjectRollupModel>? live,
  }) => ProjectRollupLoaded(
    persisted: persisted ?? this.persisted,
    live: live ?? this.live,
  );
}
