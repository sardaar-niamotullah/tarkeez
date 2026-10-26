import 'package:tarkeez/core/database/local_database.dart';
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
  const new(this._database);

  final LocalDatabase _database;

  static const _maxLength = Duration(hours: 24);

  /// The cloud and the local triggers both work in whole seconds.
  static DateTime _wholeSeconds(DateTime t) => DateTime.fromMillisecondsSinceEpoch(
    t.millisecondsSinceEpoch ~/ 1000 * 1000,
    isUtc: true,
  );

  @override
  Future<Result<SessionModel>> entrySession({
    ProjectModel? project,
    required DateTime startedAt,
    required DateTime endedAt,
  }) async {
    return resultGuard(() async {
      final start = _wholeSeconds(startedAt);
      final end = _wholeSeconds(endedAt);
      final length = end.difference(start);

      if (length <= Duration.zero || length > _maxLength) {
        throw StateError('A session must be between 1 second and 24 hours long');
      }

      // One row per session. The triggers split it at midnight.
      final id = await _database.localSessionsDao.insertSession(
        startedAt: start,
        endedAt: end,
        utcOffsetMinutes: startedAt.toLocal().timeZoneOffset.inMinutes,
        projectId: project?.id,
      );

      final row = await _database.localSessionsDao.getSessionById(id);
      if (row == null) {
        throw StateError('Failed to load created session');
      }
      return SessionModel.fromLocal(row);
    });
  }

  @override
  Future<Result<List<SessionModel>>> fetchAllSessions() async {
    return resultGuard(() async {
      final rows = await _database.localSessionsDao.getAllSessions();
      return rows.map(SessionModel.fromLocal).toList();
    });
  }

  @override
  Future<Result<List<SessionModel>>> fetchSessionsInDateRange({
    required DateTime startedAt,
    required DateTime endedAt,
  }) async {
    return resultGuard(() async {
      final rows = await _database.localSessionsDao.getAllSessionsInDateRange(
        startedAt: startedAt,
        endedAt: endedAt,
      );
      return rows.map(SessionModel.fromLocal).toList();
    });
  }

  @override
  Future<Result<void>> deleteSession(SessionModel session) async {
    return resultGuard(() async {
      await _database.localSessionsDao.deleteSession(session.id!);
    });
  }
}