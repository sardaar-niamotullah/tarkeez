// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_changes_dao.dart';

// ignore_for_file: type=lint
mixin _$PendingChangesDaoMixin on DatabaseAccessor<LocalDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $PendingChangesTable get pendingChanges => attachedDatabase.pendingChanges;
  PendingChangesDaoManager get managers => PendingChangesDaoManager(this);
}

class PendingChangesDaoManager {
  final _$PendingChangesDaoMixin _db;
  PendingChangesDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$PendingChangesTableTableManager get pendingChanges =>
      $$PendingChangesTableTableManager(
        _db.attachedDatabase,
        _db.pendingChanges,
      );
}
