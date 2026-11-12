import 'package:drift/drift.dart';
import 'package:tarkeez/core/database/local_database.dart';
import 'package:tarkeez/core/database/tables/users.dart';

part 'users_dao.g.dart';

@DriftAccessor(tables: [Users])
class UsersDao extends DatabaseAccessor<LocalDatabase> with _$UsersDaoMixin {
  UsersDao(super.db);

  Future<void> upsertUser(UsersCompanion user) =>
      into(users).insertOnConflictUpdate(user);

  Future<LocalUser?> getUserById(String id) =>
      (select(users)..where((t) => t.id.equals(id))).getSingleOrNull();

  Stream<LocalUser?> watchUserById(String id) =>
      (select(users)..where((t) => t.id.equals(id))).watchSingleOrNull();

  Future<int> deleteUser(String id) =>
      (delete(users)..where((t) => t.id.equals(id))).go();

  Future<void> setHistoryResetAt(String id, String? value) =>
      (update(users)..where((t) => t.id.equals(id))).write(
        UsersCompanion(historyResetAt: Value(value)),
      );
      
  Future<void> setPremiumUntil(String id, String? value) =>
      (update(users)..where((t) => t.id.equals(id))).write(
        UsersCompanion(premiumUntil: Value(value)),
      );
}
