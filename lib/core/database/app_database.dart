import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:tarkeez/core/database/tables/projects.dart';
import 'package:tarkeez/core/database/tables/sessions.dart';
import 'package:tarkeez/core/database/tables/daily_rollups.dart';
import 'package:tarkeez/core/database/tables/project_rollups.dart';
import 'package:tarkeez/core/database/migrations/app_migrations.dart';
import 'package:tarkeez/core/database/triggers/rollup_triggers.dart';
import 'package:uuid/uuid.dart';

import 'daos/projects_dao.dart';
import 'daos/sessions_dao.dart';
import 'daos/daily_rollups_dao.dart';
import 'daos/project_rollups_dao.dart';

part 'app_database.g.dart';

// dart run build_runner build --delete-conflicting-outputs
@DriftDatabase(
  tables: [Projects, Sessions, DailyRollups, ProjectRollups],
  daos: [ProjectsDao, SessionsDao, DailyRollupsDao, ProjectRollupsDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => buildMigrationStrategy(this);

  @override
  StreamQueryUpdateRules get streamUpdateRules => StreamQueryUpdateRules([
    ...super.streamUpdateRules.rules,
    ...rollupStreamRules,
  ]);

  static QueryExecutor _openConnection() => driftDatabase(name: 'tarkeez_db');
  Future<void> connect() => customStatement('SELECT 1');
  Future<void> rebuildRollups() => transaction(() => rebuildRollupData(this));
}
