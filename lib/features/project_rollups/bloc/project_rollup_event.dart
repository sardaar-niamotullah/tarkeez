part of 'project_rollup_bloc.dart';

sealed class ProjectRollupEvent {}

class FetchProjectRollupRequested extends ProjectRollupEvent {}

class RefreshProjectRollupRequested extends ProjectRollupEvent {
  RefreshProjectRollupRequested({this.days = 3});
  final int days;
}
