import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'project_rollup_event.dart';
part 'project_rollup_state.dart';

class ProjectRollupBloc extends Bloc<ProjectRollupEvent, ProjectRollupState> {
  ProjectRollupBloc() : super(ProjectRollupInitial()) {
    on<ProjectRollupEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
