import 'package:flutter_bloc/flutter_bloc.dart';

/// The project of the running session: `null` when nothing runs,
/// `(id: null)` when it runs without a project.
typedef RunningProject = ({String? id});

class RunningProjectCubit extends Cubit<RunningProject?> {
  new() : super(null);

  void start(String? projectId) => emit((id: projectId));
  void stop() => emit(null);
}