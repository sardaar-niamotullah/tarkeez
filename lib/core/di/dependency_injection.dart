import 'package:tarkeez/core/services/auth_session_service.dart';
import 'package:tarkeez/core/services/sound_service.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tarkeez/features/projects/data/repositories/project_repository.dart';
import 'package:tarkeez/features/time_logs/data/repositories/time_log_repository.dart';

final getIt = GetIt.instance;

Future<void> injectDependencies() async {
  // ── External ────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  // ── Sound ───────────────────────────────────────────────────────────────
  final soundService = SoundService();
  await soundService.init();
  getIt.registerSingleton<SoundService>(soundService);

  // ── Projects ────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<ProjectRepository>(
    () => ProjectRepositoryImpl(
      getIt<SupabaseClient>(),
      getIt<AuthSessionService>(),
    ),
  );

  // ── Sessions ────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<TimeLogRepository>(
    () => TimeLogRepositoryImpl(
      getIt<SupabaseClient>(),
      getIt<AuthSessionService>(),
    ),
  );
}
