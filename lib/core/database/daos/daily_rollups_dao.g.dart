// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_rollups_dao.dart';

// ignore_for_file: type=lint
mixin _$DailyRollupsDaoMixin on DatabaseAccessor<AppDatabase> {
  $DailyRollupsTable get dailyRollups => attachedDatabase.dailyRollups;
  DailyRollupsDaoManager get managers => DailyRollupsDaoManager(this);
}

class DailyRollupsDaoManager {
  final _$DailyRollupsDaoMixin _db;
  DailyRollupsDaoManager(this._db);
  $$DailyRollupsTableTableManager get dailyRollups =>
      $$DailyRollupsTableTableManager(_db.attachedDatabase, _db.dailyRollups);
}
