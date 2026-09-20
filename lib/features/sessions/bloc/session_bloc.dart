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

  Future<void> _refreshSessions(
    Emitter<SessionState> emit, {
    bool entered = false,
    bool deleted = false,
    bool isInitialLoad = false,
  }) async {
    final previousSessions = state is SessionLoaded
        ? (state as SessionLoaded).sessions
        : null;
    emit(
      SessionLoading(
        sessions: previousSessions ?? const [],
        isInitialLoad: isInitialLoad,
      ),
    );
    final result = await _repository.fetchAllSessions();
    result.fold(
      onSuccess: (sessions) =>
          emit(SessionLoaded(sessions, isEntered: entered, isDeleted: deleted)),
      onFailure: (error) => emit(
        SessionFailure(error.message, sessions: previousSessions ?? const []),
      ),
    );
  }

  // ── Event handlers ──────────────────────────────────────────────────────
  Future<void> _onEntrySessionRequested(
    EntrySessionRequested event,
    Emitter<SessionState> emit,
  ) async {
    final segments = _splitByLocalDay(event.startedAt, event.endedAt);

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
        final previousSessions = state is SessionLoaded
            ? (state as SessionLoaded).sessions
            : const <SessionModel>[];
        emit(SessionFailure(failed, sessions: previousSessions));
        return;
      }
    }
    await _refreshSessions(emit, entered: true);
  }

  Future<void> _onFetchAllSessionsRequested(
    FetchAllSessionsRequested event,
    Emitter<SessionState> emit,
  ) async => await _refreshSessions(emit, isInitialLoad: true);

  Future<void> _onDeleteSessionRequested(
    DeleteSessionRequested event,
    Emitter<SessionState> emit,
  ) async {
    final result = await _repository.deleteSession(event.session);
    await result.fold(
      onSuccess: (_) => _refreshSessions(emit, deleted: true),
      onFailure: (error) async => emit(
        SessionFailure(
          error.message,
          sessions: state is SessionLoaded
              ? (state as SessionLoaded).sessions
              : const [],
        ),
      ),
    );
  }
}
