import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/app/app.dart';
import 'package:tarkeez/core/app/app_bloc_observer.dart';
import 'package:tarkeez/core/app/app_startup_tasks.dart';
import 'package:tarkeez/core/app/theme_loader.dart';
import 'package:tarkeez/core/di/dependency_injection.dart';

Future<void> main() async {
  final stopwatch = Stopwatch()..start();

  WidgetsFlutterBinding.ensureInitialized();
  await injectDependencies();
  if (kDebugMode) Bloc.observer = AppBlocObserver();
  final initialTheme = await loadInitialTheme();
  await const AppStartupTasks().run();
  debugPrint('🎨 Datetime now ${DateTime.now()}');

  stopwatch.stop();
  debugPrint('🟨 ⏱️ Total Startup time: ${stopwatch.elapsedMilliseconds}ms');

  runApp(App(initialTheme: initialTheme));
}
