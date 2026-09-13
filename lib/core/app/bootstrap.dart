import 'package:tarkeez/core/app/app_bloc_observer.dart';
import 'package:tarkeez/core/constants/secret_keys.dart';
import 'package:tarkeez/core/di/dependency_injection.dart';
import 'package:tarkeez/core/shared_files/cubits/theme_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<ThemeState> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Supabase.initialize(
    url: dotenv.get(SecretKeys.supabaseURL),
    // ignore: deprecated_member_use
    anonKey: dotenv.get(SecretKeys.supabaseAnonKey),
    authOptions: const FlutterAuthClientOptions(authFlowType: .pkce),
  );

  await injectDependencies();
  if (kDebugMode) Bloc.observer = AppBlocObserver();

  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('theme_mode') ?? false;
  final colorIndex = prefs.getInt('theme_color') ?? 0;

  return ThemeState(
    mode: isDark ? .dark : .light,
    color: .values[colorIndex],
  );
}
