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
  const new(this._localDatabase);
  final LocalDatabase _localDatabase;

  @override
  Future<Result<ProjectModel>> createProject({
    required String name,
    required int colorId,
  }) async {
    return resultGuard(() async {
      final id = await _localDatabase.projectsDao.insertProject(
        name: name,
        colorId: colorId,
      );
      final row = await _localDatabase.projectsDao.getProjectById(id);
      if (row == null) {
        throw StateError('Failed to load created project');
      }
      return ProjectModel.fromLocal(row);
    });
  }

  @override
  Future<Result<List<ProjectModel>>> fetchProjects() async {
    return resultGuard(() async {
      final rows = await _localDatabase.projectsDao.getAllProjects();
      return rows.map(ProjectModel.fromLocal).toList();
    });
  }

  @override
  Future<Result<ProjectModel>> updateProject(ProjectModel project) async {
    return resultGuard(() async {
      final success = await _localDatabase.projectsDao.updateProject(
        id: project.id,
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
      await _localDatabase.projectsDao.deleteProject(project.id);
    });
  }
}
