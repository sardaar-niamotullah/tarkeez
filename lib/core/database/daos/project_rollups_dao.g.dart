// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_rollups_dao.dart';

// ignore_for_file: type=lint
mixin _$ProjectRollupsDaoMixin on DatabaseAccessor<AppDatabase> {
  $ProjectRollupsTable get projectRollups => attachedDatabase.projectRollups;
  ProjectRollupsDaoManager get managers => ProjectRollupsDaoManager(this);
}

class ProjectRollupsDaoManager {
  final _$ProjectRollupsDaoMixin _db;
  ProjectRollupsDaoManager(this._db);
  $$ProjectRollupsTableTableManager get projectRollups =>
      $$ProjectRollupsTableTableManager(
        _db.attachedDatabase,
        _db.projectRollups,
      );
}
