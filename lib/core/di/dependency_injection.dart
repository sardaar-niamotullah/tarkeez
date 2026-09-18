import 'package:get_it/get_it.dart';
import 'package:tarkeez/core/database/app_database.dart';
import 'package:tarkeez/core/services/sound_service.dart';
import 'package:tarkeez/features/projects/bloc/project_bloc.dart';
import 'package:tarkeez/features/projects/data/repositories/project_repository.dart';

final getIt = GetIt.instance;

Future<void> injectDependencies() async {
  // ── Core services (parallel init) ──────────────────────────────────────
  // AppDatabase and SoundService are both slow to initialize on first use
  // (DB: native lib load + file open + schema check; Sound: asset
  // decoding). We create both up front and warm them concurrently via
  // Future.wait so the app only pays the slower of the two costs, not
  // both added together. `database.connect()` forces the connection to
  // open now instead of lazily on whichever query runs first later.
  final database = AppDatabase();
  final soundService = SoundService();

  await Future.wait([database.connect(), soundService.init()]);

  getIt.registerSingleton<AppDatabase>(database);
  getIt.registerSingleton<SoundService>(soundService);

  // ── Projects ────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<ProjectRepository>(
    () => ProjectRepositoryImpl(getIt<AppDatabase>()),
  );
  getIt.registerLazySingleton<ProjectBloc>(
    () => ProjectBloc(getIt<ProjectRepository>()),
  );
}
