import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tarkeez/core/constants/db_table_and_storage_paths.dart';
import 'package:tarkeez/core/error/result.dart';
import 'package:tarkeez/core/error/result_guard.dart';
import 'package:tarkeez/features/projects/data/models/project_color_model.dart';

abstract interface class ProjectColorRepository {
  Future<Result<List<ProjectColorModel>>> fetchProjectColors();
}

class ProjectColorRepositoryImpl implements ProjectColorRepository {
  final SupabaseClient _supabase;

  const ProjectColorRepositoryImpl(this._supabase);
  @override
  Future<Result<List<ProjectColorModel>>> fetchProjectColors() async {
    return resultGuard(() async {
      final data = await _supabase
          .from(DbTableAndStoragePaths.projectColors)
          .select();
      final projectColors = (data as List)
          .map((e) => ProjectColorModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return projectColors;
    });
  }
}
