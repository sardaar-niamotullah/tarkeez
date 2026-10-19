// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_projects_dao.dart';

// ignore_for_file: type=lint
mixin _$LocalProjectsDaoMixin on DatabaseAccessor<LocalDatabase> {
  $LocalUsersTable get localUsers => attachedDatabase.localUsers;
  $LocalProjectsTable get localProjects => attachedDatabase.localProjects;
  LocalProjectsDaoManager get managers => LocalProjectsDaoManager(this);
}

class LocalProjectsDaoManager {
  final _$LocalProjectsDaoMixin _db;
  LocalProjectsDaoManager(this._db);
  $$LocalUsersTableTableManager get localUsers =>
      $$LocalUsersTableTableManager(_db.attachedDatabase, _db.localUsers);
  $$LocalProjectsTableTableManager get localProjects =>
      $$LocalProjectsTableTableManager(_db.attachedDatabase, _db.localProjects);
}
