import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/database/local_database.dart';
import 'package:tarkeez/core/dependency_injection/di.dart';
import 'package:tarkeez/core/shared_files/enums/user_settings_enums.dart';

class ThemeState {
  const new({required this.mode, required this.color});

  final ThemeMode mode;
  final AppThemeColor color;

  bool get isDark => mode == ThemeMode.dark;

  ThemeState copyWith({ThemeMode? mode, AppThemeColor? color}) {
    return ThemeState(mode: mode ?? this.mode, color: color ?? this.color);
  }
}

class ThemeCubit extends Cubit<ThemeState> {
  new({required ThemeState initialState}) : super(initialState);

  final _dao = getIt<LocalDatabase>().userPreferencesDao;

  bool get isDark => state.mode == ThemeMode.dark;

  /// Loads the active account's saved theme (after sign-in or an account switch).
  Future<void> load() async {
    final settings = await _dao.getPreferences();
    if (isClosed) return;
    emit(ThemeState(mode: settings.themeMode, color: settings.themeColor));
  }

  Future<void> toggleTheme() async {
    final newMode = isDark ? ThemeMode.light : ThemeMode.dark;
    emit(state.copyWith(mode: newMode));
    await _dao.setThemeMode(newMode);
  }

  Future<void> setColor(AppThemeColor color) async {
    emit(state.copyWith(color: color));
    await _dao.setThemeColor(color);
  }
}