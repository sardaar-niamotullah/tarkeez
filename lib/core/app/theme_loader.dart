import 'package:tarkeez/core/shared_files/cubits/theme_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<ThemeState> loadInitialTheme() async {
  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('theme_mode') ?? false;
  final colorIndex = prefs.getInt('theme_color') ?? 0;

  return ThemeState(
    mode: isDark ? .dark : .light,
    color: .values[colorIndex],
  );
}