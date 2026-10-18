// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_users_dao.dart';

// ignore_for_file: type=lint
mixin _$LocalUsersDaoMixin on DatabaseAccessor<AppDatabase> {
  $LocalUsersTable get localUsers => attachedDatabase.localUsers;
  LocalUsersDaoManager get managers => LocalUsersDaoManager(this);
}

class LocalUsersDaoManager {
  final _$LocalUsersDaoMixin _db;
  LocalUsersDaoManager(this._db);
  $$LocalUsersTableTableManager get localUsers =>
      $$LocalUsersTableTableManager(_db.attachedDatabase, _db.localUsers);
}
