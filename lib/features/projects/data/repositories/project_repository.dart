import 'package:tarkeez/core/database/local_database.dart';
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
  const new(this._database);
  final LocalDatabase _database;

  @override
  Future<Result<ProjectModel>> createProject({
    required String name,
    required int colorId,
  }) async {
    return resultGuard(() async {
      final id = await _database.localProjectsDao.insertProject(
        name: name,
        colorId: colorId,
      );
      final row = await _database.localProjectsDao.getProjectById(id);
      if (row == null) {
        throw StateError('Failed to load created project');
      }
      return ProjectModel.fromRow(row);
    });
  }

  @override
  Future<Result<List<ProjectModel>>> fetchProjects() async {
    return resultGuard(() async {
      final rows = await _database.localProjectsDao.getAllProjects();
      return rows.map(ProjectModel.fromRow).toList();
    });
  }

  @override
  Future<Result<ProjectModel>> updateProject(ProjectModel project) async {
    return resultGuard(() async {
      final success = await _database.localProjectsDao.updateProject(
        id: project.id!,
        name: project.name,
        colorId: project.colorId,
      );
      if (!success) {
        throw StateError('Failed to update project');
      }
      return project;
    });
  }

  @override
  Future<Result<void>> deleteProject(ProjectModel project) async {
    return resultGuard(() async {
      await _database.localProjectsDao.deleteProject(project.id!);
    });
  }
}
