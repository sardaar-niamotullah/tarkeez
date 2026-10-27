part of 'project_rollup_bloc.dart';

sealed class ProjectRollupEvent {}

class FetchProjectRollupRequested extends ProjectRollupEvent {}

class RefreshProjectRollupRequested extends ProjectRollupEvent {
  new({this.days = 3});
  final int days;
}

/// Sync changed the local sessions (a pull or a history reset): read the rollups again.
class ProjectRollupSynced extends ProjectRollupEvent {}