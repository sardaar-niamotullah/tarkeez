import 'package:drift/drift.dart';
import 'package:tarkeez/core/database/tables/project_rollups.dart';
import 'package:tarkeez/core/database/app_database.dart';

part 'project_rollups_dao.g.dart';

@DriftAccessor(tables: [ProjectRollups])
class ProjectRollupsDao extends DatabaseAccessor<AppDatabase>
    with _$ProjectRollupsDaoMixin {
  ProjectRollupsDao(super.db);

  static String _toKey(String? projectId) => projectId ?? noProjectKey;
  static String? _fromKey(String key) => key == noProjectKey ? null : key;

  // ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  // READ
  // ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  Future<List<ProjectRollup>> getAllRollups() =>
      (select(projectRollups)..orderBy([
            (t) => OrderingTerm.asc(t.date),
            (t) => OrderingTerm.asc(t.projectId),
          ]))
          .get();

  Future<List<ProjectRollup>> getRollupsForDate(String date) =>
      (select(projectRollups)..where((t) => t.date.equals(date))).get();

  Future<List<ProjectRollup>> getRollupsInRange(String start, String end) {
    return (select(projectRollups)
          ..where(
            (t) =>
                t.date.isBiggerOrEqualValue(start) &
                t.date.isSmallerOrEqualValue(end),
          )
          ..orderBy([
            (t) => OrderingTerm.asc(t.date),
            (t) => OrderingTerm.asc(t.projectId),
          ]))
        .get();
  }

  /// Pass `null` for the "No Project" bucket.
  Future<List<ProjectRollup>> getRollupsForProject(
    String? projectId, {
    String? start,
    String? end,
  }) {
    return (select(projectRollups)
          ..where((t) {
            Expression<bool> predicate = t.projectId.equals(_toKey(projectId));
            if (start != null) {
              predicate = predicate & t.date.isBiggerOrEqualValue(start);
            }
            if (end != null) {
              predicate = predicate & t.date.isSmallerOrEqualValue(end);
            }
            return predicate;
          })
          ..orderBy([(t) => OrderingTerm.asc(t.date)]))
        .get();
  }

  Stream<List<ProjectRollup>> watchRollupsInRange(String start, String end) {
    return (select(projectRollups)
          ..where(
            (t) =>
                t.date.isBiggerOrEqualValue(start) &
                t.date.isSmallerOrEqualValue(end),
          )
          ..orderBy([
            (t) => OrderingTerm.asc(t.date),
            (t) => OrderingTerm.asc(t.projectId),
          ]))
        .watch();
  }

  // ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  // READ: aggregates
  // ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  JoinedSelectStatement<HasResultSet, dynamic> _totalsByProjectQuery(
    String start,
    String end,
    Expression<int> total,
  ) {
    return selectOnly(projectRollups)
      ..addColumns([projectRollups.projectId, total])
      ..where(
        projectRollups.date.isBiggerOrEqualValue(start) &
            projectRollups.date.isSmallerOrEqualValue(end),
      )
      ..groupBy([projectRollups.projectId]);
  }
  Map<String?, int> _mapTotals(List<TypedResult> rows, Expression<int> total) {
    return {
      for (final r in rows)
        _fromKey(r.read(projectRollups.projectId)!): r.read(total) ?? 0,
    };
  }

  /// Total seconds per project over start..end (inclusive, 'YYYY-MM-DD').
  /// The `null` key is the "No Project" bucket.
  Future<Map<String?, int>> getTotalsByProjectInRange(
    String start,
    String end,
  ) async {
    final total = projectRollups.durationSeconds.sum();
    final rows = await _totalsByProjectQuery(start, end, total).get();
    return _mapTotals(rows, total);
  }
  Stream<Map<String?, int>> watchTotalsByProjectInRange(
    String start,
    String end,
  ) {
    final total = projectRollups.durationSeconds.sum();
    return _totalsByProjectQuery(
      start,
      end,
      total,
    ).watch().map((rows) => _mapTotals(rows, total));
  }
}
