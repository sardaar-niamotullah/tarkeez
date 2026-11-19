import 'package:tarkeez/core/database/local_database.dart';
import 'package:tarkeez/core/error/result.dart';
import 'package:tarkeez/core/error/result_guard.dart';
import 'package:tarkeez/features/daily_rollups/data/models/daily_rollup_model.dart';

abstract interface class DailyRollupRepository {
  Future<Result<List<DailyRollupModel>>> fetchAllRollups();
}

class DailyRollupRepositoryImpl implements DailyRollupRepository {
  const new(this._localDatabase);
  final LocalDatabase _localDatabase;

  @override
  Future<Result<List<DailyRollupModel>>> fetchAllRollups() async {
    return resultGuard(() async {
      final rows = await _localDatabase.dailyRollupsDao.getAllRollups();
      return rows.map(DailyRollupModel.fromRow).toList();
    });
  }
}
