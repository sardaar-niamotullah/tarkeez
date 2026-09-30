import 'package:tarkeez/core/database/app_database.dart';
import 'package:tarkeez/core/error/result.dart';
import 'package:tarkeez/core/error/result_guard.dart';
import 'package:tarkeez/core/utils/rollup_date_utils.dart';
import 'package:tarkeez/features/daily_rollups/data/models/daily_rollup_model.dart';

abstract interface class DailyRollupRepository {
  Future<Result<List<DailyRollupModel>>> fetchAllRollups();
  Future<Result<List<DailyRollupModel>>> fetchRecentRollups({int days});
}

class DailyRollupRepositoryImpl implements DailyRollupRepository {
  const DailyRollupRepositoryImpl(this._database);
  final AppDatabase _database;

  @override
  Future<Result<List<DailyRollupModel>>> fetchAllRollups() async {
    return resultGuard(() async {
      final rows = await _database.dailyRollupsDao.getAllRollups();
      return rows.map(DailyRollupModel.fromRow).toList();
    });
  }

  @override
  Future<Result<List<DailyRollupModel>>> fetchRecentRollups({
    int days = 5,
  }) async {
    return resultGuard(() async {
      final now = DateTime.now();
      final end = DateTime(now.year, now.month, now.day);
      final start = DateTime(end.year, end.month, end.day - days);

      final rows = await _database.dailyRollupsDao.getRollupsInRange(
        RollupDateUtils.format(start),
        RollupDateUtils.format(end),
      );
      return rows.map(DailyRollupModel.fromRow).toList();
    });
  }
}
