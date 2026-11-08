import 'package:drift/drift.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:tarkeez/core/database/local_database.dart';
import 'package:tarkeez/core/database/tables/user_preferences.dart';
import 'package:tarkeez/core/shared_files/enums/user_preference_enums.dart';

part 'user_preferences_dao.g.dart';

@DriftAccessor(tables: [UserPreferences])
class UserPreferencesDao extends DatabaseAccessor<LocalDatabase>
    with _$UserPreferencesDaoMixin {
  UserPreferencesDao(super.db);

  String get _uid => attachedDatabase.currentUserId;

  //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  // READ
  //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

  /// The active account's preferences. The row is created with the default
  /// values the first time it is needed.
  Future<UserPreference> getPreferences() async {
    await _ensureRow();
    return (select(
      userPreferences,
    )..where((t) => t.userId.equals(_uid))).getSingle();
  }

  //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  // WRITE (each setter changes one column)
  //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  Future<void> setTrackingMode(TrackingMode value) =>
      _save(UserPreferencesCompanion(trackingMode: Value(value)));

  Future<void> setThemeMode(ThemeMode value) =>
      _save(UserPreferencesCompanion(themeMode: Value(value)));

  Future<void> setThemeColor(AppThemeColor value) =>
      _save(UserPreferencesCompanion(themeColor: Value(value)));

  Future<void> setReportPeriod(PeriodRange value) =>
      _save(UserPreferencesCompanion(reportPeriod: Value(value)));

  Future<void> setSessionPeriod(PeriodRange value) =>
      _save(UserPreferencesCompanion(sessionPeriod: Value(value)));

  Future<void> setLeaderboardPeriod(PeriodRange value) =>
      _save(UserPreferencesCompanion(leaderboardPeriod: Value(value)));

  Future<void> _save(UserPreferencesCompanion values) async {
    await _ensureRow();
    await (update(
      userPreferences,
    )..where((t) => t.userId.equals(_uid))).write(values);
  }

  /// Default values for a new account. Keep them in step with the initial
  /// states of the settings cubits.
  Future<void> _ensureRow() => into(userPreferences).insert(
    UserPreferencesCompanion.insert(
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