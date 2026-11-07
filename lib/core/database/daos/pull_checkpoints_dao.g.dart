// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pull_checkpoints_dao.dart';

// ignore_for_file: type=lint
mixin _$PullCheckpointsDaoMixin on DatabaseAccessor<LocalDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $PullCheckpointsTable get pullCheckpoints => attachedDatabase.pullCheckpoints;
  PullCheckpointsDaoManager get managers => PullCheckpointsDaoManager(this);
}

class PullCheckpointsDaoManager {
  final _$PullCheckpointsDaoMixin _db;
  PullCheckpointsDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$PullCheckpointsTableTableManager get pullCheckpoints =>
      $$PullCheckpointsTableTableManager(
        _db.attachedDatabase,
        _db.pullCheckpoints,
      );
}
