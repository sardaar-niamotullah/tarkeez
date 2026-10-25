import 'package:drift/drift.dart';
import 'package:tarkeez/core/database/local_database.dart';
import 'package:tarkeez/core/database/tables/pull_checkpoints.dart';

part 'pull_checkpoints_dao.g.dart';

@DriftAccessor(tables: [PullCheckpoints])
class PullCheckpointsDao extends DatabaseAccessor<LocalDatabase>
    with _$PullCheckpointsDaoMixin {
  PullCheckpointsDao(super.db);

  String get _uid => attachedDatabase.currentUserId;

  Future<String?> getProjectCheckpoint() async {
    final row = await (select(
      pullCheckpoints,
    )..where((t) => t.userId.equals(_uid))).getSingleOrNull();
    return row?.lastProjectUpdatedAt;
  }

  /// A checkpoint only moves forward.
  Future<void> advanceProjectCheckpoint(String stamp) async {
    final current = await getProjectCheckpoint();
    if (current != null &&
        !DateTime.parse(stamp).isAfter(DateTime.parse(current))) {
      return;
    }
    await into(pullCheckpoints).insertOnConflictUpdate(
      PullCheckpointsCompanion(
        userId: Value(_uid),
        lastProjectUpdatedAt: Value(stamp),
      ),
    );
  }

  Future<void> clearProjectCheckpoint() =>
      (update(pullCheckpoints)..where((t) => t.userId.equals(_uid))).write(
        const PullCheckpointsCompanion(lastProjectUpdatedAt: Value(null)),
      );
}