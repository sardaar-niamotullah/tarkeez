import 'package:tarkeez/core/database/app_database.dart';
import 'package:tarkeez/core/error/result.dart';
import 'package:tarkeez/core/error/result_guard.dart';
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
      return rows
          .map(
            (r) => DailyRollupModel(
              date: r.date,
              durationSeconds: r.durationSeconds,
            ),
          )
          .toList();
    });
  }

  @override
  Future<Result<List<DailyRollupModel>>> fetchRecentRollups({
    int days = 5,
  }) async {
    return resultGuard(() async {
      final end = _todayLocal();
      final start = _shiftDate(end, -days);
      final rows = await _database.dailyRollupsDao.getRollupsInRange(
        start,
        end,
      );
      return rows
          .map(
            (r) => DailyRollupModel(
              date: r.date,
              durationSeconds: r.durationSeconds,
            ),
          )
          .toList();
    });
  }

  String _todayLocal() {
    final now = DateTime.now();
    return '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  String _shiftDate(String date, int deltaDays) {
    final d = DateTime.parse(date).add(Duration(days: deltaDays));
    return '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }
}
