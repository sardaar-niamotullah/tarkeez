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
      // Add schema migrations here.
    },
    beforeOpen: (details) async {
      await db.customStatement('PRAGMA foreign_keys = ON');
    },
  );
}