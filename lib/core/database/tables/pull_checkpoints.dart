import 'package:drift/drift.dart';
import 'package:tarkeez/core/database/tables/local_users.dart';

/// Per account: the biggest `updated_at` received from the cloud.
/// Kept as the server's own text so it is sent back unchanged.
/// `last_session_updated_at` is added when sessions start syncing.
class PullCheckpoints extends Table {
  TextColumn get userId => text().references(
    LocalUsers,
    #id,
    onUpdate: KeyAction.cascade,
    onDelete: KeyAction.cascade,
  )();
  TextColumn get lastProjectUpdatedAt => text().nullable()();

  @override
  Set<Column> get primaryKey => {userId};
}