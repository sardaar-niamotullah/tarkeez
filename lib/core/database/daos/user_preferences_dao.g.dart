// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preferences_dao.dart';

// ignore_for_file: type=lint
mixin _$UserPreferencesDaoMixin on DatabaseAccessor<LocalDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $UserPreferencesTable get userPreferences => attachedDatabase.userPreferences;
  UserPreferencesDaoManager get managers => UserPreferencesDaoManager(this);
}

class UserPreferencesDaoManager {
  final _$UserPreferencesDaoMixin _db;
  UserPreferencesDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$UserPreferencesTableTableManager get userPreferences =>
      $$UserPreferencesTableTableManager(
        _db.attachedDatabase,
        _db.userPreferences,
      );
}
