import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:tarkeez/core/database/tables/projects.dart';
import 'package:uuid/uuid.dart';

import 'daos/projects_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Projects], daos: [ProjectsDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'tarkeez_db');
  }

  /// Forces the underlying connection to actually open (native lib load,
  /// file open, schema/migration check) instead of lazily deferring that
  /// cost to whichever query happens to run first. Call once at startup,
  /// in parallel with other slow init work — not tied to any one table.
  Future<void> connect() => customStatement('SELECT 1');
}
