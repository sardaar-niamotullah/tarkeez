import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/database/local_database.dart';
import 'package:tarkeez/core/dependency_injection/di.dart';
import 'package:tarkeez/core/shared_files/enums/user_preference_enums.dart';

const _defaultPomodoroMinutes = 25;

/// All settings of the active account. The defaults are what a new account
/// starts with (keep them in step with `UserPreferencesDao`).
class UserPreferencesState extends Equatable {
  const new({
    this.themeMode = ThemeMode.system,
    this.themeColor = AppThemeColor.green,
    this.trackingMode = TrackingMode.linear,
    this.pomodoroMinutes = _defaultPomodoroMinutes,
    this.reportPeriod = PeriodRange.last7Days,
  });

  final ThemeMode themeMode;
  final AppThemeColor themeColor;
  final TrackingMode trackingMode;

  /// Not saved in the database.
  final int pomodoroMinutes;

  final PeriodRange reportPeriod;

  bool get isDark => themeMode == ThemeMode.dark;
  bool get isPomodoro => trackingMode == TrackingMode.pomodoro;

  factory UserPreferencesState.fromRow(
    UserPreference row, {
    int pomodoroMinutes = _defaultPomodoroMinutes,
  }) => UserPreferencesState(
    themeMode: row.themeMode,
    themeColor: row.themeColor,
    trackingMode: row.trackingMode,
    pomodoroMinutes: pomodoroMinutes,
    reportPeriod: row.reportPeriod,
  );

  UserPreferencesState copyWith({
    ThemeMode? themeMode,
    AppThemeColor? themeColor,
    TrackingMode? trackingMode,
    int? pomodoroMinutes,
    PeriodRange? reportPeriod,
  }) => UserPreferencesState(
    themeMode: themeMode ?? this.themeMode,
    themeColor: themeColor ?? this.themeColor,
    trackingMode: trackingMode ?? this.trackingMode,
    pomodoroMinutes: pomodoroMinutes ?? this.pomodoroMinutes,
    reportPeriod: reportPeriod ?? this.reportPeriod,
  );

  @override
  List<Object?> get props => [
    themeMode,
    themeColor,
    trackingMode,
    pomodoroMinutes,
    reportPeriod,
  ];
}

class UserPreferencesCubit extends Cubit<UserPreferencesState> {
  new() : super(const UserPreferencesState());

  final _dao = getIt<LocalDatabase>().userPreferencesDao;

  /// Loads the active account's settings: at startup, after sign-in and after
  /// an account switch. If it fails, the current values stay.
  Future<void> load() async {
    try {
      final row = await _dao.getPreferences();
      if (isClosed) return;
      emit(
        UserPreferencesState.fromRow(
          row,
          pomodoroMinutes: state.pomodoroMinutes,
        ),
      );
    } catch (e) {
      debugPrint('Could not load the saved settings: $e');
    }
  }

  // THEME
  Future<void> toggleTheme() =>
      setThemeMode(state.isDark ? ThemeMode.light : ThemeMode.dark);

  Future<void> setThemeMode(ThemeMode mode) async {
    emit(state.copyWith(themeMode: mode));
    await _dao.setThemeMode(mode);
  }

  Future<void> setThemeColor(AppThemeColor color) async {
    emit(state.copyWith(themeColor: color));
    await _dao.setThemeColor(color);
  }

  // TRACKING
  Future<void> setTrackingMode(TrackingMode mode) async {
    emit(state.copyWith(trackingMode: mode));
    await _dao.setTrackingMode(mode);
  }

  void setPomodoroMinutes(int minutes) =>
      emit(state.copyWith(pomodoroMinutes: minutes));

  // PERIODS
  Future<void> setReportPeriod(PeriodRange period) async {
    if (period.isLocked) return;
    emit(state.copyWith(reportPeriod: period));
    await _dao.setReportPeriod(period);
  }
}
