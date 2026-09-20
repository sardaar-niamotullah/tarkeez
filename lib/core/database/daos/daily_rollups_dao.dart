import 'package:drift/drift.dart';
import 'package:tarkeez/core/database/tables/daily_rollups.dart';
import 'package:tarkeez/core/database/app_database.dart';

part 'daily_rollups_dao.g.dart';

@DriftAccessor(tables: [DailyRollups])
class DailyRollupsDao extends DatabaseAccessor<AppDatabase>
    with _$DailyRollupsDaoMixin {
  DailyRollupsDao(super.db);

  // ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  // READ
  // ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  Future<List<DailyRollup>> getAllRollups() =>
      (select(dailyRollups)..orderBy([(t) => OrderingTerm.asc(t.date)])).get();
  Future<DailyRollup?> getRollupForDate(String date) =>
      (select(dailyRollups)..where((t) => t.date.equals(date)))
          .getSingleOrNull();
  Future<List<DailyRollup>> getRollupsInRange(String start, String end) {
    return (select(dailyRollups)
          ..where((t) => t.date.isBiggerOrEqualValue(start))
          ..where((t) => t.date.isSmallerOrEqualValue(end))
          ..orderBy([(t) => OrderingTerm.asc(t.date)]))
        .get();
  }
  Stream<List<DailyRollup>> watchAllRollups() {
    return (select(dailyRollups)
          ..orderBy([(t) => OrderingTerm.asc(t.date)]))
        .watch();
  }
  Stream<List<DailyRollup>> watchRollupsInRange(String start, String end) {
    return (select(dailyRollups)
          ..where((t) => t.date.isBiggerOrEqualValue(start))
          ..where((t) => t.date.isSmallerOrEqualValue(end))
          ..orderBy([(t) => OrderingTerm.asc(t.date)]))
        .watch();
  }
}