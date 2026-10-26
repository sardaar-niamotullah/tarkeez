import 'package:drift/drift.dart';
import 'package:tarkeez/core/database/tables/local_users.dart';

const String noProjectKey = '';

/// Local-day totals per project. Written only by triggers on local_sessions.
/// No FK to projects: a missing or deleted project is shown as "No Project"
/// through the project_rollups_effective view.
class ProjectRollups extends Table {
  TextColumn get userId => text().references(
    LocalUsers,
    #id,
    onUpdate: KeyAction.cascade,
    onDelete: KeyAction.cascade,
  )();

  TextColumn get date => text()();

  TextColumn get projectId =>
      text().withDefault(const Constant(noProjectKey))();

  IntColumn get durationSeconds => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {userId, date, projectId};
}