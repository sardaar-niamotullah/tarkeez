import 'package:drift/drift.dart';
import 'package:tarkeez/core/database/local_database.dart';
import 'package:tarkeez/core/database/tables/local_projects.dart';
import 'package:tarkeez/core/shared_files/enums/sync_entity.dart';
import 'package:tarkeez/features/projects/data/models/project_model.dart';

part 'local_projects_dao.g.dart';

@DriftAccessor(tables: [LocalProjects])
class LocalProjectsDao extends DatabaseAccessor<LocalDatabase>
    with _$LocalProjectsDaoMixin {
  LocalProjectsDao(super.db);

  String get _uid => attachedDatabase.currentUserId;

  //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  // CREATE
  //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  Future<String> insertProject({required String name, required int colorId}) {
    return transaction(() async {
      final row = await into(localProjects).insertReturning(
        LocalProjectsCompanion.insert(
          userId: _uid,
          name: name,
          colorId: colorId,
        ),
      );
      await attachedDatabase.pendingChangesDao.enqueue(
        SyncEntity.project,
        row.id,
      );
      return row.id;
    });
  }

  //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  // READ (deleted projects are hidden)
  //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  Future<List<LocalProject>> getAllProjects() =>
      (select(localProjects)
            ..where((t) => t.userId.equals(_uid) & t.deletedAt.isNull())
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Future<LocalProject?> getProjectById(String id) =>
      (select(localProjects)..where(
            (t) =>
                t.id.equals(id) & t.userId.equals(_uid) & t.deletedAt.isNull(),
          ))
          .getSingleOrNull();

  Stream<List<LocalProject>> watchAllProjects() {
    return (select(localProjects)
          ..where((t) => t.userId.equals(_uid) & t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  // UPDATE
  //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  Future<bool> updateProject({
    required String id,
    required String name,
    required int colorId,
  }) {
    return transaction(() async {
      final rows =
          await (update(localProjects)..where(
                (t) =>
                    t.id.equals(id) &
                    t.userId.equals(_uid) &
                    t.deletedAt.isNull(),
              ))
              .write(
                LocalProjectsCompanion(
                  name: Value(name),
                  colorId: Value(colorId),
                ),
              );
      if (rows == 0) return false;
      await attachedDatabase.pendingChangesDao.enqueue(SyncEntity.project, id);
      return true;
    });
  }

  //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  // DELETE (soft: sets the tombstone)
  //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  Future<int> deleteProject(String id) {
    return transaction(() async {
      final rows =
          await (update(localProjects)..where(
                (t) =>
                    t.id.equals(id) &
                    t.userId.equals(_uid) &
                    t.deletedAt.isNull(),
              ))
              .write(
                LocalProjectsCompanion(
                  deletedAt: Value(DateTime.now().toUtc()),
                ),
              );
      if (rows > 0) {
        await attachedDatabase.pendingChangesDao.enqueue(
          SyncEntity.project,
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
  Future<List<LocalProject>> getProjectsForPush(Iterable<String> ids) =>
      (select(
        localProjects,
      )..where((t) => t.userId.equals(_uid) & t.id.isIn(ids))).get();

  /// Saves pulled rows. Returns true if something visible changed.
  Future<bool> applyPulled(List<ProjectModel> rows) {
    if (rows.isEmpty) return Future.value(false);

    return transaction(() async {
      final ids = [for (final r in rows) r.id];
      final pendingIds = await attachedDatabase.pendingChangesDao
          .pendingEntityIds(SyncEntity.project, ids);
      final existing = await (select(
        localProjects,
      )..where((t) => t.userId.equals(_uid) & t.id.isIn(ids))).get();
      final existingById = {for (final p in existing) p.id: p};

      var changed = false;
      final companions = <LocalProjectsCompanion>[];

      for (final r in rows) {
        // A row with an unpushed local edit is never overwritten.
        if (pendingIds.contains(r.id)) continue;

        final old = existingById[r.id];
        // A tombstone is one-way: a pulled row never revives a deleted project.
        final deletedAt = old?.deletedAt ?? r.deletedAt;

        changed |=
            old == null ||
            old.name != r.name ||
            old.colorId != r.colorId ||
            (old.deletedAt == null) != (deletedAt == null);

        companions.add(
          LocalProjectsCompanion(
            id: Value(r.id),
            userId: Value(_uid),
            name: Value(r.name),
            colorId: Value(r.colorId),
            createdAt: Value(r.createdAt),
            deletedAt: Value(deletedAt),
          ),
        );
      }

      await batch(
        (b) => b.insertAllOnConflictUpdate(localProjects, companions),
      );
      return changed;
    });
  }

  //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  // Hard delete. Used for rows the cloud rejected and for a history reset.
  //–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  Future<void> hardDeleteByIds(Iterable<String> ids) => (delete(
    localProjects,
  )..where((t) => t.userId.equals(_uid) & t.id.isIn(ids))).go();

  Future<int> wipeAllProjects() =>
      (delete(localProjects)..where((t) => t.userId.equals(_uid))).go();
}
