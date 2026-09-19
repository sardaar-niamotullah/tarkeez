import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:tarkeez/core/database/app_database.dart';
import 'package:tarkeez/core/services/sound_service.dart';
import 'package:tarkeez/features/projects/bloc/project_bloc.dart';
import 'package:tarkeez/features/projects/data/repositories/project_repository.dart';
import 'package:tarkeez/features/sessions/bloc/session_bloc.dart';
import 'package:tarkeez/features/sessions/data/repositories/session_repository.dart';

final getIt = GetIt.instance;

Future<void> injectDependencies() async {
  // ── Database ─────────────────────────────────────────────────────────
  final database = AppDatabase();
  await database.connect();
  getIt.registerSingleton<AppDatabase>(database);

  // ── Sound ────────────────────────────────────────────────────────────
  final soundService = SoundService();
  unawaited(soundService.init());
  getIt.registerSingleton<SoundService>(soundService);

  // ── Projects ─────────────────────────────────────────────────────────
  getIt.registerLazySingleton<ProjectRepository>(
    () => ProjectRepositoryImpl(getIt<AppDatabase>()),
  );
  getIt.registerLazySingleton<ProjectBloc>(
    () => ProjectBloc(getIt<ProjectRepository>()),
  );

  // ── Sessions ─────────────────────────────────────────────────────────
  getIt.registerLazySingleton<SessionRepository>(
    () => SessionRepositoryImpl(getIt<AppDatabase>()),
  );
  getIt.registerLazySingleton<SessionBloc>(
    () => SessionBloc(getIt<SessionRepository>()),
  );
}
