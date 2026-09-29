import 'package:tarkeez/core/database/app_database.dart';
import 'package:tarkeez/core/error/result.dart';
import 'package:tarkeez/core/error/result_guard.dart';
import 'package:tarkeez/core/utils/date_key_utils.dart';
import 'package:tarkeez/features/project_rollups/data/models/project_rollup_model.dart';

abstract interface class ProjectRollupRepository {
  Future<Result<List<ProjectRollupModel>>> fetchAllRollups();
  Future<Result<List<ProjectRollupModel>>> fetchRecentRollups({int days});
  Future<Result<List<ProjectRollupModel>>> fetchRollupsInRange(
    DateTime start,
    DateTime end,
  );
}

class ProjectRollupRepositoryImpl implements ProjectRollupRepository {
  const ProjectRollupRepositoryImpl(this._database);
  final AppDatabase _database;

  @override
  Future<Result<List<ProjectRollupModel>>> fetchAllRollups() {
    return resultGuard(() async {
      final rows = await _database.projectRollupsDao.getAllRollups();
      return rows.map(ProjectRollupModel.fromRow).toList();
    });
  }

  @override
  Future<Result<List<ProjectRollupModel>>> fetchRecentRollups({int days = 5}) {
    final end = DateTime.now();
    return fetchRollupsInRange(end.subtract(Duration(days: days)), end);
  }

  @override
  Future<Result<List<ProjectRollupModel>>> fetchRollupsInRange(
    DateTime start,
    DateTime end,
  ) {
    return resultGuard(() async {
      final rows = await _database.projectRollupsDao.getRollupsInRange(
        DateKeyUtils.format(start),
        DateKeyUtils.format(end),
      );
      return rows.map(ProjectRollupModel.fromRow).toList();
    });
  }
}
