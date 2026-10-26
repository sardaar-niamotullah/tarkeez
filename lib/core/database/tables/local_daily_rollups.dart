import 'package:drift/drift.dart';
import 'package:tarkeez/core/database/tables/local_users.dart';

/// Local-day totals. Written only by triggers on local_sessions.
class LocalDailyRollups extends Table {
  TextColumn get userId => text().references(
    LocalUsers,
    #id,
    onUpdate: KeyAction.cascade,
    onDelete: KeyAction.cascade,
  )();

  /// 'YYYY-MM-DD', the device's local date.
  TextColumn get date => text()();

  IntColumn get durationSeconds => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {userId, date};
}