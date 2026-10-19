import 'package:drift/drift.dart';
import 'package:tarkeez/core/database/tables/local_users.dart';
import 'package:uuid/uuid.dart';

class LocalProjects extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v7())();
  TextColumn get userId => text().references(
    LocalUsers,
    #id,
    onUpdate: KeyAction.cascade,
    onDelete: KeyAction.cascade,
  )();
  TextColumn get name => text().withLength(min: 3, max: 20)();
  IntColumn get colorId => integer()();
  @override
  List<String> get customConstraints => ['CHECK (color_id BETWEEN 0 AND 20)'];
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();

  @override
  Set<Column> get primaryKey => {id};
}
