// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_sessions_dao.dart';

// ignore_for_file: type=lint
mixin _$LocalSessionsDaoMixin on DatabaseAccessor<LocalDatabase> {
  $LocalUsersTable get localUsers => attachedDatabase.localUsers;
  $LocalProjectsTable get localProjects => attachedDatabase.localProjects;
  $LocalSessionsTable get localSessions => attachedDatabase.localSessions;
  LocalSessionsDaoManager get managers => LocalSessionsDaoManager(this);
}

class LocalSessionsDaoManager {
  final _$LocalSessionsDaoMixin _db;
  LocalSessionsDaoManager(this._db);
  $$LocalUsersTableTableManager get localUsers =>
      $$LocalUsersTableTableManager(_db.attachedDatabase, _db.localUsers);
  $$LocalProjectsTableTableManager get localProjects =>
      $$LocalProjectsTableTableManager(_db.attachedDatabase, _db.localProjects);
  $$LocalSessionsTableTableManager get localSessions =>
      $$LocalSessionsTableTableManager(_db.attachedDatabase, _db.localSessions);
}
