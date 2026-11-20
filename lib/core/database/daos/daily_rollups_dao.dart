import 'package:drift/drift.dart';
import 'package:tarkeez/core/database/local_database.dart';
import 'package:tarkeez/core/database/tables/daily_rollups.dart';

part 'daily_rollups_dao.g.dart';

@DriftAccessor(tables: [DailyRollups])
class DailyRollupsDao extends DatabaseAccessor<LocalDatabase>
    with _$DailyRollupsDaoMixin {
  DailyRollupsDao(super.db);

  String get _uid => attachedDatabase.currentUserId;

  Future<List<LocalDailyRollup>> getAllRollups() =>
      (select(dailyRollups)
            ..where((t) => t.userId.equals(_uid))
            ..orderBy([(t) => OrderingTerm.asc(t.date)]))
          .get();

  /// History reset.
  Future<int> wipeAll() =>
      (delete(dailyRollups)..where((t) => t.userId.equals(_uid))).go();
}