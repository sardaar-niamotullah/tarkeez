import 'package:drift/drift.dart';
import 'package:tarkeez/core/database/tables/local_users.dart';
import 'package:tarkeez/core/database/app_database.dart';

part 'local_users_dao.g.dart';

@DriftAccessor(tables: [LocalUsers])
class LocalUsersDao extends DatabaseAccessor<AppDatabase>
    with _$LocalUsersDaoMixin {
  LocalUsersDao(super.db);

  Future<void> upsertUser(LocalUsersCompanion user) =>
      into(localUsers).insertOnConflictUpdate(user);

  Future<LocalUser?> getUserById(String id) =>
      (select(localUsers)..where((t) => t.id.equals(id))).getSingleOrNull();

  Stream<LocalUser?> watchUserById(String id) =>
      (select(localUsers)..where((t) => t.id.equals(id))).watchSingleOrNull();

  Future<int> deleteUser(String id) =>
      (delete(localUsers)..where((t) => t.id.equals(id))).go();
}