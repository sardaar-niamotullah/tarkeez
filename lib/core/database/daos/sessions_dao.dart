import 'package:drift/drift.dart';
import 'package:tarkeez/core/database/tables/sessions.dart';
import 'package:tarkeez/core/database/app_database.dart';

part 'sessions_dao.g.dart';

@DriftAccessor(tables: [Sessions])
class SessionsDao extends DatabaseAccessor<AppDatabase>
    with _$SessionsDaoMixin {
  SessionsDao(super.db);

  Future<String> insertSession(SessionsCompanion session) async {
    final row = await into(sessions).insertReturning(session);
    return row.id;
  }

  Future<List<Session>> getAllSessions() => select(sessions).get();

  Future<List<Session>> getSessionsForProject(String projectId) =>
      (select(sessions)..where((t) => t.projectId.equals(projectId))).get();

  Stream<List<Session>> watchAllSessions() {
    return (select(
      sessions,
    )..orderBy([(t) => OrderingTerm.desc(t.startedAt)])).watch();
  }

  Future<bool> updateSession(Session session) =>
      update(sessions).replace(session);

  Future<int> deleteSession(String id) =>
      (delete(sessions)..where((t) => t.id.equals(id))).go();
}