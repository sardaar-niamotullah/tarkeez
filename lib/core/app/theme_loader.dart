import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tarkeez/core/database/local_database.dart';
import 'package:tarkeez/core/dependency_injection/di.dart';
import 'package:tarkeez/core/shared_files/cubits/theme_cubit.dart';

/// The theme for the first frame: the signed-in account's saved theme, or the
/// defaults when nobody is signed in.
Future<ThemeState> loadInitialTheme() async {
  const fallback = ThemeState(
    mode: ThemeMode.system,
    color: AppThemeColor.green,
  );
  if (Supabase.instance.client.auth.currentSession == null) return fallback;

  try {
    final settings = await getIt<LocalDatabase>().userSettingsDao
        .getSettings();
    return ThemeState(mode: settings.themeMode, color: settings.themeColor);
  } catch (e) {
    debugPrint('Could not load the saved theme: $e');
    return fallback; // a cosmetic setting must never block startup
  }
}