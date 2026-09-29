import 'package:drift/drift.dart';
import 'package:tarkeez/core/database/app_database.dart';
import 'package:tarkeez/core/database/triggers/rollup_triggers.dart';

MigrationStrategy buildMigrationStrategy(AppDatabase db) {
  return MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await createDailyRollupTriggers(db);
      await createProjectRollupTriggers(db);
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(db.sessions);
      }
      if (from < 3) {
        await m.createTable(db.dailyRollups);
        await createDailyRollupTriggers(db);
      }
      if (from < 4) {
        await m.createTable(db.projectRollups);
        // Fill BOTH rollup tables from existing sessions. This also repairs
        // daily_rollups for sessions recorded before its triggers existed.
        await rebuildRollupData(db);
        await createProjectRollupTriggers(db);
      }
    },
    beforeOpen: (details) async {
      await db.customStatement('PRAGMA foreign_keys = ON');
    },
  );
}