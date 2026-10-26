import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:tarkeez/core/database/daos/local_daily_rollups_dao.dart';
import 'package:tarkeez/core/database/daos/local_projects_dao.dart';
import 'package:tarkeez/core/database/daos/local_sessions_dao.dart';
import 'package:tarkeez/core/database/daos/local_users_dao.dart';
import 'package:tarkeez/core/database/daos/pending_changes_dao.dart';
import 'package:tarkeez/core/database/daos/project_rollups_dao.dart';
import 'package:tarkeez/core/database/daos/pull_checkpoints_dao.dart';
import 'package:tarkeez/core/database/migrations/app_migrations.dart';
import 'package:tarkeez/core/database/tables/local_daily_rollups.dart';
import 'package:tarkeez/core/database/tables/local_projects.dart';
import 'package:tarkeez/core/database/tables/local_sessions.dart';
import 'package:tarkeez/core/database/tables/local_users.dart';
import 'package:tarkeez/core/database/tables/pending_changes.dart';
import 'package:tarkeez/core/database/tables/project_rollups.dart';
import 'package:tarkeez/core/database/tables/pull_checkpoints.dart';
import 'package:tarkeez/core/database/triggers/rollup_triggers.dart';
import 'package:tarkeez/core/sync/sync_entity.dart';
import 'package:tarkeez/features/auth/current_user.dart';
import 'package:uuid/uuid.dart';

part 'local_database.g.dart';

// dart run build_runner build --delete-conflicting-outputs

@DriftDatabase(
  tables: [
    LocalUsers,
    LocalProjects,
    LocalSessions,
    LocalDailyRollups,
    ProjectRollups,
    PendingChanges,
    PullCheckpoints,
  ],
  daos: [
    LocalUsersDao,
    LocalProjectsDao,
    LocalSessionsDao,
    LocalDailyRollupsDao,
    ProjectRollupsDao,
    PendingChangesDao,
    PullCheckpointsDao,
  ],
)
class LocalDatabase extends _$LocalDatabase {
  new(this._currentUser) : super(_openConnection());

  final CurrentUser _currentUser;

  String get currentUserId => _currentUser.id;

  /// 2: local_sessions, local_daily_rollups, project_rollups with user_id.
  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => buildMigrationStrategy(this);

  @override
  StreamQueryUpdateRules get streamUpdateRules => StreamQueryUpdateRules([
    ...super.streamUpdateRules.rules,
    ...rollupStreamRules,
  ]);

  static QueryExecutor _openConnection() => driftDatabase(name: 'tarkeez_db');

  Future<void> connect() => customStatement('SELECT 1');

  /// Rebuilds the active account's rollups from its sessions.
  Future<void> rebuildRollups() =>
      transaction(() => rebuildRollupData(this, currentUserId));
}