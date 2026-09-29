part of 'project_rollup_bloc.dart';

sealed class ProjectRollupState extends Equatable {
  const ProjectRollupState();
  
  @override
  List<Object> get props => [];
}

final class ProjectRollupInitial extends ProjectRollupState {}
