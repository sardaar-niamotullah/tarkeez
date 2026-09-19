import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';

class Projects extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get name => text().withLength(min: 1, max: 20)();
  IntColumn get colorId => integer()();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now().toUtc())(); 

  @override
  Set<Column> get primaryKey => {id};
}