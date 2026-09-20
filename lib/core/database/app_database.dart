import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:tarkeez/core/database/tables/projects.dart';
import 'package:tarkeez/core/database/tables/sessions.dart';
import 'package:tarkeez/core/database/tables/daily_rollups.dart';

import 'daos/projects_dao.dart';
import 'daos/sessions_dao.dart';
import 'daos/daily_rollups_dao.dart';

part 'app_database.g.dart';

// dart run build_runner build --delete-conflicting-outputs
@DriftDatabase(
  tables: [Projects, Sessions, DailyRollups],
  daos: [ProjectsDao, SessionsDao, DailyRollupsDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _createRollupTriggers();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(sessions);
      }
      if (from < 3) {
        await m.createTable(dailyRollups);
        await _createRollupTriggers();
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

  // ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  // daily_rollups triggers — the ONLY writer of that table.
  // ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  // Duration expression, reused everywhere: seconds between the two
  // ISO8601 UTC text timestamps.
  static const _durationExpression =
      "CAST((julianday(%end%) - julianday(%start%)) * 86400 AS INTEGER)";

  String _dur(String start, String end) =>
      _durationExpression.replaceAll('%start%', start).replaceAll('%end%', end);

  Future<void> _createRollupTriggers() async {
    await customStatement('DROP TRIGGER IF EXISTS trg_sessions_ai;');
    await customStatement('DROP TRIGGER IF EXISTS trg_sessions_ad;');
    await customStatement('DROP TRIGGER IF EXISTS trg_sessions_au;');

    // INSERT: add this session's duration to its local-date bucket.
    await customStatement('''
      CREATE TRIGGER trg_sessions_ai
      AFTER INSERT ON sessions
      BEGIN
        INSERT INTO daily_rollups (date, duration_seconds)
        VALUES (
          date(NEW.started_at, 'localtime'),
          ${_dur('NEW.started_at', 'NEW.ended_at')}
        )
        ON CONFLICT(date) DO UPDATE SET
          duration_seconds = duration_seconds + ${_dur('NEW.started_at', 'NEW.ended_at')};
      END;
    ''');

    // DELETE: subtract, then clean up empty buckets.
    await customStatement('''
      CREATE TRIGGER trg_sessions_ad
      AFTER DELETE ON sessions
      BEGIN
        UPDATE daily_rollups
        SET duration_seconds = duration_seconds - ${_dur('OLD.started_at', 'OLD.ended_at')}
        WHERE date = date(OLD.started_at, 'localtime');

        DELETE FROM daily_rollups
        WHERE date = date(OLD.started_at, 'localtime')
          AND duration_seconds <= 0;
      END;
    ''');

    // UPDATE: reverse the old contribution, then apply the new one.
    // Handles edits that change startedAt/endedAt AND ones that move
    // a session across a local-date boundary.
    await customStatement('''
      CREATE TRIGGER trg_sessions_au
      AFTER UPDATE ON sessions
      BEGIN
        UPDATE daily_rollups
        SET duration_seconds = duration_seconds - ${_dur('OLD.started_at', 'OLD.ended_at')}
        WHERE date = date(OLD.started_at, 'localtime');

        DELETE FROM daily_rollups
        WHERE date = date(OLD.started_at, 'localtime')
          AND duration_seconds <= 0;

        INSERT INTO daily_rollups (date, duration_seconds)
        VALUES (
          date(NEW.started_at, 'localtime'),
          ${_dur('NEW.started_at', 'NEW.ended_at')}
        )
        ON CONFLICT(date) DO UPDATE SET
          duration_seconds = duration_seconds + ${_dur('NEW.started_at', 'NEW.ended_at')};
      END;
    ''');
  }
}
