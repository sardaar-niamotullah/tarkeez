import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tarkeez/core/database/local_database.dart';
import 'package:tarkeez/core/services/auth_session_service.dart';
import 'package:tarkeez/core/services/connectivity_service.dart';
import 'package:tarkeez/core/services/sound_service.dart';
import 'package:tarkeez/core/services/sync_service.dart';
import 'package:tarkeez/core/shared_files/cubits/session_period_cubit.dart';
import 'package:tarkeez/core/sync/bloc/sync_bloc.dart';
import 'package:tarkeez/core/sync/sync_engine.dart';
import 'package:tarkeez/core/sync/sync_remote_source.dart';
import 'package:tarkeez/features/auth/bloc/auth_bloc.dart';
import 'package:tarkeez/features/auth/current_user.dart';
import 'package:tarkeez/features/auth/data/repositories/auth_repository.dart';
import 'package:tarkeez/features/daily_rollups/bloc/daily_rollup_bloc.dart';
import 'package:tarkeez/features/daily_rollups/data/repositories/daily_rollup_repository.dart';
import 'package:tarkeez/features/project_rollups/bloc/project_rollup_bloc.dart';
import 'package:tarkeez/features/project_rollups/data/repositories/project_rollup_repository.dart';
import 'package:tarkeez/features/projects/bloc/project_bloc.dart';
import 'package:tarkeez/features/projects/data/repositories/project_repository.dart';
import 'package:tarkeez/features/sessions/bloc/session_bloc.dart';
import 'package:tarkeez/features/sessions/data/repositories/session_repository.dart';

final getIt = GetIt.instance;

Future<void> injectDependencies() async {
  // ── Database ─────────────────────────────────────────────────────────
  getIt.registerLazySingleton<CurrentUser>(SupabaseCurrentUser.new);

  final database = LocalDatabase(getIt<CurrentUser>());
  await database.connect();
  getIt.registerSingleton<LocalDatabase>(database);

  getIt.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  getIt.registerLazySingleton<AuthSessionService>(
    () => AuthSessionService(getIt<SupabaseClient>()),
  );

  // ── Sound ────────────────────────────────────────────────────────────
  final soundService = SoundService();
  unawaited(soundService.init());
  getIt.registerSingleton<SoundService>(soundService);

  // ── Sync ─────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<ConnectivityService>(ConnectivityService.new);

  getIt.registerLazySingleton<SyncRemoteSource>(
    () => SyncRemoteSource(getIt<SupabaseClient>()),
  );

  getIt.registerLazySingleton<SyncEngine>(
    () => SyncEngine(
      getIt<LocalDatabase>(),
      getIt<SyncRemoteSource>(),
      getIt<CurrentUser>(),
    ),
  );

  getIt.registerLazySingleton<SyncService>(
    () => SyncService(
      getIt<SyncEngine>(),
      getIt<ConnectivityService>(),
      getIt<SupabaseClient>(),
      getIt<LocalDatabase>(),
    ),
  );

  getIt.registerLazySingleton<SyncBloc>(() => SyncBloc(getIt<SyncService>()));

  // ── Auth ────────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<SupabaseClient>(), getIt<LocalDatabase>()),
  );

  getIt.registerLazySingleton<AuthBloc>(
    () => AuthBloc(getIt<AuthRepository>()),
  );

  // ── Projects ─────────────────────────────────────────────────────────
  getIt.registerLazySingleton<ProjectRepository>(
    () => ProjectRepositoryImpl(getIt<LocalDatabase>()),
  );

  getIt.registerLazySingleton<ProjectBloc>(
    () => ProjectBloc(
      getIt<ProjectRepository>(),
      getIt<SyncService>().projectsChanged,
    ),
  );

  // ── Sessions ─────────────────────────────────────────────────────────
  getIt.registerLazySingleton<SessionRepository>(
    () => SessionRepositoryImpl(getIt<LocalDatabase>()),
  );

  getIt.registerLazySingleton<SessionBloc>(
    () => SessionBloc(
      getIt<SessionRepository>(),
      getIt<SyncService>().sessionsChanged,
    ),
  );

  getIt.registerLazySingleton<SessionPeriodCubit>(() => SessionPeriodCubit());

  // ── Daily Rollups ────────────────────────────────────────────────────
  getIt.registerLazySingleton<DailyRollupRepository>(
    () => DailyRollupRepositoryImpl(getIt<LocalDatabase>()),
  );

  getIt.registerLazySingleton<DailyRollupBloc>(
    () => DailyRollupBloc(getIt<DailyRollupRepository>()),
  );

  // ── Project Rollups ────────────────────────────────────────────────────
  getIt.registerLazySingleton<ProjectRollupRepository>(
    () => ProjectRollupRepositoryImpl(getIt<LocalDatabase>()),
  );

  getIt.registerLazySingleton<ProjectRollupBloc>(
    () => ProjectRollupBloc(getIt<ProjectRollupRepository>()),
  );
}
