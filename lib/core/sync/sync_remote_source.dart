import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tarkeez/features/projects/data/models/project_model.dart';
import 'package:tarkeez/features/sessions/data/models/session_model.dart';

class PushResponse {
  const new({
    required this.applied,
    required this.rejected,
    this.dropped = const [],
  });

  /// Saved in the cloud.
  final List<String> applied;

  /// Never acceptable: bad data, or a session older than the last history reset.
  final List<String> rejected;

  /// Sessions that lost an overlap. The cloud stored them as deleted.
  final List<String> dropped;
}

/// All calls to Supabase used by sync.
class SyncRemoteSource {
  const new(this._client);

  final SupabaseClient _client;

  Future<Map<String, dynamic>> fetchUserRow(String userId) =>
      _client.from('users').select().eq('id', userId).single();

  // PUSH

  Future<PushResponse> pushProjects(List<ProjectModel> projects) => _push({
    'p_projects': [for (final p in projects) p.toPushJson()],
  });

  Future<PushResponse> pushSessions(List<SessionModel> sessions) => _push({
    'p_sessions': [for (final s in sessions) s.toPushJson()],
  });

  Future<PushResponse> _push(Map<String, dynamic> params) async {
    final data = await _client.rpc(
      'push_changes',
      params: params,
    ) as Map<String, dynamic>;
    return PushResponse(
      applied: _ids(data['applied']),
      rejected: _ids(data['rejected']),
      dropped: _ids(data['dropped']),
    );
  }

  // PULL

  /// Rows stamped after [after], oldest first. [overlap] also re-reads the
  /// last 2 minutes and is used for the first page of a pull only.
  Future<List<ProjectModel>> pullProjects({
    String? after,
    required bool overlap,
    required int pageSize,
  }) async {
    final data = await _pull('pull_projects', after, overlap, pageSize);
    return [
      for (final row in data)
        ProjectModel.fromJson(row as Map<String, dynamic>),
    ];
  }

  Future<List<SessionModel>> pullSessions({
    String? after,
    required bool overlap,
    required int pageSize,
  }) async {
    final data = await _pull('pull_sessions', after, overlap, pageSize);
    return [
      for (final row in data)
        SessionModel.fromJson(row as Map<String, dynamic>),
    ];
  }

  Future<List> _pull(
    String fn,
    String? after,
    bool overlap,
    int pageSize,
  ) async {
    return await _client.rpc(
      fn,
      params: {'p_after': after, 'p_overlap': overlap, 'p_page_size': pageSize},
    ) as List;
  }

  /// Returns the new `history_reset_at` as the server's timestamp text.
  /// A timeout does not mean the cloud did nothing. See SyncService.resetHistory.
  Future<String> resetHistory() async =>
      await _client.rpc('reset_history').timeout(const Duration(seconds: 30))
          as String;

  static List<String> _ids(Object? raw) => [
    for (final id in (raw as List? ?? const [])) id as String,
  ];
}
