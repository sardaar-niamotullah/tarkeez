import 'package:drift/drift.dart';
import 'package:tarkeez/core/database/local_database.dart';
import 'package:tarkeez/core/database/tables/pull_checkpoints.dart';

part 'pull_checkpoints_dao.g.dart';

@DriftAccessor(tables: [PullCheckpoints])
class PullCheckpointsDao extends DatabaseAccessor<LocalDatabase>
    with _$PullCheckpointsDaoMixin {
  PullCheckpointsDao(super.db);

  String get _uid => attachedDatabase.currentUserId;

  Future<PullCheckpoint?> _row() => (select(
    pullCheckpoints,
  )..where((t) => t.userId.equals(_uid))).getSingleOrNull();

  static bool _isForward(String stamp, String? current) =>
      current == null || DateTime.parse(stamp).isAfter(DateTime.parse(current));

  // PROJECTS
  Future<String?> getProjectCheckpoint() async =>
      (await _row())?.lastProjectUpdatedAt;

  /// A checkpoint only moves forward.
  Future<void> advanceProjectCheckpoint(String stamp) async {
    if (!_isForward(stamp, await getProjectCheckpoint())) return;
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

  // SESSIONS
  Future<String?> getSessionCheckpoint() async =>
      (await _row())?.lastSessionUpdatedAt;

  Future<void> advanceSessionCheckpoint(String stamp) async {
    if (!_isForward(stamp, await getSessionCheckpoint())) return;
    await into(pullCheckpoints).insertOnConflictUpdate(
      PullCheckpointsCompanion(
        userId: Value(_uid),
        lastSessionUpdatedAt: Value(stamp),
      ),
    );
  }

  Future<void> clearSessionCheckpoint() =>
      (update(pullCheckpoints)..where((t) => t.userId.equals(_uid))).write(
        const PullCheckpointsCompanion(lastSessionUpdatedAt: Value(null)),
      );
}