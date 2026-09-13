import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tarkeez/core/constants/db_table_and_storage_paths.dart';
import 'package:tarkeez/core/error/result.dart';
import 'package:tarkeez/core/error/result_guard.dart';
import 'package:tarkeez/core/services/auth_session_service.dart';
import 'package:tarkeez/features/projects/data/models/project_model.dart';
import 'package:tarkeez/features/time_logs/data/models/time_log_model.dart';

abstract interface class TimeLogRepository {
  Future<Result<TimeLogModel>> entryTimeLog({
    required DateTime startedAt,
    required DateTime endedAt,
    ProjectModel? project,
  });
  Future<Result<List<TimeLogModel>>> fetchTimeLogs();
}

class TimeLogRepositoryImpl implements TimeLogRepository {
  final SupabaseClient _supabase;
  final AuthSessionService _session;
  const TimeLogRepositoryImpl(this._supabase, this._session);

  @override
  Future<Result<TimeLogModel>> entryTimeLog({
    required DateTime startedAt,
    required DateTime endedAt,
    ProjectModel? project,
  }) async {
    return resultGuard(() async {
      final data = await _supabase
          .from(DbTableAndStoragePaths.timeLogs)
          .insert({
            'user_id': _session.requiredUserId,
            'started_at': startedAt.toUtc().toIso8601String(),
            'ended_at': endedAt.toUtc().toIso8601String(),
            'project_id': project?.id,
          })
          .select()
          .single();
      return TimeLogModel.fromJson(data);
    });
  }

  @override
  Future<Result<List<TimeLogModel>>> fetchTimeLogs() async {
    return resultGuard(() async {
      final data = await _supabase
          .from(DbTableAndStoragePaths.timeLogs)
          .select()
          .eq('user_id', _session.requiredUserId);
      final timeLogs = (data as List)
          .map((e) => TimeLogModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return timeLogs;
    });
  }
}
