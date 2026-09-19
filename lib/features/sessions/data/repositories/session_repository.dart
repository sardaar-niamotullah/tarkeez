import 'package:drift/drift.dart';
import 'package:tarkeez/core/database/app_database.dart';
import 'package:tarkeez/core/error/result.dart';
import 'package:tarkeez/core/error/result_guard.dart';
import 'package:tarkeez/features/projects/data/models/project_model.dart';
import 'package:tarkeez/features/sessions/data/models/session_model.dart';

abstract interface class SessionRepository {
  Future<Result<SessionModel>> entrySession({
    ProjectModel? project,
    required DateTime startedAt,
    required DateTime endedAt,
  });
  Future<Result<List<SessionModel>>> fetchAllSessions();
  Future<Result<List<SessionModel>>> fetchSessionsInDateRange({
    required DateTime startedAt,
    required DateTime endedAt,
  });
  Future<Result<void>> deleteSession(SessionModel session);
}

class SessionRepositoryImpl implements SessionRepository {
  const SessionRepositoryImpl(this._database);
  final AppDatabase _database;

  @override
  Future<Result<SessionModel>> entrySession({
    ProjectModel? project,
    required DateTime startedAt,
    required DateTime endedAt,
  }) async {
    return resultGuard(() async {
      final companion = SessionsCompanion.insert(
        startedAt: startedAt,
        endedAt: endedAt,
        projectId: Value(project?.id),
      );
      final id = await _database.sessionsDao.insertSession(companion);
      final row = await _database.sessionsDao.getSessionById(id);
      if (row == null) {
        throw StateError('Failed to load created session');
      }
      return SessionModel.fromRow(row);
    });
  }

  @override
  Future<Result<List<SessionModel>>> fetchAllSessions() async {
    return resultGuard(() async {
      final rows = await _database.sessionsDao.getAllSessions();
      return rows.map(SessionModel.fromRow).toList();
    });
  }

  @override
  Future<Result<List<SessionModel>>> fetchSessionsInDateRange({
    required DateTime startedAt,
    required DateTime endedAt,
  }) async {
    return resultGuard(() async {
      final rows = await _database.sessionsDao.getAllSessionsInDateRange(
        startedAt: startedAt,
        endedAt: endedAt,
      );
      return rows.map(SessionModel.fromRow).toList();
    });
  }

  @override
  Future<Result<void>> deleteSession(SessionModel session) async {
    return resultGuard(() async {
      await _database.sessionsDao.deleteSession(session.id!);
      return;
    });
  }
}
