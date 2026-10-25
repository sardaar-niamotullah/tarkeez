import 'package:drift/drift.dart';
import 'package:tarkeez/core/database/local_database.dart';
import 'package:tarkeez/core/database/triggers/rollup_triggers.dart';

MigrationStrategy buildMigrationStrategy(LocalDatabase db) {
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
        await rebuildRollupData(db);
        await createProjectRollupTriggers(db);
      }
      if (from < 5) {
        await m.createTable(db.localUsers);
      }
      if (from < 6) {
        await m.createTable(db.localProjects);
        await m.deleteTable('projects');
      }
      if (from < 7) {
        // createTable above already builds the newest shape, so only add the
        // columns to tables that existed before this version.
        if (from >= 5) {
          await m.addColumn(db.localUsers, db.localUsers.historyResetAt);
        }
        if (from >= 6) {
          await m.addColumn(db.localProjects, db.localProjects.deletedAt);
        }
        await m.createTable(db.pendingChanges);
        await m.createTable(db.pullCheckpoints);
      }
    },
    beforeOpen: (details) async {
      await db.customStatement('PRAGMA foreign_keys = ON');
    },
  );
}