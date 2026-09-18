import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:tarkeez/core/app/app.dart';
import 'package:tarkeez/core/app/app_preloader.dart';
import 'package:tarkeez/core/app/bootstrap.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  final initialTheme = await bootstrap();
  await const AppPreloader().run();

  runApp(App(initialTheme: initialTheme));
  FlutterNativeSplash.remove();
}
