import 'package:drift/drift.dart';
import 'package:tarkeez/core/database/tables/projects.dart';
import 'package:uuid/uuid.dart';

class Sessions extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get projectId => text().nullable().references(
    Projects,
    #id,
    onDelete: KeyAction.setNull,
    onUpdate: KeyAction.cascade,
  )();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
