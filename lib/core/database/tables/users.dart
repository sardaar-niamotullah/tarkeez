import 'package:drift/drift.dart';

@DataClassName('LocalUser')
class Users extends Table {
  TextColumn get id => text()();
  TextColumn get email => text().nullable()();
  TextColumn get fullName => text().nullable()();
  TextColumn get avatarUrl => text().nullable()();
  TextColumn get historyResetAt => text().nullable()();
  TextColumn get premiumUntil => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}