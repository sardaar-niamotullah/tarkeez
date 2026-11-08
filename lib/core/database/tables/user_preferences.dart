import 'package:drift/drift.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:tarkeez/core/database/tables/users.dart';
import 'package:tarkeez/core/shared_files/enums/user_preference_enums.dart';

/// One row per account on this device. Local only, never synced.
/// Enums are stored as text (the enum name).
class UserPreferences extends Table {
  TextColumn get userId => text().references(
    Users,
    #id,
    onUpdate: KeyAction.cascade,
    onDelete: KeyAction.cascade,
  )();

  TextColumn get trackingMode => textEnum<TrackingMode>()();
  TextColumn get themeMode => textEnum<ThemeMode>()();
  TextColumn get themeColor => textEnum<AppThemeColor>()();
  TextColumn get reportPeriod => textEnum<PeriodRange>()();
  TextColumn get sessionPeriod => textEnum<PeriodRange>()();
  TextColumn get leaderboardPeriod => textEnum<PeriodRange>()();

  @override
  Set<Column> get primaryKey => {userId};
}