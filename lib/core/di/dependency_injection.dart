import 'package:get_it/get_it.dart';
import 'package:tarkeez/core/database/app_database.dart';
import 'package:tarkeez/core/services/sound_service.dart';
import 'package:tarkeez/features/projects/bloc/project_bloc.dart';
import 'package:tarkeez/features/projects/data/repositories/project_repository.dart';

final getIt = GetIt.instance;

Future<void> injectDependencies() async {
  // ── Database ────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<AppDatabase>(() => AppDatabase());

  // ── Sound ───────────────────────────────────────────────────────────────
  final soundService = SoundService();
  await soundService.init();
  getIt.registerSingleton<SoundService>(soundService);

  // ── Projects ────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<ProjectRepository>(
    () => ProjectRepositoryImpl(getIt<AppDatabase>()),
  );
  getIt.registerLazySingleton<ProjectBloc>(
    () => ProjectBloc(getIt<ProjectRepository>()),
  );
}
