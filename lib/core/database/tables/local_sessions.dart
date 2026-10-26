import 'package:drift/drift.dart';
import 'package:tarkeez/core/database/tables/local_projects.dart';
import 'package:tarkeez/core/database/tables/local_users.dart';
import 'package:uuid/uuid.dart';

@TableIndex(
  name: 'idx_sessions_history',
  columns: {#userId, #startedAt},
)
class LocalSessions extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v7())();

  TextColumn get userId => text().references(
    LocalUsers,
    #id,
    onUpdate: KeyAction.cascade,
    onDelete: KeyAction.cascade,
  )();

  /// No cascade and no SET NULL: projects are never hard-deleted.
  TextColumn get projectId =>
      text().nullable().references(LocalProjects, #id)();

  /// Absolute instants (UTC). Whole seconds.
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime()();

  /// The device's offset from UTC when recorded. Local time = instant + offset.
  IntColumn get utcOffsetMinutes => integer()();

  /// Tombstone, kept forever. The only column that changes after insert.
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  List<String> get customConstraints => [
    "CHECK (CAST(strftime('%s', ended_at) AS INTEGER) - CAST(strftime('%s', started_at) AS INTEGER) BETWEEN 1 AND 86400)",
    'CHECK (utc_offset_minutes BETWEEN -840 AND 840)',
  ];

  @override
  Set<Column> get primaryKey => {id};
}