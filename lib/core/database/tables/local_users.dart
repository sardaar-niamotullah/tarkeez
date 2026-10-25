import 'package:drift/drift.dart';

class LocalUsers extends Table {
  TextColumn get id => text()();
  TextColumn get email => text().nullable()();
  TextColumn get fullName => text().nullable()();
  TextColumn get avatarUrl => text().nullable()();
  TextColumn get historyResetAt => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}