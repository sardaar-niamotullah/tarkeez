import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeColor { green, purple, pink, blue, teal }

class ThemeState {
  final ThemeMode mode;
  final AppThemeColor color;
  
  bool get isDark => mode == ThemeMode.dark;

  const ThemeState({required this.mode, required this.color});

  ThemeState copyWith({ThemeMode? mode, AppThemeColor? color}) {
    return ThemeState(mode: mode ?? this.mode, color: color ?? this.color);
  }
}

class ThemeCubit extends Cubit<ThemeState> {
  static const _modeKey = 'theme_mode';
  static const _colorKey = 'theme_color';

  ThemeCubit({required ThemeState initialState}) : super(initialState);

  bool get isDark => state.mode == ThemeMode.dark;

  Future<void> toggleTheme() async {
    final newMode = isDark ? ThemeMode.light : ThemeMode.dark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_modeKey, newMode == ThemeMode.dark);
    emit(state.copyWith(mode: newMode));
  }

  Future<void> setColor(AppThemeColor color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_colorKey, color.index);
    emit(state.copyWith(color: color));
  }
}
