import 'package:drift/drift.dart' show Value;
import 'package:tarkeez/core/database/local_database.dart';
import 'package:tarkeez/core/error/result.dart';
import 'package:tarkeez/core/error/result_guard.dart';
import 'package:tarkeez/core/sync/sync_entity.dart';
import 'package:tarkeez/core/sync/sync_remote_source.dart';
import 'package:tarkeez/features/auth/current_user.dart';
import 'package:tarkeez/features/auth/data/models/user_model.dart';
import 'package:tarkeez/features/projects/data/models/project_model.dart';

class SyncOutcome {
  const new({required this.projectsChanged});

  /// True if the project list on this device changed (pulled rows or a reset).
  final bool projectsChanged;
}

/// One sync run: push, then pull. It does not decide when to run.
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
    await _push();
    return _pull();
  });

  /// Online only. Wipes projects in the cloud, then on this device.
  Future<Result<void>> resetHistory() => resultGuard(() async {
    final resetAt = await _remote.resetHistory();
    await _applyReset(resetAt);
  });

  // PUSH

  Future<void> _push() async {
    // Read the queue first, then the rows. An edit that lands in between is
    // pushed now (the row is read after) and its queue entry stays for next time.
    final pending = await _db.pendingChangesDao.getPending(SyncEntity.project);
    if (pending.isEmpty) return;

    // Several edits of one project leave several entries. Push it once.
    final entryIdsByProject = <String, List<String>>{};
    for (final p in pending) {
      (entryIdsByProject[p.entityId] ??= []).add(p.id);
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

    for (final chunk in _chunks(rows, _pushChunkSize)) {
      final response = await _remote.pushProjects([
        for (final r in chunk) ProjectModel.fromLocal(r),
      ]);

      // Rejected rows were created before a history reset. They are dropped,
      // not requeued. The pull that follows wipes the rest.
      await _db.localProjectsDao.hardDeleteByIds(response.rejected);

      await _db.pendingChangesDao.deleteByIds([
        for (final id in [...response.applied, ...response.rejected])
          ...?entryIdsByProject[id],
      ]);
    }
  }

  // PULL

  Future<SyncOutcome> _pull() async {
    var changed = await _pullUser();
    changed |= await _pullProjects();
    return SyncOutcome(projectsChanged: changed);
  }

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
    if (cloudResetAt == null) return false;

    final localResetAt =
        (await _db.localUsersDao.getUserById(user.id))?.historyResetAt;
    if (!_isNewer(cloudResetAt, localResetAt)) return false;

    await _applyReset(cloudResetAt);
    return true;
  }

  Future<bool> _pullProjects() async {
    final checkpoints = _db.pullCheckpointsDao;
    String? cursor = await checkpoints.getProjectCheckpoint();
    var overlap = cursor != null; // first page also re-reads the last 2 minutes
    var changed = false;

    for (var page = 0; page < _maxPagesPerRun; page++) {
      final rows = await _remote.pullProjects(
        after: cursor,
        overlap: overlap,
        pageSize: _pageSize,
      );
      overlap = false;
      if (rows.isEmpty) break;

      changed |= await _db.localProjectsDao.applyPulled(rows);

      cursor = rows.last.updatedAt!; // rows arrive ordered by updated_at
      await checkpoints.advanceProjectCheckpoint(cursor); // save after each page

      if (rows.length < _pageSize) break;
    }
    return changed;
  }

  // RESET

  Future<void> _applyReset(String resetAt) => _db.transaction(() async {
    await _db.localProjectsDao.wipeAllProjects();
    await _db.pendingChangesDao.clear(SyncEntity.project);
    await _db.pullCheckpointsDao.clearProjectCheckpoint();
    await _db.localUsersDao.setHistoryResetAt(_currentUser.id, resetAt);
  });

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