import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tarkeez/features/projects/data/models/project_model.dart';

class PushResponse {
  const new({required this.applied, required this.rejected});

  /// Saved in the cloud.
  final List<String> applied;

  /// Not saved: created before the last history reset.
  final List<String> rejected;
}

/// All calls to Supabase used by sync.
class SyncRemoteSource {
  const new(this._client);

  final SupabaseClient _client;

  Future<Map<String, dynamic>> fetchUserRow(String userId) =>
      _client.from('users').select().eq('id', userId).single();

  Future<PushResponse> pushProjects(List<ProjectModel> projects) async {
    final data =
        await _client.rpc(
              'push_changes',
              params: {
                'p_projects': [for (final p in projects) p.toPushJson()],
              },
            )
            as Map<String, dynamic>;
    return PushResponse(
      applied: _ids(data['applied']),
      rejected: _ids(data['rejected']),
    );
  }

  /// Rows stamped after [after], oldest first. [overlap] also re-reads the
  /// last 2 minutes and is used for the first page of a pull only.
  Future<List<ProjectModel>> pullProjects({
    String? after,
    required bool overlap,
    required int pageSize,
  }) async {
    final data =
        await _client.rpc(
              'pull_projects',
              params: {
                'p_after': after,
                'p_overlap': overlap,
                'p_page_size': pageSize,
              },
            )
            as List;
    return [
      for (final row in data)
        ProjectModel.fromJson(row as Map<String, dynamic>),
    ];
  }

  /// Returns the new `history_reset_at` as the server's timestamp text.
  Future<String> resetHistory() async =>
      await _client.rpc('reset_history') as String;

  static List<String> _ids(Object? raw) => [
    for (final id in (raw as List? ?? const [])) id as String,
  ];
}