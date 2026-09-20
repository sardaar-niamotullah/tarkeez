import 'package:drift/drift.dart';
import 'package:tarkeez/core/database/tables/sessions.dart';
import 'package:tarkeez/core/database/app_database.dart';

part 'sessions_dao.g.dart';

@DriftAccessor(tables: [Sessions])
class SessionsDao extends DatabaseAccessor<AppDatabase>
    with _$SessionsDaoMixin {
  SessionsDao(super.db);

  // –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  // CREATE
  // –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  Future<String> insertSession(SessionsCompanion session) async {
    final row = await into(sessions).insertReturning(session);
    return row.id;
  }

  // –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  // READ
  // –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  // Read: one-shot
  Future<List<Session>> getAllSessions() {
    return (select(
      sessions,
    )..orderBy([(t) => OrderingTerm.desc(t.startedAt)])).get();
  }
  Future<List<Session>> getAllSessionsInDateRange({
    required DateTime startedAt,
    required DateTime endedAt,
  }) {
    return (select(sessions)
          ..where((t) => t.startedAt.isBiggerOrEqualValue(startedAt.toUtc()))
          ..where((t) => t.endedAt.isSmallerOrEqualValue(endedAt.toUtc()))
          ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]))
        .get();
  }
  // Read by id
  Future<Session?> getSessionById(String id) =>
      (select(sessions)..where((t) => t.id.equals(id))).getSingleOrNull();
  // Read by project id
  Future<List<Session>> getSessionsForProject(String projectId) {
    return (select(sessions)
          ..where((t) => t.projectId.equals(projectId))
          ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]))
        .get();
  }
  // Read: reactive stream — auto-updates on any write
  Stream<List<Session>> watchAllSessions() {
    return (select(
      sessions,
    )..orderBy([(t) => OrderingTerm.desc(t.startedAt)])).watch();
  }

  // –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  // UPDATE
  // –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  Future<bool> updateSession(Session session) =>
      update(sessions).replace(session);

  // –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  // DELETE
  // –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
  Future<int> deleteSession(String id) =>
      (delete(sessions)..where((t) => t.id.equals(id))).go();

  Future<int> deleteAllSessions() => delete(sessions).go();
}
