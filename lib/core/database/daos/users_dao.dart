import 'package:drift/drift.dart';
import 'package:tarkeez/core/database/local_database.dart';
import 'package:tarkeez/core/database/tables/users.dart';

part 'users_dao.g.dart';

@DriftAccessor(tables: [Users])
class UsersDao extends DatabaseAccessor<LocalDatabase> with _$UsersDaoMixin {
  UsersDao(super.db);

  String get _uid => attachedDatabase.currentUserId;

  Future<void> upsertUser(UsersCompanion user) =>
      into(users).insertOnConflictUpdate(user);

  Future<LocalUser?> getUserById(String id) =>
      (select(users)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> setHistoryResetAt(String id, String? value) =>
      (update(users)..where((t) => t.id.equals(id))).write(
        UsersCompanion(historyResetAt: Value(value)),
      );

  Future<void> setPremiumUntil(String value) =>
      (update(users)..where((t) => t.id.equals(_uid))).write(
        UsersCompanion(premiumUntil: Value(value)),
      );

  Stream<DateTime?> watchPremiumUntil() =>
      (select(users)..where((t) => t.id.equals(_uid))).watchSingleOrNull().map(
        (u) => DateTime.tryParse(u?.premiumUntil ?? ''),
      );
}
