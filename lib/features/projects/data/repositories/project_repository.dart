import 'package:tarkeez/core/database/app_database.dart';
import 'package:tarkeez/core/error/result.dart';
import 'package:tarkeez/core/error/result_guard.dart';
import 'package:tarkeez/features/projects/data/models/project_model.dart';

abstract interface class ProjectRepository {
  Future<Result<ProjectModel>> createProject({
    required String name,
    required int colorId,
  });
  Future<Result<List<ProjectModel>>> fetchProjects();
  Future<Result<ProjectModel>> updateProject(ProjectModel project);
  Future<Result<void>> deleteProject(ProjectModel project);
}

class ProjectRepositoryImpl implements ProjectRepository {
  const ProjectRepositoryImpl(this._database);
  final AppDatabase _database;

  @override
  Future<Result<ProjectModel>> createProject({
    required String name,
    required int colorId,
  }) async {
    return resultGuard(() async {
      final companion = ProjectsCompanion.insert(name: name, colorId: colorId);
      final id = await _database.projectsDao.insertProject(companion);
      final row = await _database.projectsDao.getProjectById(id);
      if (row == null) {
        throw StateError('Failed to load created project');
      }
      return ProjectModel.fromRow(row);
    });
  }

  @override
  Future<Result<List<ProjectModel>>> fetchProjects() async {
    return resultGuard(() async {
      final rows = await _database.projectsDao.getAllProjects();
      return rows.map(ProjectModel.fromRow).toList();
    });
  }

  @override
  Future<Result<ProjectModel>> updateProject(ProjectModel project) async {
    return resultGuard(() async {
      final row = Project(
        id: project.id!,
        name: project.name,
        colorId: project.colorId,
        createdAt: project.createdAt,
      );
      final success = await _database.projectsDao.updateProject(row);
      if (!success) {
        throw StateError('Failed to update project');
      }
      return project;
    });
  }

  @override
  Future<Result<void>> deleteProject(ProjectModel project) async {
    return resultGuard(() async {
      await _database.projectsDao.deleteProject(project.id!);
      return;
    });
  }
}
