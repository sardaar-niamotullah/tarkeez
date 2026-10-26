// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_rollups_dao.dart';

// ignore_for_file: type=lint
mixin _$ProjectRollupsDaoMixin on DatabaseAccessor<LocalDatabase> {
  $LocalUsersTable get localUsers => attachedDatabase.localUsers;
  $ProjectRollupsTable get projectRollups => attachedDatabase.projectRollups;
  $LocalProjectsTable get localProjects => attachedDatabase.localProjects;
  ProjectRollupsDaoManager get managers => ProjectRollupsDaoManager(this);
}

class ProjectRollupsDaoManager {
  final _$ProjectRollupsDaoMixin _db;
  ProjectRollupsDaoManager(this._db);
  $$LocalUsersTableTableManager get localUsers =>
      $$LocalUsersTableTableManager(_db.attachedDatabase, _db.localUsers);
  $$ProjectRollupsTableTableManager get projectRollups =>
      $$ProjectRollupsTableTableManager(
        _db.attachedDatabase,
        _db.projectRollups,
      );
  $$LocalProjectsTableTableManager get localProjects =>
      $$LocalProjectsTableTableManager(_db.attachedDatabase, _db.localProjects);
}
