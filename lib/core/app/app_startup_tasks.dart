import 'package:tarkeez/core/app/dependency_injection.dart';
import 'package:tarkeez/features/daily_rollups/bloc/daily_rollup_bloc.dart';
import 'package:tarkeez/features/project_rollups/bloc/project_rollup_bloc.dart';
import 'package:tarkeez/features/projects/bloc/project_bloc.dart';

class AppStartupTasks {
  const new();

  Future<void> run() async {
    await _preloadProjects();
    await _preloadDailyRollups();
    await _preloadProjectRollups();
  }

  Future<void> _preloadProjects() async {
    final bloc = getIt<ProjectBloc>();
    if (bloc.state is ProjectLoaded) return;
    bloc.add(FetchProjectsRequested());
    await bloc.stream.firstWhere((s) => s is! ProjectLoading);
  }

  Future<void> _preloadDailyRollups() async {
    final bloc = getIt<DailyRollupBloc>();
    if (bloc.state is DailyRollupLoaded) return;
    bloc.add(FetchDailyRollupRequested());
    await bloc.stream.firstWhere((s) => s is! DailyRollupLoading);
  }

  Future<void> _preloadProjectRollups() async {
    final bloc = getIt<ProjectRollupBloc>();
    if (bloc.state is ProjectRollupLoaded) return;
    bloc.add(FetchProjectRollupRequested());
    await bloc.stream.firstWhere((s) => s is! ProjectRollupLoading);
  }
}
