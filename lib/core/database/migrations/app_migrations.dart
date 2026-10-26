import 'package:drift/drift.dart';
import 'package:tarkeez/core/database/local_database.dart';
import 'package:tarkeez/core/database/triggers/rollup_triggers.dart';

MigrationStrategy buildMigrationStrategy(LocalDatabase db) {
  Future<void> createDerivedObjects() async {
    await createRollupTriggers(db);
    await createProjectRollupsEffectiveView(db);
  }

  return MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await createDerivedObjects();
    },

    // Development only: no data is kept. Drop everything and start fresh.
    onUpgrade: (m, from, to) async {
      await db.customStatement('DROP VIEW IF EXISTS project_rollups_effective;');
      await db.customStatement('DROP TABLE IF EXISTS sessions;');
      await db.customStatement('DROP TABLE IF EXISTS daily_rollups;');
      for (final table in db.allTables.toList().reversed) {
        await m.deleteTable(table.actualTableName);
      }
      await m.createAll();
      await createDerivedObjects();
    },

    beforeOpen: (details) async {
      await db.customStatement('PRAGMA foreign_keys = ON');
    },
  );
}