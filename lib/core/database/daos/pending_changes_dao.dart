import 'package:drift/drift.dart';
import 'package:tarkeez/core/database/local_database.dart';
import 'package:tarkeez/core/database/tables/pending_changes.dart';
import 'package:tarkeez/core/shared_files/enums/sync_entity.dart';

part 'pending_changes_dao.g.dart';

@DriftAccessor(tables: [PendingChanges])
class PendingChangesDao extends DatabaseAccessor<LocalDatabase>
    with _$PendingChangesDaoMixin {
  PendingChangesDao(super.db);

  String get _uid => attachedDatabase.currentUserId;

  /// Every change adds a new row. Push groups them by entity id, and removes
  /// only the rows it read, so an edit made during a push is never lost.
  Future<void> enqueue(SyncEntity entity, String entityId) =>
      into(pendingChanges).insert(
        PendingChangesCompanion.insert(
          userId: _uid,
          entity: entity,
          entityId: entityId,
        ),
      );

  /// Oldest first (ids are UUIDv7).
  Future<List<PendingChange>> getPending(SyncEntity entity) =>
      (select(pendingChanges)
            ..where((t) => t.userId.equals(_uid) & t.entity.equalsValue(entity))
            ..orderBy([(t) => OrderingTerm.asc(t.id)]))
          .get();

  Future<bool> hasPending() async {
    final row =
        await (select(pendingChanges)
              ..where((t) => t.userId.equals(_uid))
              ..limit(1))
            .getSingleOrNull();
    return row != null;
  }

  /// Emits whenever the queue changes. Starts a sync when it is not empty.
  Stream<List<String>> watchPendingIds() =>
      (select(pendingChanges)..where((t) => t.userId.equals(_uid)))
          .watch()
          .map((rows) => [for (final r in rows) r.id]);

  /// Which of [entityIds] still have an unpushed change.
  Future<Set<String>> pendingEntityIds(
    SyncEntity entity,
    Iterable<String> entityIds,
  ) async {
    final rows =
        await (select(pendingChanges)..where(
              (t) =>
                  t.userId.equals(_uid) &
                  t.entity.equalsValue(entity) &
                  t.entityId.isIn(entityIds),
            ))
            .get();
    return {for (final r in rows) r.entityId};
  }

  Future<int> deleteByIds(Iterable<String> ids) => (delete(
    pendingChanges,
  )..where((t) => t.userId.equals(_uid) & t.id.isIn(ids))).go();

  Future<int> clear(SyncEntity entity) => (delete(
    pendingChanges,
  )..where((t) => t.userId.equals(_uid) & t.entity.equalsValue(entity))).go();
}