import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:tarkeez/core/database/tables/projects.dart';
import 'package:tarkeez/core/database/tables/sessions.dart';

import 'daos/projects_dao.dart';
import 'daos/sessions_dao.dart';

part 'app_database.g.dart';

// dart run build_runner build --delete-conflicting-outputs
@DriftDatabase(tables: [Projects, Sessions], daos: [ProjectsDao, SessionsDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(sessions);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'tarkeez_db');
  }

  Future<void> connect() => customStatement('SELECT 1');
}