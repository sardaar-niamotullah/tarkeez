import 'package:drift/drift.dart';
import 'package:tarkeez/core/database/local_database.dart';
import 'package:tarkeez/core/database/tables/local_projects.dart';

part 'local_projects_dao.g.dart';

@DriftAccessor(tables: [LocalProjects])
class LocalProjectsDao extends DatabaseAccessor<LocalDatabase>
    with _$LocalProjectsDaoMixin {
  LocalProjectsDao(super.db);

  // ---------------------------------------------------------------------------
  // CREATE
  // ---------------------------------------------------------------------------
  Future<String> insertProject(LocalProjectsCompanion project) async {
    final row = await into(localProjects).insertReturning(project);
    return row.id;
  }

  // ---------------------------------------------------------------------------
  // READ
  // ---------------------------------------------------------------------------
  Future<List<LocalProject>> getAllProjects() => select(localProjects).get();
  Future<List<LocalProject>> getProjectsByUserId(String userId) =>
      (select(localProjects)..where((t) => t.userId.equals(userId))).get();
  Future<LocalProject?> getProjectById(String id) =>
      (select(localProjects)..where((t) => t.id.equals(id))).getSingleOrNull();
  Stream<List<LocalProject>> watchAllProjects() {
    return (select(localProjects)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  Stream<List<LocalProject>> watchProjectsByUserId(String userId) {
    return (select(localProjects)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  // ---------------------------------------------------------------------------
  // UPDATE
  // ---------------------------------------------------------------------------
  Future<bool> updateProject(LocalProject project) =>
      update(localProjects).replace(project);

  // ---------------------------------------------------------------------------
  // DELETE
  // ---------------------------------------------------------------------------
  Future<int> deleteProject(String id) =>
      (delete(localProjects)..where((t) => t.id.equals(id))).go();

  Future<int> deleteAllProjects() => delete(localProjects).go();
}