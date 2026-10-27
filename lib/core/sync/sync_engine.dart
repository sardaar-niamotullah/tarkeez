import 'package:drift/drift.dart' show Value;
import 'package:tarkeez/core/database/local_database.dart';
import 'package:tarkeez/core/error/result.dart';
import 'package:tarkeez/core/error/result_guard.dart';
import 'package:tarkeez/core/shared_files/enums/sync_entity.dart';
import 'package:tarkeez/core/sync/sync_log.dart';
import 'package:tarkeez/core/sync/sync_remote_source.dart';
import 'package:tarkeez/features/auth/current_user.dart';
import 'package:tarkeez/features/auth/data/models/user_model.dart';
import 'package:tarkeez/features/projects/data/models/project_model.dart';
import 'package:tarkeez/features/sessions/data/models/session_model.dart';

class SyncOutcome {
  const new({required this.projectsChanged, required this.sessionsChanged});

  /// True if the project list on this device changed (pulled rows or a reset).
  final bool projectsChanged;

  /// True if the sessions on this device changed (pulled rows or a reset).
  final bool sessionsChanged;
}

/// One sync run: reset check, push, then pull. It does not decide when to run.
/// `SyncService` decides that.
class SyncEngine {
  new(this._db, this._remote, this._currentUser);

  final LocalDatabase _db;
  final SyncRemoteSource _remote;
  final CurrentUser _currentUser;

  static const _pageSize = 200;
  static const _pushChunkSize = 200;
  static const _maxPagesPerRun = 500;

  Future<Result<SyncOutcome>> sync() => resultGuard(() async {
    // 1. Reset check first. After "delete history" the cloud rejects older
    //    projects and sessions, so a stale device must not push them.
    syncLog('[1/3] reset check');
    final resetApplied = await _pullUser();

    // 2. Push. Projects first, because sessions point at them.
    syncLog('[2/3] push');
    await _pushProjects();
    await _pushSessions();

    // 3. Pull. Projects first, for the same reason.
    syncLog('[3/3] pull');
    final projectsChanged = await _pullProjects();
    final sessionsChanged = await _pullSessions();

    return SyncOutcome(
      projectsChanged: projectsChanged || resetApplied,
      sessionsChanged: sessionsChanged || resetApplied,
    );
  });

  /// Online only. Wipes everything in the cloud (projects, sessions, rollups),
  /// then on this device.
  Future<Result<void>> resetHistory() => resultGuard(() async {
    final resetAt = await _remote.resetHistory();
    syncLog('reset: cloud wiped at $resetAt, now wiping this device');
    await _applyReset(resetAt);
  });

  // PUSH

  Future<void> _pushProjects() async {
    // Read the queue first, then the rows. An edit that lands in between is
    // pushed now (the row is read after) and its queue entry stays for next time.
    final pending = await _db.pendingChangesDao.getPending(SyncEntity.project);
    if (pending.isEmpty) {
      syncLog('push projects: nothing queued');
      return;
    }

    // Several edits of one project leave several entries. Push it once.
    final entryIdsByProject = <String, List<String>>{};
    for (final p in pending) {
      (entryIdsByProject[p.entityId] ??= []).add(p.id);
    }

    final rows = await _db.localProjectsDao.getProjectsForPush(
      entryIdsByProject.keys,
    );
    final localIds = {for (final r in rows) r.id};
    syncLog(
      'push projects: ${pending.length} queued, ${rows.length} to send',
    );

    // An entry whose row no longer exists has nothing to push.
    await _db.pendingChangesDao.deleteByIds([
      for (final e in entryIdsByProject.entries)
        if (!localIds.contains(e.key)) ...e.value,
    ]);

    for (final chunk in _chunks(rows, _pushChunkSize)) {
      final response = await _remote.pushProjects([
        for (final r in chunk) ProjectModel.fromLocal(r),
      ]);
      syncLog(
        'push projects: sent ${chunk.length} -> '
        'applied ${response.applied.length}, '
        'rejected ${response.rejected.length}',
      );

      // Rejected rows were created before a history reset, or have bad data.
      // They are dropped, not requeued.
      await _db.localProjectsDao.hardDeleteByIds(response.rejected);
      await _db.pendingChangesDao.deleteByIds([
        for (final id in [...response.applied, ...response.rejected])
          ...?entryIdsByProject[id],
      ]);
    }
  }

  Future<void> _pushSessions() async {
    final pending = await _db.pendingChangesDao.getPending(SyncEntity.session);
    if (pending.isEmpty) {
      syncLog('push sessions: nothing queued');
      return;
    }

    final entryIdsBySession = <String, List<String>>{};
    for (final p in pending) {
      (entryIdsBySession[p.entityId] ??= []).add(p.id);
    }

    final rows = await _db.localSessionsDao.getSessionsForPush(
      entryIdsBySession.keys,
    );
    final localIds = {for (final r in rows) r.id};
    syncLog(
      'push sessions: ${pending.length} queued, ${rows.length} to send',
    );

    await _db.pendingChangesDao.deleteByIds([
      for (final e in entryIdsBySession.entries)
        if (!localIds.contains(e.key)) ...e.value,
    ]);

    var removedRejected = false;

    for (final chunk in _chunks(rows, _pushChunkSize)) {
      final response = await _remote.pushSessions([
        for (final r in chunk) SessionModel.fromLocal(r),
      ]);
      syncLog(
        'push sessions: sent ${chunk.length} -> '
        'applied ${response.applied.length}, '
        'rejected ${response.rejected.length}, '
        'dropped (lost an overlap) ${response.dropped.length}',
      );

      // Lost an overlap: the cloud stored it as deleted. Do the same here now.
      // The trigger subtracts its time. Not queued again.
      await _db.localSessionsDao.markDropped(response.dropped);

      // Rejected (older than the last reset, or bad data): drop locally.
      if (response.rejected.isNotEmpty) {
        await _db.localSessionsDao.hardDeleteByIds(response.rejected);
        removedRejected = true;
      }

      await _db.pendingChangesDao.deleteByIds([
        for (final id in [
          ...response.applied,
          ...response.rejected,
          ...response.dropped,
        ])
          ...?entryIdsBySession[id],
      ]);
    }

    // A hard delete fires no trigger, so recompute the rollups once.
    if (removedRejected) {
      syncLog('push sessions: rejected rows removed, rebuilding rollups');
      await _db.rebuildRollups();
    }
  }

  // PULL

  /// Reads the device's own `users` row. Returns true if a reset was applied.
  Future<bool> _pullUser() async {
    final row = await _remote.fetchUserRow(_currentUser.id);
    final user = UserModel.fromRow(row);

    await _db.localUsersDao.upsertUser(
      LocalUsersCompanion(
        id: Value(user.id),
        email: Value(user.email),
        fullName: Value(user.name),
        avatarUrl: Value(user.avatarUrl),
      ),
    );

    final cloudResetAt = row['history_reset_at'] as String?;
    final localResetAt =
        (await _db.localUsersDao.getUserById(user.id))?.historyResetAt;
    syncLog('reset check: cloud=$cloudResetAt, local=$localResetAt');

    if (cloudResetAt == null) return false;
    if (!_isNewer(cloudResetAt, localResetAt)) return false;

    syncLog('reset check: the cloud was reset after this device, wiping local data');
    await _applyReset(cloudResetAt);
    return true;
  }

  Future<bool> _pullProjects() async {
    final checkpoints = _db.pullCheckpointsDao;
    String? cursor = await checkpoints.getProjectCheckpoint();
    var overlap = cursor != null; // first page also re-reads the last 2 minutes
    var changed = false;
    var total = 0;

    for (var page = 0; page < _maxPagesPerRun; page++) {
      final rows = await _remote.pullProjects(
        after: cursor,
        overlap: overlap,
        pageSize: _pageSize,
      );
      overlap = false;
      if (rows.isEmpty) break;

      changed |= await _db.localProjectsDao.applyPulled(rows);
      total += rows.length;
      cursor = rows.last.updatedAt!; // rows arrive ordered by updated_at
      syncLog(
        'pull projects: page ${page + 1} -> ${rows.length} rows, '
        'checkpoint $cursor',
      );
      await checkpoints.advanceProjectCheckpoint(cursor); // save after each page
      if (rows.length < _pageSize) break;
    }
    syncLog('pull projects: $total received, list changed: $changed');
    return changed;
  }

  Future<bool> _pullSessions() async {
    final checkpoints = _db.pullCheckpointsDao;
    String? cursor = await checkpoints.getSessionCheckpoint();
    var overlap = cursor != null;
    var changed = false;
    var total = 0;

    for (var page = 0; page < _maxPagesPerRun; page++) {
      final rows = await _remote.pullSessions(
        after: cursor,
        overlap: overlap,
        pageSize: _pageSize,
      );
      overlap = false;
      if (rows.isEmpty) break;

      // The local triggers rebuild the rollups. No rollup is downloaded.
      changed |= await _db.localSessionsDao.applyPulled(rows);
      total += rows.length;
      cursor = rows.last.updatedAt!;
      syncLog(
        'pull sessions: page ${page + 1} -> ${rows.length} rows, '
        'checkpoint $cursor',
      );
      await checkpoints.advanceSessionCheckpoint(cursor);
      if (rows.length < _pageSize) break;
    }
    syncLog('pull sessions: $total received, list changed: $changed');
    return changed;
  }

  // RESET: wipes projects, sessions and rollups, and clears queues and checkpoints.

  Future<void> _applyReset(String resetAt) async {
    await _db.transaction(() async {
      // Sessions first: they point at projects.
      await _db.localSessionsDao.wipeAllSessions();
      await _db.localProjectsDao.wipeAllProjects();
      await _db.localDailyRollupsDao.wipeAll();
      await _db.projectRollupsDao.wipeAll();

      await _db.pendingChangesDao.clear(SyncEntity.session);
      await _db.pendingChangesDao.clear(SyncEntity.project);
      await _db.pullCheckpointsDao.clearSessionCheckpoint();
      await _db.pullCheckpointsDao.clearProjectCheckpoint();

      await _db.localUsersDao.setHistoryResetAt(_currentUser.id, resetAt);
    });
    syncLog('reset applied on this device (history_reset_at = $resetAt)');
  }

  // HELPERS

  static bool _isNewer(String cloud, String? local) =>
      local == null || DateTime.parse(cloud).isAfter(DateTime.parse(local));

  static Iterable<List<T>> _chunks<T>(List<T> items, int size) sync* {
    for (var i = 0; i < items.length; i += size) {
      final end = i + size > items.length ? items.length : i + size;
      yield items.sublist(i, end);
    }
  }
}