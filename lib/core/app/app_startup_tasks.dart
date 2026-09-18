import 'package:tarkeez/core/di/dependency_injection.dart';
import 'package:tarkeez/features/projects/bloc/project_bloc.dart';

class AppStartupTasks {
  const AppStartupTasks();

  Future<void> run() async {
    await Future.wait([_preloadProjects()]);
  }

  Future<void> _preloadProjects() async {
    final bloc = getIt<ProjectBloc>();
    if (bloc.state is ProjectLoaded) return;
    bloc.add(FetchProjectsRequested());
    await bloc.stream.firstWhere((s) => s is! ProjectLoading);
  }
}
