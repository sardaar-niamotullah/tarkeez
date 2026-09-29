import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:tarkeez/core/database/tables/projects.dart';
import 'package:tarkeez/core/database/tables/sessions.dart';
import 'package:tarkeez/core/database/tables/daily_rollups.dart';
import 'package:tarkeez/core/database/tables/project_rollups.dart';
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
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _createRollupTriggers();
      await _createProjectRollupTriggers();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(sessions);
      }
      if (from < 3) {
        await m.createTable(dailyRollups);
        await _createRollupTriggers();
      }
      if (from < 4) {
        await m.createTable(projectRollups);
        // Fill BOTH rollup tables from existing sessions. This also repairs
        // daily_rollups for sessions recorded before its triggers existed.
        await _rebuildRollupData();
        await _createProjectRollupTriggers();
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
  // Stream invalidation for trigger-written tables.
  // ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  // Drift only knows about the tables IT wrote to. The rollup tables are
  // written by SQLite triggers, so without these rules any `.watch()` on
  // daily_rollups / project_rollups would never re-emit.
  // (The generated code already contains the projects -> sessions rule for
  // the SET NULL foreign key; we keep it by spreading super's rules.)
  @override
  StreamQueryUpdateRules get streamUpdateRules => StreamQueryUpdateRules([
    ...super.streamUpdateRules.rules,
    const WritePropagation(
      on: TableUpdateQuery.onTableName('sessions'),
      result: [TableUpdate('daily_rollups'), TableUpdate('project_rollups')],
    ),
    // Deleting a project (or changing its id) moves rollup rows via the
    // sessions UPDATE trigger; declared explicitly so it doesn't depend on
    // Drift chaining rules transitively.
    const WritePropagation(
      on: TableUpdateQuery.onTableName('projects'),
      result: [TableUpdate('project_rollups')],
    ),
  ]);

  // ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  // Shared SQL helpers
  // ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  // Duration expression, reused everywhere: seconds between the two
  // ISO8601 UTC text timestamps.
  static const _durationExpression =
      "CAST((julianday(%end%) - julianday(%start%)) * 86400 AS INTEGER)";

  String _dur(String start, String end) =>
      _durationExpression.replaceAll('%start%', start).replaceAll('%end%', end);

  // ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  // Rebuild / repair (safe to call any time; sessions is the source of truth)
  // ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  /// Recomputes daily_rollups and project_rollups from scratch.
  Future<void> rebuildRollups() => transaction(_rebuildRollupData);

  Future<void> _rebuildRollupData() async {
    await customStatement('DELETE FROM daily_rollups;');
    await customStatement('DELETE FROM project_rollups;');

    await customStatement('''
      INSERT INTO daily_rollups (date, duration_seconds)
      SELECT date(started_at, 'localtime'),
             SUM(${_dur('started_at', 'ended_at')})
      FROM sessions
      GROUP BY 1;
    ''');

    await customStatement('''
      INSERT INTO project_rollups (date, project_id, duration_seconds)
      SELECT date(started_at, 'localtime'),
             COALESCE(project_id, ''),
             SUM(${_dur('started_at', 'ended_at')})
      FROM sessions
      GROUP BY 1, 2;
    ''');
  }

  // ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  // daily_rollups triggers — the ONLY writer of that table.
  // ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
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

  // ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  // project_rollups triggers — the ONLY writer of that table.
  // Fed directly from sessions (fan-out), independent of daily_rollups.
  // ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  // NULL project_id is stored as '' (see noProjectKey) so that
  // ON CONFLICT(date, project_id) works. When a project is deleted, the
  // FK action sets sessions.project_id to NULL, which fires the UPDATE
  // trigger below and merges the duration into the (date, '') bucket.
  Future<void> _createProjectRollupTriggers() async {
    await customStatement('DROP TRIGGER IF EXISTS trg_sessions_ai_pr;');
    await customStatement('DROP TRIGGER IF EXISTS trg_sessions_ad_pr;');
    await customStatement('DROP TRIGGER IF EXISTS trg_sessions_au_pr;');

    // INSERT: add to (date, project) bucket.
    await customStatement('''
      CREATE TRIGGER trg_sessions_ai_pr
      AFTER INSERT ON sessions
      BEGIN
        INSERT INTO project_rollups (date, project_id, duration_seconds)
        VALUES (
          date(NEW.started_at, 'localtime'),
          COALESCE(NEW.project_id, ''),
          ${_dur('NEW.started_at', 'NEW.ended_at')}
        )
        ON CONFLICT(date, project_id) DO UPDATE SET
          duration_seconds = duration_seconds + ${_dur('NEW.started_at', 'NEW.ended_at')};
      END;
    ''');

    // DELETE: subtract, then clean up empty buckets.
    await customStatement('''
      CREATE TRIGGER trg_sessions_ad_pr
      AFTER DELETE ON sessions
      BEGIN
        UPDATE project_rollups
        SET duration_seconds = duration_seconds - ${_dur('OLD.started_at', 'OLD.ended_at')}
        WHERE date = date(OLD.started_at, 'localtime')
          AND project_id = COALESCE(OLD.project_id, '');

        DELETE FROM project_rollups
        WHERE date = date(OLD.started_at, 'localtime')
          AND project_id = COALESCE(OLD.project_id, '')
          AND duration_seconds <= 0;
      END;
    ''');

    // UPDATE: reverse the old contribution, then apply the new one.
    // Covers time edits, date-boundary moves, project reassignment,
    // project deletion (SET NULL) and project id cascade updates.
    await customStatement('''
      CREATE TRIGGER trg_sessions_au_pr
      AFTER UPDATE ON sessions
      BEGIN
        UPDATE project_rollups
        SET duration_seconds = duration_seconds - ${_dur('OLD.started_at', 'OLD.ended_at')}
        WHERE date = date(OLD.started_at, 'localtime')
          AND project_id = COALESCE(OLD.project_id, '');

        DELETE FROM project_rollups
        WHERE date = date(OLD.started_at, 'localtime')
          AND project_id = COALESCE(OLD.project_id, '')
          AND duration_seconds <= 0;

        INSERT INTO project_rollups (date, project_id, duration_seconds)
        VALUES (
          date(NEW.started_at, 'localtime'),
          COALESCE(NEW.project_id, ''),
          ${_dur('NEW.started_at', 'NEW.ended_at')}
        )
        ON CONFLICT(date, project_id) DO UPDATE SET
          duration_seconds = duration_seconds + ${_dur('NEW.started_at', 'NEW.ended_at')};
      END;
    ''');
  }
}