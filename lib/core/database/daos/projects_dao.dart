import 'package:drift/drift.dart';
import 'package:tarkeez/core/database/tables/projects.dart';
import 'package:tarkeez/core/database/app_database.dart';

part 'projects_dao.g.dart';

@DriftAccessor(tables: [Projects])
class ProjectsDao extends DatabaseAccessor<AppDatabase>
    with _$ProjectsDaoMixin {
  ProjectsDao(super.db);

  // CREATE
  Future<String> insertProject(ProjectsCompanion project) async {
    final row = await into(projects).insertReturning(project);
    return row.id;
  }

  // READ (one-shot)
  Future<List<Project>> getAllProjects() => select(projects).get();

  Future<Project?> getProjectById(String id) =>
      (select(projects)..where((t) => t.id.equals(id))).getSingleOrNull();

  // READ (reactive stream — auto-updates on any write)
  Stream<List<Project>> watchAllProjects() {
    return (select(
      projects,
    )..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).watch();
  }

  // UPDATE
  Future<bool> updateProject(Project project) =>
      update(projects).replace(project);

  // DELETE
  Future<int> deleteProject(String id) =>
      (delete(projects)..where((t) => t.id.equals(id))).go();
}
