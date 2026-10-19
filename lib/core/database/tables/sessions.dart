import 'package:drift/drift.dart';
import 'package:tarkeez/core/database/tables/local_projects.dart';
import 'package:tarkeez/core/database/tables/local_users.dart';
import 'package:uuid/uuid.dart';

class Sessions extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v7())();

  TextColumn get userId => text().references(
        LocalUsers,
        #id,
        onUpdate: KeyAction.cascade,
        onDelete: KeyAction.cascade,
      )();

  TextColumn get projectId => text().nullable().references(
        LocalProjects,
        #id,
        onUpdate: KeyAction.cascade,
        onDelete: KeyAction.setNull,
      )();

  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}