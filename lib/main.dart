import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tarkeez/core/app/app.dart';
import 'package:tarkeez/core/app/app_bloc_observer.dart';
import 'package:tarkeez/core/app/app_startup_tasks.dart';
import 'package:tarkeez/core/constants/secret_keys.dart';
import 'package:tarkeez/core/dependency_injection/di.dart';
import 'package:tarkeez/core/services/sync_service.dart';
import 'package:tarkeez/core/shared_files/cubits/premium_cubit.dart';
import 'package:tarkeez/core/shared_files/cubits/user_preferences_cubit.dart';

Future<void> main() async {
  final stopwatch = Stopwatch()..start();

  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  await Supabase.initialize(
    url: dotenv.get(SecretKeys.supabaseURL),
    publishableKey: dotenv.get(SecretKeys.supabasePublishableKey),
    authOptions: const FlutterAuthClientOptions(authFlowType: .pkce),
  );

  await injectDependencies();

  if (kDebugMode) Bloc.observer = AppBlocObserver();

  if (Supabase.instance.client.auth.currentSession != null) {
    await getIt<PremiumCubit>().load();
    await getIt<UserPreferencesCubit>().load();
  }

  await const AppStartupTasks().run();

  // App start trigger. Runs in the background, it does not delay the first frame.
  getIt<SyncService>().start();

  stopwatch.stop();
  debugPrint('🟨 ⏱️ Total Startup time: ${stopwatch.elapsedMilliseconds}ms');

  runApp(const App());
}
