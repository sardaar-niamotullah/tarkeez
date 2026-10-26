import 'package:drift/drift.dart';
import 'package:tarkeez/core/database/local_database.dart';
import 'package:tarkeez/core/database/tables/local_projects.dart';
import 'package:tarkeez/core/database/tables/project_rollups.dart';

part 'project_rollups_dao.g.dart';

/// Reads go through the `project_rollups_effective` view: a project that is
/// missing or deleted is counted as "No Project" ('').
@DriftAccessor(tables: [ProjectRollups, LocalProjects])
class ProjectRollupsDao extends DatabaseAccessor<LocalDatabase>
    with _$ProjectRollupsDaoMixin {
  ProjectRollupsDao(super.db);

  static const _view = 'project_rollups_effective';

  String get _uid => attachedDatabase.currentUserId;

  static String _toKey(String? projectId) => projectId ?? noProjectKey;
  static String? _fromKey(String key) => key == noProjectKey ? null : key;

  ProjectRollup _toRow(QueryRow r) => ProjectRollup(
    userId: r.read<String>('user_id'),
    date: r.read<String>('date'),
    projectId: r.read<String>('project_id'),
    durationSeconds: r.read<int>('duration_seconds'),
  );

  Selectable<ProjectRollup> _rollups({
    String? start,
    String? end,
    String? projectKey,
  }) {
    final where = <String>['user_id = ?'];
    final vars = <Variable>[Variable.withString(_uid)];
    if (start != null) {
      where.add('date >= ?');
      vars.add(Variable.withString(start));
    }
    if (end != null) {
      where.add('date <= ?');
      vars.add(Variable.withString(end));
    }
    if (projectKey != null) {
      where.add('project_id = ?');
      vars.add(Variable.withString(projectKey));
    }
    return customSelect(
      'SELECT user_id, date, project_id, duration_seconds FROM $_view '
      'WHERE ${where.join(' AND ')} ORDER BY date, project_id',
      variables: vars,
      readsFrom: {projectRollups, localProjects},
    ).map(_toRow);
  }

  // READ
  Future<List<ProjectRollup>> getAllRollups() => _rollups().get();

  Future<List<ProjectRollup>> getRollupsForDate(String date) =>
      _rollups(start: date, end: date).get();

  Future<List<ProjectRollup>> getRollupsInRange(String start, String end) =>
      _rollups(start: start, end: end).get();

  /// Pass `null` for the "No Project" bucket.
  Future<List<ProjectRollup>> getRollupsForProject(
    String? projectId, {
    String? start,
    String? end,
  }) => _rollups(
    start: start,
    end: end,
    projectKey: _toKey(projectId),
  ).get();

  Stream<List<ProjectRollup>> watchRollupsInRange(String start, String end) =>
      _rollups(start: start, end: end).watch();

  // READ: aggregates
  Selectable<QueryRow> _totals(String start, String end) => customSelect(
    'SELECT project_id, SUM(duration_seconds) AS total FROM $_view '
    'WHERE user_id = ? AND date >= ? AND date <= ? GROUP BY project_id',
    variables: [
      Variable.withString(_uid),
      Variable.withString(start),
      Variable.withString(end),
    ],
    readsFrom: {projectRollups, localProjects},
  );

  Map<String?, int> _mapTotals(List<QueryRow> rows) => {
    for (final r in rows)
      _fromKey(r.read<String>('project_id')): r.read<int>('total'),
  };

  /// Total seconds per project over start..end (inclusive, 'YYYY-MM-DD').
  /// The `null` key is the "No Project" bucket.
  Future<Map<String?, int>> getTotalsByProjectInRange(
    String start,
    String end,
  ) async => _mapTotals(await _totals(start, end).get());

  Stream<Map<String?, int>> watchTotalsByProjectInRange(
    String start,
    String end,
  ) => _totals(start, end).watch().map(_mapTotals);

  /// History reset.
  Future<int> wipeAll() =>
      (delete(projectRollups)..where((t) => t.userId.equals(_uid))).go();
}