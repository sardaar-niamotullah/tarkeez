import 'package:tarkeez/core/services/auth_session_service.dart';
import 'package:tarkeez/core/services/sound_service.dart';
import 'package:tarkeez/core/services/storage_service.dart';
import 'package:tarkeez/core/shared_files/notifiers/app_boot_notifier.dart';
import 'package:tarkeez/features/others/customer_care/bloc/customer_report_bloc.dart';
import 'package:tarkeez/features/others/customer_care/data/repositories/customer_report_repository.dart';
import 'package:tarkeez/features/profile/bloc/profile_bloc.dart';
import 'package:tarkeez/features/profile/data/repositories/profile_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tarkeez/features/projects/data/repositories/project_color_repository.dart';
import 'package:tarkeez/features/projects/data/repositories/project_repository.dart';
import 'package:tarkeez/features/time_logs/data/repositories/time_log_repository.dart';

final getIt = GetIt.instance;

Future<void> injectDependencies() async {
  // ── External ────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);
  getIt.registerLazySingleton<StorageService>(
    () => StorageService(getIt<SupabaseClient>()),
  );
  getIt.registerLazySingleton<AuthSessionService>(
    () => AuthSessionService(getIt<SupabaseClient>()),
  );

  // ── Sound ───────────────────────────────────────────────────────────────
  final soundService = SoundService();
  await soundService.init();
  getIt.registerSingleton<SoundService>(soundService);

  // ── Profile ─────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      getIt<SupabaseClient>(),
      getIt<StorageService>(),
      getIt<AuthSessionService>(),
    ),
  );
  getIt.registerLazySingleton(
    () => ProfileBloc(getIt<ProfileRepository>(), getIt<AuthSessionService>()),
  );

  // ── Projects ────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<ProjectColorRepository>(
    () => ProjectColorRepositoryImpl(getIt<SupabaseClient>()),
  );
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

  // ── Customer Care ───────────────────────────────────────────────────────
  getIt.registerLazySingleton<CustomerReportRepository>(
    () => ReportRepositoryImpl(getIt<SupabaseClient>()),
  );
  getIt.registerFactory<CustomerReportBloc>(
    () => CustomerReportBloc(getIt<CustomerReportRepository>()),
  );

  // ── AppAuthNotifier ──────────────────────────────────────────────────────
  getIt.registerLazySingleton<AppBootNotifier>(
    () => AppBootNotifier(getIt<SupabaseClient>()),
  );
}
