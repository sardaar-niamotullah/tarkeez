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

    beforeOpen: (details) async {
      await db.customStatement('PRAGMA foreign_keys = ON');
    },
  );
}