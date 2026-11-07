// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_rollups_dao.dart';

// ignore_for_file: type=lint
mixin _$ProjectRollupsDaoMixin on DatabaseAccessor<LocalDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $ProjectRollupsTable get projectRollups => attachedDatabase.projectRollups;
  $ProjectsTable get projects => attachedDatabase.projects;
  ProjectRollupsDaoManager get managers => ProjectRollupsDaoManager(this);
}

class ProjectRollupsDaoManager {
  final _$ProjectRollupsDaoMixin _db;
  ProjectRollupsDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$ProjectRollupsTableTableManager get projectRollups =>
      $$ProjectRollupsTableTableManager(
        _db.attachedDatabase,
        _db.projectRollups,
      );
  $$ProjectsTableTableManager get projects =>
      $$ProjectsTableTableManager(_db.attachedDatabase, _db.projects);
}
