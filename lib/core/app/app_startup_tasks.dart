import 'package:flutter/foundation.dart';
import 'package:tarkeez/core/dependency_injection/di.dart';
import 'package:tarkeez/features/daily_rollups/bloc/daily_rollup_bloc.dart';
import 'package:tarkeez/features/projects/bloc/project_bloc.dart';
import 'package:tarkeez/features/sessions/bloc/session_bloc.dart';

class AppStartupTasks {
  const AppStartupTasks();

  Future<void> run() async {
    final stopwatch = Stopwatch()..start();
    await Future.wait([
      _preloadProjects(),
      _preloadSessions(),
      _preloadDailyRollups(),
    ]);
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
    final stopwatch = Stopwatch()..start();

    final bloc = getIt<SessionBloc>();
    if (bloc.state is SessionLoaded) return;
    bloc.add(FetchAllSessionsRequested());
    await bloc.stream.firstWhere((s) => s is! SessionLoading);

    stopwatch.stop();
    debugPrint(
      '🟨 ⏱️ loading all sessions took ${stopwatch.elapsedMilliseconds}ms',
    );
  }

  Future<void> _preloadDailyRollups() async {
    final stopwatch = Stopwatch()..start();

    final bloc = getIt<DailyRollupBloc>();
    if (bloc.state is DailyRollupLoaded) return;
    bloc.add(FetchDailyRollupRequested());
    await bloc.stream.firstWhere((s) => s is! DailyRollupLoading);

    stopwatch.stop();
    debugPrint(
      '🟨 ⏱️ loading all daily rollups took ${stopwatch.elapsedMilliseconds}ms',
    );
  }
}
