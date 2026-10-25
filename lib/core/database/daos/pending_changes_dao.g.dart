// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_changes_dao.dart';

// ignore_for_file: type=lint
mixin _$PendingChangesDaoMixin on DatabaseAccessor<LocalDatabase> {
  $LocalUsersTable get localUsers => attachedDatabase.localUsers;
  $PendingChangesTable get pendingChanges => attachedDatabase.pendingChanges;
  PendingChangesDaoManager get managers => PendingChangesDaoManager(this);
}

class PendingChangesDaoManager {
  final _$PendingChangesDaoMixin _db;
  PendingChangesDaoManager(this._db);
  $$LocalUsersTableTableManager get localUsers =>
      $$LocalUsersTableTableManager(_db.attachedDatabase, _db.localUsers);
  $$PendingChangesTableTableManager get pendingChanges =>
      $$PendingChangesTableTableManager(
        _db.attachedDatabase,
        _db.pendingChanges,
      );
}
