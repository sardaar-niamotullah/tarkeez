import 'package:drift/drift.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:tarkeez/core/database/local_database.dart';
import 'package:tarkeez/core/database/tables/user_settings.dart';
import 'package:tarkeez/core/shared_files/cubits/theme_cubit.dart';
import 'package:tarkeez/core/shared_files/cubits/tracking_settings_cubit.dart';
import 'package:tarkeez/core/shared_files/enums/period_range.dart';

part 'user_settings_dao.g.dart';

@DriftAccessor(tables: [UserSettings])
class UserSettingsDao extends DatabaseAccessor<LocalDatabase>
    with _$UserSettingsDaoMixin {
  UserSettingsDao(super.db);

  String get _uid => attachedDatabase.currentUserId;

  //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  // READ
  //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

  /// The active account's settings. The row is created with the default
  /// values the first time it is needed.
  Future<UserSetting> getSettings() async {
    await _ensureRow();
    return (select(
      userSettings,
    )..where((t) => t.userId.equals(_uid))).getSingle();
  }

  //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  // WRITE (each setter changes one column)
  //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  Future<void> setTrackingMode(TrackingMode value) =>
      _save(UserSettingsCompanion(trackingMode: Value(value)));

  Future<void> setThemeMode(ThemeMode value) =>
      _save(UserSettingsCompanion(themeMode: Value(value)));

  Future<void> setThemeColor(AppThemeColor value) =>
      _save(UserSettingsCompanion(themeColor: Value(value)));

  Future<void> setReportPeriod(PeriodRange value) =>
      _save(UserSettingsCompanion(reportPeriod: Value(value)));

  Future<void> setSessionPeriod(PeriodRange value) =>
      _save(UserSettingsCompanion(sessionPeriod: Value(value)));

  Future<void> setLeaderboardPeriod(PeriodRange value) =>
      _save(UserSettingsCompanion(leaderboardPeriod: Value(value)));

  Future<void> _save(UserSettingsCompanion values) async {
    await _ensureRow();
    await (update(
      userSettings,
    )..where((t) => t.userId.equals(_uid))).write(values);
  }

  /// Default values for a new account. Keep them in step with the initial
  /// states of the settings cubits.
  Future<void> _ensureRow() => into(userSettings).insert(
    UserSettingsCompanion.insert(
      userId: _uid,
      trackingMode: TrackingMode.linear,
      themeMode: ThemeMode.system,
      themeColor: AppThemeColor.green,
      reportPeriod: PeriodRange.last7Days,
      sessionPeriod: PeriodRange.last3Days,
      leaderboardPeriod: PeriodRange.last3Days,
    ),
    mode: InsertMode.insertOrIgnore,
  );
}