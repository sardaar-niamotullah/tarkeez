import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/core/database/local_database.dart';
import 'package:tarkeez/core/dependency_injection/di.dart';
import 'package:tarkeez/core/shared_files/enums/user_settings_enums.dart';

const _defaultPomodoroMinutes = 25;

/// All settings of the active account. The defaults are what a new account
/// starts with (keep them in step with `UserSettingsDao`).
class UserSettingsState extends Equatable {
  const new({
    this.themeMode = ThemeMode.system,
    this.themeColor = AppThemeColor.green,
    this.trackingMode = TrackingMode.linear,
    this.pomodoroMinutes = _defaultPomodoroMinutes,
    this.reportPeriod = PeriodRange.last7Days,
    this.sessionPeriod = PeriodRange.last3Days,
    this.leaderboardPeriod = PeriodRange.last3Days,
  });

  final ThemeMode themeMode;
  final AppThemeColor themeColor;
  final TrackingMode trackingMode;

  /// Not saved in the database.
  final int pomodoroMinutes;

  final PeriodRange reportPeriod;
  final PeriodRange sessionPeriod;
  final PeriodRange leaderboardPeriod;

  bool get isDark => themeMode == ThemeMode.dark;
  bool get isPomodoro => trackingMode == TrackingMode.pomodoro;

  factory UserSettingsState.fromRow(
    UserSetting row, {
    int pomodoroMinutes = _defaultPomodoroMinutes,
  }) => UserSettingsState(
    themeMode: row.themeMode,
    themeColor: row.themeColor,
    trackingMode: row.trackingMode,
    pomodoroMinutes: pomodoroMinutes,
    reportPeriod: row.reportPeriod,
    sessionPeriod: row.sessionPeriod,
    leaderboardPeriod: row.leaderboardPeriod,
  );

  UserSettingsState copyWith({
    ThemeMode? themeMode,
    AppThemeColor? themeColor,
    TrackingMode? trackingMode,
    int? pomodoroMinutes,
    PeriodRange? reportPeriod,
    PeriodRange? sessionPeriod,
    PeriodRange? leaderboardPeriod,
  }) => UserSettingsState(
    themeMode: themeMode ?? this.themeMode,
    themeColor: themeColor ?? this.themeColor,
    trackingMode: trackingMode ?? this.trackingMode,
    pomodoroMinutes: pomodoroMinutes ?? this.pomodoroMinutes,
    reportPeriod: reportPeriod ?? this.reportPeriod,
    sessionPeriod: sessionPeriod ?? this.sessionPeriod,
    leaderboardPeriod: leaderboardPeriod ?? this.leaderboardPeriod,
  );

  @override
  List<Object?> get props => [
    themeMode,
    themeColor,
    trackingMode,
    pomodoroMinutes,
    reportPeriod,
    sessionPeriod,
    leaderboardPeriod,
  ];
}

class UserSettingsCubit extends Cubit<UserSettingsState> {
  new({required UserSettingsState initialState}) : super(initialState);

  final _dao = getIt<LocalDatabase>().userSettingsDao;

  /// Loads the active account's settings (after sign-in or an account switch).
  Future<void> load() async {
    final row = await _dao.getSettings();
    if (isClosed) return;
    emit(
      UserSettingsState.fromRow(row, pomodoroMinutes: state.pomodoroMinutes),
    );
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

  Future<void> setSessionPeriod(PeriodRange period) async {
    if (period.isLocked) return;
    emit(state.copyWith(sessionPeriod: period));
    await _dao.setSessionPeriod(period);
  }

  Future<void> setLeaderboardPeriod(PeriodRange period) async {
    if (period.isLocked) return;
    emit(state.copyWith(leaderboardPeriod: period));
    await _dao.setLeaderboardPeriod(period);
  }
}