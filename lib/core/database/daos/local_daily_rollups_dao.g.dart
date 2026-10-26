// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_daily_rollups_dao.dart';

// ignore_for_file: type=lint
mixin _$LocalDailyRollupsDaoMixin on DatabaseAccessor<LocalDatabase> {
  $LocalUsersTable get localUsers => attachedDatabase.localUsers;
  $LocalDailyRollupsTable get localDailyRollups =>
      attachedDatabase.localDailyRollups;
  LocalDailyRollupsDaoManager get managers => LocalDailyRollupsDaoManager(this);
}

class LocalDailyRollupsDaoManager {
  final _$LocalDailyRollupsDaoMixin _db;
  LocalDailyRollupsDaoManager(this._db);
  $$LocalUsersTableTableManager get localUsers =>
      $$LocalUsersTableTableManager(_db.attachedDatabase, _db.localUsers);
  $$LocalDailyRollupsTableTableManager get localDailyRollups =>
      $$LocalDailyRollupsTableTableManager(
        _db.attachedDatabase,
        _db.localDailyRollups,
      );
}
