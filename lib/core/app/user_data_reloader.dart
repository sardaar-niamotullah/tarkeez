import 'package:tarkeez/core/dependency_injection/di.dart';
import 'package:tarkeez/features/daily_rollups/bloc/daily_rollup_bloc.dart';
import 'package:tarkeez/features/project_rollups/bloc/project_rollup_bloc.dart';
import 'package:tarkeez/features/projects/bloc/project_bloc.dart';
import 'package:tarkeez/features/sessions/bloc/session_bloc.dart';

/// These blocs are singletons, so they still hold the last user's data after
/// a new user signs in or the history is erased. This asks each one to read
/// the local database again. Every query reads the current user id when it
/// runs, so the new user gets their own rows.
class UserDataReloader {
  const new();

  void reload() {
    // Silent refresh: the same events sync uses when it changes local data.
    getIt<ProjectBloc>().add(ProjectsSynced());
    getIt<SessionBloc>().add(SessionsSynced());

    getIt<DailyRollupBloc>().add(FetchDailyRollupRequested());
    getIt<ProjectRollupBloc>().add(FetchProjectRollupRequested());
  }
}