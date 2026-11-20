import 'package:drift/drift.dart';
import 'package:tarkeez/core/database/local_database.dart';
import 'package:tarkeez/core/database/tables/projects.dart';
import 'package:tarkeez/core/database/tables/project_rollups.dart';

part 'project_rollups_dao.g.dart';

/// Reads go through the `project_rollups_effective` view: a project that is
/// missing or deleted is counted as "No Project" ('').
@DriftAccessor(tables: [ProjectRollups, Projects])
class ProjectRollupsDao extends DatabaseAccessor<LocalDatabase>
    with _$ProjectRollupsDaoMixin {
  ProjectRollupsDao(super.db);

  static const _view = 'project_rollups_effective';

  String get _uid => attachedDatabase.currentUserId;

  ProjectRollup _toRow(QueryRow r) => ProjectRollup(
    userId: r.read<String>('user_id'),
    date: r.read<String>('date'),
    projectId: r.read<String>('project_id'),
    durationSeconds: r.read<int>('duration_seconds'),
  );

  Selectable<ProjectRollup> _rollups({String? start, String? end}) {
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
    return customSelect(
      'SELECT user_id, date, project_id, duration_seconds FROM $_view '
      'WHERE ${where.join(' AND ')} ORDER BY date, project_id',
      variables: vars,
      readsFrom: {projectRollups, projects},
    ).map(_toRow);
  }

  // READ
  Future<List<ProjectRollup>> getAllRollups() => _rollups().get();

  Future<List<ProjectRollup>> getRollupsInRange(String start, String end) =>
      _rollups(start: start, end: end).get();

  /// History reset.
  Future<int> wipeAll() =>
      (delete(projectRollups)..where((t) => t.userId.equals(_uid))).go();
}
