// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pull_checkpoints_dao.dart';

// ignore_for_file: type=lint
mixin _$PullCheckpointsDaoMixin on DatabaseAccessor<LocalDatabase> {
  $LocalUsersTable get localUsers => attachedDatabase.localUsers;
  $PullCheckpointsTable get pullCheckpoints => attachedDatabase.pullCheckpoints;
  PullCheckpointsDaoManager get managers => PullCheckpointsDaoManager(this);
}

class PullCheckpointsDaoManager {
  final _$PullCheckpointsDaoMixin _db;
  PullCheckpointsDaoManager(this._db);
  $$LocalUsersTableTableManager get localUsers =>
      $$LocalUsersTableTableManager(_db.attachedDatabase, _db.localUsers);
  $$PullCheckpointsTableTableManager get pullCheckpoints =>
      $$PullCheckpointsTableTableManager(
        _db.attachedDatabase,
        _db.pullCheckpoints,
      );
}
