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

  /// Rows per request and per local read, in both directions. Supabase returns
  /// at most 1000 rows per request, and SQLite binds at most about 32,000
  /// values in one statement. Nothing here sends, reads or binds more than this
  /// at once, so a device that was offline for years syncs in many small pages.
  static const _pageSize = 200;

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
  //
  // The queue is read in pages, oldest first. `cursor` is the id of the last
  // entry read, so a row that stays pending (a hiccup in the cloud) is not read
  // again in this run. It stays queued for the next sync. Entries added while
  // the loop runs have bigger ids, so the loop picks them up too.

  Future<void> _pushProjects() async {
    String? cursor;
    var sent = 0;

    while (true) {
      final entries = await _db.pendingChangesDao.getPendingPage(
        SyncEntity.project,
        afterId: cursor,
        limit: _pageSize,
      );
      if (entries.isEmpty) break;
      cursor = entries.last.id;

      // Several edits of one project leave several entries. Push it once.
      final entryIdsByProject = <String, List<String>>{};
      for (final e in entries) {
        (entryIdsByProject[e.entityId] ??= []).add(e.id);
      }

      final rows = await _db.localProjectsDao.getProjectsForPush(
        entryIdsByProject.keys,
      );
      final localIds = {for (final r in rows) r.id};

      // An entry whose row no longer exists has nothing to push.
      await _db.pendingChangesDao.deleteByIds([
        for (final e in entryIdsByProject.entries)
          if (!localIds.contains(e.key)) ...e.value,
      ]);
      if (rows.isEmpty) continue;

      final response = await _remote.pushProjects([
        for (final r in rows) ProjectModel.fromLocal(r),
      ]);
      sent += rows.length;
      syncLog(
        'push projects: ${entries.length} queued -> sent ${rows.length}, '
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

    syncLog(
      sent == 0
          ? 'push projects: nothing to send'
          : 'push projects: $sent sent in total',
    );
  }

  Future<void> _pushSessions() async {
    String? cursor;
    var sent = 0;
    var removedRejected = false;

    while (true) {
      final entries = await _db.pendingChangesDao.getPendingPage(
        SyncEntity.session,
        afterId: cursor,
        limit: _pageSize,
      );
      if (entries.isEmpty) break;
      cursor = entries.last.id;

      final entryIdsBySession = <String, List<String>>{};
      for (final e in entries) {
        (entryIdsBySession[e.entityId] ??= []).add(e.id);
      }

      final rows = await _db.localSessionsDao.getSessionsForPush(
        entryIdsBySession.keys,
      );
      final localIds = {for (final r in rows) r.id};

      await _db.pendingChangesDao.deleteByIds([
        for (final e in entryIdsBySession.entries)
          if (!localIds.contains(e.key)) ...e.value,
      ]);
      if (rows.isEmpty) continue;

      final response = await _remote.pushSessions([
        for (final r in rows) SessionModel.fromLocal(r),
      ]);
      sent += rows.length;
      syncLog(
        'push sessions: ${entries.length} queued -> sent ${rows.length}, '
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

    syncLog(
      sent == 0
          ? 'push sessions: nothing to send'
          : 'push sessions: $sent sent in total',
    );

    // A hard delete fires no trigger, so recompute the rollups once.
    if (removedRejected) {
      syncLog('push sessions: rejected rows removed, rebuilding rollups');
      await _db.rebuildRollups();
    }
  }

  // PULL
  //
  // Pages are read by (updated_at, id). The cursor is the last row of the
  // previous page, so rows that share a timestamp are never split or skipped.
  // Only the first page of a run starts 30 seconds before the checkpoint.

  /// Reads the device's own `users` row. Returns true if a reset was applied.
  Future<bool> _pullUser() async {
    final row = await _remote.fetchUserRow(_currentUser.id);
    final user = UserModel.fromRow(row);

    await _db.localUsersDao.upsertUser(
      LocalUsersCompanion(
        id: Value(user.id),
        email: Value(user.email),
        fullName: Value(user.fullName),
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
    String? afterStamp = await checkpoints.getProjectCheckpoint();
    String? afterId; // null on the first page
    var overlap = afterStamp != null;
    var changed = false;
    var total = 0;

    while (true) {
      final rows = await _remote.pullProjects(
        after: afterStamp,
        afterId: afterId,
        overlap: overlap,
        pageSize: _pageSize,
      );
      overlap = false;
      if (rows.isEmpty) break;

      changed |= await _db.localProjectsDao.applyPulled(rows);
      total += rows.length;
      afterStamp = rows.last.updatedAt!;
      afterId = rows.last.id;
      syncLog(
        'pull projects: ${rows.length} rows, checkpoint $afterStamp',
      );
      await checkpoints.advanceProjectCheckpoint(afterStamp); // save after each page
      if (rows.length < _pageSize) break;
    }

    syncLog('pull projects: $total received, list changed: $changed');
    return changed;
  }

  Future<bool> _pullSessions() async {
    final checkpoints = _db.pullCheckpointsDao;
    String? afterStamp = await checkpoints.getSessionCheckpoint();
    String? afterId;
    var overlap = afterStamp != null;
    var changed = false;
    var total = 0;

    while (true) {
      final rows = await _remote.pullSessions(
        after: afterStamp,
        afterId: afterId,
        overlap: overlap,
        pageSize: _pageSize,
      );
      overlap = false;
      if (rows.isEmpty) break;

      // The local triggers rebuild the rollups. No rollup is downloaded.
      changed |= await _db.localSessionsDao.applyPulled(rows);
      total += rows.length;
      afterStamp = rows.last.updatedAt!;
      afterId = rows.last.id;
      syncLog(
        'pull sessions: ${rows.length} rows, checkpoint $afterStamp',
      );
      await checkpoints.advanceSessionCheckpoint(afterStamp);
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
}