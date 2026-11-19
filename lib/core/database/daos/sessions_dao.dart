import 'package:drift/drift.dart';
import 'package:tarkeez/core/constants/app_limits.dart';
import 'package:tarkeez/core/database/local_database.dart';
import 'package:tarkeez/core/database/tables/sessions.dart';
import 'package:tarkeez/core/shared_files/enums/sync_entity.dart';
import 'package:tarkeez/features/sessions/data/models/session_model.dart';

part 'sessions_dao.g.dart';

@DriftAccessor(tables: [Sessions])
class SessionsDao extends DatabaseAccessor<LocalDatabase>
    with _$SessionsDaoMixin {
  SessionsDao(super.db);

  String get _uid => attachedDatabase.currentUserId;

  //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  // CREATE (the triggers update the rollups, the queue starts the sync)
  //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

  /// Returns null and saves nothing when the UTC day of [startedAt] already has
  /// [maxSessionsPerDay] sessions. Deleted ones count, the cloud counts them too.
  Future<String?> insertSession({
    required DateTime startedAt,
    required DateTime endedAt,
    required int utcOffsetMinutes,
    String? projectId,
  }) {
    return transaction(() async {
      if (await _countOnUtcDay(startedAt) >= maxSessionsPerDay) return null;

      final row = await into(sessions).insertReturning(
        SessionsCompanion.insert(
          userId: _uid,
          startedAt: startedAt.toUtc(),
          endedAt: endedAt.toUtc(),
          utcOffsetMinutes: utcOffsetMinutes,
          projectId: Value(projectId),
        ),
      );
      await attachedDatabase.pendingChangesDao.enqueue(
        SyncEntity.session,
        row.id,
      );
      return row.id;
    });
  }

  /// Rows (live and deleted) that started on the same UTC day as [instant].
  Future<int> _countOnUtcDay(DateTime instant) {
    final utc = instant.toUtc();
    final dayStart = DateTime.utc(utc.year, utc.month, utc.day);
    final total = sessions.id.count();
    final query = selectOnly(sessions)
      ..addColumns([total])
      ..where(
        sessions.userId.equals(_uid) &
            sessions.startedAt.isBiggerOrEqualValue(dayStart) &
            sessions.startedAt.isSmallerThanValue(
              dayStart.add(const Duration(days: 1)),
            ),
      );
    return query.map((row) => row.read(total)!).getSingle();
  }

  //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  // READ (deleted sessions are hidden, newest first)
  //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  Future<List<LocalSession>> getAllSessions() =>
      (select(sessions)
            ..where((t) => t.userId.equals(_uid) & t.deletedAt.isNull())
            ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]))
          .get();

  Future<LocalSession?> getSessionById(String id) =>
      (select(sessions)..where(
            (t) =>
                t.id.equals(id) & t.userId.equals(_uid) & t.deletedAt.isNull(),
          ))
          .getSingleOrNull();

  /// Sessions that started in [startedAt, endedAt).
  Future<List<LocalSession>> getAllSessionsInDateRange({
    required DateTime startedAt,
    required DateTime endedAt,
  }) =>
      (select(sessions)
            ..where(
              (t) =>
                  t.userId.equals(_uid) &
                  t.deletedAt.isNull() &
                  t.startedAt.isBiggerOrEqualValue(startedAt.toUtc()) &
                  t.startedAt.isSmallerThanValue(endedAt.toUtc()),
            )
            ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]))
          .get();

  //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  // DELETE (soft: sets the tombstone, the trigger subtracts the time)
  //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  Future<int> deleteSession(String id) {
    return transaction(() async {
      final rows =
          await (update(sessions)..where(
                (t) =>
                    t.id.equals(id) &
                    t.userId.equals(_uid) &
                    t.deletedAt.isNull(),
              ))
              .write(
                SessionsCompanion(deletedAt: Value(DateTime.now().toUtc())),
              );
      if (rows > 0) {
        await attachedDatabase.pendingChangesDao.enqueue(
          SyncEntity.session,
          id,
        );
      }
      return rows;
    });
  }

  //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  // SYNC
  //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

  /// Rows to push. Tombstones are included.
  Future<List<LocalSession>> getSessionsForPush(Iterable<String> ids) =>
      (select(
        sessions,
      )..where((t) => t.userId.equals(_uid) & t.id.isIn(ids))).get();

  /// The cloud dropped these (they lost an overlap). Not queued again.
  Future<void> markDropped(Iterable<String> ids) {
    if (ids.isEmpty) return Future.value();
    return (update(sessions)..where(
          (t) => t.userId.equals(_uid) & t.id.isIn(ids) & t.deletedAt.isNull(),
        ))
        .write(SessionsCompanion(deletedAt: Value(DateTime.now().toUtc())));
  }

  /// Saves pulled rows. Returns true if something visible changed.
  Future<bool> applyPulled(List<SessionModel> rows) {
    if (rows.isEmpty) return Future.value(false);
    return transaction(() async {
      final ids = [for (final r in rows) r.id!];
      final pendingIds = await attachedDatabase.pendingChangesDao
          .pendingEntityIds(SyncEntity.session, ids);

      final existing = await (select(
        sessions,
      )..where((t) => t.userId.equals(_uid) & t.id.isIn(ids))).get();
      final existingById = {for (final s in existing) s.id: s};

      var changed = false;
      final companions = <SessionsCompanion>[];

      for (final r in rows) {
        // A row with an unpushed local change is never overwritten.
        if (pendingIds.contains(r.id)) continue;

        final old = existingById[r.id];

        // A tombstone is one-way: a pulled row never revives a deleted session.
        final deletedAt = old?.deletedAt ?? r.deletedAt;

        // Visible change: a new live session, or a live one that is now deleted.
        changed |= old == null
            ? deletedAt == null
            : (old.deletedAt == null) != (deletedAt == null);

        companions.add(
          SessionsCompanion(
            id: Value(r.id!),
            userId: Value(_uid),
            projectId: Value(r.projectId),
            startedAt: Value(r.startedAt),
            endedAt: Value(r.endedAt),
            utcOffsetMinutes: Value(r.utcOffsetMinutes),
            deletedAt: Value(deletedAt),
          ),
        );
      }

      await batch((b) => b.insertAllOnConflictUpdate(sessions, companions));
      return changed;
    });
  }

  //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  /// Hard delete. Used for rows the cloud rejected. Triggers do not fire for
  /// this, so the caller rebuilds the rollups afterwards.
  //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  Future<void> hardDeleteByIds(Iterable<String> ids) => (delete(
    sessions,
  )..where((t) => t.userId.equals(_uid) & t.id.isIn(ids))).go();

  /// Hard delete of every session that uses one of [projectIds]. Used when the
  /// cloud rejected those projects, so their sessions can never be pushed.
  /// Returns how many rows went. The caller rebuilds the rollups afterwards.
  Future<int> hardDeleteByProjectIds(Iterable<String> projectIds) => (delete(
    sessions,
  )..where((t) => t.userId.equals(_uid) & t.projectId.isIn(projectIds))).go();

  /// History reset. Rollups are wiped separately.
  Future<int> wipeAllSessions() =>
      (delete(sessions)..where((t) => t.userId.equals(_uid))).go();
}
