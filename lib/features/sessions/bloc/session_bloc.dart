import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarkeez/features/projects/data/models/project_model.dart';
import 'package:tarkeez/features/sessions/data/models/session_model.dart';
import 'package:tarkeez/features/sessions/data/repositories/session_repository.dart';

part 'session_event.dart';
part 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  final SessionRepository _repository;

  SessionBloc(this._repository) : super(SessionInitial()) {
    on<EntrySessionRequested>(_onEntrySessionRequested);
    on<FetchAllSessionsRequested>(_onFetchAllSessionsRequested);
    on<DeleteSessionRequested>(_onDeleteSessionRequested);
  }

  List<SessionModel> _currentSessions() {
    final s = state;
    if (s is SessionLoaded) return s.sessions;
    if (s is SessionFailure) return s.sessions;
    if (s is SessionLoading) return s.sessions;
    return const [];
  }

  // ── Private helpers ─────────────────────────────────────────────────────
  List<(DateTime, DateTime)> _splitByLocalDay(
    DateTime startedAt,
    DateTime endedAt,
  ) {
    final segments = <(DateTime, DateTime)>[];
    var segmentStart = startedAt;

    while (true) {
      final localStart = segmentStart.toLocal();
      final nextLocalMidnight = DateTime(
        localStart.year,
        localStart.month,
        localStart.day,
      ).add(const Duration(days: 1));
      if (!nextLocalMidnight.isBefore(endedAt.toLocal())) {
        segments.add((segmentStart, endedAt));
        break;
      }
      segments.add((segmentStart, nextLocalMidnight));
      segmentStart = nextLocalMidnight;
    }
    return segments;
  }

  // ── Event handlers ──────────────────────────────────────────────────────
  Future<void> _onEntrySessionRequested(
    EntrySessionRequested event,
    Emitter<SessionState> emit,
  ) async {
    final segments = _splitByLocalDay(event.startedAt, event.endedAt);
    final optimisticLogs = segments
        .map(
          (s) => SessionModel(
            startedAt: s.$1,
            endedAt: s.$2,
            projectId: event.project?.id,
          ),
        )
        .toList();
    emit(SessionLoaded([...optimisticLogs, ..._currentSessions()]));

    for (final (segStart, segEnd) in segments) {
      final result = await _repository.entrySession(
        startedAt: segStart,
        endedAt: segEnd,
        project: event.project,
      );
      final failed = result.fold(
        onSuccess: (_) => null,
        onFailure: (error) => error.message,
      );
      if (failed != null) {
        emit(SessionFailure(failed, sessions: _currentSessions()));
        return;
      }
    }
  }

  Future<void> _onFetchAllSessionsRequested(
    FetchAllSessionsRequested event,
    Emitter<SessionState> emit,
  ) async {
    emit(SessionLoading(sessions: _currentSessions()));
    final result = await _repository.fetchAllSessions();
    result.fold(
      onSuccess: (sessions) => emit(SessionLoaded(sessions)),
      onFailure: (error) =>
          emit(SessionFailure(error.message, sessions: _currentSessions())),
    );
  }

  Future<void> _onDeleteSessionRequested(
    DeleteSessionRequested event,
    Emitter<SessionState> emit,
  ) async {
    final previousSessions = _currentSessions();
    final optimisticSessions = previousSessions
        .where((s) => s.id != event.session.id)
        .toList();

    // Optimistic removal so the UI updates instantly.
    emit(SessionLoaded.deleted(optimisticSessions));
    final result = await _repository.deleteSession(event.session);
    result.fold(
      onSuccess: (_) {}, // optimistic state already reflects the delete
      onFailure: (error) =>
          emit(SessionFailure(error.message, sessions: previousSessions)),
    );
  }
}
