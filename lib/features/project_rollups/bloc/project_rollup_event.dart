part of 'project_rollup_bloc.dart';

sealed class ProjectRollupEvent {}

class FetchProjectRollupRequested extends ProjectRollupEvent {}

class RefreshProjectRollupRequested extends ProjectRollupEvent {
  new({this.days = 3});
  final int days;
}

/// Sync changed the local sessions (a pull or a history reset): read the rollups again.
class ProjectRollupSynced extends ProjectRollupEvent {}

/// Fired while a session timer is running. Repeats within the same second are ignored.
class ProjectRollupLiveTicked extends ProjectRollupEvent {
  new(this.startedAt, this.projectId);
  final DateTime startedAt;
  final String? projectId;
}

/// The running session ended (saved or failed): re-read the rollups and drop the live part together.
class ProjectRollupLiveStopped extends ProjectRollupEvent {}