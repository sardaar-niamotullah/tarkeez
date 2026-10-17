import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tarkeez/core/app/app.dart';
import 'package:tarkeez/core/app/app_bloc_observer.dart';
import 'package:tarkeez/core/app/app_startup_tasks.dart';
import 'package:tarkeez/core/app/theme_loader.dart';
import 'package:tarkeez/core/constants/secret_keys.dart';
import 'package:tarkeez/core/dependency_injection/di.dart';

Future<void> main() async {
  final stopwatch = Stopwatch()..start();

  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Supabase.initialize(
    url: dotenv.get(SecretKeys.supabaseURL),
    // ignore: deprecated_member_use
    anonKey: dotenv.get(SecretKeys.supabaseAnonKey),
    authOptions: const FlutterAuthClientOptions(authFlowType: .pkce),
  );
  await injectDependencies();
  if (kDebugMode) Bloc.observer = AppBlocObserver();
  final initialTheme = await loadInitialTheme();
  await const AppStartupTasks().run();

  stopwatch.stop();
  debugPrint('🟨 ⏱️ Total Startup time: ${stopwatch.elapsedMilliseconds}ms');

  runApp(App(initialTheme: initialTheme));
}
