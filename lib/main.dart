import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:tarkeez/core/app/app.dart';
import 'package:tarkeez/core/app/app_bloc_observer.dart';
import 'package:tarkeez/core/app/app_startup_tasks.dart';
import 'package:tarkeez/core/app/theme_loader.dart';
import 'package:tarkeez/core/di/dependency_injection.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await injectDependencies();
  if (kDebugMode) Bloc.observer = AppBlocObserver();

  final initialTheme = await loadInitialTheme();
  await const AppStartupTasks().run();

  runApp(App(initialTheme: initialTheme));
  FlutterNativeSplash.remove();
}
