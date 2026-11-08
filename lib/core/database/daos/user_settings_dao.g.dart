// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings_dao.dart';

// ignore_for_file: type=lint
mixin _$UserSettingsDaoMixin on DatabaseAccessor<LocalDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $UserSettingsTable get userSettings => attachedDatabase.userSettings;
  UserSettingsDaoManager get managers => UserSettingsDaoManager(this);
}

class UserSettingsDaoManager {
  final _$UserSettingsDaoMixin _db;
  UserSettingsDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$UserSettingsTableTableManager get userSettings =>
      $$UserSettingsTableTableManager(_db.attachedDatabase, _db.userSettings);
}
