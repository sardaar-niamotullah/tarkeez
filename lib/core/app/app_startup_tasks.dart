import 'package:flutter/foundation.dart';
import 'package:tarkeez/core/dependency_injection/di.dart';
import 'package:tarkeez/features/daily_rollups/bloc/daily_rollup_bloc.dart';
import 'package:tarkeez/features/projects/bloc/project_bloc.dart';
import 'package:tarkeez/features/sessions/bloc/session_bloc.dart';

class AppStartupTasks {
  const AppStartupTasks();

  Future<void> run() async {
    final stopwatch = Stopwatch()..start();
    
    // Sequential by design: SQLite serializes all queries on one connection,
    // so Future.wait here wouldn't run them concurrently — just queue them.
    await _preloadProjects();
    await _preloadSessions();
    await _preloadDailyRollups();

    stopwatch.stop();
    debugPrint(
      '🟨 ⏱️ AppStartupTasks.run() took ${stopwatch.elapsedMilliseconds}ms',
    );
  }

  Future<void> _preloadProjects() async {
    final bloc = getIt<ProjectBloc>();
    if (bloc.state is ProjectLoaded) return;
    bloc.add(FetchProjectsRequested());
    await bloc.stream.firstWhere((s) => s is! ProjectLoading);
  }

  Future<void> _preloadSessions() async {
    final bloc = getIt<SessionBloc>();
    if (bloc.state is SessionLoaded) return;
    bloc.add(FetchAllSessionsRequested());
    await bloc.stream.firstWhere((s) => s is! SessionLoading);
  }

  Future<void> _preloadDailyRollups() async {
    final bloc = getIt<DailyRollupBloc>();
    if (bloc.state is DailyRollupLoaded) return;
    bloc.add(FetchDailyRollupRequested());
    await bloc.stream.firstWhere((s) => s is! DailyRollupLoading);
  }
}
