import 'package:drift/drift.dart';
import 'package:tarkeez/core/database/local_database.dart';
import 'package:tarkeez/core/database/tables/local_daily_rollups.dart';

part 'local_daily_rollups_dao.g.dart';

@DriftAccessor(tables: [LocalDailyRollups])
class LocalDailyRollupsDao extends DatabaseAccessor<LocalDatabase>
    with _$LocalDailyRollupsDaoMixin {
  LocalDailyRollupsDao(super.db);

  String get _uid => attachedDatabase.currentUserId;

  SimpleSelectStatement<$LocalDailyRollupsTable, LocalDailyRollup> _mine() =>
      select(localDailyRollups)..where((t) => t.userId.equals(_uid));

  Future<List<LocalDailyRollup>> getAllRollups() =>
      (_mine()..orderBy([(t) => OrderingTerm.asc(t.date)])).get();

  Future<LocalDailyRollup?> getRollupForDate(String date) =>
      (_mine()..where((t) => t.date.equals(date))).getSingleOrNull();

  Future<List<LocalDailyRollup>> getRollupsInRange(String start, String end) {
    return (_mine()
          ..where((t) => t.date.isBiggerOrEqualValue(start))
          ..where((t) => t.date.isSmallerOrEqualValue(end))
          ..orderBy([(t) => OrderingTerm.asc(t.date)]))
        .get();
  }

  Stream<List<LocalDailyRollup>> watchAllRollups() =>
      (_mine()..orderBy([(t) => OrderingTerm.asc(t.date)])).watch();

  Stream<List<LocalDailyRollup>> watchRollupsInRange(
    String start,
    String end,
  ) {
    return (_mine()
          ..where((t) => t.date.isBiggerOrEqualValue(start))
          ..where((t) => t.date.isSmallerOrEqualValue(end))
          ..orderBy([(t) => OrderingTerm.asc(t.date)]))
        .watch();
  }

  /// History reset.
  Future<int> wipeAll() =>
      (delete(localDailyRollups)..where((t) => t.userId.equals(_uid))).go();
}