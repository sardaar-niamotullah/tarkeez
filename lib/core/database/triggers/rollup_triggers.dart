// lib/core/database/triggers/rollup_triggers.dart   (UPDATE: replace the whole file)
import 'package:drift/drift.dart';

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// Stream invalidation for trigger-written tables.
// Drift only knows about the tables it wrote to. The rollups are written by
// SQLite triggers, so these rules make `.watch()` on them re-emit.
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
const rollupStreamRules = <WritePropagation>[
  WritePropagation(
    on: TableUpdateQuery.onTableName('local_sessions'),
    result: [TableUpdate('local_daily_rollups'), TableUpdate('project_rollups')],
  ),
  // A project edit or delete changes how project_rollups_effective reads.
  WritePropagation(
    on: TableUpdateQuery.onTableName('local_projects'),
    result: [TableUpdate('project_rollups')],
  ),
];

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// SQL building blocks
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

/// A one-row source built from the trigger's NEW or OLD row.
String _triggerRow(String r) =>
    'SELECT $r.user_id AS user_id, $r.project_id AS project_id, '
    '$r.started_at AS started_at, $r.ended_at AS ended_at, '
    '$r.utc_offset_minutes AS utc_offset_minutes';

/// The midnight split (README: "How a session is split at midnight").
/// Input: rows with user_id, project_id, started_at, ended_at, utc_offset_minutes.
/// Output: one row per local day touched (at most two): user_id, project_id, day, secs.
///
///   shifted = instant + offset
///   day i   = start of the shifted day, plus i days (i = 0, 1)
///   slice   = overlap of [shifted start, shifted end] with that day
String _slices(String source) => '''
  SELECT t.user_id AS user_id,
         t.project_id AS project_id,
         date(t.day_start, 'unixepoch') AS day,
         MIN(t.s_end, t.day_start + 86400) - MAX(t.s_start, t.day_start) AS secs
  FROM (
    SELECT b.user_id, b.project_id, b.s_start, b.s_end,
           (b.s_start / 86400 + n.i) * 86400 AS day_start
    FROM (
      SELECT src.user_id AS user_id, src.project_id AS project_id,
             CAST(strftime('%s', src.started_at) AS INTEGER) + src.utc_offset_minutes * 60 AS s_start,
             CAST(strftime('%s', src.ended_at) AS INTEGER) + src.utc_offset_minutes * 60 AS s_end
      FROM ($source) AS src
    ) AS b,
    (SELECT 0 AS i UNION ALL SELECT 1) AS n
  ) AS t
  WHERE t.s_end > t.day_start AND t.s_start < t.day_start + 86400
''';

/// Adds (or subtracts) the slices to local_daily_rollups.
String _applyToDaily(String source, {required bool add}) {
  final sign = add ? '' : '-';
  return '''
    INSERT INTO local_daily_rollups (user_id, date, duration_seconds)
    SELECT s.user_id, s.day, ${sign}s.secs
    FROM (${_slices(source)}) AS s
    WHERE 1
    ON CONFLICT(user_id, date) DO UPDATE SET
      duration_seconds = duration_seconds + excluded.duration_seconds;
  ''';
}

/// Adds (or subtracts) the slices to project_rollups.
/// A session without a project goes to the '' bucket.
String _applyToProjects(String source, {required bool add}) {
  final sign = add ? '' : '-';
  return '''
    INSERT INTO project_rollups (user_id, date, project_id, duration_seconds)
    SELECT s.user_id, s.day, COALESCE(s.project_id, ''), ${sign}s.secs
    FROM (${_slices(source)}) AS s
    WHERE 1
    ON CONFLICT(user_id, date, project_id) DO UPDATE SET
      duration_seconds = duration_seconds + excluded.duration_seconds;
  ''';
}

/// Removes buckets that reached zero.
String _cleanup(String r) => '''
  DELETE FROM local_daily_rollups WHERE user_id = $r.user_id AND duration_seconds <= 0;
  DELETE FROM project_rollups WHERE user_id = $r.user_id AND duration_seconds <= 0;
''';

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// Triggers: the ONLY writers of local_daily_rollups and project_rollups.
// Sessions never change except deleted_at, so only two triggers are needed.
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
Future<void> createRollupTriggers(DatabaseConnectionUser db) async {
  await db.customStatement('DROP TRIGGER IF EXISTS trg_local_sessions_ai;');
  await db.customStatement('DROP TRIGGER IF EXISTS trg_local_sessions_au;');

  // A live session is inserted: add its slices.
  // A tombstone that arrives already deleted adds nothing.
  await db.customStatement('''
    CREATE TRIGGER trg_local_sessions_ai
    AFTER INSERT ON local_sessions
    WHEN NEW.deleted_at IS NULL
    BEGIN
      ${_applyToDaily(_triggerRow('NEW'), add: true)}
      ${_applyToProjects(_triggerRow('NEW'), add: true)}
    END;
  ''');

  // deleted_at is set for the first time: subtract the same slices.
  await db.customStatement('''
    CREATE TRIGGER trg_local_sessions_au
    AFTER UPDATE OF deleted_at ON local_sessions
    WHEN OLD.deleted_at IS NULL AND NEW.deleted_at IS NOT NULL
    BEGIN
      ${_applyToDaily(_triggerRow('OLD'), add: false)}
      ${_applyToProjects(_triggerRow('OLD'), add: false)}
      ${_cleanup('OLD')}
    END;
  ''');
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// View: a project that is missing or deleted counts as "No Project" ('').
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
Future<void> createProjectRollupsEffectiveView(
  DatabaseConnectionUser db,
) async {
  await db.customStatement('DROP VIEW IF EXISTS project_rollups_effective;');
  await db.customStatement('''
    CREATE VIEW project_rollups_effective AS
    SELECT r.user_id AS user_id,
           r.date AS date,
           CASE WHEN p.id IS NOT NULL AND p.deleted_at IS NULL
                THEN r.project_id ELSE '' END AS project_id,
           SUM(r.duration_seconds) AS duration_seconds
    FROM project_rollups AS r
    LEFT JOIN local_projects AS p
      ON p.id = r.project_id AND p.user_id = r.user_id
    GROUP BY r.user_id, r.date, 3;
  ''');
}

// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
// Rebuild (README: "Rebuilding rollups"). Sessions are the source of truth.
// ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
Future<void> rebuildRollupData(DatabaseConnectionUser db, String userId) async {
  await db.customStatement(
    'DELETE FROM local_daily_rollups WHERE user_id = ?;',
    [userId],
  );
  await db.customStatement(
    'DELETE FROM project_rollups WHERE user_id = ?;',
    [userId],
  );

  const source = '''
    SELECT user_id, project_id, started_at, ended_at, utc_offset_minutes
    FROM local_sessions
    WHERE user_id = ? AND deleted_at IS NULL
  ''';

  await db.customStatement('''
    INSERT INTO local_daily_rollups (user_id, date, duration_seconds)
    SELECT s.user_id, s.day, SUM(s.secs)
    FROM (${_slices(source)}) AS s
    GROUP BY s.user_id, s.day;
  ''', [userId]);

  await db.customStatement('''
    INSERT INTO project_rollups (user_id, date, project_id, duration_seconds)
    SELECT s.user_id, s.day, COALESCE(s.project_id, ''), SUM(s.secs)
    FROM (${_slices(source)}) AS s
    GROUP BY s.user_id, s.day, COALESCE(s.project_id, '');
  ''', [userId]);
}