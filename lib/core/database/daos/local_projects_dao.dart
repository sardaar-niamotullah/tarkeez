import 'package:drift/drift.dart';
import 'package:tarkeez/core/database/local_database.dart';
import 'package:tarkeez/core/database/tables/local_projects.dart';

part 'local_projects_dao.g.dart';

@DriftAccessor(tables: [LocalProjects])
class LocalProjectsDao extends DatabaseAccessor<LocalDatabase>
    with _$LocalProjectsDaoMixin {
  LocalProjectsDao(super.db);

  String get _uid => attachedDatabase.currentUserId;

  // CREATE 
  Future<String> insertProject({
    required String name,
    required int colorId,
  }) async {
    final row = await into(localProjects).insertReturning(
      LocalProjectsCompanion.insert(userId: _uid, name: name, colorId: colorId),
    );
    return row.id;
  }

  // READ
  Future<List<LocalProject>> getAllProjects() =>
      (select(localProjects)..where((t) => t.userId.equals(_uid))).get();
  Future<LocalProject?> getProjectById(String id) => (select(
    localProjects,
  )..where((t) => t.id.equals(id) & t.userId.equals(_uid))).getSingleOrNull();

  Stream<List<LocalProject>> watchAllProjects() {
    return (select(localProjects)
          ..where((t) => t.userId.equals(_uid))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  // UPDATE
  Future<bool> updateProject({
    required String id,
    required String name,
    required int colorId,
  }) async {
    final rows =
        await (update(
          localProjects,
        )..where((t) => t.id.equals(id) & t.userId.equals(_uid))).write(
          LocalProjectsCompanion(name: Value(name), colorId: Value(colorId)),
        );
    return rows > 0;
  }

  // DELETE
  Future<int> deleteProject(String id) => (delete(
    localProjects,
  )..where((t) => t.id.equals(id) & t.userId.equals(_uid))).go();
  Future<int> deleteAllProjects() =>
      (delete(localProjects)..where((t) => t.userId.equals(_uid))).go();
}
