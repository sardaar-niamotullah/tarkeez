import 'package:drift/drift.dart';
import 'package:tarkeez/core/database/local_database.dart';
import 'package:tarkeez/core/database/tables/local_sessions.dart';
import 'package:tarkeez/core/sync/sync_entity.dart';
import 'package:tarkeez/features/sessions/data/models/session_model.dart';

part 'local_sessions_dao.g.dart';

@DriftAccessor(tables: [LocalSessions])
class LocalSessionsDao extends DatabaseAccessor<LocalDatabase>
    with _$LocalSessionsDaoMixin {
  LocalSessionsDao(super.db);

  String get _uid => attachedDatabase.currentUserId;

  // CREATE (the triggers update the rollups, the queue starts the sync)
  Future<String> insertSession({
    required DateTime startedAt,
    required DateTime endedAt,
    required int utcOffsetMinutes,
    String? projectId,
  }) {
    return transaction(() async {
      final row = await into(localSessions).insertReturning(
        LocalSessionsCompanion.insert(
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

  // READ (deleted sessions are hidden, newest first)
  Future<List<LocalSession>> getAllSessions() =>
      (select(localSessions)
            ..where((t) => t.userId.equals(_uid) & t.deletedAt.isNull())
            ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]))
          .get();

  Future<LocalSession?> getSessionById(String id) =>
      (select(localSessions)..where(
            (t) =>
                t.id.equals(id) & t.userId.equals(_uid) & t.deletedAt.isNull(),
          ))
          .getSingleOrNull();

  /// Sessions that started in [startedAt, endedAt).
  Future<List<LocalSession>> getAllSessionsInDateRange({
    required DateTime startedAt,
    required DateTime endedAt,
  }) =>
      (select(localSessions)
            ..where(
              (t) =>
                  t.userId.equals(_uid) &
                  t.deletedAt.isNull() &
                  t.startedAt.isBiggerOrEqualValue(startedAt.toUtc()) &
                  t.startedAt.isSmallerThanValue(endedAt.toUtc()),
            )
            ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]))
          .get();

  // DELETE (soft: sets the tombstone, the trigger subtracts the time)
  Future<int> deleteSession(String id) {
    return transaction(() async {
      final rows =
          await (update(localSessions)..where(
                (t) =>
                    t.id.equals(id) &
                    t.userId.equals(_uid) &
                    t.deletedAt.isNull(),
              ))
              .write(
                LocalSessionsCompanion(deletedAt: Value(DateTime.now().toUtc())),
              );
      if (rows > 0) {
        await attachedDatabase.pendingChangesDao.enqueue(SyncEntity.session, id);
      }
      return rows;
    });
  }

  // SYNC

  /// Rows to push. Tombstones are included.
  Future<List<LocalSession>> getSessionsForPush(Iterable<String> ids) =>
      (select(
        localSessions,
      )..where((t) => t.userId.equals(_uid) & t.id.isIn(ids))).get();

  /// The cloud dropped these (they lost an overlap). Not queued again.
  Future<void> markDropped(Iterable<String> ids) {
    if (ids.isEmpty) return Future.value();
    return (update(localSessions)..where(
          (t) => t.userId.equals(_uid) & t.id.isIn(ids) & t.deletedAt.isNull(),
        ))
        .write(LocalSessionsCompanion(deletedAt: Value(DateTime.now().toUtc())));
  }

  /// Saves pulled rows. Returns true if something visible changed.
  Future<bool> applyPulled(List<SessionModel> rows) {
    if (rows.isEmpty) return Future.value(false);
    return transaction(() async {
      final ids = [for (final r in rows) r.id!];
      final pendingIds = await attachedDatabase.pendingChangesDao
          .pendingEntityIds(SyncEntity.session, ids);

      final existing = await (select(
        localSessions,
      )..where((t) => t.userId.equals(_uid) & t.id.isIn(ids))).get();
      final existingById = {for (final s in existing) s.id: s};

      var changed = false;
      final companions = <LocalSessionsCompanion>[];

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
          LocalSessionsCompanion(
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

      await batch((b) => b.insertAllOnConflictUpdate(localSessions, companions));
      return changed;
    });
  }

  /// Hard delete. Used for rows the cloud rejected. Triggers do not fire for
  /// this, so the caller rebuilds the rollups afterwards.
  Future<void> hardDeleteByIds(Iterable<String> ids) => (delete(
    localSessions,
  )..where((t) => t.userId.equals(_uid) & t.id.isIn(ids))).go();

  /// History reset. Rollups are wiped separately.
  Future<int> wipeAllSessions() =>
      (delete(localSessions)..where((t) => t.userId.equals(_uid))).go();
}