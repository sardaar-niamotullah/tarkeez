import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tarkeez/core/constants/db_table_and_storage_paths.dart';
import 'package:tarkeez/core/error/result.dart';
import 'package:tarkeez/core/error/result_guard.dart';
import 'package:tarkeez/core/services/auth_session_service.dart';
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
  final SupabaseClient _supabase;
  final AuthSessionService _session;
  const ProjectRepositoryImpl(this._supabase, this._session);

  @override
  Future<Result<ProjectModel>> createProject({
    required String name,
    required int colorId,
  }) async {
    return resultGuard(() async {
      final data = await _supabase
          .from(DbTableAndStoragePaths.projects)
          .insert({
            'name': name,
            'color_id': colorId,
            'user_id': _session.requiredUserId,
          })
          .select()
          .single();
      return ProjectModel.fromJson(data);
    });
  }

  @override
  Future<Result<List<ProjectModel>>> fetchProjects() async {
    return resultGuard(() async {
      final data = await _supabase
          .from(DbTableAndStoragePaths.projects)
          .select()
          .eq('user_id', _session.requiredUserId);
      final projects = (data as List)
          .map((e) => ProjectModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return projects;
    });
  }

  @override
  Future<Result<ProjectModel>> updateProject(ProjectModel project) async {
    return resultGuard(() async {
      final data = await _supabase
          .from(DbTableAndStoragePaths.projects)
          .update({'name': project.name, 'color_id': project.colorId})
          .eq('id', project.id!)
          .eq('user_id', _session.requiredUserId)
          .select()
          .single();
      return ProjectModel.fromJson(data);
    });
  }

  @override
  Future<Result<void>> deleteProject(ProjectModel project) async {
    return resultGuard(() async {
      await _supabase
          .from(DbTableAndStoragePaths.projects)
          .delete()
          .eq('id', project.id!)
          .eq('user_id', _session.requiredUserId);
      return;
    });
  }
}
