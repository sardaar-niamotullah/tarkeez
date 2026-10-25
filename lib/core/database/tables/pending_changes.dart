import 'package:drift/drift.dart';
import 'package:tarkeez/core/database/tables/local_users.dart';
import 'package:tarkeez/core/sync/sync_entity.dart';
import 'package:uuid/uuid.dart';

/// Rows changed locally and not yet pushed. Stores the table and id only;
/// the row itself is read at push time.
class PendingChanges extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v7())();
  TextColumn get userId => text().references(
    LocalUsers,
    #id,
    onUpdate: KeyAction.cascade,
    onDelete: KeyAction.cascade,
  )();
  TextColumn get entity => textEnum<SyncEntity>()();
  TextColumn get entityId => text()();

  @override
  Set<Column> get primaryKey => {id};
}